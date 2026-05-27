# `rules/` — Reglas transversales de rubber-duck

Cada archivo `.md` de esta carpeta define **una** regla transversal que afecta a múltiples skills, agents o commands. Son la fuente de verdad permanente: sobreviven al borrado de `PLAN_IMPLEMENTATION.md` (Fase 14) y a la reorganización de skills.

## Catálogo

| Archivo | Regla |
|---|---|
| `export-paths.md` | Convención universal de paths para artefactos exportados a disco |
| `output-language.md` | Idioma del contenido generado para el usuario |
| `project-detection.md` | Detección dinámica de proyecto desde `$PWD` |
| `self-contained.md` | Cero dependencias de paths externos en runtime |
| `operational-restrictions.md` | R1–R7 + política old-admin mantenimiento-only |

## Cómo se usan

Cualquier skill, agent o command que toque alguna de estas áreas debe **citar la regla concreta** del archivo correspondiente. Ejemplos:

- Una skill que persiste a disco cita `$RUBBER_DUCK_HOME/rules/export-paths.md`.
- Una skill que genera texto user-facing cita `$RUBBER_DUCK_HOME/rules/output-language.md`.
- Un command de proyecto (`analyze`, `plan`, `audit`, ...) cita `$RUBBER_DUCK_HOME/rules/operational-restrictions.md`.

## Mantenimiento

- Las reglas se añaden aquí cuando son **transversales** (afectan a ≥2 skills/agents/commands).
- Si una regla cambia, se actualiza el archivo y se propaga la actualización en el mismo PR a las skills/agents/commands afectados.
- Si una regla queda obsoleta, se borra el archivo y se quitan las referencias.
