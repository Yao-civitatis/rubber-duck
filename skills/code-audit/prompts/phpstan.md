# Prompt — Interpretación de output de phpstan

Solo aplicable a **new-admin**. Para old-admin, `duck-audit` no ejecuta phpstan.

## Invocación

Siempre vía el dispatcher del proyecto:

```bash
"$PROJECT_ROOT/bin/pre-commit" phpstan <archivos.php>
```

Si la lista de archivos está vacía (caso `--branch` sin cambios PHP), saltar phpstan.

Si phpstan se invoca sin archivos en modo `all` del audit, el dispatcher analiza todo el suite según `phpstan.dist.neon`.

## Output esperado

phpstan emite por stdout líneas del tipo:

```
 ------ ---------------------------------------------------------------------------------------------------------
  Line   app/Services/Payments/RefundService.php
 ------ ---------------------------------------------------------------------------------------------------------
  42     Method App\Services\Payments\RefundService::process() has parameter $amount with no type specified.
  58     Call to an undefined method App\Models\Booking::transferToProvider().
 ------ ---------------------------------------------------------------------------------------------------------
```

Exit code:
- `0` → no errores
- `non-zero` → hay errores

## Normalización a hallazgos

Cada línea de error se convierte en un hallazgo con:

| Campo | Valor |
|---|---|
| `tool` | `phpstan` |
| `severity` | `error` (phpstan no distingue niveles por defecto) |
| `file` | path relativo a `$PROJECT_ROOT` |
| `line` | número de línea |
| `message` | texto del error tal cual lo dio phpstan |
| `category` | inferida del mensaje (ver tabla) |

### Categorías heurísticas

| Patrón en el mensaje | Categoría |
|---|---|
| `has parameter ... with no type specified` | `missing-param-type` |
| `has no return type specified` | `missing-return-type` |
| `Call to an undefined method` | `undefined-method` |
| `Call to an undefined function` | `undefined-function` |
| `Access to an undefined property` | `undefined-property` |
| `Variable ... in PHPDoc tag @var does not match` | `phpdoc-mismatch` |
| `Cannot access property ... on ...|null` | `nullable-access` |
| `... not found.` | `unresolved-class` |
| otros | `other` |

## Baseline

`phpstan-baseline.neon` ya excluye los errores conocidos del proyecto. **Si phpstan reporta algo nuevo**, es porque el cambio actual lo introdujo.

**Nunca** añadir entradas al baseline sin permiso del usuario. Si quieres añadir → reportarlo como una decisión separada al usuario, no aplicarlo silenciosamente.

## Reporte en el informe unificado

Sección `## 2.1 phpstan` del informe:

```markdown
### 2.1 phpstan

Ejecutado contra: <N archivos>
Resultado: <PASS | FAIL con N errores>

| # | Archivo:línea | Categoría | Mensaje |
|---|---|---|---|
| 1 | `app/Services/Payments/RefundService.php:42` | `missing-param-type` | Method ... has parameter $amount with no type specified. |
| 2 | … | … | … |
```

Si no hay errores: `Resultado: PASS — phpstan limpio.` y se omite la tabla.

## Errores de invocación

- Docker / Tilt no arriba: el wrapper falla con un mensaje específico (ej. `error: cannot connect to docker daemon`). Capturar y reportar:
  ```
  ⚠️ phpstan no se pudo ejecutar (entorno no disponible). Saltado.
  ```
  Continuar con el resto del audit. No marcar como hallazgo bloqueante en sí.

- Configuración rota (`phpstan.dist.neon` malformado): reportar como hallazgo de severidad `error` con `category=tool-config`.
