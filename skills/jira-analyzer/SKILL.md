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

Sigue la **convención universal §2.quater**:

```
<analyze.export_dir>/<JIRA-KEY>/<JIRA-KEY>_analyze.<ext>
```

donde:
- `<analyze.export_dir>` viene de config (default `.`).
- `<ext>` viene de `analyze.export_format` (`md` | `html` | `json` | `txt`, default `md`).
- `<JIRA-KEY>` es la clave del ticket (siempre disponible).

Procedimiento:

1. Calcular `dest_dir = "<analyze.export_dir>/<JIRA-KEY>"`.
2. `mkdir -p "$dest_dir"`.
3. Calcular `dest_file = "$dest_dir/<JIRA-KEY>_analyze.<ext>"`.
4. Si `$dest_file` existe → preguntar sobrescribir / backup `.bak` / cancelar.
5. **Idioma del contenido exportado** = `output.language` (default `es`). Reutiliza el bloque ya generado en el Paso 3.
6. **Render según `<ext>`:**
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
7. Escribir archivo.
8. Confirmar al usuario:
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

1. Toma la descripción **actual completa** que leíste en el Paso 1.
2. Busca en ella un bloque delimitado por marcadores:
   - Inicio: `<!-- rubber-duck:start -->`
   - Fin: `<!-- rubber-duck:end -->`
3. **Si los marcadores existen** → reemplaza solo el contenido entre ellos por el nuevo bloque (preserva todo lo demás de la descripción intacto). Si hay dos pares por error, mantén el primero y elimina el segundo (normaliza).
4. **Si no existen** → añade al final de la descripción:
   ```
   
   ---
   <!-- rubber-duck:start -->
   ## Generado por rubber-duck (YYYY-MM-DD HH:MM)
   
   <contenido User Story + AC + Consideraciones Técnicas>
   <!-- rubber-duck:end -->
   ```
5. Llama al MCP para actualizar la descripción con la nueva versión.
6. Confirma al usuario con `✓ Descripción de <JIRA-KEY> actualizada.`

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
