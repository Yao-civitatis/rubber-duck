# Prompt — Capa semántica (cruce con `~/.rubber-duck/docs/`)

Cruza el código auditado con las **normas vivas** sincronizadas por `duck-sync-docs`. Distingue new-admin (estándares formales) de old-admin (sentido común).

## Inputs

- Lista de archivos a auditar (calculada en el Paso 1 del SKILL).
- Contenido actual de los archivos.
- Para new-admin: `~/.rubber-duck/docs/new-admin/{backend-standards,frontend-standards,project-snapshot}.md`.
- Para old-admin: `~/.rubber-duck/docs/old-admin/project-snapshot.md`.

## Cómo cargar los docs

Si `~/.rubber-duck/docs/<proyecto>/` no existe → degradar:

1. Avisar al usuario: `⚠️ docs no sincronizados aún. Ejecuta duck-sync-docs <proyecto> primero para un audit más completo.`
2. Caer a un set mínimo de checks hardcoded (R3-R6 + scope) que vive en este mismo prompt.
3. Continuar el audit con cobertura reducida.

## Checks por proyecto

### new-admin

Para cada archivo PHP/Vue del set de audit, comparar con las normas:

| Check | Severidad | Lectura del estándar |
|---|---|---|
| Controller no extiende `AbstractController` | error (R4) | backend-standards §"Controladores" |
| Controller con un solo `__invoke` público | error (R4) | backend-standards §"Controladores" |
| Controller no importa Repositories ni Models | error (R3) | backend-standards §"Controladores" + project-snapshot |
| Service con un solo `__invoke` público y sufijo `Service` | warning | backend-standards §"Servicios de aplicación" |
| Service no depende de HTTP | error (R3) | backend-standards §"Criterios obligatorios" |
| Service tiene Input/Output classes en misma carpeta | warning | backend-standards §"Input y Output" |
| Repository nuevo con prefijo `Eloquent*` + carpeta propia | warning | backend-standards §"Repositorios" |
| Interface de Repository en `app/Domain/<X>/<X>Repository.php` | warning | backend-standards §"Interfaces de Repositorio" |
| Domain Service con sufijo `DomainService` | info | backend-standards §"Servicios de Dominio" |
| Adapter en `app/Infrastructure/` con sufijo `Adapter` + Gateway en Domain | warning | backend-standards §"Adaptadores" |
| Excepción de dominio con sufijo `Exception`, no genérica `\Exception` | warning | backend-standards §"Excepciones" |
| HTTP code: nunca literales numéricos en `withStatus()` — usar `StatusCode::HTTP_*` | error (R5) | (regla del equipo + project-context) |
| Ruta nueva → entry en `config/routePermissions.yml` | error | backend-standards §"Rutas" + project-context |
| Vue: 100% Options API (no `<script setup>`, no `import { ref, ... } from 'vue'`) | error (R6) | frontend-standards §"Estructura base" |
| Vue: clases CSS BEM, scoped styles | warning | frontend-standards §"Clases CSS" |
| Vue: keys únicas en v-for (no índices) | warning | frontend-standards §"v-for y Keys" |
| Vue: no mutación directa de props | error | frontend-standards §"Evitar mutation directo de props" |
| Vue: PascalCase para componentes, camelCase para props/data/methods | warning | frontend-standards §"Nomenclatura" |
| Componente con >300 líneas de script | info | frontend-standards §"Tamaño de componentes" |

Heurísticas rápidas (grep) para acelerar la detección antes de leer cada archivo:

```bash
# R4: Controllers extending AbstractController
grep -lE "extends AbstractController" <archivos_php>

# R5: literales en withStatus
grep -nE "->withStatus\(\s*[0-9]+\s*\)" <archivos_php>

# R6: Composition API en Vue
grep -lE "(<script setup|from 'vue'.*\b(ref|reactive|computed|onMounted)\b)" <archivos_vue>

# Excepciones genéricas
grep -nE "throw new \\\\?Exception\b" <archivos_php>

# Service sin __invoke (sospechoso)
grep -L "public function __invoke" <services_php>
```

