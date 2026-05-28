# Comando `duck-upgrade`

Gestiona la migración de stack de **new-admin** en tres frentes simultáneos:

```
PHP 7.4   →  PHP 8.2
Slim 3    →  Laravel 11
Vue 2.6 + Options API + Webpack 4   →  Vue 3 + Composition API + Vite
```

## Uso

```
duck-upgrade plan                   # genera roadmap completo
duck-upgrade migrate <ruta>         # migra archivo o carpeta concreta
duck-upgrade migrate --next         # siguiente archivo pendiente del plan
duck-upgrade --next                 # atajo equivalente
duck-upgrade status                 # muestra progreso
duck-upgrade check <ruta>           # revisa compatibilidad sin modificar
```

## Comportamiento

Carga el agente `$RUBBER_DUCK_HOME/agents/upgrade-agent.md`. Cada subcomando opera distinto:

### `plan`

1. Lee `~/.rubber-duck/docs/new-admin/project-snapshot.md` (stack actual — debe haberse sincronizado con `duck-sync-docs new-admin`).
2. Lee `~/.rubber-duck/docs/new-admin/upgrade-targets.md` (stack destino — mantenido manualmente por el equipo).
3. Genera `~/.rubber-duck/docs/new-admin/upgrade-plan.md` con:
   - Inventario de breaking changes.
   - Fases ordenadas por dependencias (0 tooling → 1 PHP 8.0 → 2 PHP 8.2 → 3 Slim→Laravel → 4 Vue 2→3 → 5 Webpack→Vite).
   - Complejidad estimada por módulo (S/M/L/XL).
   - Riesgos identificados (librerías sin equivalente Vue 3, etc.).
4. **No toca código.** Solo escribe el roadmap.

### `migrate <ruta>` o `migrate --next` / `--next`

Migra un archivo o carpeta concreta:

1. **Snapshot del comportamiento esperado** (tests existentes que lo cubren + descripción funcional).
2. **Aplica transformaciones del stack** (rector + cambios manuales).
3. **Asegura tests verdes** en el nuevo stack. Si no había tests, crea los mínimos para validar equivalencia.
4. **Actualiza `~/.rubber-duck/upgrade-status.json`** con fecha, fase, commit.

`--next` consulta el status y elige el siguiente archivo pendiente del roadmap.

### `status`

Imprime el progreso por fase con barras visuales + último migrado + siguiente sugerido + bloqueos.

### `check <ruta>`

Revisa **sin modificar** la compatibilidad de un archivo o carpeta con el stack destino. Reporta APIs deprecadas, sintaxis incompatible, dependencias bloqueantes. Útil antes de un `migrate`.

## Restricciones

- **Equivalencia funcional ABSOLUTA:** nunca cambiar comportamiento durante la migración. Mejoras se posponen a tickets separados.
- **R1 (Jira):** lectura del ticket de migración si existe. Sin escritura automática.
- **R2 (BBDD):** no toca BBDD. Cambios de schema relacionados (raros) se redactan, no ejecutan.
- **R3-R6:** se respetan en el destino (hexagonal, Controllers sin AbstractController, Composition API según target).
- **Idioma:** `output.language` (default `es`).

## Configuración relacionada

Ninguna específica. El estado vive en `~/.rubber-duck/upgrade-status.json`. El plan en `~/.rubber-duck/docs/new-admin/upgrade-plan.md`. Los targets en `~/.rubber-duck/docs/new-admin/upgrade-targets.md` (mantenidos manualmente).

## Prerrequisitos

Antes de la primera invocación:

```bash
# 1. Sincronizar docs (para que project-snapshot.md exista)
duck-sync-docs new-admin

# 2. Verificar upgrade-targets.md está poblado
cat ~/.rubber-duck/docs/new-admin/upgrade-targets.md
# (este archivo se distribuye con el bundle como placeholder; el equipo
#  debe completarlo con sus decisiones específicas antes de empezar)

# 3. Generar el roadmap
duck-upgrade plan
```

## Workflow recomendado

```bash
# Una vez: roadmap
duck-upgrade plan

# Ciclo continuo
duck-upgrade --next
duck-audit --branch       # validar el cambio
git commit                # commit por archivo migrado
duck-upgrade status       # progreso

# Antes de un módulo grande:
duck-upgrade check app/Modules/Payments/
```

## Errores y exit codes

| Situación | Exit |
|---|---|
| Subcomando completado | 0 |
| `upgrade-targets.md` ausente o vacío | 2 |
| `project-snapshot.md` ausente | 3 (con instrucción de ejecutar `duck-sync-docs new-admin`) |
| Argumento inválido | 2 |
| Dependencia bloqueante durante `migrate` | 5 (con explicación; el usuario decide cómo proceder) |
| `upgrade-status.json` corrupto | 4 (con instrucción de regenerar) |

## Notas

- **Solo new-admin.** Old-admin no se "upgrade" — se migra entero a new-admin con `duck-migrate` (política mantenimiento-only).
- **Operación incremental.** No intentar migrar todo en una sola tanda. Una pieza, un PR, un release.
