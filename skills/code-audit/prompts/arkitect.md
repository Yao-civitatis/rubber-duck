# Prompt — Interpretación de output de phparkitect

Solo aplicable a **new-admin**. Las reglas viven en `$PROJECT_ROOT/phparkitect.php` y las excepciones aceptadas en `$PROJECT_ROOT/phparkitect-baseline.json`.

## Invocación

Siempre vía el dispatcher del proyecto. phparkitect analiza el **proyecto entero** (no acepta lista de archivos como filtro):

```bash
"$PROJECT_ROOT/bin/pre-commit" phparkitect
```

En modo `--branch` o `<ruta>` del audit, igualmente se ejecuta completo y luego se filtran los hallazgos para conservar solo los que tocan los archivos de la lista.

## Output esperado

phparkitect emite por stdout violaciones del estilo:

```
[ERROR] App\Controllers\Payments\RefundController violates rule "ControllersCannotDependOnRepositories"
  - Dependency on App\Repositories\RefundRepository found at line 12.

[ERROR] App\Services\Payments\RefundService violates rule "ServicesCannotDependOnHttp"
  - Dependency on Slim\Http\Request found at line 8.
```

Exit code:
- `0` → todas las reglas cumplen.
- `non-zero` → al menos una violación nueva (las del baseline se ignoran).

## Normalización a hallazgos

Por cada violación:

| Campo | Valor |
|---|---|
| `tool` | `phparkitect` |
| `severity` | `error` |
| `file` | path inferido del namespace de la clase violadora |
| `line` | número de línea reportado |
| `message` | regla violada + dependencia concreta |
| `category` | mapeada según el nombre de la regla (ver tabla) |

### Mapping de reglas → restricciones operacionales

| Regla phparkitect (aproximada) | Restricción |
|---|---|
| `ControllersCannotDependOnRepositories` | R3 / R4 |
| `ControllersCannotDependOnModels` | R3 / R4 |
| `ServicesCannotDependOnHttp` | R3 |
| `ServicesCannotDependOnRepositoriesDirectly` | R3 (con baseline si aplica) |
| `ModelsCannotContainBusinessLogic` | R3 |
| `RepositoriesCannotDependOnControllersOrServices` | R3 |
| otros | (genérico) |

Los nombres exactos pueden variar según `phparkitect.php`. Confirmar con el contenido real si difiere.

## Filtrado por archivos en el audit

Si el audit está en modo `<ruta>` o `--branch`, conservar solo las violaciones cuyo `file` esté en la lista de archivos auditados. Las del resto del proyecto se mencionan resumidamente como "(N violaciones adicionales fuera del alcance del audit actual)".

## Reporte en el informe unificado

Sección `## 2.3 phparkitect`:

```markdown
### 2.3 phparkitect

Ejecutado contra: proyecto entero (filtrado a <N> archivos del alcance del audit)
Resultado: <PASS | FAIL con N violaciones nuevas>

#### Violaciones nuevas

| # | Archivo:línea | Regla | Restricción | Dependencia |
|---|---|---|---|---|
| 1 | `App\Controllers\Payments\RefundController:12` | `ControllersCannotDependOnRepositories` | R3 | `App\Repositories\RefundRepository` |
| 2 | … | … | … | … |

#### Violaciones fuera del alcance (resumen)

<N> violaciones adicionales en el resto del proyecto (no se reportan en detalle aquí).
```

Si no hay violaciones nuevas: `Resultado: PASS — arquitectura limpia.`.

## Baseline

`phparkitect-baseline.json` documenta violaciones aceptadas temporalmente (deuda técnica). **Nunca añadir entradas nuevas al baseline sin permiso del usuario.**

Si una violación nueva aparece y el usuario propone añadirla al baseline:

1. Mostrar la violación.
2. Pedir confirmación expresa con razón documentada.
3. Solo si confirma, sugerir el cambio en `phparkitect-baseline.json`.

`duck-audit` por sí mismo no añade entradas. Es información para el usuario.

## Errores de invocación

- Docker / Tilt no arriba: reportar:
  ```
  ⚠️ phparkitect no se pudo ejecutar (entorno no disponible). Saltado.
  ```
  Continuar.

- `phparkitect.php` malformado: severidad `error`, `category=tool-config`.
