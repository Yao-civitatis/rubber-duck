# Prompt — Generación de User Story + AC + Consideraciones Técnicas

Genera el bloque siguiendo este formato exacto. Idioma según `output.language` (default `es`).

## Estructura del bloque

```markdown
## User Story

Como <rol>, quiero <acción> para <objetivo>.

(Si el ticket implica varios actores, lista una user story por actor. Máximo 3.)

## Criterios de Aceptación

**Escenario 1: <título descriptivo>**

```gherkin
Given <precondición>
When <acción>
Then <resultado esperado>
And <resultado adicional opcional>
```

**Escenario 2: <título>**

```gherkin
...
```

(Cubrir el happy path + al menos 1 edge case + al menos 1 error case cuando aplique.)

## Consideraciones Técnicas

- **Proyecto afectado:** <new-admin | old-admin | ambos>
- **Capa o módulo:** <indicar Controllers/Services/Repositories/Models cuando sea new-admin; indicar path concreto del scope /admin cuando sea old-admin>
- **Cambios esperados:** <bullet list de archivos/clases a tocar>
- **Riesgos:** <bullet list de cosas a verificar — BBDD compartida, integraciones, permisos, etc.>
- **Dependencias:** <otras tareas, otros tickets, infra externa>
- **Política aplicable:**
  - Si toca new-admin: respetar R3–R6 (hexagonal, controllers sin AbstractController, Slim StatusCode, Options API).
  - Si toca old-admin: **modo mantenimiento**. Confirmar que es bug fix o mantenimiento. Si parece funcionalidad nueva, sugerir hacerlo en new-admin.
  - BBDD compartida: cualquier cambio de esquema afecta a ambos proyectos.
```

## Criterios de calidad

- **User Story breve y orientada al usuario.** No describir implementación aquí.
- **AC verificables.** Cada Gherkin debe ser testeable. Evita "el sistema funciona bien" o frases vagas.
- **Consideraciones Técnicas específicas.** Nombrar archivos, clases, namespaces concretos cuando se conozcan (consultando `.claude/domain-index.md` del proyecto si está disponible). Evitar generalidades.
- **No inventar nombres de archivos.** Si no sabes el nombre concreto del Service/Controller a tocar, di "el Service del dominio X" en vez de inventar `XService.php`.
- **Tono:** profesional, conciso. Sin emojis salvo para destacar warnings críticos (p.ej. ⚠️ política de mantenimiento).

## Detección de proyecto

Heurística simple sobre el contenido del ticket:

- **Componentes o labels** que contengan `new-admin`, `panel-admin`, `vue`, `hexagonal` → new-admin.
- **Componentes o labels** que contengan `old-admin`, `civitatis-admin`, `legacy`, `/admin` → old-admin.
- **Mención explícita** de paths del scope `/admin` (ver `skills/project-context/old_admin.md`) → old-admin.
- **Mención explícita** de paths como `app/Controllers/`, `app/Services/`, `dev/vue/` → new-admin.
- Si no queda claro → marcar "Proyecto afectado: por determinar — preguntar al usuario".

## Idempotencia

Este prompt se ejecuta cada vez que el usuario llama `duck-analyze` con el mismo ticket. La salida debe ser **reproducible para una entrada idéntica** (modulo timestamp del bloque generado). No introducir variabilidad innecesaria.
