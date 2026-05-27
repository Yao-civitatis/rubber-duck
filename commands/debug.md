# Comando `duck-debug`

Diagnostica bugs. Acepta un mensaje de error literal o una JIRA-KEY. Produce hipótesis ordenadas por probabilidad con pasos concretos para verificar cada una.

## Uso

```
duck-debug "<mensaje de error>"
duck-debug <JIRA-KEY>
```

Ejemplos:

```bash
duck-debug "Call to undefined method PaymentService::process() en línea 45"
duck-debug TAPEO-456                                    # lee el bug report
duck-debug "Cannot read property 'id' of undefined"     # error frontend
```

## Comportamiento

Carga el agente `$RUBBER_DUCK_HOME/agents/debug-agent.md` y le inyecta:

1. Contexto del proyecto detectado (skill + docs).
2. Input del usuario:
   - Si parece JIRA-KEY (regex `^[A-Z]+-[0-9]+$`) → lee el ticket vía MCP (descripción + comentarios + status).
   - Si parece texto → lo usa como mensaje literal.
3. Para new-admin: incluye `$PROJECT_ROOT/.claude/agents/incident-analyst.md` si existe.

Produce un informe con:

- Síntoma observado y reproducción (si aplica).
- Árbol de hipótesis 🟢 / 🟡 / 🔵 por confianza.
- Para cada hipótesis: razonamiento, evidencia archivo:línea, cómo verificar, fix provisional, fix permanente.
- Siguiente acción sugerida (una sola).

## Restricciones

- **R1 (Jira):** lectura libre del ticket. Nunca escribe.
- **R2 (BBDD):** queries solo en modo lectura para verificar hipótesis. Mutaciones se redactan, no se ejecutan.
- **No aplica fixes.** Diagnostica. El fix se hace después con `duck-plan` + `duck-implement`.
- **Idioma:** `output.language` (default `es`).

## Recomendación posterior

Cuando una hipótesis se confirma:

```bash
# Si es bug en una tarea de Jira existente:
duck-plan <JIRA-KEY>

# Si no había ticket, crear uno primero (manualmente) y luego:
duck-analyze <JIRA-KEY-nuevo>
duck-plan <JIRA-KEY-nuevo>
duck-implement <JIRA-KEY-nuevo>_plan.md
```

## Errores y exit codes

| Situación | Exit |
|---|---|
| Diagnóstico generado | 0 |
| JIRA-KEY no existe / sin permisos | 1 |
| Sin input (sin argumento) | 2 |
| Detección de proyecto falló y el input no aclara cuál | 3 |
