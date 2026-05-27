# Skill `task-reviewer`

Revisa que el código implementado cumple los Criterios de Aceptación del ticket. Genera un informe estructurado. Si el usuario confirma, postea el informe como comentario en Jira.

## Invocación

`duck-review <JIRA-KEY>`

Ejemplo: `duck-review PANA-123`.

## Flujo

### Paso 1 — Lectura del ticket

Lee `<JIRA-KEY>` vía MCP. Toma:

- `summary`, `description` (incluyendo bloque rubber-duck entre marcadores si existe — son los AC oficiales).
- `status`.

### Paso 2 — Identificación de los cambios

1. Obtén la rama actual (`git rev-parse --abbrev-ref HEAD`).
2. Determina la base (`main` o `master`, lo que exista).
3. Calcula el diff: `git diff --name-only $(git merge-base HEAD main)...HEAD` (o `master`).
4. Si la rama es `main`/`master`, **avisa** y pide al usuario que indique manualmente qué cambios revisar (no podemos comparar contra sí misma).

Si no hay cambios → exit 0 con mensaje "No hay cambios para revisar".

### Paso 3 — Lectura de los archivos cambiados

Lee el contenido **actual** (HEAD) de cada archivo modificado. Para old-admin, lee también la versión previa si conviene comparar el "antes" (sufijo `--cached` o `git show HEAD~1:<archivo>`).

### Paso 4 — Carga de contexto

- `$RUBBER_DUCK_HOME/skills/project-context/<project>.md`
- Para new-admin: `$PROJECT_ROOT/.claude/domain-index.md` para localizar dónde encajan los cambios.

### Paso 5 — Generación del informe

Sigue exactamente `$RUBBER_DUCK_HOME/skills/task-reviewer/prompts/review.md`.

Estructura mínima del informe:

```markdown
# Review: <JIRA-KEY> — <summary>

## 1. Cobertura de Criterios de Aceptación

| AC | Estado | Evidencia |
|---|---|---|
| AC1: <texto del criterio> | ✅ Cumple | <archivo:línea o función concreta> |
| AC2: <texto> | ⚠️ Parcial | <qué falta> |
| AC3: <texto> | ❌ No cumple | <razón> |

## 2. Calidad del cambio

- **Arquitectura (new-admin):** R3/R4/R5/R6 — OK / Violación: <detalle>
- **Scope (old-admin):** todos los paths dentro del whitelist — OK / Violación: <path>
- **Tests:** <tests añadidos / cubren los AC / pasan local>
- **Estilo:** se imita el archivo (old-admin) / php-cs-fixer (new-admin) — OK / Violación
- **Seguridad:** SQL injection / XSS / permisos — OK / Hallazgo: <detalle>

## 3. Lo que falta o hay que corregir

- [ ] <Acción concreta 1>
- [ ] <Acción concreta 2>

## 4. Conclusión

🟢 Listo para PR / 🟡 Listo con observaciones / 🔴 No listo — bloqueantes pendientes
```

### Paso 6 — Mostrar al usuario

Imprime el informe completo en stdout con un encabezado claro.

### Paso 7 — Export (opcional)

Si `review.export = true`, sigue la **convención universal de paths de export** (ver §2.quater del plan):

```
<review.export_dir>/<JIRA-KEY>/<JIRA-KEY>_review.<ext>
```

donde:
- `<review.export_dir>` viene de config (default `.`).
- `<ext>` viene de `review.export_format` (default `md`).
- `<JIRA-KEY>` siempre disponible (argumento obligatorio del comando).

Procedimiento:

1. Calcular `dest_dir = "<review.export_dir>/<JIRA-KEY>"`.
2. `mkdir -p "$dest_dir"`.
3. Calcular `dest_file = "$dest_dir/<JIRA-KEY>_review.<ext>"`.
4. Si `$dest_file` existe → preguntar sobrescribir / backup `.bak` / cancelar.
5. Escribir archivo.
6. Confirmar: `✓ Informe guardado en <ruta>`.

### Paso 8 — Update a Jira (opcional, requiere confirmación)

Si `review.update_jira = true`:

1. Pregunta:
   ```
   ¿Quieres que postee este informe como comentario en <JIRA-KEY>?
     [s] Sí, postear comentario
     [N] No, dejar solo en pantalla
   > _
   ```
2. Default = N. Solo `s`/`si`/`sí`/`y`/`yes` cuentan como confirmación.
3. Si confirma, postea como comentario nuevo en el ticket (no editar comentarios previos, no modificar la descripción).
4. Confirma: `✓ Comentario añadido a <JIRA-KEY>.`

Si la escritura falla, mostrar error y conservar el informe en pantalla.

### Paso 9 — Salida

- 🟢 Listo → exit 0.
- 🟡 Listo con observaciones → exit 0.
- 🔴 No listo → exit 1 (útil para git hooks: `pre-push` falla y bloquea el push).
- Lectura del ticket falló → exit 2.

## Restricciones

- **R1 (Jira):** la escritura **requiere confirmación expresa**. Default = N. Solo se postea como **comentario nuevo**, nunca edita comentarios previos ni la descripción.
- **R2 (BBDD):** no toca BBDD. Cualquier verificación que requiera datos se describe como query a ejecutar por el usuario.
- **R3-R6 (new-admin):** se verifican y reportan, no se mutan.
- **Scope (old-admin):** se verifica que el commit no toque paths fuera del whitelist. Si lo hizo, marcar como bloqueante 🔴.

## Idempotencia

Llamadas repetidas a `duck-review <JIRA-KEY>` producen siempre un informe coherente con el estado actual del código + ticket. Si el usuario confirma postear, **siempre se añade un comentario nuevo** (no editamos ninguno). Eso significa que ejecutar review 3 veces y confirmar las 3 produce 3 comentarios en Jira — comportamiento aceptado (transparencia sobre cuándo se revisó).
