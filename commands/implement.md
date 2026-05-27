# Comando `duck-implement`

Implementa código a partir de un plan `.md` generado por `duck-plan`. Detecta el proyecto y aplica el flujo TDD (new-admin) o de bug fix / mantenimiento (old-admin).

## Uso

```
duck-implement <archivo_plan.md>
```

Ejemplos:

```bash
cd ~/proyectos/tilt/tilts/new-admin
duck-implement PANA-123_plan.md

cd ~/proyectos/tilt/tilts/civitatis
duck-implement TAPEO-456_plan.md
```

## Comportamiento

Carga el skill `$RUBBER_DUCK_HOME/skills/task-implementer/SKILL.md` y sigue su flujo:

1. **Lee el plan** y extrae la JIRA-KEY, rama esperada y el escenario activo.
2. **Verifica la rama actual** vs la esperada (avisa, no bloquea).
3. **Carga el subprompt correcto**:
   - `$PROJECT_TYPE = new-admin` → `prompts/new_admin.md` (TDD red-green-refactor).
   - `$PROJECT_TYPE = old-admin` → `prompts/old_admin.md` (REPRO + FIX + VERIFY).
4. **Carga el contexto del proyecto** (`skills/project-context/*.md` + `$PROJECT_ROOT/.claude/*`).
5. **Para old-admin:** valida que cada path del plan esté en el scope `/admin`. Si no → aborta con exit 4.
6. **Para old-admin:** si el cambio parece funcionalidad nueva, pide confirmación expresa.
7. **Implementa** siguiendo el plan al pie de la letra.
8. **Formateo opcional** (`implement.auto_format=true` solo para new-admin).
9. **Resumen final** con archivos tocados y próximos pasos sugeridos.
10. **Auto-commit** si está configurado (`git.auto_commit_after=implement`).

## Restricciones

- **R1 (Jira):** este comando no escribe en Jira. Las notas para el ticket se muestran en stdout.
- **R2 (BBDD):** nunca ejecuta `INSERT/UPDATE/DELETE/ALTER/DROP/TRUNCATE`. Queries de datos se redactan en el resumen.
- **R3–R6 (new-admin):** aplicadas siempre (hexagonal, controllers sin AbstractController, Slim StatusCode, Options API).
- **Scope `/admin` (old-admin):** validado antes de tocar nada.
- **Plan obligatorio:** sin argumento `.md` válido, exit 2.

## Configuración relacionada

| Clave | Default | Efecto |
|---|---|---|
| `implement.auto_format` | `false` | Si `true` y new-admin, ejecuta `bin/pre-commit php-cs-fixer` tras implementar |
| `git.auto_commit` | `false` | Auto-commit en `$PROJECT_ROOT` tras la fase indicada |
| `git.auto_commit_after` | `audit` | Cambiar a `implement` para commitear aquí |
| `git.commit_message_format` | `jira` | `jira`, `conventional` o `custom` |
| `git.auto_push` | `false` | Push automático tras commit |

## Errores y exit codes

| Situación | Exit |
|---|---|
| Éxito | 0 |
| Plan no encontrado / malformado | 2 |
| Detección de proyecto falló | 3 |
| old-admin: paths fuera del scope | 4 |
| Implementación incompleta (test no verde tras N intentos) | 5 |
| Usuario canceló (rama distinta, funcionalidad nueva en old-admin, etc.) | 0 |
