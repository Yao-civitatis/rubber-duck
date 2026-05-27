# Skill `task-implementer`

Implementa el código a partir de un plan `.md` generado por `duck-plan`. Detecta el proyecto (new-admin u old-admin) y aplica el subprompt correcto.

## Invocación

`duck-implement <ARCHIVO_PLAN.md>`

Ejemplo:

```
duck-implement PANA-123_plan.md
duck-implement ./reports/PANA-456_plan.md
```

## Argumento obligatorio

El archivo `.md` del plan es **obligatorio**. Si falta:

```
🦆 duck-implement: falta el plan.
   Uso: duck-implement <archivo_plan.md>
   Genera uno con: duck-plan <JIRA-KEY>
```
exit 2.

## Flujo

### Paso 1 — Lectura del plan

1. Abre el archivo. Si no existe → exit 2 con error claro.
2. Extrae la JIRA-KEY del título (línea `# Spec-Driven Implementation Plan: <KEY>`). Si no la encuentras, falla con error claro.
3. Extrae:
   - Branch esperada (línea `**Branch:**`).
   - Target Module/Bounded Context.
   - El **único** escenario activo (sección `🟢 ACTIVE SCENARIO`).
   - Test matrix y pasos RED/GREEN/REFACTOR.

### Paso 2 — Verificación de rama (informativa, no bloqueante)

Comprueba si la rama actual coincide con la esperada del plan. Si no, **avisa** al usuario pero permite continuar:

```
⚠️ Rama actual: <actual>
   Rama esperada por el plan: <esperada>
   ¿Continúo igualmente? [s/N]
```

Si rechaza → exit 0 (cancelado).

### Paso 3 — Carga del subprompt según proyecto

Lee `$RUBBER_DUCK_HOME/skills/task-implementer/prompts/<project>.md` donde `<project>` es `new_admin` o `old_admin`.

### Paso 4 — Carga del contexto del proyecto

- `$RUBBER_DUCK_HOME/skills/project-context/<project>.md`
- Para new-admin: además `$PROJECT_ROOT/CLAUDE.md`, `.claude/domain-index.md`, `.claude/refactoring-state.md`.

### Paso 5 — Validación específica de old-admin

Si `$PROJECT_TYPE = old-admin`:

1. Identifica los paths que el plan dice tocar.
2. Para cada path, verifica que coincide con un prefijo de la whitelist del scope `/admin` (ver `skills/project-context/old_admin.md` §"Scope estricto").
3. Si **cualquier** path está fuera → **abortar**:
   ```
   🦆 duck-implement: el plan toca paths fuera del scope /admin.
      Paths inválidos:
        - <path1>
        - <path2>
      Modifica el plan para mantener todo dentro del scope.
   ```
   exit 4.
4. Clasifica el cambio: bug fix / mantenimiento / funcionalidad nueva. Si parece funcionalidad nueva:
   ```
   ⚠️ Este plan describe lo que parece una funcionalidad nueva en old-admin.
      La política del equipo es mantenimiento-only y migrar a new-admin.
      Te recomiendo:
        duck-migrate <ruta-afectada>
      
      ¿Continúo de todos modos con duck-implement en old-admin?
        [s] Sí, registra mi decisión y continúa
        [N] No, cancelar
      > _
   ```
   Si rechaza → exit 0. Si acepta → log la decisión en stdout (`Decisión: continuar con funcionalidad nueva en old-admin a pesar de la política`).

### Paso 6 — Implementación TDD (new-admin) / manual (old-admin)

Sigue exactamente los pasos del subprompt cargado (`new_admin.md` o `old_admin.md`).

**Regla de oro:** el plan es la fuente de verdad. No improvisar fuera de lo que el plan describe. Si surge una decisión no contemplada, **para y pregunta** al usuario.

### Paso 7 — Formateo automático (opcional)

Si `implement.auto_format = true` y `$PROJECT_TYPE = new-admin`:

```bash
"$PROJECT_ROOT/bin/pre-commit" php-cs-fixer <archivos_tocados>
```

Si `$PROJECT_TYPE = old-admin`, `implement.auto_format` se ignora con log informativo (no hay toolchain).

### Paso 8 — Resumen final

Imprime un resumen claro:

```
🦆 duck-implement <JIRA-KEY> completado.

Archivos creados/modificados:
  + app/Services/Payments/RefundService.php
  ~ app/Controllers/Payments/RefundController.php

Próximos pasos sugeridos:
  duck-audit --branch
  duck-review <JIRA-KEY>
```

### Paso 9 — Auto-commit (si aplica)

Si `git.auto_commit = true` y `git.auto_commit_after = implement`:

1. Stage de los archivos tocados (no usar `git add .`).
2. Generar mensaje según `git.commit_message_format` (`jira`, `conventional`, `custom`).
3. `git commit` (sin `--no-verify`).
4. Si `git.auto_push = true` → `git push`.

## Restricciones (recordatorio)

- **R1 (Jira):** este skill no escribe en Jira. Si necesita poner notas, las muestra en stdout para pegado manual.
- **R2 (BBDD):** nunca `INSERT`/`UPDATE`/`DELETE`/`ALTER`/`DROP`/`TRUNCATE`. Si el plan requiere cambios de datos, redactar las queries en el resumen final como instrucciones para el usuario.
- **R3–R6 (new-admin):** aplicar siempre.
- **Old-admin scope:** validado en Paso 5.

## Exit codes

| Situación | Exit |
|---|---|
| Éxito | 0 |
| Plan no encontrado / malformado | 2 |
| Detección de proyecto falló | 3 |
| old-admin: paths fuera del scope | 4 |
| Usuario canceló (rama distinta, funcionalidad nueva en old-admin, etc.) | 0 |
| Error durante implementación (test verde no obtenido en X intentos) | 5 |
