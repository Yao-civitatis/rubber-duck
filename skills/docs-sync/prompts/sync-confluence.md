# Prompt — Conversión Confluence → markdown

Convierte una página de Confluence (formato `storage` XML / `atlas_doc_format` JSON) a markdown limpio para guardar en `docs/<proyecto>/`.

## Inputs

- `page_id` — ID numérico de la página.
- `page_title` — título tal cual aparece en Confluence.
- `body` — contenido en el formato devuelto por el MCP de Atlassian (`storage` XHTML o `atlas_doc_format` ADF JSON, depende del endpoint).

## Output

Archivo markdown UTF-8 con:

```markdown
# <page_title>

> Sincronizado desde Confluence — page id `<page_id>`, espacio `PANA`.
> Última actualización: <ISO-8601 UTC>.
> No editar manualmente: `duck-sync-docs <proyecto>` lo sobrescribe.

<contenido convertido>
```

## Reglas de conversión

| Elemento Confluence | Equivalente markdown |
|---|---|
| Header h1-h6 | `#` … `######` (preservar nivel) |
| Párrafo | línea simple, doble salto entre párrafos |
| Bold | `**texto**` |
| Italic | `*texto*` |
| Lista `<ul>` | `- item` |
| Lista `<ol>` | `1.` `2.` …  |
| Tabla | sintaxis markdown estándar (`\|` separadores). Si la tabla es demasiado ancha, considera dejarla como bloque HTML inline. |
| Code block (`<ac:structured-macro ac:name="code">`) | ` ```<lang>\n…\n``` ` con lenguaje detectado del parámetro `language` si está. |
| Inline code (`<code>`) | `` `texto` `` |
| Link interno (`<ac:link>`) | `[texto](https://civitatis.atlassian.net/wiki/...)` con URL absoluta. |
| Image (`<ac:image>`) | `![alt](url)` con URL absoluta. |
| Macros desconocidas | conservar como bloque HTML inline (no perder contenido). |
| Anchors (`<ac:structured-macro ac:name="anchor">`) | omitir (rara vez útiles fuera de Confluence). |

## Idioma

- **No traducir el contenido.** Confluence es la fuente; mantenemos exactamente lo que el equipo escribió.
- El **header generado** ("Sincronizado desde Confluence…") se redacta en `output.language`.

## Sanitización

- Strip espacios al final de cada línea.
- Colapsar saltos de línea triples a dobles.
- Si el contenido viene con HTML residual (`&nbsp;`, `&amp;`, `&lt;`, `&gt;`), decodificar.
- No introducir frontmatter YAML salvo que la página Confluence ya lo tuviera.

## Verificación

Tras escribir el archivo, intentar:

1. Leer el archivo de vuelta.
2. Validar que es markdown válido (sin tags HTML rotos, sin XHTML residual de Confluence).

Si la validación falla, registrar el error pero conservar el archivo (no hacer rollback). Mejor un markdown imperfecto que perder el sync.

## Errores frecuentes

- **MCP devuelve `errorMessages`:** registrar el error completo y saltar esta página. No abortar el comando entero.
- **Página vacía:** escribir el archivo solo con la cabecera y un comentario `> Página vacía en Confluence.`.
- **Macros propietarias del equipo (Jira tickets embebidos, draw.io, etc.):** convertir a un placeholder textual `> [Macro Confluence "<nombre>" — abrir en navegador para verla.]` con el link a la página.
