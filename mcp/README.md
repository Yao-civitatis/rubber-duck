# MCP — Configuración de servidores externos

rubber-duck depende de dos servidores MCP (Model Context Protocol) para acceder a servicios externos:

1. **Atlassian** — lee y escribe Jira; lee Confluence
2. **Database** — consulta la BBDD compartida entre new-admin y old-admin (modo read-only obligatorio)

## Layout

Esta carpeta (`$RUBBER_DUCK_HOME/mcp/`) contiene **plantillas y referencia** que viven en el repo:

```
mcp/
├── README.md                              (este archivo)
├── atlassian/
│   ├── config.example.json                (plantilla con valores Civitatis preconfigurados)
│   └── page-ids.json                      (IDs reales de Confluence — referencia)
├── database/
│   └── config.example.json                (plantilla con campos a rellenar)
└── claude_desktop_config.example.json     (plantilla para Claude Desktop)
```

Los **archivos con credenciales reales viven fuera del repo**, en `~/.rubber-duck/mcp/` (datos personales del usuario):

```
~/.rubber-duck/mcp/
├── atlassian/
│   └── config.json                        (tu token + datos Civitatis)
└── database/
    └── config.json                        (credenciales BBDD local/dev)
```

Ambos `config.json` se generan automáticamente en el wizard `duck-config setup` (pasos opcionales 9 y 10) o copiando las plantillas manualmente.

---

## 1. Atlassian

### 1.1. Crea tu token de API

1. Ve a https://id.atlassian.com/manage-profile/security/api-tokens
2. **Create API token** → ponle un nombre (`rubber-duck`) → cópialo. Aparece **una sola vez**.

### 1.2. Configura `~/.rubber-duck/mcp/atlassian/config.json`

**Opción recomendada (vía wizard):**

```bash
duck-config setup     # incluye paso 9 "MCP Atlassian (opcional)" donde solo te pedirá el token
```

**Opción manual:**

```bash
mkdir -p ~/.rubber-duck/mcp/atlassian
cp $RUBBER_DUCK_HOME/mcp/atlassian/config.example.json ~/.rubber-duck/mcp/atlassian/config.json
# Edita ~/.rubber-duck/mcp/atlassian/config.json y reemplaza TU_TOKEN_API_AQUI
chmod 600 ~/.rubber-duck/mcp/atlassian/config.json
```

Los demas campos (`url`, `cloud_id`, `jira_project_keys`, `confluence_space_key`, etc.) ya estan rellenos con los valores reales de Civitatis en la plantilla.

### 1.3. IDs de paginas de Confluence

`atlassian/page-ids.json` mapea los archivos `docs/<proyecto>/{backend,frontend}-standards.md` a las paginas reales de Confluence:

| Documento | Page ID |
|---|---|
| new-admin backend | `2389508098` |
| new-admin frontend | `2449342481` |

**old-admin se omite intencionadamente.** No existe Confluence con estandares para old-admin y no se va a crear: la politica del equipo es mantenimiento-only sobre ese codigo legacy. Ver `PLAN_IMPLEMENTATION.md` §"Politica de trabajo (CRITICA)" y la entrada `old-admin-policy` en la memoria global.

---

## 2. Base de datos

### 2.1. Configura `~/.rubber-duck/mcp/database/config.json`

**Opción recomendada (vía wizard):**

```bash
duck-config setup     # incluye paso 10 "MCP Database (opcional)" — te imprime la plantilla y la pega rellena
```

**Opción manual:**

```bash
mkdir -p ~/.rubber-duck/mcp/database
cp $RUBBER_DUCK_HOME/mcp/database/config.example.json ~/.rubber-duck/mcp/database/config.json
# Edita con credenciales de Tilt/dev — NUNCA producción
chmod 600 ~/.rubber-duck/mcp/database/config.json
```

### 2.2. Modo read-only obligatorio

La BBDD es **compartida** entre new-admin y old-admin. Cualquier cambio afecta a ambos.

`rubber-duck` configura el MCP de BBDD en modo **read-only**: ningun comando `duck-*` ejecuta `INSERT`, `UPDATE`, `DELETE`, `ALTER`, `DROP` o `TRUNCATE`. Si necesitas un cambio de datos:

1. `duck-db` redacta la query exacta
2. Te la muestra para revision
3. **Tu** la ejecutas manualmente fuera de la herramienta

Esta restriccion esta documentada como **R2** en `PLAN_IMPLEMENTATION.md`.

---

## 3. Claude Desktop

`claude_desktop_config.example.json` es la plantilla que declara los dos servidores MCP. Copia el contenido (no el archivo entero) al config real de Claude Desktop:

| SO | Ruta |
|---|---|
| macOS | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Linux | `~/.config/Claude/claude_desktop_config.json` |
| Windows | `%APPDATA%/Claude/claude_desktop_config.json` |

Reemplaza los `REEMPLAZAR_*` por tus credenciales reales. Reinicia Claude Desktop. Verifica que ambos servidores aparecen como conectados.

---

## 4. Verificacion rapida

```bash
# Atlassian: pide a Claude que liste tus tickets
"lista mis tickets de PANA"

# Database (read-only): pide un count simple
"cuantos registros tiene la tabla users"

# Database (write debe fallar):
"borra el usuario con id 1"
# → debe rechazar la operacion
```
