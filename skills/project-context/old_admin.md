# Skill `project-context/old_admin`

Contexto del proyecto **old-admin**: módulo `{URL_DOMAIN}/admin` del repo `civitatis`. Carga este archivo cuando `$PROJECT_TYPE == old-admin` antes de cualquier acción.

## Política de trabajo (CRÍTICA — leer antes que el resto)

old-admin está en **modo mantenimiento**. La visión a largo plazo del equipo es **eliminar old-admin** y migrar todo a `new-admin`.

| Regla | Significado |
|---|---|
| ✅ Permitido | Bug fixes (errores en producción) |
| ✅ Permitido | Mantenimiento puntual (ajustes ante cambios en BBDD compartida, integraciones, etc.) |
| ⚠️ Si lo pides | Funcionalidad nueva: advertir al usuario y proponer hacerlo en new-admin. Si insiste, continuar pero **registrar la decisión** en el output. |
| ❌ Prohibido | Modificar paths fuera del scope `/admin` (ver §"Scope") |
| ❌ Prohibido | "Modernizar" código legacy de forma puntual (rompe consistencia) |
| ❌ Prohibido | Confluence / herramientas formales de calidad (no existen y no se van a configurar) |

Cuando un cambio sea **no trivial**, sugiere usar `duck-migrate` para mover la pieza entera a new-admin en lugar de parchearla aquí.

## Scope estricto: solo rutas servidas desde `{URL_DOMAIN}/admin`

Modificaciones admitidas solo en estos paths (todos relativos a `$PROJECT_ROOT`, que es la raíz de `civitatis`):

### Backend

| Path | Contenido |
|---|---|
| `application/admin/` | Entry points, controladores y vistas mezcladas con PHP/HTML |
| `application/admin/adminApi/` | Endpoints API consumidos por la SPA del propio /admin |
| `application/lib/Admin/` | Helpers y librerías específicos de admin |
| `application/lib/Dao/Admin/` | DAO (acceso a datos directo PDO) |
| `application/lib/Dto/Admin/` | DTOs |
| `application/lib/Queues/Newadmin/` | Productores de colas que escriben a new-admin |
| `application/lib/NewAdmin/` | Otra capa de bridge histórica hacia new-admin |

### Templates

| Path | Contenido |
|---|---|
| `application/templates/admin/` | Plantillas (mezcla de HTML + PHP + Smarty/Twig según caso) |

### Frontend

| Path | Contenido |
|---|---|
| `webroot/static/js/admin/` | JS compilado/minificado |
| `webroot/static/css/admin/` | CSS compilado |
| `webroot/dev/js/admin/` | JS fuente |
| `webroot/dev/scss/admin/` | SCSS fuente |
| `dev/src/js/admin/` | Otros assets JS de desarrollo |
| `application/css_admin/` | CSS embebido en `application/` |

**Validación obligatoria** antes de aplicar un cambio: el path destino debe coincidir con un prefijo de esta lista. Si no, **rechazar** la modificación con error claro.

## Stack técnico

| Tecnología | Versión / detalle |
|---|---|
| PHP | 5.6 (`Dockerfile.base` → `FROM php:5.6-apache`) |
| Servidor | Apache 2 |
| Templating | HTML/PHP embebido con short tags `<?` y `<?= ?>` (>400 short tags en `application/admin/index.php`) |
| Frontend | jQuery + JS vanilla, sin framework SPA estable para todo el módulo |
| Persistencia | PDO directo (`include("include/conexionPDO.php")` en muchos archivos) |
| Composer | mínimo: solo `google/apiclient`, `ext-json`, `ext-pdo` (`composer.json` en la raíz de civitatis tiene 3 entradas) |
| Autoload PSR-4 | inconsistente; muchos archivos usan `include`/`require_once` manual |
| Namespacing | irregular; algunas clases usan `\Civitatis\...`, otras viven en el namespace global |
| Sesión / auth | basada en `$_SERVER["PHP_AUTH_USER"]` (HTTP Basic) y objetos como `$user_admin->hasPermission(...)` |
| Caché | `\Civitatis\Cache\Cache` cuando aplica |

## Limitaciones del stack legacy (qué no usar en PHP 5.6)

