# Comando `duck-onboarding`

Sesión interactiva pensada para developers nuevos del equipo Civitatis Admin. Carga el contexto completo de **new-admin y old-admin** y queda a la espera de preguntas, sin necesidad de molestar al equipo con dudas básicas.

## Uso

```
duck-onboarding
```

Sin argumentos. Es interactivo: tras arrancar, formula preguntas en lenguaje natural.

## Comportamiento

Carga el agente `$RUBBER_DUCK_HOME/agents/onboarding-agent.md` y le inyecta:

1. Skills de project-context (`skills/project-context/{new_admin,old_admin}.md`).
2. Normas vivas (`~/.rubber-duck/docs/<proyecto>/*.md`).
3. Reglas transversales (`rules/*.md`).
4. Si se invoca dentro de un proyecto detectado:
   - new-admin: `$PROJECT_ROOT/CLAUDE.md` + `.claude/{domain-index,project-context,refactoring-state,USAGE,jira-triage}.md` + `.claude/agents/{architect,backend-engineer,frontend-engineer,qa-engineer,analyst,incident-analyst}.md` cuando existan.
   - old-admin: solo el skill de project-context.

Responde a preguntas sobre estructura, stack, workflow, integraciones, comandos rubber-duck. Sugiere el comando `duck-*` relevante cuando aplique.

## Restricciones

- **Solo lectura.** No crea archivos, no commits, no escribe Jira/BBDD.
- **R1 (Jira):** lectura libre.
- **R2 (BBDD):** no toca BBDD.
- **Idioma:** `output.language` (default `es`).

## Recomendación previa

Antes de la primera sesión, ejecutar:

```bash
duck-sync-docs all
```

Para que el agente tenga los docs vivos sincronizados. Si no se ha sincronizado nunca, el agente cae a `$RUBBER_DUCK_HOME/docs/` (bundle) y avisa.

## Ejemplos de preguntas

- "¿cómo está estructurado new-admin?"
- "¿qué es la arquitectura hexagonal en este proyecto?"
- "¿dónde está la lógica de pagos?"
- "¿qué es el modo mantenimiento de old-admin?"
- "¿cuál es el workflow de Jira que sigue el equipo?"
- "enséñame los hooks de git que tiene rubber-duck"
- "¿cómo creo un Controller nuevo en new-admin?"
- "diferencia entre Services y Domain Services"

## Errores y exit codes

| Situación | Exit |
|---|---|
| Sesión terminada por el usuario | 0 |
| Sin docs sincronizadas (degradación a bundle) | 0 con warning |
