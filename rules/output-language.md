# Regla: idioma del contenido generado

**Aplica a:** cualquier skill, agent o command que genere texto user-facing (planes, informes, exports, mensajes interactivos).

## Patrón

Todo artefacto generado por rubber-duck se redacta en el idioma configurado en `output.language`:

- `es` por defecto.
- `en` opcional.

El idioma se aplica a:
- Títulos y descripciones de secciones.
- Criterios, comentarios, justificaciones.
- Commit messages sugeridos.
- Mensajes interactivos al usuario.
- Cualquier prosa generada.

## Literales que NO se traducen

Estos elementos se preservan en su forma original sin importar el idioma:

- Jira keys (`PANA-123`, `TAPEO-456`).
- X-Ray IDs.
- Símbolos de código (`PaymentService::process()`, `App\Controllers\...`).
- Paths de archivos y carpetas.
- Comandos shell (`bin/pre-commit phpstan`).
- Queries SQL.
- URLs.
- Frontmatter de YAML.
- Claves de JSON.

## Plantillas

Si una plantilla externa fuerza un idioma, se **modifica la plantilla local** para que respete `output.language`. Caso documentado en `templates/README.md` §"Divergencias locales": `templates/planning-template.md` fue rewriteado para no exigir inglés.

## Aplicabilidad

- Skills downstream que generen prosa cargan `output.language` y rinden en ese idioma.
- Skills bash-only (`help`, `config CRUD`) muestran sus mensajes en el idioma del catálogo de `help.sh` (actualmente español); no aplica esta regla.
