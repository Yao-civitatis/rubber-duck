# Skill `jira-analyzer`

Lee un ticket de Jira y genera **User Story + Criterios de Aceptación + Consideraciones Técnicas**. Si el usuario confirma, escribe el resultado en la descripción del ticket de forma **idempotente** (entre marcadores).

## Invocación

`duck-analyze <JIRA-KEY> [archivo-contexto]`

Por ejemplo:
- `duck-analyze PANA-123`
- `duck-analyze PANA-123 ./notas-extra.txt`

## Cuándo NO actuar

Si `<JIRA-KEY>` no parece una clave válida (regex `^[A-Z]+-[0-9]+$`), responde con un error claro y para.

## Flujo

### Paso 1 — Lectura del ticket

Antes de empezar, verificar `~/.rubber-duck/mcp/atlassian/config.json`. Si no existe → avisar `⚠️ MCP de Atlassian sin configurar. Ejecuta 'duck-config setup' (paso MCP Atlassian) y reintenta.` y abortar con exit 1.

Usa el MCP de Atlassian para leer el ticket:

- `summary`
- `description` (texto actual, **completo**, incluyendo cualquier bloque previo entre marcadores rubber-duck)
- `status`
- `issuetype`
- `labels`, `components`
- `customfield_11001` (equipo — verificar que sea "Civitatis Admin"; si no, advertir pero continuar)

Si la lectura falla (4xx/5xx, ticket no existe, sin permisos): para y muestra el error tal cual lo devuelve la API.

### Paso 2 — Lectura del contexto adicional (opcional)

Si el usuario pasó un segundo argumento, léelo:
- Si es ruta a archivo existente → cárgalo como contexto adicional.
- Si es texto literal → úsalo tal cual.

### Paso 3 — Generación

Sigue exactamente el formato definido en `$RUBBER_DUCK_HOME/skills/jira-analyzer/prompts/generate_story.md`. Genera tres secciones:

1. **User Story** — formato "Como <rol>, quiero <acción> para <objetivo>."
2. **Criterios de Aceptación** — Gherkin (Given/When/Then), uno por escenario.
3. **Consideraciones Técnicas** — implicaciones para new-admin / old-admin según corresponda. Si el ticket parece tocar `/admin` de civitatis, marca la política de mantenimiento.

Idioma: español por defecto. Si `output.language=en` en `~/.rubber-duck/config.json`, en inglés.

### Paso 4 — Mostrar al usuario

Imprime el resultado completo en pantalla con un encabezado claro:

```
🦆 Análisis generado para <JIRA-KEY>: <summary>

## User Story
...

## Criterios de Aceptación
...

## Consideraciones Técnicas
...
```

### Paso 5 — Pedir confirmación (3 opciones)

Pregunta literalmente:

```
¿Quieres actualizar la descripción del ticket en Jira?
  [s] Sí (append idempotente entre marcadores)
  [n] No, dejar solo en pantalla
  [e] Exportar primero a archivo, luego te vuelvo a preguntar
> _
```

Default = `n`. Aceptación de respuestas:
- `s`/`si`/`sí`/`y`/`yes` → ir al Paso 7.
- `e`/`export` → ir al Paso 6 (export) y luego **volver** al Paso 5b.
- `n`/`no`/cualquier otra cosa → exit 0 sin tocar nada (Paso 8).

### Paso 6 — Export a archivo (cuando el usuario eligió `e`)

Sigue la **convención universal de paths de export** definida en `$RUBBER_DUCK_HOME/rules/export-paths.md`:

```
<analyze.export_dir>/<JIRA-KEY>/<JIRA-KEY>_analyze.<ext>
```

donde:
- `<analyze.export_dir>` viene de config (default `.`). **Si es relativo, se resuelve contra `$PROJECT_ROOT`**; si es absoluto, se usa tal cual.
- `<ext>` viene de `analyze.export_format` (`md` | `html` | `json` | `txt`, default `md`).
- `<JIRA-KEY>` es la clave del ticket (siempre disponible).

Procedimiento:

1. Resolver `<analyze.export_dir>` → `resolved_export_dir`.
2. Calcular `dest_dir = "$resolved_export_dir/<JIRA-KEY>"`.
3. `mkdir -p "$dest_dir"`.
4. Calcular `dest_file = "$dest_dir/<JIRA-KEY>_analyze.<ext>"`.
5. Si `$dest_file` existe → preguntar sobrescribir / backup `.bak` / cancelar.
6. **Idioma del contenido exportado** = `output.language` (default `es`). Reutiliza el bloque ya generado en el Paso 3.
7. **Render según `<ext>`:**
   - `md` → escribir el bloque tal cual (separador `---` arriba + bloque entre marcadores).
   - `html` → convertir markdown a HTML simple. Incluir `<!DOCTYPE html>`, `<meta charset="UTF-8">`, título `<title>Analyze <JIRA-KEY></title>`.
   - `json` → estructura:
     ```json
     {
       "jira_key": "<KEY>",
       "summary": "<summary>",
       "generated_at": "<ISO-8601>",
       "user_story": "<texto>",
       "acceptance_criteria": [
         {"title": "...", "gherkin": "Given... When... Then..."}
       ],
       "technical_considerations": {
         "project": "new-admin | old-admin | ambos",
         "module": "...",
         "expected_changes": ["..."],
         "risks": ["..."],
         "dependencies": ["..."],
         "applicable_policy": "..."
       }
     }
     ```
   - `txt` → strip markdown (sin asteriscos, sin headers `#`), texto plano legible.
8. Escribir archivo.
9. Confirmar al usuario:
   ```
   ✓ Análisis exportado a <ruta>
   ```

### Paso 5b — Re-preguntar confirmación (solo 2 opciones)

