# Comando `duck-config`

Gestiona la configuración personal de `rubber-duck` en `~/.rubber-duck/config.json`.

## Subcomandos

| Subcomando | Comportamiento |
|---|---|
| `list` | Muestra todas las claves con valor actual + default + descripción. |
| `get <clave>` | Imprime el valor actual de la clave (default si no está fijada). |
| `set <clave> <valor>` | Valida y persiste. Rechaza claves desconocidas y valores fuera del set permitido. |
| `reset <clave>` | Borra la clave del JSON. Vuelve al default. |
| `reset --all` | Borra el archivo entero. Reinicia a defaults. |
| `setup` | Lanza el wizard interactivo (este flujo es el único que pasa por Claude). |

## Importante

- `list`, `get`, `set`, `reset` se atienden **en bash puro** (no se invoca a Claude). El dispatcher hace short-circuit a `bin/lib/config.sh` para que sean instantáneos.
- `setup` es el único que carga este markdown y delega al skill `skills/config/SKILL.md`.

## Cuando se invoca `duck-config setup`

Carga el skill `skills/config/SKILL.md` y sigue sus instrucciones al pie de la letra. El skill:

1. Detecta si `~/.rubber-duck/config.json` ya existe. Si existe, pregunta si el usuario quiere sobrescribirlo o cancelar.
2. Hace las preguntas del wizard en el orden definido por el skill.
3. Guarda el JSON resultante con `"_version": 1`.
4. Si el usuario interrumpe con Ctrl+C → guarda lo respondido + defaults para el resto.

## Claves disponibles

Ver `bin/lib/config.sh` (arrays `CONFIG_DEFAULTS`, `CONFIG_ALLOWED`, `CONFIG_DESCRIPTIONS`). Son la fuente de verdad. El wizard debe usar exactamente las mismas claves y valores permitidos.

## Restricciones

- **No fijes `project.new_admin_path` ni `project.old_admin_path` sin necesidad.** El dispatcher detecta el proyecto automáticamente desde `$PWD`. Estos campos son solo fallback.
- **`review.update_jira = true`** significa "ofrecer actualizar Jira tras confirmación expresa", no "actualizar silenciosamente". El skill `task-reviewer` aplica esa semántica.