| Feature | Disponible en 5.6 | Permitido aquí |
|---|---|---|
| Argumento variadic `...$args` | ✅ desde 5.6 | ✅ |
| Operador de potencia `**` | ✅ desde 5.6 | ✅ |
| `use function` / `use const` | ✅ desde 5.6 | ✅ |
| Spread en arrays `[1, ...$other]` | ❌ (PHP 7.4+) | ❌ |
| Null coalescing `??` | ❌ (PHP 7.0+) | ❌ |
| Spaceship `<=>` | ❌ (PHP 7.0+) | ❌ |
| Return type declarations `: string` | ❌ (PHP 7.0+) | ❌ |
| Scalar type hints (`int`, `string`, ...) | ❌ (PHP 7.0+) | ❌ |
| Nullable types `?Type` | ❌ (PHP 7.1+) | ❌ |
| Void return type | ❌ (PHP 7.1+) | ❌ |
| Typed properties `private int $x` | ❌ (PHP 7.4+) | ❌ |
| Arrow functions `fn() => …` | ❌ (PHP 7.4+) | ❌ |
| Named arguments | ❌ (PHP 8.0+) | ❌ |
| `match` expression | ❌ (PHP 8.0+) | ❌ |
| Enum | ❌ (PHP 8.1+) | ❌ |
| Readonly properties | ❌ (PHP 8.1+) | ❌ |

**Regla práctica:** imita el estilo del archivo que estás editando. No introduzcas sintaxis o patrones que el resto del archivo no use.

## Patrones reales del código

- **Short tags everywhere:** `<? include("..."); ?>` y `<?=$variable?>`. No conviertas a `<?php` aunque sea mejor práctica — rompes consistencia.
- **Includes manuales:** `include("../slim-common.php")`, `include_once $_SERVER["DOCUMENT_ROOT"]."/lib/Roles/checkPermision.php"`. No intentes pasar a PSR-4 puntualmente.
- **HTML embebido con PHP:** plantilla y lógica mezcladas en el mismo archivo. Asumir que es así y trabajar con ello.
- **PDO directo:** consultas SQL con `$pdo->prepare(...)` y `bindValue` o, en código más antiguo, concatenación. Si añades una query nueva, **siempre prepared statements** (defensa contra SQL injection — ver §"Auditoría").
- **jQuery:** la mayoría del JS del módulo. No introduzcas frameworks SPA puntuales.
- **Globals:** `$user_admin`, `$_SERVER["PHP_AUTH_USER"]`, etc. No intentes refactorizarlos.

## Auditoría: modo "sentido común" (sin herramientas estáticas)

old-admin **no tiene** `phpstan`, ni `phparkitect`, ni `php-cs-fixer`. No los configures.

Cuando `duck-audit` se ejecute sobre old-admin, el modo es semántico:

| Buscar | Por qué |
|---|---|
| SQL injection | Concatenación de variables en queries sin prepared statements |
| XSS | Output sin escape en templates (`echo $foo` en HTML) |
| Lógica obviamente rota | Condicionales invertidos, return missing, branches imposibles |
| Inconsistencia grosera con el archivo | Sintaxis o patrones que rompen el estilo del resto del fichero |
| Permisos faltantes | Cambios en endpoints sin la comprobación habitual `$user_admin->hasPermission(...)` |

**NO reportar** como problema:

- Short tags `<?`
- Indentación irregular
- Falta de typed properties / return types
- Globals, includes manuales, PDO directo
- HTML embebido en PHP

Esos son **el estado normal** del código.

## Base de datos

- **Misma BBDD que new-admin.** `civitatis`, MySQL 8.x, ~898 tablas.
- Acceso típicamente vía PDO directo (`conexionPDO.php`) y a veces `\Civitatis\Cache\Cache` o helpers en `application/lib/`.
- **R2 sigue siendo regla:** rubber-duck no ejecuta `INSERT`/`UPDATE`/`DELETE`/`ALTER`/`DROP`/`TRUNCATE`. Si el cambio lo requiere, redactar la query exacta y dejar al usuario ejecutarla.

## Atlassian — Confluence

**No existen páginas de estándares para old-admin** y no se van a crear. `mcp/atlassian/page-ids.json` solo contiene entradas para new-admin.

`duck-sync-docs old-admin` se limita a generar `project-snapshot.md` (análisis del código real restringido al scope `/admin`). No genera `backend-standards.md` ni `frontend-standards.md` artificiales.

## Antes de actuar

1. Confirmar que el cambio cabe en la política "bug fix o mantenimiento". Si huele a funcionalidad nueva → propón new-admin.
2. Confirmar que cada path tocado está en el scope (§"Scope estricto"). Si no → rechazar.
3. Identificar el archivo concreto. Leer las primeras 50 líneas para conocer su estilo (short tags, namespacing, indentación).
4. Imitar ese estilo en los cambios.
5. Si la query SQL es nueva o se modifica, usar prepared statements aunque el resto del archivo concatene.
6. Para escape de output en templates, usar `htmlspecialchars(..., ENT_QUOTES, 'UTF-8')` salvo que el archivo ya tenga un helper específico del proyecto.

## Visión

`old-admin` → `new-admin`. Cada cambio no trivial es candidato a **migrar la pieza entera** a new-admin con `duck-migrate` en lugar de parcharla aquí. Anota la sugerencia en el output cuando aplique.
