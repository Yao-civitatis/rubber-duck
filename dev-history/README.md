# `dev-history/`

Histórico de planes de implementación de **rubber-duck**. **No consumido por el runtime de la herramienta** — solo archivo documental del desarrollo de la propia herramienta.

## Convención de naming

```
<YYYY-MM-DD>_plan_implementation_v<N>.md
```

- `<YYYY-MM-DD>` — fecha del cierre del plan (no la de inicio).
- `<N>` — número de iteración. Empieza en `v1` para la primera implementación. Solo se incrementa si en el futuro se rehace el proyecto con un plan nuevo desde cero — los archivos históricos no se sobrescriben.

## Entradas

| Archivo | Cierre | Notas |
|---|---|---|
| `2026-05-28_plan_implementation_v1.md` | 2026-05-28 | Implementación inicial completa de la v1. Fases F1-F13 ejecutadas; F13 con verificación parcial automatizada y 3 flujos manuales pendientes (F13.3, F13.4, F13.6). |
| `2026-05-28_plan_db_multi_env_v1.md` | 2026-05-28 | Plan post-MVP: `duck-db` multi-entorno (dev/qa/slave/prod) con read-only reforzado por gates `(a)..(e)` escalonadas por `danger_level`. F1–F8 completados. Tests 24/24 PASS. 1 fix cosmético en F7 (`keys_unsorted` para orden natural en error messages); sin items out-of-scope. |

## Política

- Estos archivos no se editan tras su creación — son un snapshot del plan en el momento del cierre.
- No se referencian desde skills/agents/commands/rules en runtime.
- Si una iteración futura necesita un plan nuevo, se crea como entrada `vN+1`, no se modifica el anterior.
