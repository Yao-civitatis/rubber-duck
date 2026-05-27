# Comando `duck-migrate`

Migra una pieza del módulo `{URL_DOMAIN}/admin` de `civitatis` (old-admin) al stack de `new-admin`. Prioridad estratégica del equipo: la visión a largo plazo es eliminar old-admin.

## Uso

```
duck-migrate plan <ruta-en-old-admin>
duck-migrate <ruta-en-old-admin>
```

Ejemplos:

```bash
duck-migrate plan application/admin/payments/list.php
duck-migrate application/admin/payments/list.php
```

## Comportamiento

Carga el agente `$RUBBER_DUCK_HOME/agents/migration-agent.md`. Dos modos:

### Modo `plan`

Genera un roadmap de migración para la pieza indicada:

- Mapeo a dominio de new-admin (consulta `~/.rubber-duck/docs/new-admin/`).
- Lista de archivos a crear en new-admin (Controller, Service, Repository, interfaz Domain, módulo Vue si aplica).
- Test matrix mínima (Pest backend + Jest frontend si toca).
- Plan de deprecación de la pieza vieja (no se elimina en este flujo).

Salida sigue la convención de paths (rules/export-paths.md): si hay JIRA-KEY inferible, `<output_dir>/<JIRA-KEY>/<JIRA-KEY>_migrate.md`. Si no, `<output_dir>/migrate/<slug>_migrate.md`.

### Modo ejecutar

Aplica el plan generado en el modo anterior (o lo genera al vuelo si no se hizo `plan` antes):

1. Lee la pieza de old-admin (path absoluto o relativo a `$PROJECT_ROOT` del repo civitatis).
2. **Valida scope:** la ruta debe estar dentro del whitelist `/admin`. Si no → abort.
3. Diseña destino en new-admin (Controllers/Services/Repositories/Vue) aplicando R3-R6.
4. **TDD obligatorio** en new-admin: RED → GREEN → REFACTOR.
5. Side-by-side de equivalencia funcional (descripción de requests/respuestas esperadas).
6. **NO elimina** la pieza vieja. Sugiere plan de deprecación en el output.

## Restricciones

- **Scope estricto** en origen: solo `/admin` de civitatis.
- **R3-R6** en destino: arquitectura hexagonal validada por `phparkitect`.
- **R1 (Jira):** lectura del ticket asociado si existe. Sin escritura automática.
- **R2 (BBDD):** no migra datos. Cambios de esquema (raros) se redactan, no ejecutan.
- **No tocar old-admin:** la pieza vieja queda intacta hasta validación en QA y decisión del equipo.
- **Idioma:** `output.language` (default `es`).

## Workflow completo

```bash
# 1. roadmap
duck-migrate plan application/admin/payments/list.php
#    → genera <output>/PANA-123/PANA-123_migrate.md (si la rama tiene la key)

# 2. ejecución
duck-migrate application/admin/payments/list.php

# 3. validación en new-admin
cd ~/proyectos/tilt/tilts/new-admin
duck-audit --branch
duck-review PANA-123

# 4. QA manual de equivalencia
#    (comparar old vs new lado a lado)

# 5. cuando todo está OK, deprecar pieza vieja (manual, fuera de duck-migrate):
#    - añadir comentario de redirección al nuevo endpoint, o
#    - coordinar con el equipo un sunset date
```

## Errores y exit codes

| Situación | Exit |
|---|---|
| Migración completada (en plan o ejecución) | 0 |
| Path fuera del scope `/admin` | 4 |
| Sin pieza válida que migrar (archivo no existe) | 2 |
| Equivalencia funcional no garantizable sin más info | 5 (con explicación; el usuario decide continuar manualmente) |

## Cuándo NO usar este comando

- Cambios mínimos (1-2 líneas) sobre old-admin → mantener en old-admin como bug fix con `duck-implement`.
- Pieza ya en proceso de eliminación → no duplicar esfuerzo.
- Sin tests de QA disponibles para verificar equivalencia → más arriesgado que el valor que aporta; coordinar con QA primero.