### old-admin

Las normas formales no aplican. Auditoría en modo **sentido común**.

Checks (severidad alta solo si tocan seguridad/lógica/scope):

| Check | Severidad | Razón |
|---|---|---|
| Path del archivo fuera del whitelist `/admin` | error 🔴 (bloqueante) | scope estricto |
| SQL injection: query nueva con concatenación de variables (`->query("... " . $foo)` o `->exec`) | error 🔴 | seguridad |
| XSS: output a HTML con `echo $foo` sin `htmlspecialchars` en código nuevo/modificado | error 🔴 | seguridad |
| Permisos: endpoint nuevo sin `$user_admin->hasPermission(...)` o equivalente | error 🔴 | seguridad |
| Sintaxis ilegal en PHP 5.6 (`??`, `?Type`, `match`, `enum`, spread arrays, arrow functions, scalar type hints) | error 🔴 | el stack no lo soporta |
| Lógica obviamente rota (condicionales invertidos, return missing, branches imposibles) | warning 🟡 | sentido común |
| Cambio incompatible con el estilo del archivo (mezclar long tags `<?php` con archivo que usa short tags `<?`) | warning 🟡 | consistencia |

**No reportar:**

- Short tags `<?`
- Indentación irregular
- Falta de typed properties / return types
- Globals, includes manuales, PDO directo (cuando es prepared)
- HTML embebido en PHP

Esto es el estado normal — reportarlo sería ruido.

Heurísticas:

```bash
# Sintaxis ilegal PHP 5.6 en archivos del scope
grep -nE "\?\?|: \?\w+|: void|: bool|: int|: string|fn ?\(|\bmatch\s*\(|\benum\s+\w" <archivos>

# Concatenación en SQL (heurística aproximada)
grep -nE "->query\([^?]*\.\$|->exec\([^?]*\.\$" <archivos>

# Output sin escape (heurística — falsos positivos posibles, revisar manualmente)
grep -nE "echo\s+\\\$\w+\s*;" <archivos>
```

## Hallazgos por categoría

Cada hallazgo se normaliza a:

| Campo | Valor |
|---|---|
| `tool` | `semantic` |
| `severity` | `error` / `warning` / `info` |
| `file` | path relativo a `$PROJECT_ROOT` |
| `line` | nº de línea (si aplica) |
| `message` | descripción concreta del problema |
| `category` | tag corto (`R3`, `R4`, `R5`, `R6`, `SQLi`, `XSS`, `scope`, `php-5.6-syntax`, …) |
| `suggestion` | acción concreta para resolverlo |

## Reporte en el informe unificado

Sección `## 3. Capa semántica`:

```markdown
## 3. Capa semántica

Cruzado contra:
- `~/.rubber-duck/docs/<proyecto>/backend-standards.md` (si new-admin)
- `~/.rubber-duck/docs/<proyecto>/frontend-standards.md` (si new-admin)
- `~/.rubber-duck/docs/<proyecto>/project-snapshot.md`

Resultado: <PASS | N hallazgos>

| # | Archivo:línea | Severidad | Categoría | Problema | Sugerencia |
|---|---|---|---|---|---|
| 1 | `app/Controllers/Payments/RefundController.php:8` | 🔴 | R4 | Extiende AbstractController | Reescribir inyectando Service por parámetro |
| 2 | `app/Controllers/Payments/RefundController.php:42` | 🔴 | R5 | Literal `422` en withStatus() | Usar `StatusCode::HTTP_UNPROCESSABLE_ENTITY` |
| 3 | … | … | … | … | … |
```

Si no hay hallazgos: `Resultado: PASS — normas cumplidas.`.

## Idioma

`output.language` aplica al cuerpo del informe. Mensajes y categorías técnicas (`R4`, `SQLi`, etc.) se preservan tal cual. Paths nunca se traducen.
