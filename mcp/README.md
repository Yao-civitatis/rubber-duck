# MCP — Configuración de servidores externos

rubber-duck depende de dos servidores MCP (Model Context Protocol) para acceder a servicios externos:

1. **Atlassian** — lee y escribe Jira; lee Confluence
2. **Database** — consulta la BBDD compartida entre new-admin y old-admin (modo read-only obligatorio)

Esta carpeta contiene plantillas (`.example.json`) que se subiran al repo y archivos reales (`config.json`, `claude_desktop_config.json`) que **nunca** se commitean (estan en `.gitignore`).

---

## 1. Atlassian

### 1.1. Crea tu token de API

1. Ve a https://id.atlassian.com/manage-profile/security/api-tokens
2. **Create API token** → ponle un nombre (`rubber-duck`) → cópialo. Aparece **una sola vez**.

### 1.2. Configura `atlassian/config.json`

```bash
cp atlassian/config.example.json atlassian/config.json
```

Edita `atlassian/config.json` y reemplaza `TU_TOKEN_API_AQUI` por tu token real.

Los demas campos (`url`, `cloud_id`, `jira_project_keys`, `confluence_space_key`, etc.) ya estan rellenos con los valores reales de Civitatis.

### 1.3. IDs de paginas de Confluence

`atlassian/page-ids.json` mapea los archivos `docs/<proyecto>/{backend,frontend}-standards.md` a las paginas reales de Confluence:

| Documento | Page ID |
|---|---|
| new-admin backend | `2389508098` |
| new-admin frontend | `2449342481` |

**old-admin se omite intencionadamente.** No existe Confluence con estandares para old-admin y no se va a crear: la politica del equipo es mantenimiento-only sobre ese codigo legacy. Ver `PLAN_IMPLEMENTATION.md` §"Politica de trabajo (CRITICA)" y la entrada `old-admin-policy` en la memoria global.

---

## 2. Base de datos

### 2.1. Configura `database/config.json`

```bash
cp database/config.example.json database/config.json
```

Rellena los valores de conexion a la BBDD de desarrollo (Tilt) o staging. **No uses credenciales de produccion.**

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
