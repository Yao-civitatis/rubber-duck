# Prompt — Interpretación de output de php-cs-fixer

Solo aplicable a **new-admin**. Old-admin no tiene configuración de php-cs-fixer (política mantenimiento).

## Invocación

Siempre vía el dispatcher del proyecto, en modo dry-run con diff:

```bash
"$PROJECT_ROOT/bin/pre-commit" php-cs-fixer --dry-run --diff <archivos.php>
```

El modo `--dry-run --diff` evita modificaciones reales y produce el diff por archivo.

## Output esperado

php-cs-fixer emite por stdout:

```
Loaded config default from "/app/.php-cs-fixer.dist.php".
Using cache file ".php-cs-fixer.cache".
   1) app/Services/Payments/RefundService.php
      ---------- begin diff ----------
      --- Original
      +++ New
      @@ -10,7 +10,7 @@
       class RefundService
       {
      -    public function process( int $amount ): Refund
      +    public function process(int $amount): Refund
           {
      ...
      ----------- end diff -----------
```

Exit code:
- `0` → todos los archivos limpios.
- `8` → al menos un archivo necesita cambios (modo dry-run).
- otros → error de configuración.

## Normalización a hallazgos

Cada archivo listado se convierte en **un solo hallazgo** (no uno por línea — el diff puede ser largo):

| Campo | Valor |
|---|---|
| `tool` | `php-cs-fixer` |
| `severity` | `warning` (cs-fixer es estilo, no error semántico) |
| `file` | path relativo a `$PROJECT_ROOT` |
| `line` | (vacío — el diff incluye varias líneas) |
| `message` | resumen breve de los fixers aplicados; si no se puede extraer, "estilo no conforme" |
| `category` | `code-style` |
| `diff` | bloque del diff completo (capturarlo para mostrarlo en el informe) |

## Reporte en el informe unificado

Sección `## 2.2 php-cs-fixer`:

```markdown
### 2.2 php-cs-fixer

Ejecutado contra: <N archivos>
Resultado: <PASS | FAIL con N archivos a corregir>

Comando para auto-corregir:
\`\`\`bash
$PROJECT_ROOT/bin/pre-commit php-cs-fixer <archivos>
\`\`\`

#### Archivos no conformes

<por cada archivo:>
- `app/Services/Payments/RefundService.php`
  <diff truncado a 30 líneas + link "completo en stdout">
```

Si no hay archivos a corregir: `Resultado: PASS — estilo limpio.` y se omite la sección de diffs.

## Auto-corrección por config

Si `implement.auto_format = true`, `duck-implement` ya ejecuta el cs-fixer **en escritura** tras implementar. En ese flujo, el audit posterior debería estar limpio. Si `duck-audit` reporta diff aquí significa que:

- El usuario tiene `auto_format = false` (esperado, no es problema).
- O el usuario hizo edits manuales tras el implement.

No reportar como hallazgo bloqueante (`severity=warning`).

## Errores de invocación

- Docker / Tilt no arriba: capturar y reportar:
  ```
  ⚠️ php-cs-fixer no se pudo ejecutar (entorno no disponible). Saltado.
  ```
  Continuar con el audit. No bloqueante.

- `.php-cs-fixer.dist.php` malformado: severidad `error`, `category=tool-config`.
