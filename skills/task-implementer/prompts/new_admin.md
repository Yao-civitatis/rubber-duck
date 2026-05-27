# Prompt — Implementación TDD en new-admin

Implementación estricta en **TDD red-green-refactor** sobre el stack PHP 7.4 + Slim 3 + illuminate/database 8 + Twig 3 + Vue 2.6 Options API + Webpack 4.

## Recordatorio de restricciones

- **R3 (Arquitectura hexagonal):** Controllers → Services → Repositories → Models. Validado por `phparkitect`.
- **R4 (Controllers):** sin `AbstractController`. Service inyectado por parámetro del método.
- **R5 (HTTP codes):** `Slim\Http\StatusCode::HTTP_*`, nunca literales.
- **R6 (Frontend):** 100% Options API. Container + Presentational. Props down / events up. Módulos en `dev/vue/modules/`.
- **R2 (BBDD):** read-only. Si el cambio requiere datos, redactar SQL en el output, no ejecutar.

## Flujo por escenario activo del plan

### A. Por cada item del Test Matrix (en orden T1, T2, ...)

#### A.1 RED — Escribir UN test que falle

1. Identificar la capa que se está probando:
   - Unit (Service, Repository, Domain): test en `tests/<capa>/<Modulo>Test.php` con Pest.
   - Integration (Controller con DB): test en `tests/Repository/` o `tests/Modules/`.
   - Frontend (Vue component): test en `dev/vue/__tests__/` o equivalente con Jest + `@vue/test-utils`.
2. Crear el archivo de test si no existe. Si existe, **añadir** un `it(...)` (Pest) o `test(...)` (Jest), no reescribir.
3. **Incluir X-Ray ID en el cuerpo del test como comentario o en el nombre del test:**
   ```php
   it('returns 422 when amount is negative [XRAY: PANA-XR-1]', function () {
       // ...
   });
   ```
4. Ejecutar SOLO ese test:
   - PHP: `$PROJECT_ROOT/bin/pre-commit tests <ruta-test>` (si no acepta filtros, ejecuta todo el suite y verifica que el nuevo falla).
   - Vue: `cd $PROJECT_ROOT/dev && jest <ruta-test>`.
5. **Verifica que falla** (mensaje de error coherente con la ausencia de implementación). Si no falla, hay un problema: el código ya existía o el test no comprueba lo que pretende. Para y diagnostica.

#### A.2 GREEN — Implementar el mínimo

Sigue las secciones "GREEN (Domain)" y "GREEN (Application/UI)" del plan al pie de la letra.

**Capas obligatorias:**

1. **Domain:** entidades, value objects, exceptions de dominio. Vive en `app/Domain/<Modulo>/`. Sin dependencias de framework.
2. **Repositories:** interfaces de repo en `app/Repositories/<Modulo>/<X>RepositoryInterface.php`; implementación con Eloquent en `app/Repositories/<Modulo>/<X>Repository.php`.
3. **Services (use cases):** `app/Services/<Modulo>/<X>Service.php`. **Recibe Repositorios por constructor** (excepción a R3 controlada vía baseline). Lógica de negocio aquí.
4. **Controllers:** `app/Controllers/<Modulo>/<X>Controller.php`. Adaptador HTTP fino. Inyecta el Service por parámetro de método.
5. **Rutas:** registrar en `app/Routes/<modulo>.php` (o `app/route.php` principal si así está la convención).
6. **Permisos:** **siempre** actualizar `config/routePermissions.yml` si la ruta es nueva o cambia.

**Validación:**

- Inputs: `App\Validations\<Modulo>\<X>Validator` con `respect/validation`.
- Errores de validación → respuesta `StatusCode::HTTP_UNPROCESSABLE_ENTITY` (422).

**Ejecuta los tests** tras cada GREEN. Repite hasta que el test del paso A.1 pase.

#### A.3 REFACTOR & OBSERVE

1. Limpia el código: funciones pequeñas, nombres claros.
2. Añade métricas/logs si el plan los pide:
   - Logging: Monolog channel `app` o el que dicte el plan.
   - Observabilidad: si toca un flujo crítico de colas, considerar emit a `queue_action_payload` log.
3. Ejecuta TODO el suite para asegurar no-regresión: `$PROJECT_ROOT/bin/pre-commit tests`.
4. Si hay regresiones, corregirlas antes de continuar.

#### A.4 SCENARIO COMPLETENESS GATE

¿Quedan items en el Test Matrix? Vuelve a A.1.

¿Todos pasan? Salta a B.

### B. Validación arquitectónica

```bash
"$PROJECT_ROOT/bin/pre-commit" phparkitect
"$PROJECT_ROOT/bin/pre-commit" phpstan
"$PROJECT_ROOT/bin/pre-commit" php-cs-fixer
```

Si alguno falla, **NO añadas baseline nuevo** sin permiso del usuario. Pregunta:

```
⚠️ phparkitect detecta violaciones nuevas:
  <lista>

Opciones:
  [r] Refactorizar para cumplir la regla [recomendado]
  [b] Añadir entrada en phparkitect-baseline.json (requiere justificación)
  [N] Parar aquí
> _
```

### C. Commit (al final del escenario)

Mensaje según `git.commit_message_format`:

- `jira`: `PANA-123: <descripción breve>`
- `conventional`: `feat(<scope>): PANA-123 <descripción>`
- `custom`: leer `~/.rubber-duck/commit-template.txt`

Si `git.auto_commit_after = implement` y `git.auto_commit = true`, el dispatcher hace el commit. Si no, deja los cambios staged y avisa al usuario.

## Reglas de oro

- **No saltes pasos.** Si el plan pide T1 antes de T2, sigue ese orden.
- **No inventes nombres.** Si dudas, consulta `$PROJECT_ROOT/.claude/domain-index.md` o pregunta al usuario.
- **No introduzcas Composition API.** Vue 2 + Options API es la única opción.
- **No uses `new AbstractController`.** Controllers son finos, sin herencia.
- **No literales HTTP.** Siempre `StatusCode::HTTP_*`.
- **No mutar props en Vue.** Emit events.
- **Tests primero, código después.** Si encuentras un código ya implementado sin test, escribe el test antes de modificarlo.

## Mensajes de progreso

Imprime al usuario un breve estado por paso:

```
🦆 [T1 RED] Escribiendo test para RefundService::process()...
🦆 [T1 GREEN] Implementando RefundService::process()...
🦆 [T1 PASS] OK
🦆 [T2 RED] ...
```

Si algo va mal, **para** y explica qué pasó.
