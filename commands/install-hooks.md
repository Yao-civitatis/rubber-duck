# Comando `duck-install-hooks`

Instala los git hooks de rubber-duck en el repositorio indicado. Los hooks quedan **desactivados por defecto** y se activan después con `duck-config set git.hooks.<hook>_enabled true`.

## Uso

```
duck-install-hooks [ruta-al-repo]
```

Sin argumento → instala en el repo del directorio actual.

Ejemplos:

```bash
# desde dentro de new-admin
duck-install-hooks .

# explícito
duck-install-hooks /home/<usuario>/proyectos/tilt/tilts/new-admin
duck-install-hooks /home/<usuario>/proyectos/tilt/tilts/civitatis
```

## Comportamiento

`duck-install-hooks` se ejecuta **100% en bash** vía `hooks/install-hooks.sh`. El dispatcher hace short-circuit; no se invoca a Claude (el comando es declarativo: copiar tres archivos).

Para cada hook (`pre-commit`, `pre-push`, `post-merge`):

- Si el repo destino **no** tiene un hook con ese nombre → se instala el de rubber-duck.
- Si **ya** existe un hook con el sello `# rubber-duck git hook` → se actualiza in-place (versiones antiguas de rubber-duck se reemplazan).
- Si existe un hook **ajeno** → se preserva como `<hook>.bak.<timestamp>` antes de instalar el de rubber-duck.

Los scripts instalados son idénticos a los de `$RUBBER_DUCK_HOME/hooks/git/`. Leen `~/.rubber-duck/config.json` en cada invocación; cambiar el flag con `duck-config` aplica inmediatamente sin reinstalar.

## Activación

Tras instalar, los hooks no hacen nada (default `false`). Activar uno o todos:

```bash
duck-config set git.hooks.pre_commit_enabled true
duck-config set git.hooks.pre_push_enabled true
duck-config set git.hooks.post_merge_enabled true
```

Comprobar estado:

```bash
duck-config get git.hooks.pre_commit_enabled
duck-help config.git.hooks.pre_commit_enabled
```

## Qué hace cada hook (cuando está activado)

| Hook | Acción |
|---|---|
| `pre-commit` | Detecta el proyecto del repo y ejecuta el audit. new-admin → `$PROJECT_ROOT/bin/pre-commit`. old-admin → `duck-audit --branch` (sentido común). Bloquea el commit si falla. Saltable con `git commit --no-verify`. |
| `pre-push` | Extrae JIRA-KEY del nombre de rama (`feature/PANA-123-foo` → `PANA-123`) y ejecuta `duck-review <KEY>`. Bloquea el push si 🔴. Sale silencioso si no hay key. Saltable con `git push --no-verify`. |
| `post-merge` | Ejecuta `duck-sync-docs all` en background tras `git pull` / `git merge`. Log en `~/.rubber-duck/last-post-merge-sync.log`. No bloquea el flujo de git. |

## Restricciones

- No modifica `~/.rubber-duck/config.json` — solo copia los scripts.
- No instala dependencias externas.
- No requiere que el repo sea un proyecto detectado por rubber-duck (cualquier repo git sirve; los hooks dentro saltan si la detección falla).

## Errores y exit codes

| Situación | Exit |
|---|---|
| Éxito | 0 |
| Destino no es un repo git (sin `.git/`) | 2 |
| Algún hook no se pudo copiar | 1 |
