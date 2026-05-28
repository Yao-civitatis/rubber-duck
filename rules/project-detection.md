# Regla: detección dinámica de proyecto

**Aplica a:** cualquier comando que opere sobre un proyecto (new-admin u old-admin). No aplica a comandos project-agnostic (`config`, `help`, `install-hooks`).

## Patrón

Ningún skill, agent, command o helper **hardcodea** paths de proyectos. La fuente de verdad para `$PROJECT_ROOT` y `$PROJECT_TYPE` es `bin/lib/detect-project.sh`, ejecutada:

- Por el dispatcher `bin/duck.sh` antes de invocar a Claude.
- Por los slash commands `/duck-*` en su Paso 1 (vía Bash).

## Marcadores

| Proyecto | Marcador |
|---|---|
| new-admin | `composer.json` con `"name": "civitatis/newadmin"` **o** `.claude/domain-index.md` presente |
| old-admin | directorio con `application/admin/` Y `webroot/` (raíz de civitatis) |

## Resolución

1. **Walk-up desde `$PWD`** buscando los marcadores. Primer match gana.
2. **Fallback:** `~/.rubber-duck/config.json` con `project.new_admin_path` y `project.old_admin_path` (si están definidos y el CWD es subpath).
3. **Si falla todo:** error explícito con sugerencia de moverse al proyecto o configurar el path.

## Fitness check

```bash
grep -rE "/home/[^/]+/proyectos/(ai-development-rules|tilt)" \
  skills/ agents/ commands/ templates/ rules/ bin/lib/ \
  | grep -v '<usuario>'
```

Debe devolver 0 matches. Si aparece algún path absoluto externo, hay una dependencia ilegal que romper.

## Cómo lo usan las skills

- Skills downstream consumen `$PROJECT_ROOT` (env var) y `$PROJECT_TYPE` (env var, `new-admin` | `old-admin`).
- Subpaths se componen desde el root: `$PROJECT_ROOT/app/Services/...`, `$PROJECT_ROOT/application/admin/...`.
- Nunca se leen rutas absolutas hardcoded.
