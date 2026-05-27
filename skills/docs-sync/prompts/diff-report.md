# Prompt — Diff report entre snapshots

Compara el `project-snapshot.md` recién generado con la versión anterior (si existía) y produce un resumen accionable de cambios. Persiste el resumen en `docs/last-sync.json` y lo muestra al usuario al final de `duck-sync-docs`.

## Inputs

- `current` — contenido del `project-snapshot.md` recién escrito.
- `previous` — contenido del `project-snapshot.md` anterior (leer antes de sobrescribir; si no existía, el report es "primera ejecución").
- `confluence_changed` — bool por proyecto: ¿alguno de los `*-standards.md` cambió en este run?

## Output (estructurado)

```json
{
  "<proyecto>": {
    "confluence_updated": <bool>,
    "snapshot_updated": <bool>,
    "changes": [
      "axios actualizado: ^0.18.0 → ^0.18.1",
      "carpeta app/Modules/Refunds/ añadida",
      "1 nuevo punto de entrada detectado en app/Console/SyncCustomers.php"
    ]
  }
}
```

Reglas para poblar `changes`:

- **Versiones**: detectar cambios en las tablas §1 Tecnologías. Formato: `<paquete> <oldver> → <newver>`.
- **Estructura**: detectar carpetas nuevas/eliminadas en §2.
- **Arquitectura**: cambios obvios en §3 (nuevas capas mencionadas, nuevos patrones detectados).
- **Puntos de entrada**: cambios en §4.
- **Dependencias externas**: nuevas integraciones detectadas en §5.

NO incluir en `changes`:

- Cambios de formato/markdown que no reflejan cambio real en el código.
- Diferencias de orden (alfabetización distinta).
- Timestamps en cabeceras.

## Tamaño del report

Máximo 10 bullets por proyecto. Si hay más, agrupar en familias:

- `12 paquetes actualizados (ver tablas §1)`
- `3 carpetas añadidas, 1 eliminada (ver §2)`

## Persistencia en `$DOCS_DIR/last-sync.json`

Archivo único (en `~/.rubber-duck/docs/` por defecto, o en `$RUBBER_DUCK_HOME/docs/` si se invocó con `--bundle`) con el estado de ambos proyectos. Si solo se sincronizó uno en este run, preservar la entrada del otro proyecto leyendo el JSON previo.

Estructura completa del archivo:

```json
{
  "last_sync": "<ISO-8601 UTC>",
  "projects": {
    "new-admin": {
      "confluence_updated": true,
      "snapshot_updated": true,
      "changes": ["…"]
    },
    "old-admin": {
      "confluence_updated": false,
      "snapshot_updated": true,
      "changes": ["…"]
    }
  }
}
```

Si un proyecto **no se sincronizó** en este run (porque el path no se resolvió, por ejemplo):

```json
{
  "<proyecto>": {
    "confluence_updated": false,
    "snapshot_updated": false,
    "changes": [],
    "skipped_reason": "<motivo legible>"
  }
}
```

## Idioma

`changes` se escribe en `output.language`. Literales (paths, versiones, símbolos) se preservan.

## Primer run (sin previous)

Cuando no existe el snapshot anterior:

```json
{
  "<proyecto>": {
    "confluence_updated": <bool>,
    "snapshot_updated": true,
    "changes": ["Primer snapshot — sin diff disponible."]
  }
}
```

## Output al usuario (parte del resumen final del comando)

```
Cambios destacados:
  new-admin:
    - axios actualizado: ^0.18.0 → ^0.18.1
    - carpeta app/Modules/Refunds/ añadida
  old-admin:
    - (sin cambios)
```
