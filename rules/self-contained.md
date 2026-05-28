# Regla: self-contained (cero dependencias externas en runtime)

**Aplica a:** todo el repo de rubber-duck.

## Patrón

rubber-duck **no asume** la existencia de otros repositorios ni rutas absolutas externas en runtime. Toda plantilla, recurso o snippet que rubber-duck necesite vive **dentro del repo**, en `$RUBBER_DUCK_HOME/templates/` u otra carpeta interna.

## Plantillas externas

Cuando una plantilla provenga originalmente de otro proyecto (ej. `ai-development-rules`), se **copia** a `$RUBBER_DUCK_HOME/templates/` y se referencia siempre como `$RUBBER_DUCK_HOME/templates/<nombre>.md`.

Origen, commit y fecha de copia se anotan en `templates/README.md` para poder re-sincronizar manualmente cuando convenga.

## Divergencias locales

Si tras copiar una plantilla se aplica un cambio local (caso de `planning-template.md` que perdió la regla "Write all sections in English" para respetar `output.language`), se documenta la divergencia en `templates/README.md` §"Divergencias locales conocidas". Al re-sync futuro se preserva la divergencia, no se acepta ciegamente el upstream.

## Fitness check

```bash
grep -rE "/home/[^/]+/proyectos/(ai-development-rules|tilt)" \
  skills/ agents/ commands/ templates/ rules/ bin/lib/ \
  | grep -v '<usuario>'
```

Cero matches.

## Por qué

- Permite distribuir rubber-duck en máquinas con layouts distintos sin romper.
- Cada usuario puede tener `~/proyectos/`, `~/dev/`, `~/code/`… sin importar.
- Evita que la herramienta deje de funcionar si otro repo se mueve o desaparece.
