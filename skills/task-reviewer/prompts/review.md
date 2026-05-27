# Prompt — Informe de revisión de código vs ticket

Cruza el código modificado en la rama actual contra los Criterios de Aceptación del ticket. Sé concreto, conciso, accionable.

## Criterios de evaluación

### 1. Cobertura de Criterios de Aceptación

Para **cada** AC del ticket (idealmente extraído del bloque rubber-duck entre marcadores), evalúa:

- ✅ **Cumple** — hay código + test que lo respaldan. Cita archivo:línea.
- ⚠️ **Parcial** — el código está, pero falta test, manejo de error, o caso edge.
- ❌ **No cumple** — el AC no se ha implementado o el código no hace lo que pide.

Cita evidencia **siempre**. "Cumple" sin archivo:línea = inútil.

### 2. Calidad del cambio (según proyecto)

**new-admin (verificar R3-R6):**

| Item | Pregunta concreta |
|---|---|
| R3 (Arquitectura) | ¿Controllers importan Models o Repositories directamente? ¿Services usan HTTP? |
| R4 (Controllers) | ¿Hay `extends AbstractController`? ¿Hay `$repositoryClass`? Si sí → violación. |
| R5 (HTTP codes) | `grep -E "withStatus\(\s*[0-9]+" archivos_modificados` — si match, violación. |
| R6 (Frontend) | ¿Hay `<script setup>` o `import { ref, reactive }` desde 'vue'? Si sí → violación (es Composition API). |
| Tests | ¿Hay tests nuevos en `tests/`? ¿Cubren cada AC del ticket? |
| Estilo | `bin/pre-commit php-cs-fixer --dry-run` da limpio? |
| Phpstan | `bin/pre-commit phpstan` da limpio? |
| Phparkitect | `bin/pre-commit phparkitect` da limpio? |
| Rutas/Permisos | Si hay ruta nueva, ¿`config/routePermissions.yml` actualizada? |

**old-admin:**

| Item | Pregunta concreta |
|---|---|
| Scope | ¿Todos los archivos modificados están en el whitelist del scope `/admin`? Si alguno está fuera → 🔴 bloqueante. |
| Política | ¿El cambio es bug fix / mantenimiento, o funcionalidad nueva? Si nueva → ⚠️ advertencia con sugerencia de `duck-migrate`. |
| Estilo coherente | ¿Los cambios imitan el archivo? (short tags, indentación, namespacing) |
| SQL injection | ¿Cualquier query SQL **nueva** usa prepared statements? Concatenación = violación. |
| XSS | ¿Output a HTML nuevo usa `htmlspecialchars` o equivalente? |
| Permisos | Si hay endpoint nuevo, ¿comprueba `$user_admin->hasPermission(...)` o similar? |
| Sintaxis legal en PHP 5.6 | ¿Se ha colado `??`, `?Type`, typed properties, `match`, enums, spread arrays, arrow functions? Cualquier match → violación. |
| Frontend | Si toca `dev/...`, ¿hay nota de recompilar assets? |

### 3. Lo que falta o hay que corregir

Lista accionable, con verbos. Ejemplos:

- ✅ "Añadir test para el caso de `amount=0` en `RefundServiceTest`."
- ✅ "Reemplazar `withStatus(422)` por `withStatus(StatusCode::HTTP_UNPROCESSABLE_ENTITY)` en `RefundController.php:42`."
- ❌ "Mejorar el código." → vago, inútil.

### 4. Conclusión

Una sola línea con el veredicto:

- 🟢 **Listo para PR.** Todos los AC cumplen y la calidad es OK.
- 🟡 **Listo con observaciones.** Cumple AC pero quedan mejoras menores. Sugerido pero no bloqueante.
- 🔴 **No listo.** Hay AC sin cumplir, violaciones de R3-R6 (new-admin), violaciones de scope (old-admin), o problemas de seguridad.

## Tono y formato

- Markdown limpio.
- Sin emojis salvo los del veredicto (✅ ⚠️ ❌ 🟢 🟡 🔴).
- Sin emoji-flood. Uno por celda de tabla, no más.
- Conciso. No repetir el ticket. No explicar lo obvio.
- **Idioma:** español por defecto. Si `output.language=en`, en inglés.
- Si el informe va a Jira como comentario, considera que va a ser leído por humanos del equipo. Sé respetuoso, factual, sin tono crítico personal.

## Detección rápida de violaciones (heurísticas)

```bash
# new-admin — R5 violation
grep -nE "->withStatus\(\s*[0-9]+\s*\)" <archivos>

# new-admin — R4 violation (Controllers extending AbstractController)
grep -lE "extends AbstractController" <controllers>

# new-admin — R6 violation (Composition API)
grep -lE "(<script setup|from 'vue'.*\bref\b|\bcomputed\b|\bonMounted\b)" <vue-files>

# old-admin — sintaxis PHP 7+ ilegal
grep -nE "\?\?|: \?\w+|: void|: bool|: int|: string|fn ?\(" <archivos>

# old-admin — concatenación en SQL (heurística)
grep -nE "->query\([^?]*\.\$|->exec\([^?]*\.\$" <archivos>
```

No bases el informe SOLO en estas heurísticas — son ayudas. Lee el código.
