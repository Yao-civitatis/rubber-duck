# Project Snapshot — old-admin

> Generado por `duck-sync-docs` el 2026-05-27.
> Refleja el estado real del código en `/home/yaowu/proyectos/tilt/tilts/civitatis` en ese momento, restringido al scope `{URL_DOMAIN}/admin`.
> No editar manualmente: el siguiente sync lo sobrescribe.

> **⚠️ Política de mantenimiento.**
> old-admin está en modo mantenimiento-only. No hay desarrollo de nueva funcionalidad.
> Visión del equipo: eliminar old-admin → migrar todo a new-admin.
> Sin Confluence ni herramientas formales de calidad. Audit por sentido común.
> Detalle en `$RUBBER_DUCK_HOME/rules/operational-restrictions.md` y `$RUBBER_DUCK_HOME/skills/project-context/old_admin.md`.

## 1. Tecnologías y versiones

### Backend

| Componente | Versión | Uso |
|---|---|---|
| PHP | 5.6 | runtime (Dockerfile.base → `FROM php:5.6-apache`) |
| Apache | 2.x | servidor HTTP |
| Composer (paquetes) | mínimo | `google/apiclient ^2.2`, `ext-json`, `ext-pdo`, `ext-redis` (composer.json del root tiene solo estas 4 entradas) |
| Autoload PSR-4 | inconsistente | la mayoría del scope `/admin` usa `include`/`require_once` manual, no PSR-4 |
| Persistencia | PDO directo | `include("include/conexionPDO.php")` por archivo |
| Templating | HTML embebido en PHP | short tags `<?` y `<?= ?>` ampliamente usados |
| Sesión / Auth | `$_SERVER["PHP_AUTH_USER"]` (HTTP Basic) + `$user_admin->hasPermission(...)` | |
| Caché | `\Civitatis\Cache\Cache` cuando aplica | |
| Newrelic | `newrelic-php5 9.16.0.295` | instrumentación legacy |

### Frontend (dentro del scope `/admin`)

| Componente | Detalle |
|---|---|
| jQuery | librería principal del módulo |
| JS minificado | `webroot/static/js/admin/civitatisAdmin.min.js` (~182 KB) |
| JS fuente | `webroot/dev/js/admin/` |
| CSS fuente | `webroot/dev/scss/admin/` |
| CSS compilado | `webroot/static/css/admin/`, `application/css_admin/` |
| Build pipeline | `dev/src/js/admin/admin.js` (~6.7 KB) — pipeline mínimo |

No hay framework SPA estable para todo el módulo. Convivencia ad hoc de jQuery + scripts inline.

## 2. Estructura de carpetas (scope `/admin` únicamente)

```
civitatis/
├── application/
│   ├── admin/                       # Entry points + controladores + vistas (mezcla)
│   │   ├── index.php                # Entry principal (240 KB)
│   │   ├── indexfast.php            # Variante optimizada (210 KB)
│   │   ├── actividades/             # Subarea actividades (verReserva.php = 419 KB)
│   │   ├── adminApi/                # Endpoints API consumidos por SPA del propio /admin
│   │   ├── afiliados/, agencias/, audioguias/, chargebacks/, coches/
│   │   ├── compensaciones/, css/, destinos/, estadisticas/
│   │   ├── facturacion/, facturas/, goom/, guias/, hoteles/
│   │   ├── iconos/, imagenes/, it/, proveedores/, traslados/
│   │   └── …
│   ├── lib/
│   │   ├── Admin/                   # Helpers/librerías específicas de admin
│   │   ├── Dao/Admin/               # DAO (acceso a datos directo PDO)
│   │   ├── Dto/Admin/               # DTOs
│   │   ├── NewAdmin/                # Bridge histórico hacia new-admin
│   │   └── Queues/Newadmin/         # Productores de colas hacia new-admin
│   ├── templates/admin/             # Plantillas (HTML + PHP + Smarty/Twig según caso)
│   └── css_admin/                   # CSS embebido en application/
├── webroot/
│   ├── static/
│   │   ├── js/admin/                # JS compilado (civitatisAdmin.min.js)
│   │   └── css/admin/               # CSS compilado
│   └── dev/
│       ├── js/admin/                # JS fuente
│       └── scss/admin/              # SCSS fuente
└── dev/
    └── src/js/admin/                # Otros assets JS de desarrollo (admin.js)
```

Paths fuera del whitelist anterior se ignoran intencionadamente (regla `skills/project-context/old_admin.md` §"Scope estricto").

## 3. Arquitectura detectada

**No aplican capas hexagonales.** El código es legacy estructurado por carpeta funcional:

