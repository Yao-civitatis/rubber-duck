# `templates/` — Plantillas locales (self-contained)

Esta carpeta contiene **copias locales** de plantillas genéricas que rubber-duck usa internamente. La regla §2.bis del plan exige que rubber-duck no dependa de paths externos a otros repos: cualquier plantilla externa se copia aquí y se referencia siempre como `$RUBBER_DUCK_HOME/templates/<nombre>.md`.

## Plantillas

| Archivo | Origen | Commit | Fecha sync | Usado por |
|---|---|---|---|---|
| `planning-template.md` | `ai-development-rules/rules/templates/planning-template.md` | `71e8924` | 2026-05-27 | `skills/task-planner/` (formato del plan generado por `duck-plan`) |
| `agents-exceptions-template.md` | `ai-development-rules/rules/templates/agents-exceptions-template.md` | `71e8924` | 2026-05-27 | `skills/code-audit/` (formato de `AGENTS.md` con excepciones reconocidas) |

## Divergencias locales conocidas

- `planning-template.md`: el bloque "Language rule for this template" fue **modificado localmente** para que el idioma siga `output.language` del config en lugar de forzar inglés. Al re-sincronizar desde origen, preservar esta divergencia (no aceptar ciegamente el "Write all sections in English" upstream).

## Re-sincronización

Cuando la plantilla origen evolucione en `ai-development-rules`, re-copiar manualmente y actualizar la tabla (commit + fecha). **Antes de aceptar la copia**, revisar que las divergencias locales documentadas arriba siguen aplicadas. Aplicar los cambios upstream sobre el resto del archivo. No hay sync automático: simplicidad sobre frescura.

Procedimiento:

```bash
cp /ruta/a/ai-development-rules/rules/templates/<archivo>.md \
   $RUBBER_DUCK_HOME/templates/<archivo>.md
git -C /ruta/a/ai-development-rules log -1 --format='%h %ai' rules/templates/<archivo>.md
# anotar el commit y la fecha en la tabla de arriba
```

## Fitness check (§2.bis)

```bash
grep -rE "/home/[^/]+/proyectos/(ai-development-rules|tilt)" \
  $RUBBER_DUCK_HOME/{skills,agents,commands,templates,bin/lib}/ \
  | grep -v '<usuario>'
```

Debe devolver 0 matches. Si aparece algún path absoluto externo, hay una dependencia ilegal que romper.
