# Comando `duck-ask`

Experto consultable del equipo Civitatis Admin. Carga el contexto completo de **new-admin y old-admin** y responde **cualquier pregunta** sobre ellos, a nivel **junior y senior**, sin necesidad de molestar al equipo. El onboarding de un developer nuevo es uno de sus usos, no el único: también resuelve dudas de arquitectura, integraciones y decisiones de stack a nivel experto.

## Uso

```
duck-ask                         # modo interactivo: arranca y espera preguntas
duck-ask "¿pregunta concreta?"   # responde directamente a la pregunta dada
```

Tanto interactivo como con la pregunta en línea. Las preguntas se formulan en lenguaje natural.

## Comportamiento

Carga el agente `$RUBBER_DUCK_HOME/agents/ask-agent.md` y le inyecta:

1. Skills de project-context (`skills/project-context/{new_admin,old_admin}.md`).
2. Normas vivas (`~/.rubber-duck/docs/<proyecto>/*.md`).
3. Reglas transversales (`rules/*.md`).
4. Si se invoca dentro de un proyecto detectado:
   - new-admin: `$PROJECT_ROOT/CLAUDE.md` + `.claude/{domain-index,project-context,refactoring-state,USAGE,jira-triage}.md` + `.claude/agents/{architect,backend-engineer,frontend-engineer,qa-engineer,analyst,incident-analyst}.md` cuando existan.
   - old-admin: solo el skill de project-context.

Responde a preguntas de cualquier nivel: estructura, stack, workflow, integraciones, decisiones de arquitectura, trade-offs, comandos rubber-duck. Ajusta la profundidad al nivel de la pregunta. Sugiere el comando `duck-*` relevante cuando aplique.

## Honestidad (no inventar)

Si la respuesta **no consta** en docs/código/reglas, el agente responde con sinceridad **"no lo sé"** y sugiere a quién/dónde preguntar o cómo averiguarlo. **Nunca fabrica** soluciones, archivos, APIs ni decisiones históricas. Un "no lo sé" honesto es preferible a una respuesta inventada que el equipo dé por buena.

## Restricciones

- **Solo lectura.** No crea archivos, no commits, no escribe Jira/BBDD. (El alcance senior **no** afloja estos permisos.)
- **R1 (Jira):** lectura libre.
- **R2 (BBDD):** no toca BBDD.
- **Idioma:** `output.language` (default `es`).

## Recomendación previa

Antes de la primera sesión, ejecutar:

```bash
duck-sync-docs all
```

Para que el agente tenga los docs vivos sincronizados. Si no se ha sincronizado nunca, el agente cae a `$RUBBER_DUCK_HOME/docs/` (bundle) y avisa de que el contexto puede estar desactualizado.

## Ejemplos de preguntas

**Junior:**
- "¿cómo está estructurado new-admin?"
- "¿qué es la arquitectura hexagonal en este proyecto?"
- "¿dónde está la lógica de pagos?"
- "¿cómo creo un Controller nuevo en new-admin?"
- "diferencia entre Services y Domain Services"

**Senior:**
- "¿por qué new-admin y old-admin comparten BBDD y cómo evito romper old-admin desde new-admin?"
- "¿qué trade-offs tuvo elegir Slim sobre Laravel?"
- "¿cómo se orquesta el flujo de pago con Adyen y dónde están los puntos de fallo?"
- "¿qué implica la migración de stack PHP 7.4→8.2 para el módulo X?"

**Workflow / herramienta:**
- "¿cuál es el workflow de Jira que sigue el equipo?"
- "enséñame los hooks de git que tiene rubber-duck"

## Errores y exit codes

| Situación | Exit |
|---|---|
| Sesión terminada por el usuario | 0 |
| Sin docs sincronizadas (degradación a bundle) | 0 con warning |