Tras exportar, vuelve a preguntar **solo por Jira** (sin opción `e` esta vez, para evitar bucle):

```
Archivo exportado. ¿Actualizo también la descripción del ticket en Jira?
  [s] Sí
  [N] No
> _
```

Default = `N`. Si confirma `s` → ir al Paso 7. Si rechaza → exit 0 (Paso 8) con el archivo ya guardado.

### Paso 7 — Actualización idempotente (solo si confirmó)

**Objetivo:** que el usuario NO vea en la descripción de Jira ningún marcador ni branding de rubber-duck, pero que la detección idempotente siga funcionando.

**Contexto técnico (verificado sobre Jira Cloud):** la descripción es ADF. Los `<!-- comentarios HTML -->` NO son un nodo ADF → Jira los renderiza como **texto literal visible** (causa del problema histórico). La solución es escribir los marcadores como texto ADF con marca **`textColor` blanco (`#FFFFFF`)**: invisibles sobre fondo claro, pero presentes como ancla. Al releer la descripción como markdown (Paso 1) el color se pierde, pero las cadenas `rubber-duck:start` / `rubber-duck:end` siguen ahí → la detección funciona. (Render verificado: `<font color="#ffffff">rubber-duck:start ...</font>`.)

#### Marcadores (nuevo formato, sin `<!-- -->`)

- Apertura: texto `rubber-duck:start generated=YYYY-MM-DD` con marca `textColor` `#FFFFFF`. El timestamp viaja **dentro** del marcador → ya no hay encabezado visible "Generado por rubber-duck".
- Cierre: texto `rubber-duck:end` con marca `textColor` `#FFFFFF`.
- El contenido entre ambos (User Story + AC + Consideraciones) se renderiza con formato normal y visible.

#### Procedimiento

1. Toma la descripción **actual completa** leída en el Paso 1 (markdown).
2. Busca el bloque por sus cadenas ancla: desde la línea que contenga `rubber-duck:start` hasta la que contenga `rubber-duck:end` (inclusive). Detección por subcadena, **independiente del color/formato** y compatible con bloques antiguos `<!-- rubber-duck:start -->`/`<!-- rubber-duck:end -->`.
3. **Si el bloque existe** → reemplaza desde `start` hasta `end` por el nuevo bloque (preserva el resto intacto). Si hay dos pares por error, conserva el primero y elimina el segundo (normaliza).
4. **Si no existe** → añade al final, precedido de un separador `---`.
5. **Escritura vía MCP en modo ADF** (`editJiraIssue`, `contentFormat: adf`): reconstruye la descripción completa como documento ADF = `[contenido previo del usuario] + rule + [marcador start blanco] + [User Story/AC/Consideraciones como nodos ADF] + [marcador end blanco]`. Marca de los marcadores: `{"type":"textColor","attrs":{"color":"#FFFFFF"}}` sobre el nodo de texto.
6. Confirma al usuario con `✓ Descripción de <JIRA-KEY> actualizada (marcadores rubber-duck ocultos).`

#### ⚠️ Aviso de fidelidad (obligatorio antes de escribir en modo ADF)

El MCP devuelve la descripción como **markdown** (no ADF), así que para escribir ADF hay que **reconstruir** la descripción completa desde su markdown. Texto, listas, enlaces, código y encabezados se preservan; **nodos no representables en markdown (imágenes/media pegadas, paneles, tablas complejas) pueden degradarse a un placeholder**.

Antes de escribir, inspecciona la descripción actual. Si contiene media/imagen embebida (markdown `![...](...)` con `blob:`/`media`, o macros de panel/tabla), **avisa y pregunta**:

```
⚠️ La descripción contiene contenido enriquecido (imagen/panel/tabla) que el modo
   oculto (ADF) podría degradar a un placeholder.
   [a] Continuar en modo oculto (recomendado si el contenido es solo texto)
   [v] Modo compatible: marcadores VISIBLES pero contenido enriquecido intacto
   [n] Cancelar
> _
```

- `a` → proceder en ADF (marcadores blancos), reconstruyendo el contenido lo más fiel posible.
- `v` → escribir en markdown con marcadores visibles (`rubber-duck:start`/`end` en texto plano, degradación segura, sin tocar el contenido enriquecido).
- `n` → no tocar Jira.

Si la descripción es solo texto (sin media/paneles), proceder en modo oculto sin preguntar.

**Caveat de tema:** el blanco es invisible sobre fondo claro; en **modo oscuro** de Jira los marcadores pueden verse como texto tenue. Comportamiento aceptado (alternativa pedida por el usuario; ADF no tiene nodo de comentario real).

Si la escritura falla, muestra el error y conserva el texto generado en pantalla.

### Paso 8 — Salida

- Salida exitosa: exit 0.
- Si el usuario rechazó: exit 0 (no es error).
- Si la lectura inicial falló: exit 1.
- Si la generación falló (modelo no produjo formato esperado): regenera una vez; si falla otra vez, exit 2 con el output crudo.

## Restricciones

- **R1 (Jira):** solo escribir cuando el usuario confirme explícitamente. Nunca silenciar la confirmación.
- **R2 (BBDD):** este skill no toca BBDD. Si la lectura del ticket sugiere queries para investigación, redacta la query pero **no la ejecutes**.
- No leas archivos del proyecto (`$PROJECT_ROOT/**`) salvo que el ticket lo requiera explícitamente. Mantén el alcance al análisis.

## Comportamiento ante repeticiones

`duck-analyze` es idempotente. Llamar dos veces sobre el mismo ticket y aceptar ambas veces produce:
- Primera: añade bloque entre marcadores al final.
- Segunda: reemplaza el bloque in-place. El resto de la descripción intacto.

Llamar dos veces y rechazar ambas no toca Jira.
