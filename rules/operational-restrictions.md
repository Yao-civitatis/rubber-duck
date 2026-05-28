# Regla: restricciones operacionales R1–R7 + política old-admin

**Aplica a:** cualquier comando que toque new-admin (y por extensión a old-admin salvo indicación contraria).

## Restricciones globales

| # | Restricción | Detalle |
|---|---|---|
| **R1** | Jira escritura controlada | Solo en flujos explícitos con confirmación expresa del usuario (`duck-analyze`, `duck-review`). El resto solo lee. `duck-analyze` hace append idempotente entre marcadores `<!-- rubber-duck:start -->` … `<!-- rubber-duck:end -->`. `duck-review` solo añade comentarios nuevos, nunca edita los existentes ni la descripción. |
| **R2** | Base de datos read-only | Prohibido `INSERT`/`UPDATE`/`DELETE`/`ALTER`/`DROP`/`TRUNCATE`. Si la tarea requiere mutación, redactar la query exacta y dejar al usuario ejecutarla manualmente. BBDD compartida new-admin ↔ old-admin: cualquier mutación afecta a ambos. |
| **R2.1** | Niveles por entorno DB | `duck-db` aplica gates anti-mutación escalonadas por `danger_level` del env activo (`$DUCK_DB_ENV`, default `dev`). `low` (dev) → gates (a)+(d); `medium` (qa) → (a)+(d)+(e); `high` (slave) → (a)+(b)+(c)+(d)+(e); `critical` (prod) → (a)+(b)+(c)+(d)+(e) con confirmación tipeando literal `prod`. Gates: **(a)** `config.read_only=true`, **(b)** servidor `@@global.read_only=1` ∧ `@@global.super_read_only=1`, **(c)** `SHOW GRANTS FOR CURRENT_USER` sin privilegios de mutación, **(d)** regex anti-mutación sobre la query, **(e)** confirmación interactiva. Implementación: `bin/lib/db-env.sh`. Tests: `bin/lib/db-env.test.sh`. Sin flag `--env=` solo se permite `dev`; `qa/slave/prod` requieren flag explícito. |
| **R3** | Arquitectura hexagonal (new-admin) | Validada por `phparkitect`. Controllers → Services → Repositories → Models. Sin dependencias inversas. |
| **R4** | Controllers nuevos (new-admin) | Sin `AbstractController`. Service inyectado por parámetro del método. Sin `$repositoryClass`. |
| **R5** | HTTP codes (new-admin) | `Slim\Http\StatusCode::HTTP_*`. Nunca literales numéricos como `422`, `404`, etc. |
| **R6** | Frontend (new-admin) | 100% Options API. Container + Presentational. Props down / events up. Módulos en `dev/vue/modules/`. |
| **R7** | BBDD compartida | Cualquier cambio de esquema afecta a new-admin y old-admin. Avisar siempre. |

## Política old-admin (mantenimiento-only)

Old-admin = módulo `{URL_DOMAIN}/admin` del repo `civitatis` (PHP 5.6 + Apache + HTML/jQuery + PDO directo).

- **Solo bug fixes y mantenimiento.** Funcionalidad nueva → advertir al usuario y proponer `duck-migrate` para mover la pieza a new-admin.
- **Scope estricto:** solo se modifican paths del whitelist (definida en `skills/project-context/old_admin.md`). Cualquier cambio fuera → rechazar con error.
- **Sin Confluence ni estándares formales.** No hay `phpstan`, `phparkitect`, `php-cs-fixer` configurados ni se van a configurar.
- **Auditoría por sentido común:** SQL injection, XSS, lógica obviamente rota, consistencia con el estilo del archivo. NO reportar estilo legacy (short tags, etc.) — es el estado normal.
- **Stack legacy (PHP 5.6):** sin syntax post-5.6 (sin `??`, sin `?Type`, sin typed properties, sin `match`, sin enums, sin spread arrays, sin arrow functions, sin scalar type hints).
- **Visión:** eliminar old-admin → migrar todo a new-admin.

## Aplicabilidad

- Restricciones R1–R7 se inyectan automáticamente en el system prompt por el dispatcher (`bin/duck.sh`) y los slash commands `/duck-*` (en su Paso 2).
- Skills, agents y commands citan esta regla cuando refuerzan un punto concreto (p.ej. `duck-analyze` cita R1 al pedir confirmación).
