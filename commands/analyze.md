# Comando `duck-analyze`

Analiza un ticket de Jira y, tras confirmación expresa del usuario, escribe el resultado en la descripción del ticket de forma idempotente.

## Uso

```
duck-analyze <JIRA-KEY> [archivo-contexto-opcional]
```

Ejemplos:

```bash
duck-analyze PANA-123
duck-analyze PANA-123 ./notas-extra.txt
duck-analyze TAPEO-456 "El reporte de errores que pegamos en Slack"
```

## Comportamiento

Carga el skill `$RUBBER_DUCK_HOME/skills/jira-analyzer/SKILL.md` y sigue su flujo al pie de la letra:

1. Lee el ticket vía MCP de Atlassian.
2. Si hay segundo argumento, lo incorpora como contexto.
3. Genera **User Story + Criterios de Aceptación + Consideraciones Técnicas** según el formato definido en `$RUBBER_DUCK_HOME/skills/jira-analyzer/prompts/generate_story.md`.
4. Muestra el resultado en pantalla.
5. **Pide confirmación con 3 opciones** (`[s/n/e]`, default n):
   - `s` → actualizar Jira ahora.
   - `n` → no tocar nada, fin.
   - `e` → exportar a archivo siguiendo `<analyze.export_dir>/<JIRA-KEY>/<JIRA-KEY>_analyze.<ext>` (formato `analyze.export_format`, idioma `output.language`). **Tras exportar, vuelve a preguntar solo por Jira (`s/N`)** para que puedas hacer las dos cosas si quieres, sin bucle.
6. Si en cualquier momento confirmas `s` → actualiza la descripción del ticket de forma idempotente:
   - Bloque entre `<!-- rubber-duck:start -->` y `<!-- rubber-duck:end -->`.
   - Si los marcadores ya existían → reemplaza solo el contenido entre ellos.
   - Si no existían → añade al final precedido de separador `---`.
   - Nunca reemplaza la descripción entera. Nunca duplica el bloque.
7. Si rechaza → no toca Jira. El texto generado permanece visible en pantalla para copia manual.

## Restricciones

- **R1 (Jira):** la escritura **requiere confirmación expresa**. El default es No. Nunca actualices Jira por defecto.
- **R2 (BBDD):** este comando no toca BBDD. Si el ticket sugiere queries, redactarlas pero no ejecutarlas.
- **Proyecto:** este comando no requiere `$PROJECT_TYPE` (puede ejecutarse desde cualquier sitio). El dispatcher lo marca como project-bound solo a efectos de logging; las restricciones de proyecto se aplican únicamente al apartado "Consideraciones Técnicas" del output.

## Idempotencia

`duck-analyze PANA-123` puede ejecutarse N veces sobre el mismo ticket. El resultado es siempre el mismo bloque entre marcadores (modulo timestamp). Llamadas repetidas no duplican contenido en Jira.

## Errores y exit codes

| Situación | Exit |
|---|---|
| Éxito (con o sin actualización de Jira) | 0 |
| Lectura del ticket falló (no existe, sin permisos) | 1 |
| Generación falló dos veces seguidas | 2 |
| Argumento `<JIRA-KEY>` faltante o malformado | 2 |
| Escritura a Jira falló tras confirmación | 3 (texto preservado en pantalla) |
