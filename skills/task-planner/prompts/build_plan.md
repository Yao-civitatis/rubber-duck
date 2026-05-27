# Prompt — Construcción del plan de implementación

Construye el plan a partir de `$RUBBER_DUCK_HOME/templates/planning-template.md`. Adapta el contenido para que sea ejecutable por `duck-implement` después.

## Reglas de adaptación de la plantilla

- **Idioma del cuerpo:** se determina por `output.language` del config (`es` por defecto, `en` opcional). Todo el contenido del plan generado se redacta en ese idioma, incluyendo títulos de secciones, descripciones, criterios, comentarios y el commit message sugerido.
- **Literales que se preservan:** Jira keys (`PANA-123`), X-Ray IDs, símbolos de código (`PaymentService::process()`), paths de archivos, comandos shell. Estos NO se traducen.
- **`{JIRA_KEY}`:** sustituir por la key real del ticket.
- **`{project}.{module}`:** sustituir por el módulo real. Para new-admin: `new-admin.<modulo>` donde `<modulo>` se deriva del dominio (ej: `new-admin.payments`, `new-admin.activities`). Para old-admin: `old-admin.<path-corto>` donde `<path-corto>` es el subdirectorio relevante del scope `/admin`.
- **`[Link to JIRA]`:** sustituir por la URL real del ticket (`https://civitatis.atlassian.net/browse/<JIRA-KEY>`).

## Adaptaciones específicas por proyecto

### new-admin

- En "Architectural Pre-flight Check", marcar los puntos relevantes:
  - [x] Hexagonal layer rules respected (Controllers → Services → Repositories → Models).
  - [x] Shared DTOs used for cross-module communication.
  - [x] YAGNI check.
- En "Target Module/Bounded Context", usar los namespaces reales: `App\Controllers\<Modulo>`, `App\Services\<Modulo>`, etc.
- En "GREEN (Domain)" y "GREEN (Application/UI)", listar clases concretas a crear/modificar. Consultar `$PROJECT_ROOT/.claude/domain-index.md` para no inventar nombres.
- En "REFACTOR & OBSERVE", indicar métricas/logs concretos a añadir (Monolog channel, métrica Optimizely si aplica).
- En "COMMIT", usar formato Conventional Commits con prefijo apropiado (`feat`, `fix`, `refactor`, etc.) seguido de la JIRA key.

### old-admin

- Insertar como **primer** punto del Pre-flight check:
  ```
  - [ ] Cambio dentro del scope /admin (verificar paths exactos)
  - [ ] Confirmado: es bug fix o mantenimiento (no funcionalidad nueva)
  ```
- "Architectural Pre-flight Check" se relaja: no hay capas formales, no aplica YAGNI estricto.
- "SCENARIO TEST MATRIX (Mandatory)" se sustituye por:
  ```
  ### VERIFICATION MATRIX (manual)
  - [ ] V1 [URL: /admin/<ruta>] Comprobación: <qué hacer>
  - [ ] V2 [Output esperado: ...]
  - [ ] V3 [No-regresión: ...]
  ```
- "RED" se sustituye por "REPRO" (reproducir el bug si es un bug fix).
- "GREEN (Domain)" → "FIX" (lista archivos a modificar dentro del scope).
- "GREEN (Application/UI)" → opcional, solo si toca templates/JS.
- "REFACTOR & OBSERVE" → solo si añade logging útil para diagnóstico futuro. No refactor estructural.

## Detección de dominio

Para new-admin, consultar `$PROJECT_ROOT/.claude/domain-index.md` si existe. Buscar palabras clave del título y descripción del ticket. Producir un mapping del estilo:

```
Dominio detectado: payments
Controllers candidatos: App\Controllers\Payments\PaymentController
Services candidatos: App\Services\Payments\PaymentService
Rutas afectadas: app/Routes/payments.php (verificar app/route.php principal también)
Permisos: config/routePermissions.yml § payments
```

Si el dominio no se detecta con confianza, añadir entrada en "Defensive Planning → Questions" pidiendo al usuario que confirme.

## Salida

El archivo generado debe:

1. Empezar con el título de la plantilla: `# Spec-Driven Implementation Plan: <JIRA-KEY>`.
2. Incluir las 4 secciones de la plantilla (Traceability, Defensive Planning, Pre-flight Check, Execution).
3. Tener exactamente UN escenario activo (`🟢 ACTIVE SCENARIO`) y el resto como `⏳ PENDING SCENARIO ... [Pending Planning]`.
4. Ser legible y autocontenido. Cualquier developer del equipo debe poder leer el plan y entender la siguiente acción sin abrir otros archivos.

## Estilo

- Sin emojis salvo los del template original (🟢 ⏳ ⚠️).
- Sin frases vagas. "Modificar PaymentService" en lugar de "actualizar la lógica de pagos".
- Pasos accionables (un verbo por línea).
- Si hay dudas pendientes, listarlas en "Defensive Planning → Questions" en lugar de adivinar.