- Entry HTTP por archivo `.php` directo (Apache sirve `index.php`, `actividades/listar.php`, etc.).
- Lógica y vista mezcladas en el mismo archivo (HTML embebido con `<?= $var ?>`).
- Acceso a datos vía PDO directo (`$pdo->prepare(...)` o concatenación en archivos más antiguos).
- Permisos comprobados con `$user_admin->hasPermission("<permiso>")` al inicio del archivo.
- Comunicación con new-admin vía colas (`application/lib/Queues/Newadmin/` produce → RabbitMQ → new-admin consume).
- Sin DI container, sin router central, sin namespaces consistentes.

Patrones visibles:

- **Short tags `<?` y `<?=`** ampliamente usados (>400 ocurrencias en `application/admin/index.php`).
- **Includes manuales:** `include("../slim-common.php")`, `include_once $_SERVER["DOCUMENT_ROOT"]."/lib/Roles/checkPermision.php"`.
- **PHP 5.6 strict:** sin `??`, sin `?Type`, sin typed properties, sin `match`, sin enums, sin spread arrays, sin arrow functions, sin scalar type hints. Cualquier código nuevo debe respetar esto.

## 4. Puntos de entrada

| Ruta servida | Archivo |
|---|---|
| `{URL_DOMAIN}/admin/` | `application/admin/index.php` |
| `{URL_DOMAIN}/admin/indexfast.php` | variante optimizada |
| `{URL_DOMAIN}/admin/<subarea>/<archivo>.php` | rutas directas servidas por Apache (un PHP = una URL) |
| `{URL_DOMAIN}/admin/adminApi/*` | endpoints API consumidos por SPA del propio /admin |

No hay router central — Apache sirve cada `.php` como endpoint.

## 5. Dependencias externas

- **BBDD MySQL `civitatis`** — compartida con new-admin (~898 tablas).
- **RabbitMQ** vía `application/lib/Queues/Newadmin/` (productores hacia new-admin).
- **Newrelic** (`newrelic-php5` 9.16.0.295) — instrumentación de performance.
- **Google API** (`google/apiclient ^2.2`) — auth/integraciones.
- **Redis** (`ext-redis`) — caché/sesión.
- **Sistema de assets externos:** imágenes en CDN/S3 (referenciadas, no servidas desde el repo).

## 6. Estado de deuda técnica

**Indicadores accionables** (no estilo legacy — ese es el estado normal del código y no se reporta):

- **Archivos enormes en `application/admin/`:**

  | Archivo | Tamaño |
  |---|---|
  | `application/admin/actividades/verReserva.php` | 419 KB |
  | `application/admin/traslados/verReserva.php` | 320 KB |
  | `application/admin/index.php` | 240 KB |
  | `application/admin/indexfast.php` | 210 KB |
  | `application/admin/proveedores/modificarProveedor.php` | 197 KB |
  | `application/admin/actividades/include/modificar_actividad_post.php` | 172 KB |
  | `application/admin/guias/modificarPaginaGuia.php` | 159 KB |
  | `application/admin/facturas/listado.php` | 144 KB |
  | `application/admin/facturacion/pagosCreditoAvoris.php` | 116 KB |
  | `application/admin/it/parsearXlsxHtmlTable.php` | 115 KB |

  Estos son candidatos prioritarios a **migrar pieza a pieza** a new-admin con `duck-migrate` cuando se trabaje en su dominio. Parchear in-place es válido (modo mantenimiento) pero no escalable.

- **Asset minificado monolítico:** `webroot/static/js/admin/civitatisAdmin.min.js` (~182 KB) concentra todo el JS del admin. Cualquier cambio en `webroot/dev/js/admin/` requiere recompilación manual y afecta a todo el módulo.

- **Bridge `application/lib/NewAdmin/`** existe para comunicación con new-admin; cualquier cambio en contratos new-admin afecta a este bridge.

- **`application/admin/index.php` (240 KB)** mezcla layout principal, navegación, permisos, y multiples vistas inline. Punto único de fallo para el área admin.

- **Riesgos típicos para auditoría puntual** (sentido común, no formales):
  - SQL injection: revisar siempre que añadas o modifiques una query nueva. Prepared statements obligatorios aunque el resto del archivo concatene.
  - XSS: cualquier output HTML nuevo debe usar `htmlspecialchars($v, ENT_QUOTES, 'UTF-8')`.
  - Permisos: si añades endpoint, mantén la comprobación `$user_admin->hasPermission(...)`.

- **Sin pipeline de calidad propia:** no hay `phpstan`, ni `phparkitect`, ni `php-cs-fixer` configurados para el scope `/admin`. Política del equipo: no se van a configurar. `duck-audit` opera en modo "sentido común" sobre este código.

- **Visión a largo plazo:** **eliminar `old-admin`** y migrar todo a new-admin. `duck-migrate` es la herramienta estratégica para empezar por las piezas grandes / críticas.
