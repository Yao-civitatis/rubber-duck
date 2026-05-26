# Comando `duck-help`

Muestra ayuda de rubber-duck en tres modos.

## Implementación

`duck-help` se atiende **100% en bash** vía `bin/lib/help.sh`. El dispatcher hace short-circuit y nunca invoca a Claude para este comando — la ayuda es texto declarativo y no necesita razonamiento.

## Modos

| Invocación | Comportamiento |
|---|---|
| `duck-help` | Lista todos los comandos con descripción corta y enlaces a más detalle. |
| `duck-help <comando>` | Uso + argumentos + ejemplos del comando indicado. |
| `duck-help config` | Lista todas las claves de configuración con valor actual y default. |
| `duck-help config.<clave>` | Descripción + valores permitidos + default + cómo cambiarla. |

## Mantenimiento

El catálogo vive en `bin/lib/help.sh` en tres arrays:

- `HELP_SHORT[cmd]` — descripción de una línea (sale en ayuda general).
- `HELP_USAGE[cmd]` — sintaxis del comando.
- `HELP_DETAILS[cmd]` — descripción larga + ejemplos (heredoc).

Sincronizar siempre con:

- `setup.sh` (array `COMMANDS=()`)
- README §"Comandos que instala"

La parte de `config.<clave>` se genera dinámicamente leyendo el schema de `bin/lib/config.sh` (`CONFIG_DEFAULTS`, `CONFIG_ALLOWED`, `CONFIG_DESCRIPTIONS`). No requiere mantenimiento manual.
