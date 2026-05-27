# Prompt — Implementación de bug fix / mantenimiento en old-admin

Aplicación de cambios mínimos sobre el módulo `{URL_DOMAIN}/admin` del repo `civitatis` (PHP 5.6 + Apache + HTML/jQuery + PDO directo).

## Recordatorio de restricciones

- **Política mantenimiento-only.** Si el plan describe funcionalidad nueva, ya hubo confirmación en el SKILL.md previo; aquí se asume aceptada.
- **Scope `/admin`:** todas las modificaciones quedan dentro del whitelist documentado en `skills/project-context/old_admin.md` §"Scope estricto". El SKILL.md ya validó esto.
- **PHP 5.6.** No introducir sintaxis post-5.6 (sin `??`, sin `?Type`, sin typed properties, sin `match`, sin enums, sin spread en arrays, sin arrow functions, sin scalar type hints).
- **R2 (BBDD):** read-only. Queries de mutación se redactan, no se ejecutan.

## Flujo

### Paso 1 — Lectura del archivo objetivo

Por cada archivo que el plan dice tocar:

1. Lee el archivo **completo** (o al menos las primeras 100 líneas + las regiones cercanas a la modificación).
2. Identifica el estilo concreto del archivo:
   - ¿Short tags `<?` o long tags `<?php`?
   - ¿Indentación con tabs, 2 espacios, 4 espacios?
   - ¿Usa namespace o vive en namespace global?
   - ¿`include` / `require_once`?
   - ¿PDO directo, helper `\Civitatis\...`, ambos?
   - ¿Cómo comprueba permisos? (`$user_admin->hasPermission(...)`, `checkPermision.php`, etc.)
3. **Tomas nota mental del estilo.** Vas a imitarlo.

### Paso 2 — REPRO (solo si es bug fix)

Si el plan es un bug fix, reproducir manualmente o describir cómo reproducir. No se requiere test automatizado.

Documenta en el output:
```
🦆 REPRO: <pasos para reproducir el bug observado>
```

### Paso 3 — FIX

Aplica el cambio mínimo:

1. **Mantén el estilo del archivo.** Si el archivo usa short tags, los nuevos bloques también. Si usa `include`, no introduzcas `use`.
2. **Prepared statements obligatorios** para cualquier query SQL nueva. Aunque el archivo concatene queries en otras partes, en tus líneas usa `prepare()` + `bindValue()`. Esta es la única excepción al "imita el estilo".
3. **Escape de output:**
   - HTML: `htmlspecialchars($var, ENT_QUOTES, 'UTF-8')` salvo que el archivo ya tenga un helper.
   - URL: `urlencode()`.
   - JS: `json_encode($var, JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT)`.
4. **Permisos:** si el cambio afecta a un endpoint nuevo, mantener la comprobación habitual (`$user_admin->hasPermission(...)`). Si el archivo no la tenía y debería, añadirla.
5. **No refactorices.** Cambia lo mínimo. No reordenes funciones. No renombres variables. No conviertas short tags a long tags.
6. **Comentarios:** un comentario `// PANA-XXX: <breve descripción>` junto al cambio cuando aporte contexto. No saturar.

### Paso 4 — Frontend (si aplica)

Si el cambio toca `webroot/(static|dev)/(js|scss|css)/admin/` o `dev/src/js/admin/`:

1. Mantén jQuery si el archivo lo usa. No introduzcas frameworks SPA.
2. SCSS: respeta la organización existente (BEM si está, lo que esté).
3. Si modificas un archivo `dev/...` y existe un build pipeline, anota en el output:
   ```
   ⚠️ Recuerda recompilar assets:
      cd $PROJECT_ROOT/dev && npm run build:admin   # o el comando real del proyecto
   ```
   No ejecutes el build automáticamente (puede tardar y romper otros assets).

### Paso 5 — Verificación manual

Sigue la "VERIFICATION MATRIX (manual)" del plan. Por cada V1, V2, ... describe en el output qué comprobar:

```
🦆 [V1] Comprobación manual:
   1. Abre /admin/<ruta>
   2. <acción>
   3. Esperado: <resultado>
```

### Paso 6 — Resumen final

```
🦆 duck-implement <JIRA-KEY> completado (old-admin).

Archivos modificados:
  ~ application/admin/<archivo1>
  ~ application/lib/Admin/<archivo2>

⚠️ Verificación manual pendiente:
  - V1: <pasos del plan>
  - V2: <pasos del plan>

Si añades assets en dev/, recompila:
  cd $PROJECT_ROOT/dev && npm run build

Próximos pasos sugeridos:
  duck-audit --branch     (audit sentido común sobre los archivos cambiados)
  duck-review <JIRA-KEY>  (cross-check con el ticket)
```

### Paso 7 — Auto-commit (si aplica)

Igual que en new-admin pero **sin pre-commit pipeline** (old-admin no tiene). Si `git.auto_commit = true` y `git.auto_commit_after = implement`, hacer commit directo sobre `$PROJECT_ROOT`.

## Reglas de oro

- **Imita el archivo.** Si dudas entre tu instinto moderno y el estilo del archivo, **gana el archivo**.
- **No PHP 7+.** Sin excepciones.
- **Prepared statements** siempre que añadas SQL.
- **Escape** siempre que añadas output a HTML/JS.
- **No reescribir queries existentes para "limpiarlas".** Solo toca lo que el plan dice tocar.
- **Migrar es preferible.** Si el cambio crece, sugerir `duck-migrate` y parar.

## Mensajes de progreso

```
🦆 [REPRO] Reproducido el bug en /admin/payments/list (paginación rota cuando filter=expired).
🦆 [FIX] Modificando application/admin/payments/list.php (línea 142).
🦆 [VERIFY] Esperando verificación manual de V1, V2, V3.
```
