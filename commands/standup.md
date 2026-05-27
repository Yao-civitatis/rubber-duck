# Comando `duck-standup`

Genera el resumen del daily standup a partir de tu actividad en Jira de las últimas 24 horas. Listo para pegar al canal del equipo.

## Uso

```
duck-standup
```

Sin argumentos. Lee la actividad del usuario actual (derivada del MCP de Atlassian).

## Comportamiento

Carga el agente `$RUBBER_DUCK_HOME/agents/standup-agent.md`. Pasos:

1. Identifica el `accountId` del usuario actual vía MCP.
2. Busca tickets con actividad del usuario en las últimas 24h:
   - Comentarios escritos por el usuario.
   - Transiciones de estado realizadas.
   - Tickets asignados al usuario (`assignee = currentUser()`).
3. Filtra por equipo cuando aplique (`customfield_11001 = "Civitatis Admin"`).
4. Detecta bloqueos en comentarios recientes (palabras clave) y en estado `Blocked` si existe en el workflow.
5. Compone el resumen en 3 secciones:
   - **Ayer:** qué se hizo (comentarios + transiciones).
   - **Hoy:** tickets en `In Progress` + el siguiente `To Do`.
   - **Bloqueos:** tickets parados + responsable mencionado si lo hay.

## Output

Texto markdown listo para copiar, encabezado con la fecha:

```
🦆 Standup — 2026-05-28

## Ayer
- [PANA-123] título — qué hice
- [TAPEO-456] título — qué hice

## Hoy
- [PANA-123] título — siguiente paso
- [PANA-789] título — empezar

## Bloqueos
- [PANA-456] esperando aprobación de diseño (último comentario hace 2 días)
```

## Restricciones

- **R1 (Jira):** lectura libre. **No escribe.**
- **R2 (BBDD):** no toca BBDD.
- **Idioma:** `output.language` (default `es`).

## Configuración relacionada

Ninguna específica para este comando. Usa `mcp/atlassian/config.json` con el `team_custom_field` ya configurado.

## Errores y exit codes

| Situación | Exit |
|---|---|
| Resumen generado | 0 |
| Sin actividad ayer/hoy | 0 (con mensaje "Sin actividad ayer; Hoy <next>") |
| MCP Atlassian no accesible | 1 |

## Uso típico

```bash
# Justo antes del daily
duck-standup
# → copiar al canal o leerlo en vivo
```
