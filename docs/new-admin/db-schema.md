# DB Schema — new-admin

> Generado por `duck-sync-docs --schema` el 2026-05-28T20:24:32Z.
> Entorno: dev (db.civitatis.local). Base de datos: civitatis (MySQL 8.x).
> Tablas detectadas por heurística scan del código (`app/Models/` propiedad `protected $table`) — puede estar incompleto.
> No editar: el siguiente `duck-sync-docs --schema` lo sobrescribe.

> ⚠️ Nota de extracción: el entorno `slave` (default del plan) falló la gate (b) — el servidor réplica
> reporta `@@global.super_read_only=0`. Se usó `dev` (Tilt local) como fallback seguro (gate PASS, level=low).
> El schema es idéntico entre entornos; los datos no se extraen (solo DDL/columnas/índices).

## Resumen

- **Tablas detectadas (código):** 447
- **Tablas encontradas en DB:** 445
- **Tablas no encontradas:** 2 (listadas con ⚠️)

### ⚠️ Tablas referenciadas en código pero no encontradas en DB (dev)

- `entity_type` — referenciada en `app/Models/EntityType.php` (puede existir solo en prod o ser legacy).
- `latest_activity_booking_antifraud` — referenciada en `app/Models/Views/LatestActivityBookingAntifraud.php` (puede existir solo en prod o ser legacy).

---

### `accesibilidad_actividades_master`

**Usado por:**
- `new-admin`: (`app/Models/AccesibilidadActividadesMaster.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| code | int | NO |  | NULL |  |
| name | text | NO |  | NULL |  |
| type | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `accesibilidad_actividades_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` int NOT NULL,
  `name` text NOT NULL,
  `type` int NOT NULL COMMENT '1- Sí 2- No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3
```

### `accesibilidad_actividades_translations`

**Usado por:**
- `new-admin`: (`app/Models/AccessibilityActivitiesTranslations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_accesibilidad | int | NO |  | NULL |  |
| name | text | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `accesibilidad_actividades_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_accesibilidad` int NOT NULL,
  `name` text NOT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb3
```

### `accommodation_bookings_pay_info`

**Usado por:**
- `new-admin`: (`app/Models/AccommodationBookingsPayInfo.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| accommodation_id | int | NO | MUL | NULL |  |
| booking_id | int | NO |  | NULL |  |
| booking_type | int | NO |  | NULL |  |
| billing_date_check | timestamp | YES |  | NULL |  |
| payment_invoice_number | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_booking_id_type_accommodation_bookings_info | BTREE | accommodation_id, booking_id, booking_type | No |

#### DDL

```sql
CREATE TABLE `accommodation_bookings_pay_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `accommodation_id` int NOT NULL,
  `booking_id` int NOT NULL,
  `booking_type` int NOT NULL COMMENT '1 Actividad 2 Traslado',
  `billing_date_check` timestamp NULL DEFAULT NULL,
  `payment_invoice_number` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_booking_id_type_accommodation_bookings_info` (`accommodation_id`,`booking_id`,`booking_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `actividades`

**Usado por:**
- `new-admin`: (`app/Models/Activity.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCiudad | smallint | NO | MUL | NULL |  |
| url | varchar(64) | NO | MUL | NULL |  |
| titulo | varchar(255) | NO |  | NULL |  |
| tituloLargo | varchar(255) | NO |  | NULL |  |
| tituloCorto | varchar(29) | NO |  | NULL |  |
| tituloOriginal | varchar(66) | YES |  | NULL |  |
| descripcion | text | NO |  | NULL |  |
| descripcionBreve | varchar(512) | NO |  | NULL |  |
| imagen | varchar(128) | NO |  | NULL |  |
| keywords | varchar(256) | NO |  | NULL |  |
| proveedor | int | NO | MUL | NULL |  |
| incluido | varchar(1024) | NO |  | NULL |  |
| noIncluido | varchar(1024) | NO |  | NULL |  |
| cancelaciones | varchar(1024) | NO |  | NULL |  |
| infoAdicional | varchar(1024) | NO |  | NULL |  |
| infoVoucher | text | NO |  | NULL |  |
| duracion | varchar(256) | NO |  | NULL |  |
| duracion_minutos | int | NO |  | 0 |  |
| duracion_libre | varchar(50) | YES |  | NULL |  |
| duracion_minima | varchar(50) | YES |  | NULL |  |
| duracion_maxima | varchar(50) | YES |  | NULL |  |
| tipos | varchar(1024) | NO |  | NULL |  |
| preciosGenerales | varchar(128) | NO |  | NULL |  |
| preciosEstudiantes | varchar(128) | NO |  | NULL |  |
| preciosMenores | varchar(128) | NO |  | NULL |  |
| comoReservar | varchar(512) | NO |  | NULL |  |
| antelacion | varchar(8) | NO |  | NULL |  |
| zonaHorarias | varchar(32) | NO |  | NULL |  |
| precioMinimo | float | NO |  | 0 |  |
| precioOficial | float | NO |  | 0 |  |
| precioPersona | tinyint(1) | NO |  | 0 |  |
| divisa | varchar(3) | NO |  | NULL |  |
| tarifaReserva | int | NO |  | NULL |  |
| ganancia | varchar(16) | NO |  | NULL |  |
| direccion | varchar(256) | NO |  | NULL |  |
| comoLlegar | varchar(512) | NO |  | NULL |  |
| longitud | double | NO |  | 0 |  |
| latitud | double | NO |  | 0 |  |
| zoom | tinyint | NO |  | 0 |  |
| datosSolicitados | varchar(512) | NO |  | NULL |  |
| activa | tinyint(1) | NO | MUL | 0 |  |
| activityStatus | int | YES |  | 1 |  |
| modificable | varchar(8) | NO |  | si |  |
| datosEntrega | varchar(512) | NO |  | NULL |  |
| accesibilidad | varchar(256) | NO |  | NULL |  |
| opiniones | int | NO |  | NULL |  |
| valoracion | double | NO |  | NULL |  |
| personas | int | NO |  | NULL |  |
| popularidad | int | NO | MUL | NULL |  |
| popularidadb2b | int | NO |  | 0 |  |
| prioridad | tinyint | NO |  | 10 |  |
| urgencia | tinyint(1) | NO |  | NULL |  |
| idioma | int | NO |  | NULL |  |
| idInternoProveedor | varchar(64) | NO |  | NULL |  |
| promo_text | varchar(32) | YES |  | NULL |  |
| lang | varchar(2) | YES | MUL | es |  |
| tipo_iva | tinyint(1) | NO |  | 0 |  |
| activation_date | datetime | YES |  | NULL |  |
| descripcionAdwords | varchar(80) | YES |  | NULL |  |
| tituloAdwords | varchar(30) | YES |  | NULL |  |
| author | varchar(32) | YES |  | NULL |  |
| redactor | varchar(32) | YES |  | NULL |  |
| account | varchar(32) | YES |  | NULL |  |
| contentManager | varchar(32) | YES |  | NULL |  |
| reviewer_id | int | YES |  | NULL |  |
| video | varchar(512) | YES |  | NULL |  |
| video_approved | tinyint | NO |  | 0 |  |
| disponibilidad | int | YES |  | NULL |  |
| show_price_table | tinyint | NO |  | 2 |  |
| price_message | text | YES |  | NULL |  |
| redirect_activity_id | int | YES |  | NULL |  |
| redirect_activity_type | int | YES |  | NULL |  |
| account_manager | int | YES |  | NULL |  |
| desactivation_date | datetime | YES |  | NULL |  |
| jira | varchar(100) | YES |  | NULL |  |
| sin_colas | int | YES |  | 0 |  |
| producto_verificado | int | YES |  | NULL |  |
| notified_provider | tinyint | NO |  | 0 |  |
| status_date | datetime | YES |  | NULL |  |
| reactivation_date | datetime | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| guide_options | bigint | YES |  | 0 |  |
| pet_allow | tinyint(1) | YES |  | NULL |  |
| integration_info | int | YES |  | NULL |  |
| commissionable_affiliates | int | NO |  | 1 |  |
| ratio_fraude | float | YES |  | 0 |  |
| non_commissionable_refunds | tinyint | YES |  | 0 |  |
| easy_run_out | tinyint | NO |  | 0 |  |
| ganancia_provisional | float | NO |  | 0 |  |
| is_secondary | tinyint | NO | MUL | 0 |  |
| low_availability | tinyint | NO |  | 0 |  |
| tipo_iva_proveedor | tinyint | NO |  | -1 |  |
| seo_content_date | date | YES |  | NULL |  |
| calendar_available | tinyint(1) | NO |  | 1 |  |
| preciosManuales | tinyint(1) | NO |  | 0 |  |
| showPriceFrom | tinyint(1) | NO |  | 0 |  |
| is_proposal | tinyint(1) | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| activa | BTREE | activa, idCiudad, lang | No |
| actividades_idx_activa_lang_popularida | BTREE | activa, lang, popularidad | No |
| actividades_idx_lang_activa_id_opinion | BTREE | lang, activa, id, opiniones | No |
| id | BTREE | id, idCiudad, lang | No |
| idx_actividades | BTREE | popularidad | No |
| idx_actividades_idCiudad | BTREE | idCiudad | No |
| idx_actividades_is_secondary_lang | BTREE | is_secondary, lang | No |
| idx_actividades_proveedor_activa_secondary_precio | BTREE | proveedor, activa, is_secondary, precioMinimo | No |
| idx_actividades_uel | BTREE | url | No |
| idx_activity_city_status | BTREE | activa, idCiudad | No |

#### DDL

```sql
CREATE TABLE `actividades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCiudad` smallint NOT NULL,
  `url` varchar(64) NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `tituloLargo` varchar(255) NOT NULL,
  `tituloCorto` varchar(29) NOT NULL,
  `tituloOriginal` varchar(66) DEFAULT NULL,
  `descripcion` text NOT NULL,
  `descripcionBreve` varchar(512) NOT NULL,
  `imagen` varchar(128) NOT NULL,
  `keywords` varchar(256) NOT NULL,
  `proveedor` int NOT NULL,
  `incluido` varchar(1024) NOT NULL,
  `noIncluido` varchar(1024) NOT NULL,
  `cancelaciones` varchar(1024) NOT NULL,
  `infoAdicional` varchar(1024) NOT NULL,
  `infoVoucher` text NOT NULL,
  `duracion` varchar(256) NOT NULL,
  `duracion_minutos` int NOT NULL DEFAULT '0',
  `duracion_libre` varchar(50) DEFAULT NULL,
  `duracion_minima` varchar(50) DEFAULT NULL,
  `duracion_maxima` varchar(50) DEFAULT NULL,
  `tipos` varchar(1024) NOT NULL,
  `preciosGenerales` varchar(128) NOT NULL,
  `preciosEstudiantes` varchar(128) NOT NULL,
  `preciosMenores` varchar(128) NOT NULL,
  `comoReservar` varchar(512) NOT NULL,
  `antelacion` varchar(8) NOT NULL,
  `zonaHorarias` varchar(32) NOT NULL,
  `precioMinimo` float NOT NULL DEFAULT '0',
  `precioOficial` float NOT NULL DEFAULT '0',
  `precioPersona` tinyint(1) NOT NULL DEFAULT '0',
  `divisa` varchar(3) NOT NULL,
  `tarifaReserva` int NOT NULL,
  `ganancia` varchar(16) NOT NULL,
  `direccion` varchar(256) NOT NULL,
  `comoLlegar` varchar(512) NOT NULL,
  `longitud` double NOT NULL DEFAULT '0',
  `latitud` double NOT NULL DEFAULT '0',
  `zoom` tinyint NOT NULL DEFAULT '0',
  `datosSolicitados` varchar(512) NOT NULL,
  `activa` tinyint(1) NOT NULL DEFAULT '0',
  `activityStatus` int DEFAULT '1' COMMENT '0-Inactiva por per, 1-Pendiente Info Básica, 2-Pendiente Asignar, 3-Pendiente Redacción, 4-Falta Info, 5-En Redacion, 6-Pendiente Mapeo, 6-En Mapeo, 7-Pendiente Revisión, 8-Activa,10-Inact no opera,11-Inact fraude,12-Pte de Master,13-Inact Rechazada,14-Inact Fantasma',
  `modificable` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'si',
  `datosEntrega` varchar(512) NOT NULL,
  `accesibilidad` varchar(256) NOT NULL,
  `opiniones` int NOT NULL,
  `valoracion` double NOT NULL,
  `personas` int NOT NULL,
  `popularidad` int NOT NULL,
  `popularidadb2b` int NOT NULL DEFAULT '0' COMMENT 'Popularidad calculada para agencias/Alojamientos',
  `prioridad` tinyint NOT NULL DEFAULT '10',
  `urgencia` tinyint(1) NOT NULL,
  `idioma` int NOT NULL,
  `idInternoProveedor` varchar(64) NOT NULL,
  `promo_text` varchar(32) DEFAULT NULL,
  `lang` varchar(2) DEFAULT 'es',
  `tipo_iva` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 Sin IVA, 1 IVA general, 2 Régimen especial',
  `activation_date` datetime DEFAULT NULL,
  `descripcionAdwords` varchar(80) DEFAULT NULL,
  `tituloAdwords` varchar(30) DEFAULT NULL,
  `author` varchar(32) DEFAULT NULL,
  `redactor` varchar(32) DEFAULT NULL,
  `account` varchar(32) DEFAULT NULL,
  `contentManager` varchar(32) DEFAULT NULL,
  `reviewer_id` int DEFAULT NULL,
  `video` varchar(512) DEFAULT NULL,
  `video_approved` tinyint NOT NULL DEFAULT '0',
  `disponibilidad` int DEFAULT NULL,
  `show_price_table` tinyint NOT NULL DEFAULT '2',
  `price_message` text,
  `redirect_activity_id` int DEFAULT NULL,
  `redirect_activity_type` int DEFAULT NULL,
  `account_manager` int DEFAULT NULL,
  `desactivation_date` datetime DEFAULT NULL,
  `jira` varchar(100) DEFAULT NULL,
  `sin_colas` int DEFAULT '0' COMMENT '0-No, 1-Sí',
  `producto_verificado` int DEFAULT NULL,
  `notified_provider` tinyint NOT NULL DEFAULT '0',
  `status_date` datetime DEFAULT NULL,
  `reactivation_date` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `guide_options` bigint DEFAULT '0',
  `pet_allow` tinyint(1) DEFAULT NULL COMMENT '0-No, 1-Sí, 2- Si, con transportín, 3- Sí, animales de menos de 10 kg, 4- Sí, solo en zonas exteriores',
  `integration_info` int DEFAULT NULL,
  `commissionable_affiliates` int NOT NULL DEFAULT '1' COMMENT '0 No es comisionable 1 Si es comisionable',
  `ratio_fraude` float DEFAULT '0' COMMENT '0',
  `non_commissionable_refunds` tinyint DEFAULT '0' COMMENT '0 - Falso, 1 - Verdadero',
  `easy_run_out` tinyint NOT NULL DEFAULT '0' COMMENT '0-NO 1-SI',
  `ganancia_provisional` float NOT NULL DEFAULT '0' COMMENT 'ganancia provisional en EUR para GTM',
  `is_secondary` tinyint NOT NULL DEFAULT '0',
  `low_availability` tinyint NOT NULL DEFAULT '0' COMMENT '0-NO 1-SI',
  `tipo_iva_proveedor` tinyint NOT NULL DEFAULT '-1',
  `seo_content_date` date DEFAULT NULL,
  `calendar_available` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Flag que determina si la actividad dispone de fechas abiertas en el calendario desde ahora en un año',
  `preciosManuales` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'campo configurado desde admin para establecer el valor de precio mínimo y oficial de manera manual y no calculado automáticamente por el calendario',
  `showPriceFrom` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Flag que identificará si se muestra el literal ''desde'' para la actividad',
  `is_proposal` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0: No | 1: Si',
  PRIMARY KEY (`id`),
  KEY `idx_actividades` (`popularidad`),
  KEY `idx_activity_city_status` (`activa`,`idCiudad`),
  KEY `idx_actividades_uel` (`url`),
  KEY `id` (`id`,`idCiudad`,`lang`),
  KEY `activa` (`activa`,`idCiudad`,`lang`),
  KEY `actividades_idx_activa_lang_popularida` (`activa`,`lang`,`popularidad`),
  KEY `idx_actividades_idCiudad` (`idCiudad`),
  KEY `actividades_idx_lang_activa_id_opinion` (`lang`,`activa`,`id`,`opiniones`),
  KEY `idx_actividades_is_secondary_lang` (`is_secondary`,`lang`),
  KEY `idx_actividades_proveedor_activa_secondary_precio` (`proveedor`,`activa`,`is_secondary`,`precioMinimo`)
) ENGINE=InnoDB AUTO_INCREMENT=209489 DEFAULT CHARSET=utf8mb3 COMMENT='0: No | 1: Si'
```

### `actividades_categorias`

**Usado por:**
- `new-admin`: (`app/Models/ActivityCategory.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(256) | NO |  | NULL |  |
| public_label | varchar(256) | YES |  | NULL |  |
| enabled | tinyint | NO |  | 1 |  |
| sort | int | NO |  | NULL |  |
| icon | varchar(256) | NO |  |  |  |
| view | int | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `actividades_categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `public_label` varchar(256) DEFAULT NULL COMMENT 'Label usada para la descripción en web',
  `enabled` tinyint NOT NULL DEFAULT '1',
  `sort` int NOT NULL,
  `icon` varchar(256) NOT NULL DEFAULT '' COMMENT 'Icono SVG de la categoría',
  `view` int NOT NULL DEFAULT '1' COMMENT 'Visibilidad en los filtros de la web',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1
```

### `actividades_categorias_translations`

**Usado por:**
- `new-admin`: (`app/Models/ActivityCategoryTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterCategoria | int | NO |  | NULL |  |
| lang | varchar(2) | NO | MUL | NULL |  |
| nombre | varchar(128) | NO |  | NULL |  |
| url | varchar(128) | NO |  | NULL |  |
| metaTitle_generico | varchar(256) | YES |  | NULL |  |
| metaTitle_destino | varchar(256) | YES |  | NULL |  |
| metaDescription_generico | varchar(256) | YES |  | NULL |  |
| metaDescription_destino | varchar(256) | YES |  | NULL |  |
| keywords_generico | varchar(256) | YES |  | NULL |  |
| keywords_destino | varchar(256) | YES |  | NULL |  |
| image | varchar(128) | YES |  | NULL |  |
| indexable | tinyint | YES |  | 0 |  |
| content | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_act_lang_idMasterCat | BTREE | lang, idMasterCategoria, id | No |

#### DDL

```sql
CREATE TABLE `actividades_categorias_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterCategoria` int NOT NULL,
  `lang` varchar(2) NOT NULL,
  `nombre` varchar(128) NOT NULL,
  `url` varchar(128) NOT NULL,
  `metaTitle_generico` varchar(256) DEFAULT NULL,
  `metaTitle_destino` varchar(256) DEFAULT NULL,
  `metaDescription_generico` varchar(256) DEFAULT NULL,
  `metaDescription_destino` varchar(256) DEFAULT NULL,
  `keywords_generico` varchar(256) DEFAULT NULL,
  `keywords_destino` varchar(256) DEFAULT NULL,
  `image` varchar(128) DEFAULT NULL,
  `indexable` tinyint DEFAULT '0' COMMENT '1 - Si, 0 - No',
  `content` text,
  PRIMARY KEY (`id`),
  KEY `idx_act_lang_idMasterCat` (`lang`,`idMasterCategoria`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb3
```

### `actividades_fechas_ocupadas`

**Usado por:**
- `new-admin`: (`app/Models/ActivityOccupiedDate.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | bigint | NO | PRI | NULL | auto_increment |
| idActividad | int | NO | MUL | NULL |  |
| fecha | date | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_actividades_fechas_ocupadas_idActividad | BTREE | idActividad | No |

#### DDL

```sql
CREATE TABLE `actividades_fechas_ocupadas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `idActividad` int NOT NULL,
  `fecha` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_actividades_fechas_ocupadas_idActividad` (`idActividad`)
) ENGINE=InnoDB AUTO_INCREMENT=25558488039 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `actividades_horarios`

**Usado por:**
- `new-admin`: (`app/Models/ActivitySchedule.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | bigint | NO | PRI | NULL | auto_increment |
| idActividad | int | YES | MUL | NULL |  |
| tipo | tinyint(1) | NO |  | NULL |  |
| fechaInicio | date | NO |  | 2019-01-01 |  |
| fechaFin | date | NO |  | 2029-12-31 |  |
| dias | varchar(16) | NO |  | NULL |  |
| horas | varchar(512) | NO |  | NULL |  |
| precios | text | YES |  | NULL |  |
| suplementos | varchar(128) | NO |  | NULL |  |
| plazas | tinyint | NO |  | NULL |  |
| integration | tinyint | YES |  | 0 |  |
| cupos | varchar(1500) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_actividades_horarios_idActividad_fechaFin | BTREE | idActividad, fechaFin | No |
| idx_activity | BTREE | idActividad | No |

#### DDL

```sql
CREATE TABLE `actividades_horarios` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `idActividad` int DEFAULT NULL,
  `tipo` tinyint(1) NOT NULL,
  `fechaInicio` date NOT NULL DEFAULT '2019-01-01',
  `fechaFin` date NOT NULL DEFAULT '2029-12-31',
  `dias` varchar(16) NOT NULL,
  `horas` varchar(512) NOT NULL,
  `precios` text,
  `suplementos` varchar(128) NOT NULL,
  `plazas` tinyint NOT NULL,
  `integration` tinyint DEFAULT '0' COMMENT 'Activity schedule is added by integration or not. Defaults to 0 (no)',
  `cupos` varchar(1500) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_activity` (`idActividad`) USING BTREE,
  KEY `idx_actividades_horarios_idActividad_fechaFin` (`idActividad`,`fechaFin` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=7951210884 DEFAULT CHARSET=utf8mb3
```

### `actividades_imagenes`

**Usado por:**
- `new-admin`: (`app/Models/ActivityImage.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_actividad | int | NO | MUL | NULL |  |
| pos | int | NO |  | 10000 |  |
| titulo | varchar(64) | NO |  | NULL |  |
| carpeta | varchar(128) | NO |  | NULL |  |
| archivo | varchar(64) | NO |  | NULL |  |
| ancho_thumb | int | NO |  | NULL |  |
| alto_thumb | int | NO |  | NULL |  |
| free_use | int | YES |  | 0 |  |
| origin | varchar(10) | NO |  | admin |  |
| origin_id | varchar(10) | YES |  | NULL |  |
| approved | tinyint | NO |  | 1 |  |
| spreaded_img_id | int | YES |  | NULL |  |
| alt_text | varchar(100) | YES |  | NULL |  |
| created_by_ia | tinyint(1) | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_actividades_imagenes_actividad | BTREE | id_actividad | No |

#### DDL

```sql
CREATE TABLE `actividades_imagenes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_actividad` int NOT NULL,
  `pos` int NOT NULL DEFAULT '10000' COMMENT 'Orden de la imagen',
  `titulo` varchar(64) NOT NULL,
  `carpeta` varchar(128) NOT NULL,
  `archivo` varchar(64) NOT NULL,
  `ancho_thumb` int NOT NULL,
  `alto_thumb` int NOT NULL,
  `free_use` int DEFAULT '0' COMMENT '0 No 1 Sí',
  `origin` varchar(10) NOT NULL DEFAULT 'admin' COMMENT 'admin/provider',
  `origin_id` varchar(10) DEFAULT NULL COMMENT 'id del creador/editor',
  `approved` tinyint NOT NULL DEFAULT '1',
  `spreaded_img_id` int DEFAULT NULL COMMENT 'id de imagen de la que se replica',
  `alt_text` varchar(100) DEFAULT NULL,
  `created_by_ia` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_actividades_imagenes_actividad` (`id_actividad`)
) ENGINE=InnoDB AUTO_INCREMENT=1303648 DEFAULT CHARSET=utf8mb3
```

### `actividades_opciones`

**Usado por:**
- `new-admin`: (`app/Models/ActivityOption.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL |  |
| tipo | tinyint | NO | PRI | NULL |  |
| idProveedor | int | NO | MUL | 0 | DEFAULT_GENERATED |
| precios_filas | varchar(1024) | NO |  | NULL |  |
| precios_columnas | varchar(1024) | NO |  | NULL |  |
| incluido | varchar(1024) | NO |  | NULL |  |
| noIncluido | varchar(1024) | NO |  | NULL |  |
| cancelaciones | varchar(1024) | NO |  | NULL |  |
| infoAdicional | varchar(1024) | NO |  | NULL |  |
| infoVoucher | text | NO |  | NULL |  |
| tipos | varchar(1024) | NO |  | NULL |  |
| comoReservar | varchar(512) | NO |  | NULL |  |
| antelacion | varchar(16) | NO |  | NULL |  |
| precioMinimo | float | NO |  | 0 |  |
| precioPersona | tinyint | NO |  | 0 |  |
| divisa | varchar(3) | NO |  | NULL |  |
| tarifaReserva | int | NO |  | 100 |  |
| formasPago | varchar(8) | NO |  | 1,0,0,0 |  |
| direccion | varchar(256) | NO |  | NULL |  |
| direccionCompleta | varchar(256) | NO |  | NULL |  |
| comoLlegar | varchar(512) | NO |  | NULL |  |
| longitud | double | NO |  | 0 |  |
| latitud | double | NO |  | 0 |  |
| zoom | int | NO |  | 0 |  |
| return_point_type | int | NO |  | 0 |  |
| return_longitude | double | NO |  | 0 |  |
| return_latitude | double | NO |  | 0 |  |
| return_direction | varchar(256) | NO |  | NULL |  |
| datosSolicitados | varchar(512) | NO |  | NULL |  |
| diasCierre | varchar(1024) | YES |  | NULL |  |
| preguntasAdicionales | text | NO |  | NULL |  |
| datosEntrega | varchar(1024) | NO |  | NULL |  |
| voucher | tinyint(1) | NO |  | 0 |  |
| requiereConfirmacion | tinyint(1) | NO |  | 1 |  |
| showHour | int | YES |  | 1 |  |
| passenger_info_required | int | YES |  | NULL |  |
| minimo_participantes | tinyint | NO |  | 0 |  |
| maximo_participantes | int | YES |  | 0 |  |
| min_pax_per_booking | tinyint | YES |  | NULL |  |
| cupo | int | YES |  | NULL |  |
| custom_quotas | tinyint(1) | NO |  | 0 |  |
| edad_minima | int | NO |  | 0 |  |
| log_reservas | tinyint | NO |  | 0 |  |
| log_horarios | tinyint | NO |  | 0 |  |
| pickup_type | int | YES |  | 0 |  |
| tour_note | text | YES |  | NULL |  |
| log_reservas_manual_cancel | int | YES |  | 0 |  |
| has_low_quality_images | tinyint | NO |  | 0 |  |
| indexable | tinyint(1) | YES |  | 1 |  |
| listable | tinyint(1) | YES |  | 1 |  |
| type_of_writing | tinyint(1) | YES |  | NULL |  |
| golden_tour | tinyint(1) | NO |  | 0 |  |
| status_error_type | tinyint unsigned | YES |  | NULL |  |
| prioritize_provider_responsive | tinyint(1) | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id, tipo | Sí |
| idx-actividades_opciones-proveedor | BTREE | idProveedor | No |

#### DDL

```sql
CREATE TABLE `actividades_opciones` (
  `id` int NOT NULL,
  `tipo` tinyint NOT NULL,
  `idProveedor` int NOT NULL DEFAULT (0),
  `precios_filas` varchar(1024) NOT NULL,
  `precios_columnas` varchar(1024) NOT NULL,
  `incluido` varchar(1024) NOT NULL,
  `noIncluido` varchar(1024) NOT NULL,
  `cancelaciones` varchar(1024) NOT NULL,
  `infoAdicional` varchar(1024) NOT NULL,
  `infoVoucher` text NOT NULL,
  `tipos` varchar(1024) NOT NULL,
  `comoReservar` varchar(512) NOT NULL,
  `antelacion` varchar(16) NOT NULL,
  `precioMinimo` float NOT NULL DEFAULT '0',
  `precioPersona` tinyint NOT NULL DEFAULT '0',
  `divisa` varchar(3) NOT NULL,
  `tarifaReserva` int NOT NULL DEFAULT '100',
  `formasPago` varchar(8) NOT NULL DEFAULT '1,0,0,0',
  `direccion` varchar(256) NOT NULL,
  `direccionCompleta` varchar(256) NOT NULL,
  `comoLlegar` varchar(512) NOT NULL,
  `longitud` double NOT NULL DEFAULT '0',
  `latitud` double NOT NULL DEFAULT '0',
  `zoom` int NOT NULL DEFAULT '0',
  `return_point_type` int NOT NULL DEFAULT '0' COMMENT '0.- No definido 1.- Mismo punto que inicio 2.- Punto diferente que el de inicio',
  `return_longitude` double NOT NULL DEFAULT '0' COMMENT 'Si return_type es 2',
  `return_latitude` double NOT NULL DEFAULT '0' COMMENT 'Si return_type es 2',
  `return_direction` varchar(256) NOT NULL COMMENT 'Si return_type es 2',
  `datosSolicitados` varchar(512) NOT NULL,
  `diasCierre` varchar(1024) DEFAULT NULL,
  `preguntasAdicionales` text NOT NULL,
  `datosEntrega` varchar(1024) NOT NULL,
  `voucher` tinyint(1) NOT NULL DEFAULT '0' COMMENT '"1": "Bono Civitatis electrónico",\\r\
"2": "Bono Civitatis impreso",\\r\
"3": "Bono proveedor impreso",\\r\
"5": "Bono proveedor electrónico",\\r\
"4": "PDF propio impreso",\\r\
"6": "PDF propio electrónico"',
  `requiereConfirmacion` tinyint(1) NOT NULL DEFAULT '1',
  `showHour` int DEFAULT '1' COMMENT '1 - Si 0 - No',
  `passenger_info_required` int DEFAULT NULL COMMENT '1- Nombre, apellidos y peso. 2- Nombre, apellidos. 3- Nombre completo pasaporte, numero pasaporte y fecha caducidad, fecha y lugar de nacimiento, otras posibles fechas. 4-Nombre completo pasaporte, numero pasaporte y fecha caducidad, fecha y lugar de nacimiento. 5- Nombre completo pasaporte, numero pasaporte y fecha caducidad, fecha nacimiento, nacionalidad. 6- Nombre completo pareja',
  `minimo_participantes` tinyint NOT NULL DEFAULT '0',
  `maximo_participantes` int DEFAULT '0',
  `min_pax_per_booking` tinyint DEFAULT NULL COMMENT 'Mínimo de participantes por reserva, sin ello no deja seguir. null = sin mínimo.',
  `cupo` int DEFAULT NULL COMMENT 'porcentaje de la canitidad aplicada al wallet (Agencias)',
  `custom_quotas` tinyint(1) NOT NULL DEFAULT '0',
  `edad_minima` int NOT NULL DEFAULT '0' COMMENT 'Id del proveedor que está cerrado para dicha fecha. Null para todos',
  `log_reservas` tinyint NOT NULL DEFAULT '0',
  `log_horarios` tinyint NOT NULL DEFAULT '0',
  `pickup_type` int DEFAULT '0' COMMENT '(0: No, 1:Si, incluida, 2:Si, opcional de pago',
  `tour_note` text,
  `log_reservas_manual_cancel` int DEFAULT '0' COMMENT '0- NO 1-SI',
  `has_low_quality_images` tinyint NOT NULL DEFAULT '0',
  `indexable` tinyint(1) DEFAULT '1' COMMENT '0. No indexable, 1. Indexable',
  `listable` tinyint(1) DEFAULT '1' COMMENT '0. No listable, 1. Listable',
  `type_of_writing` tinyint(1) DEFAULT NULL COMMENT '0: Redacción desde 0 | 1: Traducción',
  `golden_tour` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0: No | 1: Sí',
  `status_error_type` tinyint unsigned DEFAULT NULL COMMENT '1: Error Inte/Proveedor | 2: Error Inte/Integración',
  `prioritize_provider_responsive` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`,`tipo`),
  KEY `idx-actividades_opciones-proveedor` (`idProveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='1: Error Inte/Proveedor | 2: Error Inte/Integración'
```

### `actividades_opiniones`

**Usado por:**
- `new-admin`: (`app/Models/ActivityOpinion.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| idReserva | int | NO | PRI | NULL |  |
| idActividad | int | NO | PRI | NULL |  |
| nombre | varchar(32) | NO |  | NULL |  |
| texto | text | NO |  | NULL |  |
| respuesta | text | NO |  | NULL |  |
| preguntaProveedor | text | YES |  | NULL |  |
| fecha_pregunta | datetime | YES |  | NULL |  |
| ticket_automatico | tinyint | YES |  | NULL |  |
| comentarios_proveedor | text | NO |  | NULL |  |
| puntuacion | int | NO |  | NULL |  |
| fecha | date | NO | MUL | NULL |  |
| fechaInsercion | timestamp | NO |  | 0000-00-00 00:00:00 |  |
| fechaAprobada | timestamp | NO |  | 0000-00-00 00:00:00 |  |
| fechaEliminada | timestamp | YES |  | NULL |  |
| fechaMalaResolucion | timestamp | YES |  | NULL |  |
| fecha_respuesta_proveedor | timestamp | YES |  | NULL |  |
| estado | tinyint | YES |  | 0 |  |
| pais | varchar(2) | YES | MUL | es |  |
| tipoViajero | varchar(8) | YES |  | NULL |  |
| ciudad | varchar(32) | YES |  | NULL |  |
| idioma | varchar(2) | NO |  | es |  |
| id_ticket | int | YES |  | NULL |  |
| aprobada_por | int | YES | MUL | NULL |  |
| eliminada_por | int | YES |  | NULL |  |
| mala_resolucion | tinyint | YES |  | 0 |  |
| reason_refuse | int | YES |  | NULL |  |
| motivo_rechazo | text | YES |  | NULL |  |
| lang_detected | varchar(4) | YES |  | NULL |  |
| submitted | tinyint | YES |  | 1 |  |
| providerId | int | YES |  | NULL |  |
| notaInterna | text | YES |  | NULL |  |
| pending_provider_answer | tinyint | NO |  | 0 |  |
| boost | int | YES | MUL | NULL |  |
| utility | int | NO | MUL | 0 |  |
| opinion_visited | tinyint(1) | YES |  | 0 |  |
| nps_sent | tinyint(1) | YES |  | 0 |  |
| long_enough_text | tinyint(1) | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | idReserva, idActividad | Sí |
| idReserva | BTREE | idReserva, idActividad, pending_provider_answer | Sí |
| idx_actividades_opiniones | BTREE | pais, idioma, estado | No |
| idx_actividades_opiniones_2 | BTREE | idActividad, idioma, estado, fecha | No |
| idx_actividades_opiniones_aprobada_por_estado_fecha | BTREE | aprobada_por, estado, fechaInsercion | No |
| idx_actividades_opiniones_boost | BTREE | boost | No |
| idx_actividades_opiniones_estado_puntuacion_fecha | BTREE | fecha, estado, puntuacion, idioma, lang_detected, long_enough_text | No |
| idx_actividades_opiniones_utility | BTREE | utility | No |
| idx_texto_descriptivo | BTREE | idReserva, pending_provider_answer | No |

#### DDL

```sql
CREATE TABLE `actividades_opiniones` (
  `idReserva` int NOT NULL,
  `idActividad` int NOT NULL,
  `nombre` varchar(32) NOT NULL,
  `texto` text NOT NULL,
  `respuesta` text NOT NULL,
  `preguntaProveedor` text,
  `fecha_pregunta` datetime DEFAULT NULL,
  `ticket_automatico` tinyint DEFAULT NULL,
  `comentarios_proveedor` text NOT NULL,
  `puntuacion` int NOT NULL,
  `fecha` date NOT NULL,
  `fechaInsercion` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `fechaAprobada` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `fechaEliminada` timestamp NULL DEFAULT NULL,
  `fechaMalaResolucion` timestamp NULL DEFAULT NULL,
  `fecha_respuesta_proveedor` timestamp NULL DEFAULT NULL,
  `estado` tinyint DEFAULT '0' COMMENT '0 No revisada 1 Aprobada y mostrada 2 Otro proveedor',
  `pais` varchar(2) DEFAULT 'es',
  `tipoViajero` varchar(8) DEFAULT NULL,
  `ciudad` varchar(32) DEFAULT NULL,
  `idioma` varchar(2) NOT NULL DEFAULT 'es',
  `id_ticket` int DEFAULT NULL,
  `aprobada_por` int DEFAULT NULL,
  `eliminada_por` int DEFAULT NULL,
  `mala_resolucion` tinyint DEFAULT '0',
  `reason_refuse` int DEFAULT NULL,
  `motivo_rechazo` text,
  `lang_detected` varchar(4) DEFAULT NULL,
  `submitted` tinyint DEFAULT '1',
  `providerId` int DEFAULT NULL,
  `notaInterna` text COMMENT 'opinion en la moderación',
  `pending_provider_answer` tinyint NOT NULL DEFAULT '0',
  `boost` int DEFAULT NULL,
  `utility` int NOT NULL DEFAULT '0' COMMENT 'Cantidad de votos acumulados',
  `opinion_visited` tinyint(1) DEFAULT '0',
  `nps_sent` tinyint(1) DEFAULT '0',
  `long_enough_text` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`idReserva`,`idActividad`),
  UNIQUE KEY `idReserva` (`idReserva`,`idActividad`,`pending_provider_answer`),
  KEY `idx_actividades_opiniones` (`pais`,`idioma`,`estado`),
  KEY `idx_actividades_opiniones_2` (`idActividad`,`idioma`,`estado`,`fecha`),
  KEY `idx_texto_descriptivo` (`idReserva`,`pending_provider_answer`),
  KEY `idx_actividades_opiniones_boost` (`boost`),
  KEY `idx_actividades_opiniones_utility` (`utility`),
  KEY `idx_actividades_opiniones_aprobada_por_estado_fecha` (`aprobada_por`,`estado`,`fechaInsercion` DESC),
  KEY `idx_actividades_opiniones_estado_puntuacion_fecha` (`fecha` DESC,`estado`,`puntuacion`,`idioma`,`lang_detected`,`long_enough_text`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Cantidad de votos acumulados'
```

### `actividades_reservas`

**Usado por:**
- `new-admin`: (`app/Models/ActivityBooking.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idActividad | int | NO | MUL | NULL |  |
| idProveedor | int | NO | MUL | NULL |  |
| idCiudad | int | YES |  | NULL |  |
| tipo | tinyint(1) | NO |  | NULL |  |
| articulo | varchar(256) | NO |  | NULL |  |
| modalidad | varchar(64) | YES |  | NULL |  |
| fecha | date | YES | MUL | NULL |  |
| hora | varchar(32) | NO |  | NULL |  |
| numPersonas | smallint | YES |  | NULL |  |
| textoPersonas | varchar(1024) | YES |  | NULL |  |
| codigoProveedor | varchar(128) | NO |  | NULL |  |
| precioTotal | decimal(38,2) | YES |  | NULL |  |
| precioTotalEuros | decimal(38,2) | YES |  | NULL |  |
| precioReserva | decimal(38,2) | YES |  | NULL |  |
| precioReservaEuros | decimal(38,2) | YES |  | NULL |  |
| ganancia | decimal(38,2) | YES |  | NULL |  |
| gananciaEuros | decimal(38,2) | YES |  | NULL |  |
| comision | decimal(38,2) | YES |  | NULL |  |
| divisa | varchar(3) | NO |  | NULL |  |
| divisaPago | varchar(3) | NO |  | NULL |  |
| nombre | varchar(64) | NO | MUL | NULL |  |
| apellidos | varchar(64) | NO |  | NULL |  |
| email | varchar(256) | NO | MUL | NULL |  |
| pais | char(4) | NO |  | NULL |  |
| telefono | varchar(32) | YES | MUL | NULL |  |
| pais_procedencia | int | YES | MUL | NULL |  |
| alojamiento | varchar(256) | NO |  | NULL |  |
| preguntasAdicionales | text | YES |  | NULL |  |
| comentarios | text | YES |  | NULL |  |
| estado | tinyint(1) | NO |  | 0 |  |
| fechaReserva | timestamp | NO | MUL | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| dispositivo | tinyint(1) | NO |  | 0 |  |
| pin | int | NO |  | NULL |  |
| ip | varchar(32) | NO | MUL | NULL |  |
| ipv6 | varchar(50) | YES |  | NULL |  |
| id_recibo | varchar(32) | NO | MUL | NULL |  |
| num_transaccion | varchar(20) | NO | MUL | NULL |  |
| num_factura | int | NO |  | NULL |  |
| recordatorio | timestamp | YES |  | NULL |  |
| origen | tinyint | NO |  | NULL |  |
| fechaPago | date | YES |  | NULL |  |
| fechaPagoAfiliado | date | YES |  | NULL |  |
| fechaPagoAgencia | date | YES |  | NULL |  |
| info | text | NO |  | NULL |  |
| fp | varchar(16) | YES |  | NULL |  |
| booking_attempts | tinyint | YES |  | 0 |  |
| importePago | decimal(38,2) | YES |  | NULL |  |
| userAgent | text | YES |  | NULL |  |
| isRefundableByModify | varchar(16) | NO |  | si |  |
| titularHotel | varchar(32) | YES |  | NULL |  |
| recordatorioComentarios | timestamp | YES |  | NULL |  |
| id_afiliado | int | YES | MUL | NULL |  |
| url_referencia | text | YES |  | NULL |  |
| comision_afiliado | float | YES |  | NULL |  |
| campana_afiliado | varchar(255) | YES |  | NULL |  |
| xrt_payment_currency | float | YES |  | NULL |  |
| xrt_eur | float | YES |  | NULL |  |
| agent | varchar(16) | YES | MUL | web |  |
| language | varchar(2) | YES |  | es |  |
| direccionHotel | varchar(256) | YES |  | NULL |  |
| fechaRevision | timestamp | YES |  | NULL |  |
| motivo_cancelacion | int | YES |  | NULL |  |
| tipo_comision_afiliado | tinyint | YES |  | 1 |  |
| facturaPago | varchar(50) | YES |  | NULL |  |
| enviar_recordatorio | tinyint | NO |  | 1 |  |
| info_voucher | text | YES |  | NULL |  |
| cancel_policy | text | YES |  | NULL |  |
| meeting_point | text | YES |  | NULL |  |
| duracion_libre | varchar(50) | YES |  | NULL |  |
| duracion_minima | varchar(50) | YES |  | NULL |  |
| duracion_maxima | varchar(50) | YES |  | NULL |  |
| affiliated_intern_campaign | varchar(85) | YES |  | NULL |  |
| cancel_policy_old | text | YES |  | NULL |  |
| base_commission | tinyint | YES |  | NULL |  |
| initial_affiliate_commission_amount | float | NO |  | NULL |  |
| affiliate_commission_amount | decimal(38,2) | YES |  | NULL |  |
| initial_agency_commission_amount | decimal(38,2) | NO |  | NULL |  |
| agency_commission_amount | decimal(38,2) | YES |  | NULL |  |
| channel_id | int | YES |  | NULL |  |
| week_reminder | tinyint | YES |  | 0 |  |
| idioma_info_actividad | int | YES | MUL | NULL |  |
| precioInicialEuros | decimal(38,2) | YES |  | NULL |  |
| gananciaInicialEuros | decimal(38,2) | YES |  | NULL |  |
| fechaAnticipo | date | YES |  | NULL |  |
| typology | int | YES |  | NULL |  |
| revisionFacturacion | date | YES |  | NULL |  |
| hora_recogida | varchar(32) | YES |  | NULL |  |
| fechaRevisionAfiliado | timestamp | YES |  | NULL |  |
| lang_site | varchar(3) | YES |  | NULL |  |
| recalculated_noshow | int | YES |  | NULL |  |
| guide_options | bigint | YES |  | 0 |  |
| affiliate_timestamp_cookie | timestamp | YES |  | NULL |  |
| commissionable_affiliates | int | NO |  | 1 |  |
| total_paxes_commissionable | int | YES |  | 0 |  |
| amount_supplement | float | NO |  | 0 |  |
| commission_supplement | float | NO |  | 0 |  |
| fechaCobroAgencia | date | YES |  | NULL |  |
| facturaCobroAgencia | date | YES |  | NULL |  |
| facturaCobroAgenciaV2 | varchar(256) | YES |  | NULL |  |
| fecha_cobrado_agencia_credito | date | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| actividades_reserv_idx_id_afiliado_fechareserva | BTREE | id_afiliado, fechaReserva | No |
| actividades_reservas_agent_IDX | BTREE | agent | No |
| fk_actividades_reservas_pais_id | BTREE | pais_procedencia | No |
| ft_idx_nombre_apellidos | FULLTEXT | nombre, apellidos | No |
| idx_actividades_reservars_id_proveedor_divisa_estado | BTREE | idProveedor, divisa, estado | No |
| idx_actividades_reservas_actividad | BTREE | idActividad | No |
| idx_actividades_reservas_email | BTREE | email | No |
| idx_actividades_reservas_fecha_estado | BTREE | fecha, estado | No |
| idx_actividades_reservas_id_actividad_channel_id | BTREE | idActividad, channel_id | No |
| idx_actividades_reservas_ip_id | BTREE | ip, id | No |
| idx_actividades_reservas_telefono | BTREE | telefono | No |
| idx_afiliados_stats_actividades | BTREE | id_afiliado, estado, fechaReserva | No |
| idx_booking_bookingData_status | BTREE | fechaReserva, estado | No |
| idx_id_recibo | BTREE | id_recibo | No |
| idx_idioma_info_actividad_guide_options | BTREE | idioma_info_actividad, guide_options | No |
| idx_idproveedor_estado_fecha | BTREE | idProveedor, estado, fecha | No |
| idx_idproveedor_estado_fecha_precios | BTREE | idProveedor, estado, fecha, precioTotal, ganancia | No |
| idx_num_transaccion | BTREE | num_transaccion | No |

#### DDL

```sql
CREATE TABLE `actividades_reservas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idActividad` int NOT NULL,
  `idProveedor` int NOT NULL,
  `idCiudad` int DEFAULT NULL,
  `tipo` tinyint(1) NOT NULL,
  `articulo` varchar(256) NOT NULL,
  `modalidad` varchar(64) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(32) NOT NULL,
  `numPersonas` smallint DEFAULT NULL,
  `textoPersonas` varchar(1024) DEFAULT NULL,
  `codigoProveedor` varchar(128) NOT NULL,
  `precioTotal` decimal(38,2) DEFAULT NULL,
  `precioTotalEuros` decimal(38,2) DEFAULT NULL,
  `precioReserva` decimal(38,2) DEFAULT NULL,
  `precioReservaEuros` decimal(38,2) DEFAULT NULL,
  `ganancia` decimal(38,2) DEFAULT NULL,
  `gananciaEuros` decimal(38,2) DEFAULT NULL,
  `comision` decimal(38,2) DEFAULT NULL,
  `divisa` varchar(3) NOT NULL,
  `divisaPago` varchar(3) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `email` varchar(256) NOT NULL,
  `pais` char(4) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'Almacena el prefijo del pais correspondiente con paises.prefijo',
  `telefono` varchar(32) DEFAULT NULL,
  `pais_procedencia` int DEFAULT NULL COMMENT 'Almacena el id del pais correspondiente con paises.id',
  `alojamiento` varchar(256) NOT NULL COMMENT 'HR (Rec), HE (Ent), HI (Inf), HS (Sol), BR (Rec), BI (Inf), PE (Inf)',
  `preguntasAdicionales` text,
  `comentarios` text,
  `estado` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 Sin pagar 1 Pagado 2 Confirmado 3 Opinion solicitada 4 Opinado 5 No show 6 Cancelado 7 Reintegrado',
  `fechaReserva` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dispositivo` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 Desktop 1 Tablet 2 Movil',
  `pin` int NOT NULL,
  `ip` varchar(32) NOT NULL,
  `ipv6` varchar(50) DEFAULT NULL COMMENT 'Ip buena. El campo IP de esta tabla se queda corto para IPV6',
  `id_recibo` varchar(32) NOT NULL,
  `num_transaccion` varchar(20) NOT NULL,
  `num_factura` int NOT NULL,
  `recordatorio` timestamp NULL DEFAULT NULL,
  `origen` tinyint NOT NULL,
  `fechaPago` date DEFAULT NULL COMMENT 'Fecha de pago al proveedor',
  `fechaPagoAfiliado` date DEFAULT NULL,
  `fechaPagoAgencia` date DEFAULT NULL,
  `info` text NOT NULL,
  `fp` varchar(16) DEFAULT NULL,
  `booking_attempts` tinyint DEFAULT '0',
  `importePago` decimal(38,2) DEFAULT NULL,
  `userAgent` text,
  `isRefundableByModify` varchar(16) NOT NULL DEFAULT 'si',
  `titularHotel` varchar(32) DEFAULT NULL,
  `recordatorioComentarios` timestamp NULL DEFAULT NULL,
  `id_afiliado` int DEFAULT NULL,
  `url_referencia` text,
  `comision_afiliado` float DEFAULT NULL,
  `campana_afiliado` varchar(255) DEFAULT NULL,
  `xrt_payment_currency` float DEFAULT NULL COMMENT 'Stores the effective exchange rate from contract currency to selected payment currency',
  `xrt_eur` float DEFAULT NULL COMMENT 'Stores the effective exchange rate from contract currency to euro',
  `agent` varchar(16) DEFAULT 'web',
  `language` varchar(2) DEFAULT 'es',
  `direccionHotel` varchar(256) DEFAULT NULL,
  `fechaRevision` timestamp NULL DEFAULT NULL,
  `motivo_cancelacion` int DEFAULT NULL,
  `tipo_comision_afiliado` tinyint DEFAULT '1' COMMENT '1-Percent, 0-Porpax',
  `facturaPago` varchar(50) DEFAULT NULL,
  `enviar_recordatorio` tinyint NOT NULL DEFAULT '1',
  `info_voucher` text,
  `cancel_policy` text,
  `meeting_point` text,
  `duracion_libre` varchar(50) DEFAULT NULL COMMENT 'Duración libre',
  `duracion_minima` varchar(50) DEFAULT NULL COMMENT 'Duración mínima en segundos',
  `duracion_maxima` varchar(50) DEFAULT NULL COMMENT 'Duración máxima en segundos',
  `affiliated_intern_campaign` varchar(85) DEFAULT NULL,
  `cancel_policy_old` text,
  `base_commission` tinyint DEFAULT NULL,
  `initial_affiliate_commission_amount` float NOT NULL,
  `affiliate_commission_amount` decimal(38,2) DEFAULT NULL,
  `initial_agency_commission_amount` decimal(38,2) NOT NULL,
  `agency_commission_amount` decimal(38,2) DEFAULT NULL,
  `channel_id` int DEFAULT NULL,
  `week_reminder` tinyint DEFAULT '0',
  `idioma_info_actividad` int DEFAULT NULL,
  `precioInicialEuros` decimal(38,2) DEFAULT NULL,
  `gananciaInicialEuros` decimal(38,2) DEFAULT NULL,
  `fechaAnticipo` date DEFAULT NULL,
  `typology` int DEFAULT NULL,
  `revisionFacturacion` date DEFAULT NULL,
  `hora_recogida` varchar(32) DEFAULT NULL,
  `fechaRevisionAfiliado` timestamp NULL DEFAULT NULL,
  `lang_site` varchar(3) DEFAULT NULL,
  `recalculated_noshow` int DEFAULT NULL COMMENT '(0: No fue, 1:Si fue, 2:Ha opinado, 3: Confirma no show parcial, 4: No confirma no show parcial, 5: Free tour confirmado automaticamente)',
  `guide_options` bigint DEFAULT '0',
  `affiliate_timestamp_cookie` timestamp NULL DEFAULT NULL,
  `commissionable_affiliates` int NOT NULL DEFAULT '1' COMMENT '0 No es comisionable 1 Si es comisionable',
  `total_paxes_commissionable` int DEFAULT '0',
  `amount_supplement` float NOT NULL DEFAULT '0',
  `commission_supplement` float NOT NULL DEFAULT '0',
  `fechaCobroAgencia` date DEFAULT NULL,
  `facturaCobroAgencia` date DEFAULT NULL,
  `facturaCobroAgenciaV2` varchar(256) DEFAULT NULL,
  `fecha_cobrado_agencia_credito` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_actividades_reservas_fecha_estado` (`fecha`,`estado`),
  KEY `idx_afiliados_stats_actividades` (`id_afiliado`,`estado`,`fechaReserva`),
  KEY `idx_actividades_reservas_actividad` (`idActividad`),
  KEY `idx_actividades_reservas_email` (`email`(255)),
  KEY `idx_booking_bookingData_status` (`fechaReserva`,`estado`),
  KEY `idx_idproveedor_estado_fecha` (`idProveedor`,`estado`,`fecha`),
  KEY `fk_actividades_reservas_pais_id` (`pais_procedencia`),
  KEY `idx_idioma_info_actividad_guide_options` (`idioma_info_actividad`,`guide_options`),
  KEY `idx_actividades_reservas_telefono` (`telefono`),
  KEY `actividades_reservas_agent_IDX` (`agent`) USING BTREE,
  KEY `idx_idproveedor_estado_fecha_precios` (`idProveedor`,`estado`,`fecha`,`precioTotal`,`ganancia`),
  KEY `actividades_reserv_idx_id_afiliado_fechareserva` (`id_afiliado`,`fechaReserva`),
  KEY `idx_actividades_reservas_id_actividad_channel_id` (`idActividad`,`channel_id`),
  KEY `idx_actividades_reservars_id_proveedor_divisa_estado` (`idProveedor`,`divisa`,`estado`),
  KEY `idx_actividades_reservas_ip_id` (`ip`,`id`),
  KEY `idx_id_recibo` (`id_recibo`),
  KEY `idx_num_transaccion` (`num_transaccion`),
  FULLTEXT KEY `ft_idx_nombre_apellidos` (`nombre`,`apellidos`)
) ENGINE=InnoDB AUTO_INCREMENT=36387506 DEFAULT CHARSET=utf8mb3
```

### `actividades_reservas_bkp_personas`

**Usado por:**
- `new-admin`: (`app/Models/ActivityBookingBkpPeople.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| pnr | int | NO | MUL | NULL |  |
| type | int | NO |  | NULL |  |
| numPersonas | int | NO |  | NULL |  |
| textoPersonas | varchar(1024) | NO |  | NULL |  |
| ganancia | float | NO |  | NULL |  |
| gananciaEuros | float | NO |  | NULL |  |
| total_paxes_commissionable | int | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| deleted_at | datetime | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_actividades_reservas_bkp_pnr_type | BTREE | pnr, type | No |

#### DDL

```sql
CREATE TABLE `actividades_reservas_bkp_personas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pnr` int NOT NULL,
  `type` int NOT NULL COMMENT '1.- actividad 2.- traslado',
  `numPersonas` int NOT NULL,
  `textoPersonas` varchar(1024) NOT NULL,
  `ganancia` float NOT NULL,
  `gananciaEuros` float NOT NULL,
  `total_paxes_commissionable` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_actividades_reservas_bkp_pnr_type` (`pnr`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb3 COMMENT='tabla para poder tener los datos de historico para noshows parciales'
```

### `actividades_reservas_versiones`

**Usado por:**
- `new-admin`: (`app/Models/ActivityBookingVersion.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id_version | int | NO | PRI | NULL | auto_increment |
| id | int | NO | MUL | NULL |  |
| idActividad | int | NO |  | NULL |  |
| idProveedor | smallint | NO |  | NULL |  |
| tipo | tinyint | NO |  | NULL |  |
| articulo | varchar(256) | NO |  | NULL |  |
| modalidad | varchar(32) | NO |  | NULL |  |
| fecha | date | YES |  | NULL |  |
| hora | varchar(32) | NO |  | NULL |  |
| numPersonas | smallint | NO |  | NULL |  |
| textoPersonas | varchar(128) | NO |  | NULL |  |
| codigoProveedor | varchar(64) | NO |  | NULL |  |
| precioTotal | float | NO |  | NULL |  |
| precioTotalEuros | float | NO |  | NULL |  |
| precioReserva | float | NO |  | NULL |  |
| precioReservaEuros | float | NO |  | NULL |  |
| ganancia | float | NO |  | NULL |  |
| gananciaEuros | float | NO |  | NULL |  |
| comision | float | NO |  | NULL |  |
| divisa | varchar(3) | NO |  | NULL |  |
| divisaPago | varchar(3) | NO |  | NULL |  |
| nombre | varchar(64) | NO |  | NULL |  |
| apellidos | varchar(64) | NO |  | NULL |  |
| email | varchar(256) | NO |  | NULL |  |
| pais | char(4) | NO |  | NULL |  |
| telefono | varchar(32) | YES |  | NULL |  |
| alojamiento | varchar(256) | NO |  | NULL |  |
| preguntasAdicionales | varchar(256) | NO |  | NULL |  |
| comentarios | text | YES |  | NULL |  |
| estado | tinyint | NO |  | 0 |  |
| updated_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| fechaReserva | timestamp | NO |  | 0000-00-00 00:00:00 |  |
| dispositivo | tinyint | NO |  | NULL |  |
| pin | int | NO |  | NULL |  |
| ip | varchar(32) | NO |  | NULL |  |
| id_recibo | varchar(32) | NO |  | NULL |  |
| num_transaccion | varchar(20) | NO |  | NULL |  |
| num_factura | int | NO |  | NULL |  |
| recordatorio | timestamp | YES |  | NULL |  |
| origen | tinyint | NO |  | NULL |  |
| fechaPago | date | YES |  | NULL |  |
| info | text | NO |  | NULL |  |
| fp | varchar(16) | YES |  | NULL |  |
| booking_attempts | tinyint | YES |  | 0 |  |
| importePago | float | YES |  | NULL |  |
| userAgent | text | YES |  | NULL |  |
| titularHotel | varchar(32) | YES |  | NULL |  |
| version | int | NO |  | NULL |  |
| validado | varchar(16) | NO |  | no |  |
| direccionHotel | varchar(256) | YES |  | NULL |  |
| language | varchar(2) | YES |  | es |  |
| typology | int | YES |  | NULL |  |
| hora_recogida | varchar(32) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id_version | Sí |
| idx_actividades_reservas_versiones_id_validado_fecha | BTREE | id, validado, fecha | No |

#### DDL

```sql
CREATE TABLE `actividades_reservas_versiones` (
  `id_version` int NOT NULL AUTO_INCREMENT,
  `id` int NOT NULL,
  `idActividad` int NOT NULL,
  `idProveedor` smallint NOT NULL,
  `tipo` tinyint NOT NULL,
  `articulo` varchar(256) NOT NULL,
  `modalidad` varchar(32) NOT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(32) NOT NULL,
  `numPersonas` smallint NOT NULL,
  `textoPersonas` varchar(128) NOT NULL,
  `codigoProveedor` varchar(64) NOT NULL,
  `precioTotal` float NOT NULL,
  `precioTotalEuros` float NOT NULL,
  `precioReserva` float NOT NULL,
  `precioReservaEuros` float NOT NULL,
  `ganancia` float NOT NULL,
  `gananciaEuros` float NOT NULL,
  `comision` float NOT NULL,
  `divisa` varchar(3) NOT NULL,
  `divisaPago` varchar(3) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `email` varchar(256) NOT NULL,
  `pais` char(4) NOT NULL,
  `telefono` varchar(32) DEFAULT NULL,
  `alojamiento` varchar(256) NOT NULL,
  `preguntasAdicionales` varchar(256) NOT NULL,
  `comentarios` text,
  `estado` tinyint NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechaReserva` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `dispositivo` tinyint NOT NULL,
  `pin` int NOT NULL,
  `ip` varchar(32) NOT NULL,
  `id_recibo` varchar(32) NOT NULL,
  `num_transaccion` varchar(20) NOT NULL,
  `num_factura` int NOT NULL,
  `recordatorio` timestamp NULL DEFAULT NULL,
  `origen` tinyint NOT NULL,
  `fechaPago` date DEFAULT NULL,
  `info` text NOT NULL,
  `fp` varchar(16) DEFAULT NULL,
  `booking_attempts` tinyint DEFAULT '0',
  `importePago` float DEFAULT NULL,
  `userAgent` text,
  `titularHotel` varchar(32) DEFAULT NULL,
  `version` int NOT NULL,
  `validado` varchar(16) NOT NULL DEFAULT 'no',
  `direccionHotel` varchar(256) DEFAULT NULL,
  `language` varchar(2) DEFAULT 'es',
  `typology` int DEFAULT NULL COMMENT '0 Regular 1 Free tour',
  `hora_recogida` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id_version`),
  KEY `idx_actividades_reservas_versiones_id_validado_fecha` (`id`,`validado`,`fecha`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3
```

### `actividades_sub_categorias`

**Usado por:**
- `new-admin`: (`app/Models/ActivitySubCategory.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| category_id | int | NO |  | NULL |  |
| name | varchar(256) | NO |  | NULL |  |
| public_label | varchar(256) | YES |  | NULL |  |
| enabled | tinyint | NO |  | 1 |  |
| sort | int | NO |  | NULL |  |
| icon | varchar(256) | YES |  | NULL |  |
| id_wp_tag | int | YES |  | NULL |  |
| canonical_rule | int | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `actividades_sub_categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `name` varchar(256) NOT NULL,
  `public_label` varchar(256) DEFAULT NULL COMMENT 'Label usada para la descripción en web',
  `enabled` tinyint NOT NULL DEFAULT '1',
  `sort` int NOT NULL,
  `icon` varchar(256) DEFAULT NULL COMMENT 'Si esta vacio, pilla del padre',
  `id_wp_tag` int DEFAULT NULL COMMENT 'Id del tag de magazine',
  `canonical_rule` int NOT NULL DEFAULT '1' COMMENT 'Regla de canonicidad para esta subcategoría',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=latin1 COMMENT='Regla de canonicidad para esta subcategoría'
```

### `actividades_tipos_descripciones`

**Usado por:**
- `new-admin`: (`app/Models/TypeActivityDescription.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| url | varchar(64) | NO |  | NULL |  |
| nombre | varchar(64) | NO |  | NULL |  |
| orden | int | NO |  | NULL |  |
| idDestino | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `actividades_tipos_descripciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `url` varchar(64) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `orden` int NOT NULL,
  `idDestino` int DEFAULT '0' COMMENT '0 - Todos los destinos',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb3
```

### `actividades_tipos_descripciones_translations`

**Usado por:**
- `new-admin`: (`app/Models/ActivityTypeDescriptionTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterActivityTipo | int | NO |  | NULL |  |
| nombre | varchar(128) | YES |  | NULL |  |
| url | varchar(56) | YES |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `actividades_tipos_descripciones_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterActivityTipo` int NOT NULL,
  `nombre` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `url` varchar(56) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `lang` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=828 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `activities_canonical`

**Usado por:**
- `new-admin`: (`app/Models/ActivitiesCanonical.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | NO | UNI | NULL |  |
| canonical_type | varchar(20) | YES |  | activity |  |
| canonical_id | varchar(256) | YES |  | NULL |  |
| active | tinyint(1) | NO |  | 1 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | YES |  | NULL |  |
| update_manually | tinyint(1) | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| uk_activities_canonical_activity_id | BTREE | activity_id | Sí |

#### DDL

```sql
CREATE TABLE `activities_canonical` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int NOT NULL COMMENT 'id de la actividad, sencillito tío',
  `canonical_type` varchar(20) COLLATE utf8mb3_unicode_ci DEFAULT 'activity' COMMENT '''activity'', ''poi'', ''category'', ''subcategory'' o null',
  `canonical_id` varchar(256) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0 o 1 tío es sencillo no me cabrees',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  `update_manually` tinyint(1) DEFAULT '0' COMMENT 'Si está a 1 significa que el cron no lo updatea automáticamente',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_activities_canonical_activity_id` (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Si está a 1 significa que el cron no lo updatea automáticamente'
```

### `activities_schedules_backup`

**Usado por:**
- `new-admin`: (`app/Models/ActivityScheduleBackup.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idActividad | int | NO | MUL | NULL |  |
| tipo | tinyint | NO |  | NULL |  |
| fechaInicio | date | NO |  | 2019-01-01 |  |
| fechaFin | date | NO |  | 2029-12-31 |  |
| dias | varchar(16) | NO |  | NULL |  |
| horas | varchar(512) | NO |  | NULL |  |
| precios | text | YES |  | NULL |  |
| suplementos | varchar(128) | NO |  | NULL |  |
| plazas | tinyint | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_activity | BTREE | idActividad | No |

#### DDL

```sql
CREATE TABLE `activities_schedules_backup` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idActividad` int NOT NULL,
  `tipo` tinyint NOT NULL,
  `fechaInicio` date NOT NULL DEFAULT '2019-01-01',
  `fechaFin` date NOT NULL DEFAULT '2029-12-31',
  `dias` varchar(16) NOT NULL,
  `horas` varchar(512) NOT NULL,
  `precios` text,
  `suplementos` varchar(128) NOT NULL,
  `plazas` tinyint NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_activity` (`idActividad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `activities_services_translations`

**Usado por:**
- `new-admin`: (`app/Models/ActivityServicesTranslations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | NO |  | NULL |  |
| translation | varchar(512) | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| url | varchar(64) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `activities_services_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int NOT NULL,
  `translation` varchar(512) NOT NULL,
  `lang` varchar(2) NOT NULL,
  `url` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3
```

### `activity_antifraud`

**Usado por:**
- `new-admin`: (`app/Models/ActivityAntifraud.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| active | varchar(1) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `activity_antifraud` (
  `id` int NOT NULL AUTO_INCREMENT,
  `active` varchar(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=198039 DEFAULT CHARSET=utf8mb3
```

### `activity_booking_antifraud`

**Usado por:**
- `new-admin`: (`app/Models/ActivityBookingAntifraud.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| booking_id | int | NO |  | NULL |  |
| check_timestamp | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| fraud_status | tinyint | NO | MUL | 0 |  |
| score | int | NO | MUL | 0 |  |
| score_threshold | int | NO |  | 0 |  |
| score_pass | tinyint | NO |  | 0 |  |
| checks_json | text | NO |  | NULL |  |
| updated_by | int | YES |  | NULL |  |
| updated_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_activity_booking_antifraud_fraud_status | BTREE | fraud_status | No |
| idx_activity_booking_antifraud_score | BTREE | score | No |

#### DDL

```sql
CREATE TABLE `activity_booking_antifraud` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `check_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fraud_status` tinyint NOT NULL DEFAULT '0' COMMENT '0.- No sospechoso. 1.- Sospechoso 2.- Marcada no fraudulenta 3.- Marcada fraudulenta',
  `score` int NOT NULL DEFAULT '0',
  `score_threshold` int NOT NULL DEFAULT '0' COMMENT 'Threshold actual',
  `score_pass` tinyint NOT NULL DEFAULT '0',
  `checks_json` text NOT NULL,
  `updated_by` int DEFAULT NULL COMMENT 'Id admin_user',
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_activity_booking_antifraud_fraud_status` (`fraud_status`),
  KEY `idx_activity_booking_antifraud_score` (`score`)
) ENGINE=InnoDB AUTO_INCREMENT=7676502 DEFAULT CHARSET=utf8mb3
```

### `activity_booking_reference`

**Usado por:**
- `new-admin`: (`app/Models/ActivityBookingReference.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| pnr | int | NO | MUL | NULL |  |
| reference | varchar(512) | YES |  | NULL |  |
| reference_type | varchar(32) | NO |  | NULL |  |
| pk | int | NO | PRI | NULL | auto_increment |
| integrations_version | varchar(12) | NO |  | v1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | pk | Sí |
| pnr_index | BTREE | pnr | No |

#### DDL

```sql
CREATE TABLE `activity_booking_reference` (
  `pnr` int NOT NULL,
  `reference` varchar(512) DEFAULT NULL,
  `reference_type` varchar(32) NOT NULL,
  `pk` int NOT NULL AUTO_INCREMENT,
  `integrations_version` varchar(12) NOT NULL DEFAULT 'v1',
  PRIMARY KEY (`pk`),
  KEY `pnr_index` (`pnr`),
  CONSTRAINT `activity_booking_reference_pnr_fk` FOREIGN KEY (`pnr`) REFERENCES `actividades_reservas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78273112 DEFAULT CHARSET=utf8mb3
```

### `activity_booking_reference_manual`

**Usado por:**
- `new-admin`: (`app/Models/ActivityBookingReferenceManual.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| pnr | int | NO | MUL | NULL |  |
| reference | varchar(128) | NO |  | NULL |  |
| reference_type | varchar(32) | NO |  | NULL |  |
| pk | int | NO | PRI | NULL | auto_increment |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | pk | Sí |
| pnr_index | BTREE | pnr | No |

#### DDL

```sql
CREATE TABLE `activity_booking_reference_manual` (
  `pnr` int NOT NULL,
  `reference` varchar(128) NOT NULL,
  `reference_type` varchar(32) NOT NULL,
  `pk` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`pk`),
  KEY `pnr_index` (`pnr`),
  CONSTRAINT `activity_booking_reference_manual_pnr_fk` FOREIGN KEY (`pnr`) REFERENCES `actividades_reservas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61793 DEFAULT CHARSET=utf8mb3 COMMENT='References to bookings without integration'
```

### `activity_cancel_policy`

**Usado por:**
- `new-admin`: (`app/Models/ActivityCancelPolicy.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| activity_id | int | NO | PRI | NULL |  |
| advance_hours | int | NO | PRI | NULL |  |
| penalty | float | NO |  | NULL |  |
| amount_percent | varchar(8) | NO |  | NULL |  |
| time | time | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | activity_id, advance_hours | Sí |

#### DDL

```sql
CREATE TABLE `activity_cancel_policy` (
  `activity_id` int NOT NULL,
  `advance_hours` int NOT NULL,
  `penalty` float NOT NULL,
  `amount_percent` varchar(8) NOT NULL COMMENT 'amount: the penalty is a fixed amount (same currency as the price activity), percent: the penalty is a percentage of the deposit',
  `time` time DEFAULT NULL,
  PRIMARY KEY (`activity_id`,`advance_hours`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Holds the cancellation policy items for every activity'
```

### `activity_change`

**Usado por:**
- `new-admin`: (`app/Models/ActivityChange.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | NO | MUL | NULL |  |
| type | int | YES |  | NULL |  |
| creator_id | int | NO | MUL | NULL |  |
| assigned_id | int | YES | MUL | NULL |  |
| title | varchar(255) | NO |  | NULL |  |
| description | text | NO |  | NULL |  |
| priority | varchar(20) | YES |  | NULL |  |
| status | tinyint | NO | MUL | 0 |  |
| reason_closing | varchar(255) | YES |  |  |  |
| master | tinyint | NO |  | 0 |  |
| activity_change_id | int | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | YES |  | NULL |  |
| closed_at | timestamp | YES |  | NULL |  |
| deleted_at | timestamp | YES |  | NULL |  |
| schedule_timestamp | timestamp | YES |  | NULL |  |
| associate_jira | varchar(100) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| activity_assigned_idx | BTREE | assigned_id | No |
| activity_change_status_idx | BTREE | status | No |
| activity_creator_idx | BTREE | creator_id | No |
| activity_id_idx | BTREE | activity_id | No |

#### DDL

```sql
CREATE TABLE `activity_change` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int NOT NULL,
  `type` int DEFAULT NULL,
  `creator_id` int NOT NULL,
  `assigned_id` int DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `priority` varchar(20) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0=abierto,1=cerrrado,2=borrado',
  `reason_closing` varchar(255) DEFAULT '',
  `master` tinyint NOT NULL DEFAULT '0' COMMENT '1=cambio actividad master, 0=actividad relacionada',
  `activity_change_id` int DEFAULT NULL COMMENT 'id desde el cual se copiaron los datos',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  `closed_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `schedule_timestamp` timestamp NULL DEFAULT NULL,
  `associate_jira` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_id_idx` (`activity_id`),
  KEY `activity_creator_idx` (`creator_id`),
  KEY `activity_assigned_idx` (`assigned_id`),
  KEY `activity_change_status_idx` (`status`),
  CONSTRAINT `activity_assigned_idx` FOREIGN KEY (`assigned_id`) REFERENCES `admin_user` (`id`),
  CONSTRAINT `activity_creator_idx` FOREIGN KEY (`creator_id`) REFERENCES `admin_user` (`id`),
  CONSTRAINT `activity_id_idx` FOREIGN KEY (`activity_id`) REFERENCES `actividades` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3
```

### `activity_change_date_offer`

**Usado por:**
- `new-admin`: (`app/Models/ActivityChangeDateOffer.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idReserva | int | YES |  | NULL |  |
| booking_type | varchar(1) | YES |  | a |  |
| date | varchar(10) | YES |  | NULL |  |
| time | varchar(7) | YES |  | NULL |  |
| status | varchar(1) | YES |  | 0 |  |
| admin_user | varchar(15) | YES |  | NULL |  |
| date_offered | datetime | NO |  | NULL |  |
| date_accepted | datetime | NO |  | NULL |  |
| date_limit | datetime | NO |  | NULL |  |
| id_md_five | varchar(128) | NO |  | NULL |  |
| id_reason | int | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `activity_change_date_offer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idReserva` int DEFAULT NULL,
  `booking_type` varchar(1) DEFAULT 'a',
  `date` varchar(10) DEFAULT NULL,
  `time` varchar(7) DEFAULT NULL,
  `status` varchar(1) DEFAULT '0' COMMENT '0- en proceso,1- recordatorio enviado, 2-aceptado, 3- cancelado',
  `admin_user` varchar(15) DEFAULT NULL,
  `date_offered` datetime NOT NULL,
  `date_accepted` datetime NOT NULL,
  `date_limit` datetime NOT NULL,
  `id_md_five` varchar(128) NOT NULL,
  `id_reason` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb3
```

### `activity_change_pending_edit_bookings`

**Usado por:**
- `new-admin`: (`app/Models/ActivityChangePendingEditBookings.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| typeChanges | int | NO |  | NULL |  |
| created_at | datetime | NO |  | NULL |  |
| activity_id | int | NO |  | NULL |  |
| idBookings | text | NO |  | NULL |  |
| creator_id | int | NO |  | NULL |  |
| assigned_id | int | YES |  | NULL |  |
| status | tinyint | NO |  | NULL |  |
| title | text | YES |  | NULL |  |
| description | text | YES |  | NULL |  |
| reason | text | YES |  | NULL |  |
| id_change | int | NO |  | NULL |  |
| priority | int | YES |  | NULL |  |
| date_bookings | text | YES |  | NULL |  |
| external_provider | tinyint | YES |  | NULL |  |
| external_provider_name | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `activity_change_pending_edit_bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `typeChanges` int NOT NULL,
  `created_at` datetime NOT NULL,
  `activity_id` int NOT NULL,
  `idBookings` text NOT NULL,
  `creator_id` int NOT NULL,
  `assigned_id` int DEFAULT NULL,
  `status` tinyint NOT NULL COMMENT '0 abierto, 1 cerrado, 2 eliminado',
  `title` text,
  `description` text,
  `reason` text,
  `id_change` int NOT NULL,
  `priority` int DEFAULT NULL,
  `date_bookings` text,
  `external_provider` tinyint DEFAULT NULL COMMENT '0 no, 1 si',
  `external_provider_name` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `activity_change_provider_reasons`

**Usado por:**
- `new-admin`: (`app/Models/ActivityChangeProviderReason.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_change_id | int | NO | MUL | NULL |  |
| reason_id | int | YES |  | NULL |  |
| type | tinyint | NO |  | 1 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| activity_change_id | BTREE | activity_change_id | No |

#### DDL

```sql
CREATE TABLE `activity_change_provider_reasons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_change_id` int NOT NULL,
  `reason_id` int DEFAULT NULL,
  `type` tinyint NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `activity_change_id` (`activity_change_id`),
  CONSTRAINT `activity_change_provider_reasons_ibfk_1` FOREIGN KEY (`activity_change_id`) REFERENCES `activity_change` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3
```

### `activity_change_reasons`

**Usado por:**
- `new-admin`: (`app/Models/ActivityChangeReason.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| nombre | varchar(45) | NO |  | NULL |  |
| status | tinyint | NO |  | NULL |  |
| label | varchar(45) | NO |  | NULL |  |
| orden | int | YES |  | NULL |  |
| label_provider | varchar(128) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `activity_change_reasons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `status` tinyint NOT NULL,
  `label` varchar(45) NOT NULL,
  `orden` int DEFAULT NULL,
  `label_provider` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3
```

### `activity_connection_info`

**Usado por:**
- `new-admin`: (`app/Models/ActivityConnectionInfo.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| activity | int | NO | PRI | NULL |  |
| conn | varchar(32) | NO | PRI | NULL |  |
| generation | int | NO | PRI | NULL |  |
| active | tinyint | YES |  | 0 |  |
| dynamic_price | tinyint | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | activity, conn, generation | Sí |

#### DDL

```sql
CREATE TABLE `activity_connection_info` (
  `activity` int NOT NULL,
  `conn` varchar(32) NOT NULL,
  `generation` int NOT NULL,
  `active` tinyint DEFAULT '0',
  `dynamic_price` tinyint NOT NULL DEFAULT '0' COMMENT '0- NO 1-SI',
  PRIMARY KEY (`activity`,`conn`,`generation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `activity_currency_inheritance_exceptions`

**Usado por:**
- `new-admin`: (`app/Models/ActivityCurrencyInheritanceExceptions.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| source_id | int | NO | PRI | NULL |  |
| type | int | NO | PRI | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | source_id, type | Sí |

#### DDL

```sql
CREATE TABLE `activity_currency_inheritance_exceptions` (
  `source_id` int NOT NULL,
  `type` int NOT NULL DEFAULT '1' COMMENT '1 = activity, 2 = provider',
  PRIMARY KEY (`source_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='1 = activity, 2 = provider'
```

### `activity_description_summary`

**Usado por:**
- `new-admin`: (`app/Models/ActivityDescriptionSummary.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| activity_id | int | NO | PRI | NULL |  |
| description | text | YES |  | NULL |  |
| last_update | datetime | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| description_ai_app | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | activity_id | Sí |

#### DDL

```sql
CREATE TABLE `activity_description_summary` (
  `activity_id` int NOT NULL,
  `description` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `description_ai_app` text,
  PRIMARY KEY (`activity_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1
```

### `activity_destination`

**Usado por:**
- `new-admin`: (`app/Models/ActivityDestination.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | NO | MUL | NULL |  |
| destination_id | int | NO | MUL | NULL |  |
| main_destination | tinyint | NO | MUL | 0 |  |
| enabled | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| activity_destination_main | BTREE | main_destination | No |
| activity_id | BTREE | activity_id, destination_id | Sí |
| idx_ac_activity_main_destination | BTREE | activity_id, main_destination | No |
| idx_activity_destination_activity | BTREE | activity_id, main_destination | No |
| idx_activity_destination_destination_id | BTREE | destination_id | No |

#### DDL

```sql
CREATE TABLE `activity_destination` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int NOT NULL,
  `destination_id` int NOT NULL,
  `main_destination` tinyint NOT NULL DEFAULT '0' COMMENT '1- Ciudad Principal, 0- No Principal',
  `enabled` tinyint NOT NULL DEFAULT '1' COMMENT '1- La relación entre actividad y destino esta activa, 0- Relación desactivada',
  PRIMARY KEY (`id`),
  UNIQUE KEY `activity_id` (`activity_id`,`destination_id`),
  KEY `idx_activity_destination_destination_id` (`destination_id`),
  KEY `activity_destination_main` (`main_destination`),
  KEY `idx_activity_destination_activity` (`activity_id`,`main_destination`),
  KEY `idx_ac_activity_main_destination` (`activity_id`,`main_destination`)
) ENGINE=InnoDB AUTO_INCREMENT=268972 DEFAULT CHARSET=latin1 COMMENT='New table to connect activities with multiple cities'
```

### `activity_details_changelog`

**Usado por:**
- `new-admin`: (`app/Models/ActivityDetailsChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterActivity | int | NO | MUL | NULL |  |
| field | varchar(32) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validated | int | YES | MUL | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_activity_details_changelog | BTREE | idMasterActivity, created_at | No |
| idx_activity_details_changelog_validated | BTREE | validated | No |

#### DDL

```sql
CREATE TABLE `activity_details_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterActivity` int NOT NULL,
  `field` varchar(32) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validated` int DEFAULT '0' COMMENT '1 - Si 0 - No',
  PRIMARY KEY (`id`),
  KEY `idx_activity_details_changelog` (`idMasterActivity`,`created_at`),
  KEY `idx_activity_details_changelog_validated` (`validated`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb3 COMMENT='Track the changes made in the activities'
```

### `activity_details_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/ActivityDetailsChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCambio | int | NO |  | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| idioma | varchar(2) | NO | MUL | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_activity_details_changelog_validation | BTREE | idioma | No |

#### DDL

```sql
CREATE TABLE `activity_details_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCambio` int NOT NULL,
  `user` varchar(16) NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_activity_details_changelog_validation` (`idioma`)
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8mb3
```

### `activity_hours_helper`

**Usado por:**
- `new-admin`: (`app/Models/ActivityScheduleCustom.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | bigint | NO | PRI | NULL | auto_increment |
| activity_id | int | NO | MUL | NULL |  |
| date | date | NO |  | NULL |  |
| time | time | YES |  | NULL |  |
| quota | int | YES |  | NULL |  |
| type | tinyint | NO |  | NULL |  |
| quota_active | varchar(1) | NO |  | 0 |  |
| added_from | varchar(256) | YES |  | NULL |  |
| ip | varchar(15) | YES |  | NULL |  |
| created_at | timestamp | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| activity_id_date | BTREE | activity_id, date | No |
| idx_activity_hours_helper_activity_date_quota | BTREE | activity_id, date, quota | No |

#### DDL

```sql
CREATE TABLE `activity_hours_helper` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `activity_id` int NOT NULL,
  `date` date NOT NULL,
  `time` time DEFAULT NULL,
  `quota` int DEFAULT NULL,
  `type` tinyint NOT NULL COMMENT '1 - Añadir, 2- Eliminar',
  `quota_active` varchar(1) NOT NULL DEFAULT '0' COMMENT '0 -> desactivada, 1 -> activada',
  `added_from` varchar(256) DEFAULT NULL COMMENT 'Quién lo insertó. Campo libre.',
  `ip` varchar(15) DEFAULT NULL COMMENT 'IP desde la que se insertó',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de insercción',
  PRIMARY KEY (`id`),
  KEY `activity_id_date` (`activity_id`,`date`),
  KEY `idx_activity_hours_helper_activity_date_quota` (`activity_id`,`date`,`quota`)
) ENGINE=InnoDB AUTO_INCREMENT=58244661412 DEFAULT CHARSET=utf8mb3
```

### `activity_hours_helper_log`

**Usado por:**
- `new-admin`: (`app/Models/ActivityHoursHelperLog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | NO |  | NULL |  |
| date | date | NO |  | NULL |  |
| time | time | NO |  | NULL |  |
| init_quota | int | NO |  | NULL |  |
| final_quota | int | NO |  | NULL |  |
| value | int | NO |  | NULL |  |
| actioner | varchar(256) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| ip | varchar(256) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `activity_hours_helper_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `init_quota` int NOT NULL COMMENT 'Número inicial de la quota',
  `final_quota` int NOT NULL COMMENT 'Número final de la quota',
  `value` int NOT NULL COMMENT 'Número de quotas que se modifica',
  `actioner` varchar(256) NOT NULL COMMENT 'Quien activa esta modificación de quota',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3
```

### `activity_images_attributes_translations`

**Usado por:**
- `new-admin`: (`app/Models/ActivityVariablesTranslationsImage.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| label | varchar(256) | NO |  | NULL |  |
| idVariableMaster | int | NO | MUL | NULL |  |
| src | text | NO |  | NULL |  |
| alt | text | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_activity_images_attributes_translations_idVariableMaster | BTREE | idVariableMaster | No |

#### DDL

```sql
CREATE TABLE `activity_images_attributes_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label` varchar(256) NOT NULL,
  `idVariableMaster` int NOT NULL,
  `src` text NOT NULL,
  `alt` text NOT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_activity_images_attributes_translations_idVariableMaster` (`idVariableMaster`),
  CONSTRAINT `fk_activity_images_attributes_translations_idVariableMaster` FOREIGN KEY (`idVariableMaster`) REFERENCES `activity_variables_translations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `activity_internal_statuses`

**Usado por:**
- `new-admin`: (`app/Models/ActivityInternalStatuses.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | text | NO |  | NULL |  |
| short_name | varchar(255) | YES |  | NULL |  |
| order | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `activity_internal_statuses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `short_name` varchar(255) DEFAULT NULL COMMENT 'Abreviado',
  `order` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3
```

### `activity_links_attributes_translations`

**Usado por:**
- `new-admin`: (`app/Models/ActivityVariablesTranslationsLink.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| label | varchar(256) | NO |  | NULL |  |
| idVariableMaster | int | NO | MUL | NULL |  |
| href | text | NO |  | NULL |  |
| alt | text | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_activity_links_attributes_translations_idVariableMaster | BTREE | idVariableMaster | No |

#### DDL

```sql
CREATE TABLE `activity_links_attributes_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label` varchar(256) NOT NULL,
  `idVariableMaster` int NOT NULL,
  `href` text NOT NULL,
  `alt` text NOT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_activity_links_attributes_translations_idVariableMaster` (`idVariableMaster`),
  CONSTRAINT `fk_activity_links_attributes_translations_idVariableMaster` FOREIGN KEY (`idVariableMaster`) REFERENCES `activity_variables_translations` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `activity_management`

**Usado por:**
- `new-admin`: (`app/Models/ActivityManagement.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | YES | MUL | NULL |  |
| priority | smallint | YES |  | NULL |  |
| class | varchar(32) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| activity_management_activity_id_IDX | BTREE | activity_id | No |

#### DDL

```sql
CREATE TABLE `activity_management` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int DEFAULT NULL,
  `priority` smallint DEFAULT NULL,
  `class` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_management_activity_id_IDX` (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `activity_modality_quota`

**Usado por:**
- `new-admin`: (`app/Models/ActivityModalityQuota.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | NO |  | NULL |  |
| modality_id | int | NO |  | NULL |  |
| date | date | NO |  | NULL |  |
| time | time | NO |  | NULL |  |
| quota | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `activity_modality_quota` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int NOT NULL,
  `modality_id` int NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `quota` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `activity_option_taxon`

**Usado por:**
- `new-admin`: (`app/Models/ActivityOptionTaxonomy.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | char(36) | NO | PRI | NULL |  |
| tag | varchar(255) | NO | UNI | NULL |  |
| description | varchar(255) | YES |  | NULL |  |
| taxon_data_type_id | char(36) | YES | MUL | NULL |  |
| default_value | text | YES |  | NULL |  |
| is_active | tinyint unsigned | NO |  | 1 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_activity_option_taxon_data_type | BTREE | taxon_data_type_id | No |
| uq_activity_option_taxon_tag | BTREE | tag | Sí |

#### DDL

```sql
CREATE TABLE `activity_option_taxon` (
  `id` char(36) COLLATE utf8mb3_unicode_ci NOT NULL,
  `tag` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `taxon_data_type_id` char(36) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `default_value` text COLLATE utf8mb3_unicode_ci,
  `is_active` tinyint unsigned NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_activity_option_taxon_tag` (`tag`),
  KEY `fk_activity_option_taxon_data_type` (`taxon_data_type_id`),
  CONSTRAINT `fk_activity_option_taxon_data_type` FOREIGN KEY (`taxon_data_type_id`) REFERENCES `taxon_data_types` (`uuid`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `activity_option_value`

**Usado por:**
- `new-admin`: (`app/Models/ActivityOptionTaxonomyValue.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | char(36) | NO | PRI | NULL |  |
| activity_id | int | NO | MUL | NULL |  |
| activity_option_taxon_id | char(36) | NO | MUL | NULL |  |
| value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_activity_option_value_taxon | BTREE | activity_option_taxon_id | No |
| uq_activity_option_value_activity_taxon | BTREE | activity_id, activity_option_taxon_id | Sí |

#### DDL

```sql
CREATE TABLE `activity_option_value` (
  `id` char(36) COLLATE utf8mb3_unicode_ci NOT NULL,
  `activity_id` int NOT NULL,
  `activity_option_taxon_id` char(36) COLLATE utf8mb3_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_activity_option_value_activity_taxon` (`activity_id`,`activity_option_taxon_id`),
  KEY `fk_activity_option_value_taxon` (`activity_option_taxon_id`),
  CONSTRAINT `fk_activity_option_value_activity` FOREIGN KEY (`activity_id`) REFERENCES `actividades` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_activity_option_value_taxon` FOREIGN KEY (`activity_option_taxon_id`) REFERENCES `activity_option_taxon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `activity_passenger_info_relations`

**Usado por:**
- `new-admin`: (`app/Models/ActivityPassengerInfoRelations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id_passenger_info_field | int | NO |  | NULL |  |
| id_activity | int | NO |  | NULL |  |
| required | int | NO |  | NULL |  |
| orden | int | NO |  | NULL |  |
| id | int | NO | PRI | NULL | auto_increment |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `activity_passenger_info_relations` (
  `id_passenger_info_field` int NOT NULL,
  `id_activity` int NOT NULL,
  `required` int NOT NULL COMMENT '1- Yes 0- No',
  `orden` int NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=188887 DEFAULT CHARSET=utf8mb3
```

### `activity_pois`

**Usado por:**
- `new-admin`: (`app/Models/ActivityPoi.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| place_id | varchar(200) | NO | MUL | NULL |  |
| type | varchar(100) | YES |  | NULL |  |
| activity_id | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| google_pois_fk | BTREE | place_id | No |

#### DDL

```sql
CREATE TABLE `activity_pois` (
  `id` int NOT NULL AUTO_INCREMENT,
  `place_id` varchar(200) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `activity_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `google_pois_fk` (`place_id`),
  CONSTRAINT `google_pois_fk` FOREIGN KEY (`place_id`) REFERENCES `google_pois` (`place_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `activity_provider_offer`

**Usado por:**
- `new-admin`: (`app/Models/ActivityProviderOffer.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| provider_offer_id | int | NO | PRI | NULL |  |
| activity_id | int | NO | PRI | NULL |  |
| status | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | provider_offer_id, activity_id | Sí |

#### DDL

```sql
CREATE TABLE `activity_provider_offer` (
  `provider_offer_id` int NOT NULL,
  `activity_id` int NOT NULL,
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '0- Desactivada 1-Activa 2-Borrada',
  PRIMARY KEY (`provider_offer_id`,`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `activity_provider_proposal`

**Usado por:**
- `new-admin`: (`app/Models/ActivityProviderProposal.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | NO | PRI | NULL |  |
| status | tinyint(1) | NO | MUL | 1 |  |
| template_id | int | YES |  | NULL |  |
| inputs | text | NO |  | NULL |  |
| requested_by | varchar(255) | YES |  | NULL |  |
| requested_at | timestamp | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id, activity_id | Sí |
| activity_provider_proposal_status_IDX | BTREE | status | No |
| idx_activity_provider_proposal_activity_id | BTREE | activity_id | No |

#### DDL

```sql
CREATE TABLE `activity_provider_proposal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1-Borrador inicial, 2-En revisión inicial, 3-Aprobado, 4-Rechazada, 5-Borrador final, 6-En revisión final, 7-En producción, 8-Rechazada final',
  `template_id` int DEFAULT NULL,
  `inputs` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT 'Form inputs in JSON format',
  `requested_by` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `requested_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`,`activity_id`),
  KEY `idx_activity_provider_proposal_activity_id` (`activity_id`),
  KEY `activity_provider_proposal_status_IDX` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='List activities proposed by providers'
```

### `activity_provider_proposal_annotations`

**Usado por:**
- `new-admin`: (`app/Models/ActivityProviderProposalAnnotations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_provider_proposal_id | int | NO | PRI | NULL |  |
| annotation | text | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id, activity_provider_proposal_id | Sí |
| fk_appa_appi_app_i | BTREE | activity_provider_proposal_id | No |

#### DDL

```sql
CREATE TABLE `activity_provider_proposal_annotations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_provider_proposal_id` int NOT NULL,
  `annotation` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT 'Form inputs in JSON format',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`,`activity_provider_proposal_id`),
  KEY `fk_appa_appi_app_i` (`activity_provider_proposal_id`),
  CONSTRAINT `fk_appa_appi_app_i` FOREIGN KEY (`activity_provider_proposal_id`) REFERENCES `activity_provider_proposal` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='List annotations for an activity provider proposal'
```

### `activity_redirects`

**Usado por:**
- `new-admin`: (`app/Models/ActivityRedirection.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| lang_from | varchar(2) | NO |  | NULL |  |
| city_from | varchar(64) | NO |  | NULL |  |
| activity_slug_from | varchar(64) | NO |  | NULL |  |
| lang_to | varchar(2) | NO |  | NULL |  |
| city_to | varchar(64) | NO |  | NULL |  |
| activity_slug_to | varchar(64) | NO |  | NULL |  |
| redir_type | tinyint | NO |  | 1 |  |
| redirect_code | varchar(3) | NO |  | 301 |  |
| date_added | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `activity_redirects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang_from` varchar(2) NOT NULL,
  `city_from` varchar(64) NOT NULL,
  `activity_slug_from` varchar(64) NOT NULL,
  `lang_to` varchar(2) NOT NULL,
  `city_to` varchar(64) NOT NULL,
  `activity_slug_to` varchar(64) NOT NULL,
  `redir_type` tinyint NOT NULL DEFAULT '1' COMMENT '1.- Sólo Civitatis 2.- Sólo Guías (si procede) 3.- Ambos',
  `redirect_code` varchar(3) NOT NULL DEFAULT '301',
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3655 DEFAULT CHARSET=utf8mb3
```

### `activity_relations`

**Usado por:**
- `new-admin`: (`app/Models/ActivityRelations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterActivity | int | NO | MUL | NULL |  |
| idRelatedActivity | int | NO | UNI | NULL |  |
| commonSchedule | int | NO | MUL | 0 |  |
| commonCancelPolicy | int | YES |  | 0 |  |
| idMasterContent | int | NO | MUL | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| activity_relations_unique_idRelatedActivity | BTREE | idRelatedActivity | Sí |
| commonSchedule | BTREE | commonSchedule | No |
| idx_activity_relations_idMasterActivity | BTREE | idMasterActivity | No |
| idx_activity_relations_idMasterContent | BTREE | idMasterContent | No |
| keyRelatedActivity | BTREE | idRelatedActivity | No |

#### DDL

```sql
CREATE TABLE `activity_relations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterActivity` int NOT NULL,
  `idRelatedActivity` int NOT NULL,
  `commonSchedule` int NOT NULL DEFAULT '0' COMMENT '1 - Si 0 - No',
  `commonCancelPolicy` int DEFAULT '0',
  `idMasterContent` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `activity_relations_unique_idRelatedActivity` (`idRelatedActivity`),
  KEY `keyRelatedActivity` (`idRelatedActivity`),
  KEY `commonSchedule` (`commonSchedule`),
  KEY `idx_activity_relations_idMasterActivity` (`idMasterActivity`),
  KEY `idx_activity_relations_idMasterContent` (`idMasterContent`)
) ENGINE=InnoDB AUTO_INCREMENT=208985 DEFAULT CHARSET=utf8mb3
```

### `activity_release`

**Usado por:**
- `new-admin`: (`app/Models/ActivityRelease.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | NO |  | NULL |  |
| days_before | int | NO |  | NULL |  |
| time | time | YES |  | NULL |  |
| minutes_before | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `activity_release` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int NOT NULL COMMENT 'Identificativo de la actividad',
  `days_before` int NOT NULL COMMENT 'Días de antelación',
  `time` time DEFAULT NULL COMMENT 'Hora límite de compra',
  `minutes_before` int DEFAULT NULL COMMENT 'Minutos previos de antelación',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=174057 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Antelación de las activdades'
```

### `activity_secondary_related`

**Usado por:**
- `new-admin`: (`app/Models/SecondaryActivityRelation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterActivity | int | NO | MUL | NULL |  |
| idRelatedActivity | int | NO | UNI | NULL |  |
| commonSchedule | int | NO | MUL | 0 |  |
| commonCancelPolicy | int | NO |  | 0 |  |
| idMasterContent | int | NO | MUL | 0 |  |
| mainActivityId | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_activity_secondary_related_idMasterActivity | BTREE | idMasterActivity | No |
| idx_activity_secondary_related_idMasterContent | BTREE | idMasterContent | No |
| idx_activity_secondary_related_idRelatedActivity_commonSchedule | BTREE | commonSchedule, idRelatedActivity | No |
| uq_activity_secondary_related_idRelatedActivity | BTREE | idRelatedActivity | Sí |

#### DDL

```sql
CREATE TABLE `activity_secondary_related` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterActivity` int NOT NULL,
  `idRelatedActivity` int NOT NULL,
  `commonSchedule` int NOT NULL DEFAULT '0' COMMENT '1 - Si, 0 - No',
  `commonCancelPolicy` int NOT NULL DEFAULT '0' COMMENT '1 - Si, 0 - No',
  `idMasterContent` int NOT NULL DEFAULT '0' COMMENT '1 - Si, 0 - No',
  `mainActivityId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_activity_secondary_related_idRelatedActivity` (`idRelatedActivity`),
  KEY `idx_activity_secondary_related_idMasterActivity` (`idMasterActivity`),
  KEY `idx_activity_secondary_related_idMasterContent` (`idMasterContent`),
  KEY `idx_activity_secondary_related_idRelatedActivity_commonSchedule` (`commonSchedule`,`idRelatedActivity`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `activity_status`

**Usado por:**
- `new-admin`: (`app/Models/ActivityStatus.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | YES |  | NULL |  |
| account_id | int | YES |  | NULL |  |
| content_id | int | YES |  | NULL |  |
| account_percent | decimal(10,2) | YES |  | NULL |  |
| content_percent | decimal(10,2) | YES |  | NULL |  |
| status | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `activity_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  `content_id` int DEFAULT NULL,
  `account_percent` decimal(10,2) DEFAULT NULL,
  `content_percent` decimal(10,2) DEFAULT NULL,
  `status` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3
```

### `activity_sub_category_info`

**Usado por:**
- `new-admin`: (`app/Models/ActivitySubCategoryInfo.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | NO | MUL | NULL |  |
| sub_category_id | int | NO | MUL | NULL |  |
| bookings_last_year | mediumint unsigned | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_activity_sub_category_info | BTREE | activity_id, sub_category_id | No |
| idx_sub_category_info_id | BTREE | sub_category_id | No |

#### DDL

```sql
CREATE TABLE `activity_sub_category_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int NOT NULL,
  `sub_category_id` int NOT NULL,
  `bookings_last_year` mediumint unsigned NOT NULL DEFAULT '0' COMMENT 'Number of bookings in the last year',
  PRIMARY KEY (`id`),
  KEY `idx_activity_sub_category_info` (`activity_id`,`sub_category_id`),
  KEY `idx_sub_category_info_id` (`sub_category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=279627 DEFAULT CHARSET=latin1 COMMENT='Number of bookings in the last year'
```

### `activity_tickets`

**Usado por:**
- `new-admin`: (`app/Models/Tickets/ActivityTicket.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| uuid | char(36) | NO | PRI | NULL |  |
| activity_id | varchar(36) | NO | MUL | NULL |  |
| ticket_uuid | varchar(36) | NO | MUL | NULL |  |
| ticket_name | varchar(255) | NO |  | NULL |  |
| parent_uuid | varchar(36) | YES | MUL | NULL |  |
| quantity | int | NO |  | 1 |  |
| position | int | YES |  | NULL |  |
| is_verified | tinyint(1) | YES |  | NULL |  |
| is_deleted | tinyint(1) | YES |  | 0 |  |
| activity_ticket_modality_uuid | varchar(36) | YES | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | uuid | Sí |
| fk_activity_tickets_activity_ticket_modality | BTREE | activity_ticket_modality_uuid | No |
| fk_activity_tickets_parent_uuid | BTREE | parent_uuid | No |
| idx_activity_id | BTREE | activity_id | No |
| idx_activity_id_is_deleted | BTREE | activity_id, is_deleted | No |
| idx_activity_id_is_deleted_uuid | BTREE | activity_id, is_deleted, uuid | No |
| idx_parent_uuid | BTREE | parent_uuid | No |
| idx_parent_uuid_activity_id | BTREE | parent_uuid, activity_id | No |
| idx_ticket_uuid | BTREE | ticket_uuid | No |

#### DDL

```sql
CREATE TABLE `activity_tickets` (
  `uuid` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `activity_id` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `ticket_uuid` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `ticket_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `parent_uuid` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `position` int DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT NULL COMMENT '0 - Datos sin validar de precios_columnas | 1 - Datos validados en NA',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '0 - Ticket activos 1 - Ticket borrados lógicamente (hay reservas asociadas a estos tickets)',
  `activity_ticket_modality_uuid` varchar(36) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  KEY `idx_activity_id` (`activity_id`),
  KEY `idx_ticket_uuid` (`ticket_uuid`),
  KEY `fk_activity_tickets_parent_uuid` (`parent_uuid`),
  KEY `idx_parent_uuid` (`parent_uuid`),
  KEY `idx_activity_id_is_deleted` (`activity_id`,`is_deleted`),
  KEY `idx_activity_id_is_deleted_uuid` (`activity_id`,`is_deleted`,`uuid`),
  KEY `idx_parent_uuid_activity_id` (`parent_uuid`,`activity_id`),
  KEY `fk_activity_tickets_activity_ticket_modality` (`activity_ticket_modality_uuid`),
  CONSTRAINT `fk_activity_tickets_activity_ticket_modality` FOREIGN KEY (`activity_ticket_modality_uuid`) REFERENCES `activity_tickets_modalities` (`uuid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_activity_tickets_parent_uuid` FOREIGN KEY (`parent_uuid`) REFERENCES `activity_tickets` (`uuid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_activity_tickets_ticket_uuid` FOREIGN KEY (`ticket_uuid`) REFERENCES `tickets` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='0 - Ticket activos 1 - Ticket borrados lógicamente (hay reservas asociadas a estos tickets)'
```

### `activity_ticket_taxons`

**Usado por:**
- `new-admin`: (`app/Models/Tickets/ActivityTicketTaxon.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| uuid | char(36) | NO | PRI | NULL |  |
| activity_ticket_uuid | varchar(36) | NO | MUL | NULL |  |
| taxon_uuid | varchar(36) | NO | MUL | NULL |  |
| value | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | uuid | Sí |
| idx_activity_ticket_uuid | BTREE | activity_ticket_uuid | No |
| idx_taxon_uuid | BTREE | taxon_uuid | No |

#### DDL

```sql
CREATE TABLE `activity_ticket_taxons` (
  `uuid` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `activity_ticket_uuid` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `taxon_uuid` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`uuid`),
  KEY `idx_activity_ticket_uuid` (`activity_ticket_uuid`),
  KEY `idx_taxon_uuid` (`taxon_uuid`),
  CONSTRAINT `fk_activity_ticket_taxons_activity_ticket_uuid` FOREIGN KEY (`activity_ticket_uuid`) REFERENCES `activity_tickets` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_activity_ticket_taxons_taxon_uuid` FOREIGN KEY (`taxon_uuid`) REFERENCES `taxon` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `activity_translations`

**Usado por:**
- `new-admin`: (`app/Models/ActivityTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | NO | MUL | NULL |  |
| lang | char(2) | NO |  | NULL |  |
| url | varchar(64) | YES |  | NULL |  |
| title | varchar(255) | YES |  | NULL |  |
| long_title | varchar(255) | YES |  | NULL |  |
| description | text | YES |  | NULL |  |
| short_description | varchar(512) | YES |  | NULL |  |
| keywords | varchar(256) | YES |  | NULL |  |
| included | varchar(1024) | YES |  | NULL |  |
| not_included | varchar(1024) | YES |  | NULL |  |
| cancellations | varchar(1024) | YES |  | NULL |  |
| how_to_get_there | varchar(512) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_activityId-lang | BTREE | activity_id, lang | Sí |

#### DDL

```sql
CREATE TABLE `activity_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int NOT NULL,
  `lang` char(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `url` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `long_title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `short_description` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `keywords` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `included` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `not_included` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `cancellations` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `how_to_get_there` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_activityId-lang` (`activity_id`,`lang`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `activity_variables_translations`

**Usado por:**
- `new-admin`: (`app/Models/ActivityVariablesTranslations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | NO | MUL | NULL |  |
| label | varchar(128) | NO | MUL | NULL |  |
| value | text | YES |  | NULL |  |
| value_plural | text | YES |  | NULL |  |
| type | varchar(16) | NO |  | NULL |  |
| lang | varchar(2) | NO | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_activity_variables_label_lang | BTREE | label, lang | No |
| idx_activity_variables_translations_lang | BTREE | lang | No |
| idx_id_lang_activity_variables_translations | BTREE | id, lang | No |
| idx_idMaster_lang_activity_variables_translations | BTREE | idMaster, lang | No |

#### DDL

```sql
CREATE TABLE `activity_variables_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int NOT NULL,
  `label` varchar(128) NOT NULL,
  `value` text,
  `value_plural` text,
  `type` varchar(16) NOT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_idMaster_lang_activity_variables_translations` (`idMaster`,`lang`),
  KEY `idx_id_lang_activity_variables_translations` (`id`,`lang`),
  KEY `idx_activity_variables_label_lang` (`label`,`lang`),
  KEY `idx_activity_variables_translations_lang` (`lang`)
) ENGINE=InnoDB AUTO_INCREMENT=6987 DEFAULT CHARSET=utf8mb3
```

### `additional_questions`

**Usado por:**
- `new-admin`: (`app/Models/AdditionalQuestion.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| question | text | YES |  | NULL |  |
| activity_id | int | NO |  | NULL |  |
| type | int | NO |  | NULL |  |
| typology_id | int unsigned | YES | MUL | NULL |  |
| required | int | NO |  | 0 |  |
| orden | int | NO |  | NULL |  |
| is_pickup_point | tinyint | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_additional_questions_typology_id | BTREE | typology_id | No |

#### DDL

```sql
CREATE TABLE `additional_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question` text,
  `activity_id` int NOT NULL,
  `type` int NOT NULL COMMENT '1 - Regular, 2 - Private',
  `typology_id` int unsigned DEFAULT NULL,
  `required` int NOT NULL DEFAULT '0' COMMENT '0 - No, 1 - Yes',
  `orden` int NOT NULL,
  `is_pickup_point` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_additional_questions_typology_id` (`typology_id`),
  CONSTRAINT `fk_additional_questions_typology_id` FOREIGN KEY (`typology_id`) REFERENCES `additional_question_typology` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=196649 DEFAULT CHARSET=utf8mb3
```

### `adjust_bookings`

**Usado por:**
- `new-admin`: (`app/Models/AdjustBooking.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| product_type | tinyint | NO |  | NULL |  |
| booking_id | int | NO |  | NULL |  |
| activity_kind | text | YES |  | NULL |  |
| att_status | tinyint | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `adjust_bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_type` tinyint NOT NULL,
  `booking_id` int NOT NULL,
  `activity_kind` text,
  `att_status` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `admin_user`

**Usado por:**
- `new-admin`: (`app/Models/AdminUser.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| user | varchar(50) | NO |  | NULL |  |
| name | varchar(50) | YES |  | NULL |  |
| surname | varchar(50) | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| email | varchar(32) | NO |  | NULL |  |
| status | tinyint | NO |  | 1 |  |
| skype | varchar(50) | YES |  | NULL |  |
| phones | varchar(50) | YES |  | NULL |  |
| job_id | int | NO |  | 1 |  |
| department_id | int | NO |  | 1 |  |
| shop_password | varchar(256) | YES |  | NULL |  |
| phone_ext | varchar(50) | YES |  | NULL |  |
| photo | varchar(50) | YES |  | NULL |  |
| birth_date | date | YES |  | NULL |  |
| entry_date | date | YES |  | NULL |  |
| leave_date | date | YES |  | NULL |  |
| document | varchar(50) | YES |  | NULL |  |
| address | varchar(128) | YES |  | NULL |  |
| password | varchar(128) | YES |  | NULL |  |
| ss_number | varchar(50) | YES |  | NULL |  |
| iban | varchar(50) | YES |  | NULL |  |
| comments | varchar(128) | YES |  | NULL |  |
| bio | varchar(128) | YES |  | NULL |  |
| image_new_format | tinyint | NO |  | 0 |  |
| aboutus_mobile_img | varchar(128) | YES |  | NULL |  |
| aboutus_mobile_img_content_type | varchar(128) | YES |  | NULL |  |
| aboutus_desktop_img | varchar(128) | YES |  | NULL |  |
| aboutus_desktop_img_content_type | varchar(128) | YES |  | NULL |  |
| aboutus_position | int | NO |  | 0 |  |
| aboutus_image_hover | tinyint | NO |  | 0 |  |
| insider_url | varchar(128) | YES |  | NULL |  |
| newadmin_menu_config | text | YES |  | NULL |  |
| newadmin_widgets_config | text | YES |  | NULL |  |
| show_image | tinyint(1) | NO |  | 1 |  |
| is_deactivated | tinyint(1) | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `admin_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` varchar(50) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `surname` varchar(50) DEFAULT NULL,
  `lang` varchar(2) DEFAULT NULL,
  `email` varchar(32) NOT NULL,
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1. Activo 0. No activo',
  `skype` varchar(50) DEFAULT NULL,
  `phones` varchar(50) DEFAULT NULL,
  `job_id` int NOT NULL DEFAULT '1',
  `department_id` int NOT NULL DEFAULT '1',
  `shop_password` varchar(256) DEFAULT NULL COMMENT 'Password para los agentes de tienda en BCRYPT.',
  `phone_ext` varchar(50) DEFAULT NULL,
  `photo` varchar(50) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `entry_date` date DEFAULT NULL,
  `leave_date` date DEFAULT NULL,
  `document` varchar(50) DEFAULT NULL,
  `address` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `ss_number` varchar(50) DEFAULT NULL,
  `iban` varchar(50) DEFAULT NULL,
  `comments` varchar(128) DEFAULT NULL,
  `bio` varchar(128) DEFAULT NULL,
  `image_new_format` tinyint NOT NULL DEFAULT '0' COMMENT '1.-nuevo formato, 0.- antiguo formato',
  `aboutus_mobile_img` varchar(128) DEFAULT NULL,
  `aboutus_mobile_img_content_type` varchar(128) DEFAULT NULL,
  `aboutus_desktop_img` varchar(128) DEFAULT NULL,
  `aboutus_desktop_img_content_type` varchar(128) DEFAULT NULL,
  `aboutus_position` int NOT NULL DEFAULT '0',
  `aboutus_image_hover` tinyint NOT NULL DEFAULT '0',
  `insider_url` varchar(128) DEFAULT NULL,
  `newadmin_menu_config` text,
  `newadmin_widgets_config` text,
  `show_image` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1.-Si, 0.- No',
  `is_deactivated` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1364 DEFAULT CHARSET=utf8mb3 COMMENT='1.-Si, 0.- No'
```

### `admin_user_changelog`

**Usado por:**
- `new-admin`: (`app/Models/AdminUserChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| admin_user_id | int | YES |  | NULL |  |
| field | varchar(32) | NO |  | NULL |  |
| old_value | text | NO |  | NULL |  |
| new_value | text | NO |  | NULL |  |
| user_id | int | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| ip | varchar(45) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `admin_user_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `admin_user_id` int DEFAULT NULL,
  `field` varchar(32) NOT NULL,
  `old_value` text NOT NULL,
  `new_value` text NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=675 DEFAULT CHARSET=utf8mb3
```

### `admin_user_role_changelog`

**Usado por:**
- `new-admin`: (`app/Models/AdminUserRoleChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| admin_user_id | int | NO |  | NULL |  |
| field | varchar(32) | NO |  | NULL |  |
| old_value | text | NO |  | NULL |  |
| new_value | text | NO |  | NULL |  |
| user_id | int | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `admin_user_role_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `admin_user_id` int NOT NULL,
  `field` varchar(32) NOT NULL,
  `old_value` text NOT NULL,
  `new_value` text NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3
```

### `affiliate_bookings_info`

**Usado por:**
- `new-admin`: (`app/Models/AffiliateBookingsInfo.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| affiliate_id | int | NO | MUL | NULL |  |
| booking_id | int | NO |  | NULL |  |
| booking_type | int | NO |  | NULL |  |
| billing_date_check | timestamp | YES |  | NULL |  |
| payment_invoice_number | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_booking_id_type_affiliate_bookings_info | BTREE | affiliate_id, booking_id, booking_type | No |

#### DDL

```sql
CREATE TABLE `affiliate_bookings_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `affiliate_id` int NOT NULL,
  `booking_id` int NOT NULL,
  `booking_type` int NOT NULL COMMENT '1 Actividad 2 Traslado',
  `billing_date_check` timestamp NULL DEFAULT NULL,
  `payment_invoice_number` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_booking_id_type_affiliate_bookings_info` (`affiliate_id`,`booking_id`,`booking_type`)
) ENGINE=InnoDB AUTO_INCREMENT=13927422 DEFAULT CHARSET=utf8mb3
```

### `affiliate_comments`

**Usado por:**
- `new-admin`: (`app/Models/AffiliateComment.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| comment | text | NO |  | NULL |  |
| date | date | NO |  | NULL |  |
| affiliate_id | int | NO |  | NULL |  |
| admin_user_id | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `affiliate_comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comment` text NOT NULL,
  `date` date NOT NULL,
  `affiliate_id` int NOT NULL,
  `admin_user_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `affiliate_docs`

**Usado por:**
- `new-admin`: (`app/Models/AffiliateDocs.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_affiliate | int | YES |  | NULL |  |
| typology | int | YES |  | 5 |  |
| filename | varchar(256) | YES |  | NULL |  |
| content_type | varchar(16) | YES |  | NULL |  |
| document_type | varchar(16) | YES |  | NULL |  |
| path | varchar(256) | YES |  | NULL |  |
| end_date | date | YES |  | NULL |  |
| status | int | YES |  | 0 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `affiliate_docs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_affiliate` int DEFAULT NULL,
  `typology` int DEFAULT '5',
  `filename` varchar(256) DEFAULT NULL,
  `content_type` varchar(16) DEFAULT NULL,
  `document_type` varchar(16) DEFAULT NULL,
  `path` varchar(256) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` int DEFAULT '0' COMMENT '0-No validado 1-Validado',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=287 DEFAULT CHARSET=utf8mb3 COMMENT='Acreditación de regimen fiscal de los afiliados autónomos '
```

### `afiliados`

**Usado por:**
- `new-admin`: (`app/Models/Affiliate.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| email | varchar(64) | YES |  | NULL |  |
| password | varchar(32) | NO |  | NULL |  |
| idioma | varchar(2) | NO |  | es |  |
| activo | tinyint | YES |  | 1 |  |
| nombre_contacto | varchar(32) | YES |  | NULL |  |
| apellidos_contacto | varchar(64) | YES |  | NULL |  |
| nombre_empresa | varchar(64) | YES |  | NULL |  |
| vat | varchar(50) | YES |  | NULL |  |
| pais | varchar(32) | YES |  | NULL |  |
| region | int | YES |  | 1 |  |
| ciudad | varchar(32) | YES |  | NULL |  |
| direccion | varchar(64) | YES |  | NULL |  |
| cp | varchar(16) | YES |  | NULL |  |
| telefono | varchar(32) | YES |  | NULL |  |
| webs | text | YES |  | NULL |  |
| pais_banco | varchar(32) | YES |  | NULL |  |
| nombre_banco | varchar(32) | YES |  | NULL |  |
| bank_address | varchar(64) | YES |  | NULL |  |
| nombre_cuenta_corriente | varchar(64) | YES |  | NULL |  |
| iban | varchar(128) | YES |  | NULL |  |
| swift | varchar(32) | YES |  | NULL |  |
| aba | varchar(32) | YES |  | NULL |  |
| autobill | int | YES |  | 0 |  |
| comision | int | YES |  | 8 |  |
| duracion_cookie | int | YES |  | 30 |  |
| referido | int | NO |  | NULL |  |
| activation_token | varchar(256) | NO |  | NULL |  |
| lost_password_request | tinyint | NO |  | 0 |  |
| lost_password_timestamp | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| comision_freetours | float | YES |  | NULL |  |
| newsletter | int | YES |  | 1 |  |
| base_comision | varchar(128) | NO |  | 1 |  |
| forma_pago | int | YES |  | NULL |  |
| email_paypal | varchar(256) | YES |  | NULL |  |
| internal_name | varchar(256) | YES |  | NULL |  |
| tipo_identificacion | varchar(2) | YES |  | 01 |  |
| activation_date | timestamp | YES |  | NULL |  |
| sign_up_stamp | timestamp | NO |  | 0000-00-00 00:00:00 |  |
| sales_notification | int | YES |  | 1 |  |
| motivo_rechazo | tinyint | YES |  | 0 |  |
| welcome_email | tinyint | YES |  | 0 |  |
| inactivity_email | int | NO |  | 0 |  |
| inactivity_email_date | datetime | YES |  | NULL |  |
| rappel_comission | tinyint | NO |  | 1 |  |
| idioma_servicios | varchar(128) | YES |  | NULL |  |
| afiliadoType | int | YES |  | 3 |  |
| irpfPercent | int | YES |  | NULL |  |
| first_sale | tinyint | NO |  | 0 |  |
| deactivation_date | timestamp | YES |  | NULL |  |
| procedencia | int | YES |  | 1 |  |
| refuse_date | timestamp | YES |  | NULL |  |
| autobill_conditions | int | YES |  | 0 |  |
| date_refuse_autobill | date | YES |  | NULL |  |
| date_accepted_autobill | timestamp | YES |  | NULL |  |
| comentarios | text | YES |  | NULL |  |
| validation_admon | tinyint | YES |  | 0 |  |
| date_validation_admon | timestamp | YES |  | NULL |  |
| cmp_registro | varchar(255) | YES |  | NULL |  |
| trafico | int | YES |  | NULL |  |
| id_responsable | int | YES |  | NULL |  |
| provincia | varchar(32) | YES |  | NULL |  |
| nro_establecimientos | int | YES |  | 0 |  |
| date_last_login | datetime | YES |  | NULL |  |
| date_api_last_login | datetime | YES |  | NULL |  |
| market_id | int | YES |  | NULL |  |
| currencyToDisplay | varchar(3) | NO |  | EUR |  |
| instagram_nick | varchar(50) | YES |  | NULL |  |
| instagram_followers | int | YES |  | NULL |  |
| tiktok_nick | varchar(50) | YES |  | NULL |  |
| tiktok_followers | int | YES |  | NULL |  |
| b2b_category_id | int | YES | MUL | NULL |  |
| youtube_nick | varchar(50) | YES |  | NULL |  |
| average_youtube_views | int | YES |  | NULL |  |
| enabled_2fa | tinyint(1) | NO |  | 0 |  |
| widget_by_tags | tinyint(1) | NO |  | 0 |  |
| whatsapp_nick | varchar(256) | YES |  | NULL |  |
| telegram_nick | varchar(256) | YES |  | NULL |  |
| where_known | varchar(250) | YES |  | NULL |  |
| hubspot_data | text | YES |  | NULL |  |
| last_updated_at | timestamp | YES |  | NULL |  |
| created_at | timestamp | YES |  | NULL |  |
| hubspot_identifier | varchar(20) | YES |  | NULL |  |
| irnrPercent | int | YES |  | NULL |  |
| has_pending_conditions | tinyint unsigned | NO |  | 1 |  |
| is_blocked_due_conditions | tinyint unsigned | NO |  | 0 |  |
| commission_new_user | decimal(5,2) | YES |  | NULL |  |
| commission_recurrent | decimal(5,2) | YES |  | NULL |  |
| voucher_branding_type | tinyint unsigned | NO |  | 0 |  |
| is_activity_link_visible | tinyint unsigned | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| afiliados_b2b_category_id | BTREE | b2b_category_id | No |

#### DDL

```sql
CREATE TABLE `afiliados` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(64) DEFAULT NULL,
  `password` varchar(32) NOT NULL,
  `idioma` varchar(2) NOT NULL DEFAULT 'es',
  `activo` tinyint DEFAULT '1',
  `nombre_contacto` varchar(32) DEFAULT NULL,
  `apellidos_contacto` varchar(64) DEFAULT NULL,
  `nombre_empresa` varchar(64) DEFAULT NULL,
  `vat` varchar(50) DEFAULT NULL,
  `pais` varchar(32) DEFAULT NULL,
  `region` int DEFAULT '1' COMMENT '1 Peninsula y Baleares 2 I.Canarias',
  `ciudad` varchar(32) DEFAULT NULL,
  `direccion` varchar(64) DEFAULT NULL,
  `cp` varchar(16) DEFAULT NULL,
  `telefono` varchar(32) DEFAULT NULL,
  `webs` text,
  `pais_banco` varchar(32) DEFAULT NULL,
  `nombre_banco` varchar(32) DEFAULT NULL,
  `bank_address` varchar(64) DEFAULT NULL,
  `nombre_cuenta_corriente` varchar(64) DEFAULT NULL,
  `iban` varchar(128) DEFAULT NULL,
  `swift` varchar(32) DEFAULT NULL,
  `aba` varchar(32) DEFAULT NULL,
  `autobill` int DEFAULT '0' COMMENT '0 No 1 Si',
  `comision` int DEFAULT '8',
  `duracion_cookie` int DEFAULT '30',
  `referido` int NOT NULL,
  `activation_token` varchar(256) NOT NULL,
  `lost_password_request` tinyint NOT NULL DEFAULT '0',
  `lost_password_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comision_freetours` float DEFAULT NULL,
  `newsletter` int DEFAULT '1',
  `base_comision` varchar(128) NOT NULL DEFAULT '1' COMMENT '1 - PVP 2 - Beneficio',
  `forma_pago` int DEFAULT NULL COMMENT '1. Transferencia 2. Paypal',
  `email_paypal` varchar(256) DEFAULT NULL,
  `internal_name` varchar(256) DEFAULT NULL,
  `tipo_identificacion` varchar(2) DEFAULT '01' COMMENT '01 - NIF/CIF, 02 - NIF-IVA, 03 - Pasaporte, 04 - Documento oficial de identificación expedido por el país o territorio de residencia, 05 - Certificado de residencia, 06 -  Otro documento probatorio, 07 - No censado',
  `activation_date` timestamp NULL DEFAULT NULL,
  `sign_up_stamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `sales_notification` int DEFAULT '1' COMMENT '0.- No 1.- Sí',
  `motivo_rechazo` tinyint DEFAULT '0' COMMENT '1. Ya existe 2. Trabaja como agencia 3. Quiere ser proveedor 4. No cumple requisitos',
  `welcome_email` tinyint DEFAULT '0' COMMENT '0.- No se ha enviado email de bienvenida. 1.- Enviado el de dos días. 2.- Enviado el de siete días.',
  `inactivity_email` int NOT NULL DEFAULT '0' COMMENT 'último mail de inactividad mandado. [0/30/90/365/380]',
  `inactivity_email_date` datetime DEFAULT NULL COMMENT 'Fecha a la que he enviado el último inactivity_email',
  `rappel_comission` tinyint NOT NULL DEFAULT '1',
  `idioma_servicios` varchar(128) DEFAULT NULL,
  `afiliadoType` int DEFAULT '3' COMMENT '1. Empresa 2. Autónomo 3. Otros',
  `irpfPercent` int DEFAULT NULL,
  `first_sale` tinyint NOT NULL DEFAULT '0' COMMENT '0.- Email no enviado 1.- Email enviado',
  `deactivation_date` timestamp NULL DEFAULT NULL,
  `procedencia` int DEFAULT '1' COMMENT '1 Organico 2 Captado',
  `refuse_date` timestamp NULL DEFAULT NULL,
  `autobill_conditions` int DEFAULT '0',
  `date_refuse_autobill` date DEFAULT NULL,
  `date_accepted_autobill` timestamp NULL DEFAULT NULL,
  `comentarios` text,
  `validation_admon` tinyint DEFAULT '0',
  `date_validation_admon` timestamp NULL DEFAULT NULL,
  `cmp_registro` varchar(255) DEFAULT NULL,
  `trafico` int DEFAULT NULL,
  `id_responsable` int DEFAULT NULL,
  `provincia` varchar(32) DEFAULT NULL,
  `nro_establecimientos` int DEFAULT '0',
  `date_last_login` datetime DEFAULT NULL,
  `date_api_last_login` datetime DEFAULT NULL,
  `market_id` int DEFAULT NULL,
  `currencyToDisplay` varchar(3) NOT NULL DEFAULT 'EUR',
  `instagram_nick` varchar(50) DEFAULT NULL,
  `instagram_followers` int DEFAULT NULL,
  `tiktok_nick` varchar(50) DEFAULT NULL,
  `tiktok_followers` int DEFAULT NULL,
  `b2b_category_id` int DEFAULT NULL,
  `youtube_nick` varchar(50) DEFAULT NULL,
  `average_youtube_views` int DEFAULT NULL,
  `enabled_2fa` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 - 2FA inactivo 1 - 2FA activo',
  `widget_by_tags` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0) No permitir 1) Permitir',
  `whatsapp_nick` varchar(256) DEFAULT NULL,
  `telegram_nick` varchar(256) DEFAULT NULL,
  `where_known` varchar(250) DEFAULT NULL,
  `hubspot_data` text,
  `last_updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `hubspot_identifier` varchar(20) DEFAULT NULL,
  `irnrPercent` int DEFAULT NULL,
  `has_pending_conditions` tinyint unsigned NOT NULL DEFAULT '1',
  `is_blocked_due_conditions` tinyint unsigned NOT NULL DEFAULT '0',
  `commission_new_user` decimal(5,2) DEFAULT NULL,
  `commission_recurrent` decimal(5,2) DEFAULT NULL,
  `voucher_branding_type` tinyint unsigned NOT NULL DEFAULT '0',
  `is_activity_link_visible` tinyint unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `afiliados_b2b_category_id` (`b2b_category_id`),
  CONSTRAINT `afiliados_b2b_category_id` FOREIGN KEY (`b2b_category_id`) REFERENCES `b2b_categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10762 DEFAULT CHARSET=utf8mb3 COMMENT='0) No permitir 1) Permitir'
```

### `afiliados_notificaciones`

**Usado por:**
- `new-admin`: (`app/Models/AffiliateNotification.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| motivo | varchar(255) | YES |  | NULL |  |
| mail_label | varchar(255) | NO |  | NULL |  |
| active | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `afiliados_notificaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `motivo` varchar(255) DEFAULT NULL,
  `mail_label` varchar(255) NOT NULL COMMENT 'Texto a traducir en el mail.',
  `active` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3
```

### `afiliados_referral_clicks_v3`

**Usado por:**
- `new-admin`: (`app/Models/AffiliateReferralClick.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idAfiliado | int | NO |  | NULL |  |
| fecha | date | NO |  | NULL |  |
| clicks | int | NO |  | NULL |  |
| urlReferral | text | NO |  | NULL |  |
| campanaAfiliado | varchar(256) | NO |  |  |  |
| linked_id | int | NO |  | 0 |  |
| linked_type | int | NO |  | 0 |  |
| origin | int | NO |  | 0 |  |
| origin_type | varchar(256) | NO |  |  |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `afiliados_referral_clicks_v3` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idAfiliado` int NOT NULL,
  `fecha` date NOT NULL,
  `clicks` int NOT NULL,
  `urlReferral` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `campanaAfiliado` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '',
  `linked_id` int NOT NULL DEFAULT '0',
  `linked_type` int NOT NULL DEFAULT '0',
  `origin` int NOT NULL DEFAULT '0',
  `origin_type` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `agencias`

**Usado por:**
- `new-admin`: (`app/Models/Agency.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| nombre_comercial | varchar(256) | NO |  | NULL |  |
| web | text | YES |  | NULL |  |
| denominacion_social | varchar(256) | NO |  | NULL |  |
| tipo_identificacion | varchar(2) | NO |  | 01 |  |
| nombre_fiscal | varchar(256) | NO |  | NULL |  |
| cif | varchar(50) | NO |  | NULL |  |
| direccion | varchar(256) | NO |  | NULL |  |
| cp | varchar(10) | NO |  | NULL |  |
| cod_pais | varchar(2) | NO |  | NULL |  |
| ciudad | varchar(100) | NO |  | NULL |  |
| telefono | varchar(256) | YES |  | NULL |  |
| descuento | float | YES |  | NULL |  |
| activo | tinyint | YES |  | 2 |  |
| show_original_prices | tinyint | NO |  | 0 |  |
| group_id | int | YES |  | NULL |  |
| activation_date | timestamp | YES |  | NULL |  |
| welcome_email | tinyint | NO |  | 0 |  |
| firstSale_email | int | NO |  | 0 |  |
| inactivity_email | int | NO |  | 0 |  |
| inactivity_email_date | datetime | YES |  | NULL |  |
| idioma | varchar(2) | YES |  | NULL |  |
| touristIdentificationCode | tinyint | NO |  | 1 |  |
| agencyIdentification | varchar(512) | YES |  | NULL |  |
| motivo_rechazo | tinyint | YES |  | 0 |  |
| region | int | YES |  | 0 |  |
| nuevasCondiciones | int | NO |  | 1 |  |
| nuevasCondiciones_dateAccepted | timestamp | YES |  | NULL |  |
| idioma_servicios | varchar(128) | YES |  | NULL |  |
| comentarios | text | YES |  | NULL |  |
| deactivation_date | timestamp | YES |  | NULL |  |
| created_at | timestamp | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| last_updated_at | timestamp | NO |  | NULL |  |
| external_id | varchar(32) | YES |  | NULL |  |
| show_voucher_price | int | YES |  | 1 |  |
| id_categoria_alojamiento | int | YES |  | NULL |  |
| alojamiento | tinyint | NO |  | 0 |  |
| provincia | varchar(32) | YES |  | NULL |  |
| nro_establecimientos | int | YES |  | 0 |  |
| date_last_login | datetime | YES |  | NULL |  |
| date_api_last_login | datetime | YES |  | NULL |  |
| market_id | int | YES |  | NULL |  |
| direccion_fisica | varchar(256) | YES |  | NULL |  |
| cp_fisica | varchar(10) | YES |  | NULL |  |
| ciudad_fisica | text | YES |  | NULL |  |
| provincia_fisica | varchar(32) | YES |  | NULL |  |
| cod_pais_fisica | varchar(2) | YES |  | NULL |  |
| region_fisica | int | YES |  | NULL |  |
| send_billing_by_email | tinyint | NO |  | 0 |  |
| billing_email | varchar(100) | YES |  | NULL |  |
| credit_notification_email | varchar(75) | YES |  | NULL |  |
| cmp_registro | varchar(255) | YES |  | NULL |  |
| procedencia | int | YES |  | 1 |  |
| factura_proveedor | tinyint | YES |  | NULL |  |
| payLater | int | NO |  | 0 |  |
| autofactura | tinyint | YES |  | 1 |  |
| autofactura_comm_afi | tinyint | YES |  | 0 |  |
| tipo_precio | tinyint | YES |  | 0 |  |
| wallet_mode | tinyint | YES |  | 1 |  |
| tipo_pago | tinyint | YES |  | 0 |  |
| pais_banco | varchar(256) | YES |  | NULL |  |
| nombre_banco | varchar(256) | YES |  | NULL |  |
| bank_address | varchar(64) | YES |  | NULL |  |
| iban | varchar(256) | YES |  | NULL |  |
| nombre_cuenta_corriente | varchar(256) | YES |  | NULL |  |
| swift | varchar(256) | YES |  | NULL |  |
| aba | varchar(32) | YES |  | NULL |  |
| email_paypal | varchar(256) | YES |  | NULL |  |
| works_with_pms | varchar(150) | YES |  | NULL |  |
| pec | varchar(256) | YES |  | NULL |  |
| force_fdac_invoice | int | NO |  | 0 |  |
| date_add_fdac_invoice | timestamp | YES |  | NULL |  |
| responsible | int | YES |  | NULL |  |
| free_tour_pax_commission | float | NO |  | 1 |  |
| top_agency | tinyint | YES |  | 0 |  |
| b2b_category_id | int | YES | MUL | NULL |  |
| enabled_2fa | tinyint(1) | NO |  | 1 |  |
| size | tinyint | YES |  | NULL |  |
| tier | tinyint | YES |  | NULL |  |
| validation_admon | tinyint(1) | YES |  | 0 |  |
| date_validation_admon | timestamp | YES |  | NULL |  |
| irpfPercent | int | YES |  | NULL |  |
| entity_tax_type | int | YES |  | 1 |  |
| electronicInvoice | int | YES |  | 0 |  |
| unified_invoice | tinyint(1) | NO |  | 0 |  |
| hubspot_identifier | varchar(20) | YES |  | NULL |  |
| hubspot_data | text | YES |  | NULL |  |
| has_credit | tinyint(1) | YES |  | 0 |  |
| credit_limit | decimal(9,2) | YES |  | 0.00 |  |
| irnrPercent | int | YES |  | NULL |  |
| unifiedInvoiceDate | datetime | YES |  | NULL |  |
| has_pending_conditions | tinyint unsigned | NO |  | 0 |  |
| is_blocked_due_conditions | tinyint unsigned | NO |  | 0 |  |
| voucher_branding_type | tinyint unsigned | NO |  | 0 |  |
| is_activity_link_visible | tinyint unsigned | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| agencias_b2b_category_id | BTREE | b2b_category_id | No |
| idx_agency_id | BTREE | id | No |

#### DDL

```sql
CREATE TABLE `agencias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre_comercial` varchar(256) NOT NULL,
  `web` text,
  `denominacion_social` varchar(256) NOT NULL,
  `tipo_identificacion` varchar(2) NOT NULL DEFAULT '01' COMMENT '01 - NIF/CIF, 02 - NIF-IVA, 03 - Pasaporte, 04 - Documento oficial de identificación expedido por el país o territorio de residencia, 05 - Certificado de residencia, 06 -  Otro documento probatorio, 07 - No censado',
  `nombre_fiscal` varchar(256) NOT NULL,
  `cif` varchar(50) NOT NULL,
  `direccion` varchar(256) NOT NULL,
  `cp` varchar(10) NOT NULL,
  `cod_pais` varchar(2) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `telefono` varchar(256) DEFAULT NULL,
  `descuento` float DEFAULT NULL,
  `activo` tinyint DEFAULT '2',
  `show_original_prices` tinyint NOT NULL DEFAULT '0' COMMENT '0- No 1 - si',
  `group_id` int DEFAULT NULL,
  `activation_date` timestamp NULL DEFAULT NULL,
  `welcome_email` tinyint NOT NULL DEFAULT '0',
  `firstSale_email` int NOT NULL DEFAULT '0',
  `inactivity_email` int NOT NULL DEFAULT '0' COMMENT 'último mail de inactividad mandado. [0/30/90/365/370]',
  `inactivity_email_date` datetime DEFAULT NULL COMMENT 'Fecha a la que he enviado el último inactivity_email',
  `idioma` varchar(2) DEFAULT NULL,
  `touristIdentificationCode` tinyint NOT NULL DEFAULT '1' COMMENT '1. Licencia 2. IATA 3. OTRO',
  `agencyIdentification` varchar(512) DEFAULT NULL,
  `motivo_rechazo` tinyint DEFAULT '0' COMMENT '1. Ya existe 2. No cumple requisitos',
  `region` int DEFAULT '0' COMMENT '0  Canarias y Resto 1 Peninsula y Baleares',
  `nuevasCondiciones` int NOT NULL DEFAULT '1' COMMENT '1. Aceptadas 0 No aceptadas',
  `nuevasCondiciones_dateAccepted` timestamp NULL DEFAULT NULL,
  `idioma_servicios` varchar(128) DEFAULT NULL,
  `comentarios` text,
  `deactivation_date` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_at` timestamp NOT NULL,
  `external_id` varchar(32) DEFAULT NULL,
  `show_voucher_price` int DEFAULT '1' COMMENT '0 no, 1 si',
  `id_categoria_alojamiento` int DEFAULT NULL,
  `alojamiento` tinyint NOT NULL DEFAULT '0',
  `provincia` varchar(32) DEFAULT NULL,
  `nro_establecimientos` int DEFAULT '0',
  `date_last_login` datetime DEFAULT NULL,
  `date_api_last_login` datetime DEFAULT NULL,
  `market_id` int DEFAULT NULL,
  `direccion_fisica` varchar(256) DEFAULT NULL,
  `cp_fisica` varchar(10) DEFAULT NULL,
  `ciudad_fisica` text,
  `provincia_fisica` varchar(32) DEFAULT NULL,
  `cod_pais_fisica` varchar(2) DEFAULT NULL,
  `region_fisica` int DEFAULT NULL COMMENT '0 Canarias y Resto 1 Peninsula y Baleares',
  `send_billing_by_email` tinyint NOT NULL DEFAULT '0' COMMENT 'Determina si envía la facturación por correo electrónico. 0 No, 1 Si',
  `billing_email` varchar(100) DEFAULT NULL,
  `credit_notification_email` varchar(75) DEFAULT NULL,
  `cmp_registro` varchar(255) DEFAULT NULL,
  `procedencia` int DEFAULT '1' COMMENT '1 Organico 2 Captado 3 Campaña',
  `factura_proveedor` tinyint DEFAULT NULL,
  `payLater` int NOT NULL DEFAULT '0' COMMENT 'Controlamos si esta activo o no el pago más tarde',
  `autofactura` tinyint DEFAULT '1' COMMENT '0.- No se genera autofactura. 1.- Se genera autofactura',
  `autofactura_comm_afi` tinyint DEFAULT '0' COMMENT '0.- No se genera autofactura de comisión de afiliación. 1.- Se generarán una única autofactura con todas las comisiones de ventas de afiliación',
  `tipo_precio` tinyint DEFAULT '0' COMMENT '0.- Ambos. 1.- Neto 2.- PVP',
  `wallet_mode` tinyint DEFAULT '1' COMMENT '0.- Ninguno. 1.- Agencia',
  `tipo_pago` tinyint DEFAULT '0' COMMENT '0.- NA 1.- Transferencia bancaria. 2.- Paypal',
  `pais_banco` varchar(256) DEFAULT NULL,
  `nombre_banco` varchar(256) DEFAULT NULL,
  `bank_address` varchar(64) DEFAULT NULL,
  `iban` varchar(256) DEFAULT NULL,
  `nombre_cuenta_corriente` varchar(256) DEFAULT NULL,
  `swift` varchar(256) DEFAULT NULL,
  `aba` varchar(32) DEFAULT NULL,
  `email_paypal` varchar(256) DEFAULT NULL,
  `works_with_pms` varchar(150) DEFAULT NULL,
  `pec` varchar(256) DEFAULT NULL COMMENT 'codice univoco solo aplicable en las agencias italianas',
  `force_fdac_invoice` int NOT NULL DEFAULT '0',
  `date_add_fdac_invoice` timestamp NULL DEFAULT NULL,
  `responsible` int DEFAULT NULL,
  `free_tour_pax_commission` float NOT NULL DEFAULT '1' COMMENT 'Importe de la comision de los freetours',
  `top_agency` tinyint DEFAULT '0' COMMENT '0.- no, 1.- si',
  `b2b_category_id` int DEFAULT NULL,
  `enabled_2fa` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0 - 2FA inactivo 1 - 2FA activo',
  `size` tinyint DEFAULT NULL COMMENT '1 - Pequeña (0-2 empleados), 2 - Mediana (3-5 empleados), 3 - Grande (+5 empleados)',
  `tier` tinyint DEFAULT NULL COMMENT '1 - Tier 1, 2 - Tier 2, 3 - Tier 3',
  `validation_admon` tinyint(1) DEFAULT '0',
  `date_validation_admon` timestamp NULL DEFAULT NULL,
  `irpfPercent` int DEFAULT NULL,
  `entity_tax_type` int DEFAULT '1' COMMENT '1. Empresa 2. Autónomo',
  `electronicInvoice` int DEFAULT '0' COMMENT '0 no se envia factura electronica, 1 se envia factura electronica',
  `unified_invoice` tinyint(1) NOT NULL DEFAULT '0',
  `hubspot_identifier` varchar(20) DEFAULT NULL,
  `hubspot_data` text,
  `has_credit` tinyint(1) DEFAULT '0',
  `credit_limit` decimal(9,2) DEFAULT '0.00',
  `irnrPercent` int DEFAULT NULL,
  `unifiedInvoiceDate` datetime DEFAULT NULL COMMENT 'fecha desde que esta disponible la factura unificada',
  `has_pending_conditions` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Indicates if the agency has pending contract conditions',
  `is_blocked_due_conditions` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Indicates if the agency is blocked due to pending contract conditions',
  `voucher_branding_type` tinyint unsigned NOT NULL DEFAULT '0',
  `is_activity_link_visible` tinyint unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_agency_id` (`id`),
  KEY `agencias_b2b_category_id` (`b2b_category_id`),
  CONSTRAINT `agencias_b2b_category_id` FOREIGN KEY (`b2b_category_id`) REFERENCES `b2b_categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85185 DEFAULT CHARSET=utf8mb3 COMMENT='Indicates if the agency is blocked due to pending contract conditions'
```

### `agencias_docs`

**Usado por:**
- `new-admin`: (`app/Models/AgencyDoc.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| agency_id | int | YES |  | NULL |  |
| typology | int | YES |  | 5 |  |
| filename | varchar(256) | YES |  | NULL |  |
| content_type | varchar(16) | YES |  | NULL |  |
| document_type | varchar(16) | YES |  | NULL |  |
| path | varchar(256) | YES |  | NULL |  |
| end_date | date | YES |  | NULL |  |
| status | int | YES |  | 0 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `agencias_docs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `agency_id` int DEFAULT NULL,
  `typology` int DEFAULT '5',
  `filename` varchar(256) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `content_type` varchar(16) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `document_type` varchar(16) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `path` varchar(256) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` int DEFAULT '0' COMMENT '0 - No validado | 1 - Validado',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `agencias_grupos`

**Usado por:**
- `new-admin`: (`app/Models/AgencyGroup.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(512) | NO |  | NULL |  |
| descuento | float | YES |  | NULL |  |
| solicitar_expediente | tinyint | YES |  | 0 |  |
| cod_pais | varchar(2) | YES |  | NULL |  |
| nombre_fiscal | varchar(128) | YES |  | NULL |  |
| direccion | text | YES |  | NULL |  |
| tipo_identificacion | varchar(2) | YES |  | 01 |  |
| cif | varchar(50) | YES |  | NULL |  |
| cp | varchar(10) | YES |  | NULL |  |
| ciudad | varchar(100) | YES |  | NULL |  |
| telefono | varchar(50) | YES |  | NULL |  |
| region | int | NO |  | 0 |  |
| active | tinyint | NO |  | 1 |  |
| shareBilling | int | NO |  | 0 |  |
| emailFacturacion | varchar(256) | YES |  | NULL |  |
| credit_notification_email | varchar(75) | YES |  | NULL |  |
| autofactura | tinyint | YES |  | 1 |  |
| tipo_precio | tinyint | YES |  | 0 |  |
| wallet | tinyint | YES |  | 1 |  |
| pay_with_wallet | int | NO |  | 1 |  |
| factura_proveedor | tinyint | YES |  | 0 |  |
| idioma | varchar(2) | YES |  | NULL |  |
| show_commission | tinyint | NO |  | 1 |  |
| show_voucher_price | int | YES |  | NULL |  |
| alojamiento | tinyint | NO |  | 0 |  |
| affiliation_resources | int | NO |  | 1 |  |
| date_last_login | datetime | YES |  | NULL |  |
| date_api_last_login | datetime | YES |  | NULL |  |
| market_id | int | YES |  | NULL |  |
| pec | varchar(256) | NO |  | 0000000 |  |
| force_fdac_invoice | int | NO |  | 0 |  |
| date_add_fdac_invoice | timestamp | YES |  | NULL |  |
| responsible | int | YES |  | NULL |  |
| free_tour_pax_commission | float | NO |  | 1 |  |
| show_billing_section | tinyint | YES |  | 0 |  |
| payLater | tinyint | YES |  | 0 |  |
| enable_wallet_payment_at_pvp | tinyint(1) | NO |  | 0 |  |
| only_pay_with_wallet | tinyint(1) | NO |  | 0 |  |
| created_at | timestamp | NO |  | NULL |  |
| last_updated_at | timestamp | NO |  | NULL |  |
| enabled_2fa | tinyint(1) | NO |  | 1 |  |
| send_welcome_email | tinyint(1) | NO |  | 1 |  |
| electronicInvoice | int | YES |  | 0 |  |
| enable_wallet_refund | tinyint(1) | NO |  | 1 |  |
| has_credit | tinyint(1) | YES |  | 0 |  |
| credit_limit | decimal(9,2) | YES |  | 0.00 |  |
| has_pending_conditions | tinyint unsigned | NO |  | 0 |  |
| is_blocked_due_conditions | tinyint unsigned | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `agencias_grupos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(512) NOT NULL,
  `descuento` float DEFAULT NULL,
  `solicitar_expediente` tinyint DEFAULT '0' COMMENT '0. No 1. Si',
  `cod_pais` varchar(2) DEFAULT NULL,
  `nombre_fiscal` varchar(128) DEFAULT NULL,
  `direccion` text,
  `tipo_identificacion` varchar(2) DEFAULT '01' COMMENT '01 - NIF/CIF, 02 - NIF-IVA, 03 - Pasaporte, 04 - Documento oficial de identificación expedido por el país o territorio de residencia, 05 - Certificado de residencia, 06 -  Otro documento probatorio, 07 - No censado',
  `cif` varchar(50) DEFAULT NULL,
  `cp` varchar(10) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `region` int NOT NULL DEFAULT '0' COMMENT '0 Canarias y Resto 1 Peninsula y Baleares',
  `active` tinyint NOT NULL DEFAULT '1',
  `shareBilling` int NOT NULL DEFAULT '0' COMMENT '0 No 1 si',
  `emailFacturacion` varchar(256) DEFAULT NULL,
  `credit_notification_email` varchar(75) DEFAULT NULL,
  `autofactura` tinyint DEFAULT '1' COMMENT '0.- No se genera autofactura. 1.- Se genera autofactura',
  `tipo_precio` tinyint DEFAULT '0' COMMENT '0.- Ambos. 1.- Neto 2.- PVP',
  `wallet` tinyint DEFAULT '1' COMMENT '0.- Ninguno. 1.- Agencia 2.- Grupo',
  `pay_with_wallet` int NOT NULL DEFAULT '1' COMMENT '0.- NO se permite el pago con wallet 1.- Se permite el pago con wallet',
  `factura_proveedor` tinyint DEFAULT '0' COMMENT '0.- No se solicita factura al proveedor automáticamente. 1.- Se solicita factura al proveedor automáticamente',
  `idioma` varchar(2) DEFAULT NULL,
  `show_commission` tinyint NOT NULL DEFAULT '1',
  `show_voucher_price` int DEFAULT NULL COMMENT 'null - sin definir, 0 no 1 si',
  `alojamiento` tinyint NOT NULL DEFAULT '0',
  `affiliation_resources` int NOT NULL DEFAULT '1' COMMENT '0 no funciona nada de afiliación ni se muestra en panel, 1 si funciona afiliación',
  `date_last_login` datetime DEFAULT NULL,
  `date_api_last_login` datetime DEFAULT NULL,
  `market_id` int DEFAULT NULL,
  `pec` varchar(256) NOT NULL DEFAULT '0000000' COMMENT 'número de declaración de facturas para agencias Italianas',
  `force_fdac_invoice` int NOT NULL DEFAULT '0',
  `date_add_fdac_invoice` timestamp NULL DEFAULT NULL,
  `responsible` int DEFAULT NULL,
  `free_tour_pax_commission` float NOT NULL DEFAULT '1' COMMENT 'Importe de la comision de los freetours',
  `show_billing_section` tinyint DEFAULT '0' COMMENT '0.- no, 1.- si',
  `payLater` tinyint DEFAULT '0' COMMENT '0.- no, 1.- si',
  `enable_wallet_payment_at_pvp` tinyint(1) NOT NULL DEFAULT '0',
  `only_pay_with_wallet` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 - Si, 0 - No',
  `created_at` timestamp NOT NULL,
  `last_updated_at` timestamp NOT NULL,
  `enabled_2fa` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0 - 2FA inactivo 1 - 2FA activo',
  `send_welcome_email` tinyint(1) NOT NULL DEFAULT '1',
  `electronicInvoice` int DEFAULT '0' COMMENT '0 no se envia factura electronica, 1 se envia factura electronica',
  `enable_wallet_refund` tinyint(1) NOT NULL DEFAULT '1',
  `has_credit` tinyint(1) DEFAULT '0',
  `credit_limit` decimal(9,2) DEFAULT '0.00',
  `has_pending_conditions` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Indicates if the agency group has pending contract conditions',
  `is_blocked_due_conditions` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Indicates if the agency group is blocked due to pending contract conditions',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=367 DEFAULT CHARSET=utf8mb3 COMMENT='Indicates if the agency group is blocked due to pending contract conditions'
```

### `agencias_grupos_usuarios`

**Usado por:**
- `new-admin`: (`app/Models/AgencyGroupUser.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| group_id | int | NO |  | NULL |  |
| admin | int | NO |  | 0 |  |
| nombre | varchar(256) | YES |  | NULL |  |
| apellidos | varchar(256) | YES |  | NULL |  |
| password | varchar(256) | YES |  | NULL |  |
| email | varchar(100) | NO | UNI | NULL |  |
| idioma | varchar(2) | YES |  | es |  |
| currencyToDisplay | varchar(3) | NO |  | EUR |  |
| newsletter | int | NO |  | 1 |  |
| lost_password_request | tinyint | NO |  | 0 |  |
| lost_password_timestamp | timestamp | YES |  | NULL |  |
| last_sign_in_stamp | timestamp | YES |  | NULL |  |
| activation_token | varchar(256) | YES |  | NULL |  |
| activo | tinyint | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| email | BTREE | email | Sí |

#### DDL

```sql
CREATE TABLE `agencias_grupos_usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `admin` int NOT NULL DEFAULT '0' COMMENT '0.- No 1.- Sí',
  `nombre` varchar(256) DEFAULT NULL,
  `apellidos` varchar(256) DEFAULT NULL,
  `password` varchar(256) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `idioma` varchar(2) DEFAULT 'es',
  `currencyToDisplay` varchar(3) NOT NULL DEFAULT 'EUR',
  `newsletter` int NOT NULL DEFAULT '1',
  `lost_password_request` tinyint NOT NULL DEFAULT '0',
  `lost_password_timestamp` timestamp NULL DEFAULT NULL,
  `last_sign_in_stamp` timestamp NULL DEFAULT NULL,
  `activation_token` varchar(256) DEFAULT NULL,
  `activo` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=326 DEFAULT CHARSET=utf8mb3
```

### `agencias_usuarios`

**Usado por:**
- `new-admin`: (`app/Models/UserAgency.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_agencia | int | NO | MUL | NULL |  |
| admin | int | NO |  | 0 |  |
| nombre | varchar(256) | YES |  | NULL |  |
| apellidos | varchar(256) | YES |  | NULL |  |
| usuario | varchar(256) | NO |  | NULL |  |
| password | varchar(32) | YES |  | NULL |  |
| email | varchar(256) | NO |  | NULL |  |
| idioma | varchar(2) | YES |  | es |  |
| shareBilling | int | NO |  | 1 |  |
| tipo_identificacion | varchar(2) | YES |  | 01 |  |
| nombre_fiscal | varchar(256) | NO |  | NULL |  |
| cif | varchar(50) | YES |  | NULL |  |
| direccion | varchar(256) | NO |  | NULL |  |
| cp | varchar(10) | YES |  | NULL |  |
| cod_pais | varchar(2) | YES |  | NULL |  |
| ciudad | varchar(100) | YES |  | NULL |  |
| currencyToDisplay | varchar(3) | NO |  | EUR |  |
| lost_password_request | tinyint | NO |  | 0 |  |
| lost_password_timestamp | timestamp | YES |  | NULL |  |
| activation_token | varchar(256) | NO |  | NULL |  |
| activo | tinyint | YES |  | 0 |  |
| guest | tinyint | NO |  | 0 |  |
| sign_up_stamp | timestamp | NO |  | 0000-00-00 00:00:00 |  |
| last_updated_at | timestamp | NO |  | NULL |  |
| last_sign_in_stamp | timestamp | YES |  | NULL |  |
| deleted_by | varchar(255) | YES |  | NULL |  |
| deleted_at | datetime | YES |  | NULL |  |
| newsletter | tinyint | YES |  | 1 |  |
| nuevasCondicionesEnviadas | int | NO |  | 0 |  |
| admin_validation_date | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_usuario_agencia | BTREE | id_agencia | No |

#### DDL

```sql
CREATE TABLE `agencias_usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_agencia` int NOT NULL,
  `admin` int NOT NULL DEFAULT '0' COMMENT '0- no 1- si',
  `nombre` varchar(256) DEFAULT NULL,
  `apellidos` varchar(256) DEFAULT NULL,
  `usuario` varchar(256) NOT NULL,
  `password` varchar(32) DEFAULT NULL,
  `email` varchar(256) NOT NULL,
  `idioma` varchar(2) DEFAULT 'es',
  `shareBilling` int NOT NULL DEFAULT '1' COMMENT '1- Si 0- No',
  `tipo_identificacion` varchar(2) DEFAULT '01' COMMENT '01 - NIF/CIF, 02 - NIF-IVA, 03 - Pasaporte, 04 - Documento oficial de identificación expedido por el país o territorio de residencia, 05 - Certificado de residencia, 06 -  Otro documento probatorio, 07 - No censado',
  `nombre_fiscal` varchar(256) NOT NULL,
  `cif` varchar(50) DEFAULT NULL,
  `direccion` varchar(256) NOT NULL,
  `cp` varchar(10) DEFAULT NULL,
  `cod_pais` varchar(2) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `currencyToDisplay` varchar(3) NOT NULL DEFAULT 'EUR',
  `lost_password_request` tinyint NOT NULL DEFAULT '0',
  `lost_password_timestamp` timestamp NULL DEFAULT NULL,
  `activation_token` varchar(256) NOT NULL,
  `activo` tinyint DEFAULT '0',
  `guest` tinyint NOT NULL DEFAULT '0',
  `sign_up_stamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_at` timestamp NOT NULL,
  `last_sign_in_stamp` timestamp NULL DEFAULT NULL,
  `deleted_by` varchar(255) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `newsletter` tinyint DEFAULT '1',
  `nuevasCondicionesEnviadas` int NOT NULL DEFAULT '0' COMMENT '1. Si 0 No ',
  `admin_validation_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_usuario_agencia` (`id_agencia`)
) ENGINE=InnoDB AUTO_INCREMENT=99546 DEFAULT CHARSET=utf8mb3
```

### `agencias_usuarios_ventas`

**Usado por:**
- `new-admin`: (`app/Models/AgencyUserSale.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_usuario | int | NO | MUL | NULL |  |
| id_producto | varchar(32) | YES | MUL | NULL |  |
| type | int | NO |  | NULL |  |
| descuento | decimal(38,2) | YES |  | NULL |  |
| wallet_move_key | varchar(128) | YES |  | NULL |  |
| venta_afiliado | tinyint | NO |  | 0 |  |
| cmp | varchar(250) | YES |  | NULL |  |
| referal | text | YES |  | NULL |  |
| tipo_pago | tinyint | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| id_producto-type | BTREE | id_producto, type | Sí |
| idx_agencias_usuarios_ventas_user_type_booking | BTREE | id_usuario, id_producto, type | No |
| idx_agencias_ususarios_ventas_id_producto_type | BTREE | id_producto, type | No |

#### DDL

```sql
CREATE TABLE `agencias_usuarios_ventas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `id_producto` varchar(32) DEFAULT NULL,
  `type` int NOT NULL COMMENT '1- Actividad 2- Traslado',
  `descuento` decimal(38,2) DEFAULT NULL,
  `wallet_move_key` varchar(128) DEFAULT NULL,
  `venta_afiliado` tinyint NOT NULL DEFAULT '0',
  `cmp` varchar(250) DEFAULT NULL,
  `referal` text,
  `tipo_pago` tinyint DEFAULT NULL COMMENT '0 - PVP, 1 - NETO',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_producto-type` (`id_producto`,`type`),
  KEY `idx_agencias_ususarios_ventas_id_producto_type` (`id_producto`,`type`),
  KEY `idx_agencias_usuarios_ventas_user_type_booking` (`id_usuario`,`id_producto`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4051448 DEFAULT CHARSET=utf8mb3
```

### `agencias_usuarios_ventas_comisiones`

**Usado por:**
- `new-admin`: (`app/Models/AgencySalesCommision.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_agencia | int | NO | MUL | NULL |  |
| id_usuario | int | NO |  | NULL |  |
| id_producto | int | NO | MUL | NULL |  |
| type | int | NO |  | NULL |  |
| tipo_comision | int | NO |  | 1 |  |
| descuento | float | YES |  | 0 |  |
| importe_a_wallet | float | YES |  | 0 |  |
| divisa | varchar(3) | NO |  | NULL |  |
| fecha_aplicacion | timestamp | YES |  | NULL |  |
| wallet_move_key | varchar(128) | YES | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| agencias_usuarios_ventas_comisiones_id_agencia_IDX | BTREE | id_agencia | No |
| idx_auvc_id_producto_type | BTREE | id_producto, type | No |
| idx_auvc_wallet_move_key | BTREE | wallet_move_key | No |

#### DDL

```sql
CREATE TABLE `agencias_usuarios_ventas_comisiones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_agencia` int NOT NULL,
  `id_usuario` int NOT NULL,
  `id_producto` int NOT NULL,
  `type` int NOT NULL COMMENT '1- Actividad 2- Traslado',
  `tipo_comision` int NOT NULL DEFAULT '1' COMMENT '1.- Venta PVP 2.- Venta afiliado',
  `descuento` float DEFAULT '0' COMMENT '% del importe de la reserva que irá al wallet',
  `importe_a_wallet` float DEFAULT '0',
  `divisa` varchar(3) NOT NULL,
  `fecha_aplicacion` timestamp NULL DEFAULT NULL,
  `wallet_move_key` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_auvc_id_producto_type` (`id_producto`,`type`),
  KEY `agencias_usuarios_ventas_comisiones_id_agencia_IDX` (`id_agencia`),
  KEY `idx_auvc_wallet_move_key` (`wallet_move_key`)
) ENGINE=InnoDB AUTO_INCREMENT=393995 DEFAULT CHARSET=utf8mb3
```

### `agencies_comments`

**Usado por:**
- `new-admin`: (`app/Models/AgencyComment.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| comment | text | NO |  | NULL |  |
| date | date | NO |  | NULL |  |
| agency_id | int | NO |  | NULL |  |
| admin_user_id | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `agencies_comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comment` text NOT NULL,
  `date` date NOT NULL,
  `agency_id` int NOT NULL,
  `admin_user_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6906 DEFAULT CHARSET=utf8mb3
```

### `agencies_followups`

**Usado por:**
- `new-admin`: (`app/Models/AgencyFollowup.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| agency_id | int | NO |  | NULL |  |
| user_id | int | NO |  | NULL |  |
| followup_type | tinyint | NO |  | NULL |  |
| contact_name | varchar(32) | NO |  | NULL |  |
| contact_date | date | NO |  | NULL |  |
| comments | varchar(200) | NO |  | NULL |  |
| new_followup_date | date | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `agencies_followups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `agency_id` int NOT NULL,
  `user_id` int NOT NULL,
  `followup_type` tinyint NOT NULL COMMENT '1 - Llamada, 2 - Visita, 3 - Evento, 4 - Email, 5 - otros',
  `contact_name` varchar(32) NOT NULL,
  `contact_date` date NOT NULL,
  `comments` varchar(200) NOT NULL,
  `new_followup_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `agencies_referral_clicks`

**Usado por:**
- `new-admin`: (`app/Models/AgencyReferralClick.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| agency_id | int | NO | MUL | NULL |  |
| date | date | NO |  | NULL |  |
| clicks | int | NO |  | NULL |  |
| referral_url | text | YES |  | NULL |  |
| cmp | varchar(256) | YES |  | NULL |  |
| linked_id | int | YES |  | NULL |  |
| linked_type | int | YES |  | NULL |  |
| origin | int | YES |  | NULL |  |
| origin_type | varchar(255) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_agencies_referral_campaigns_stats | BTREE | agency_id, date, cmp | No |
| idx_agencies_referral_clicks_stats | BTREE | agency_id, date | No |

#### DDL

```sql
CREATE TABLE `agencies_referral_clicks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `agency_id` int NOT NULL,
  `date` date NOT NULL,
  `clicks` int NOT NULL,
  `referral_url` text,
  `cmp` varchar(256) DEFAULT NULL,
  `linked_id` int DEFAULT NULL,
  `linked_type` int DEFAULT NULL,
  `origin` int DEFAULT NULL COMMENT '1-Web, 2-App',
  `origin_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_agencies_referral_clicks_stats` (`agency_id`,`date`),
  KEY `idx_agencies_referral_campaigns_stats` (`agency_id`,`date`,`cmp`(255))
) ENGINE=InnoDB AUTO_INCREMENT=1624561 DEFAULT CHARSET=utf8mb3
```

### `albums`

**Usado por:**
- `new-admin`: (`app/Models/Album.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCiudad | int | NO | MUL | NULL |  |
| titulo | varchar(128) | NO |  | NULL |  |
| url | varchar(32) | NO |  | NULL |  |
| orden | int | NO |  | NULL |  |
| header | text | YES |  | NULL |  |
| footer | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idCiudad | BTREE | idCiudad, url | Sí |

#### DDL

```sql
CREATE TABLE `albums` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCiudad` int NOT NULL,
  `titulo` varchar(128) NOT NULL,
  `url` varchar(32) NOT NULL,
  `orden` int NOT NULL,
  `header` text,
  `footer` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idCiudad` (`idCiudad`,`url`)
) ENGINE=InnoDB AUTO_INCREMENT=206 DEFAULT CHARSET=utf8mb3
```

### `albums_master`

**Usado por:**
- `new-admin`: (`app/Models/AlbumMaster.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCiudad | int | NO |  | NULL |  |
| orden | int | NO |  | NULL |  |
| titulo | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `albums_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCiudad` int NOT NULL,
  `orden` int NOT NULL,
  `titulo` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=549 DEFAULT CHARSET=utf8mb3
```

### `albums_translations`

**Usado por:**
- `new-admin`: (`app/Models/AlbumTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterAlbum | int | NO | MUL | NULL |  |
| idioma | varchar(2) | NO |  | NULL |  |
| url | varchar(64) | NO |  | NULL |  |
| header | text | YES |  | NULL |  |
| footer | text | YES |  | NULL |  |
| titulo | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_albums_translations_idMasterAlbum_idioma | BTREE | idMasterAlbum, idioma | No |

#### DDL

```sql
CREATE TABLE `albums_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterAlbum` int NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `url` varchar(64) NOT NULL,
  `header` text,
  `footer` text,
  `titulo` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_albums_translations_idMasterAlbum_idioma` (`idMasterAlbum`,`idioma`)
) ENGINE=InnoDB AUTO_INCREMENT=3252 DEFAULT CHARSET=utf8mb3
```

### `alojamientos_categorias`

**Usado por:**
- `new-admin`: (`app/Models/AccommodationCategories.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| label | varchar(250) | NO |  | NULL |  |
| nombre | varchar(250) | NO |  | NULL |  |
| active | tinyint | NO |  | 1 |  |
| orden | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `alojamientos_categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label` varchar(250) NOT NULL,
  `nombre` varchar(250) NOT NULL,
  `active` tinyint NOT NULL DEFAULT '1' COMMENT 'category active or not. Defaults to 1 (yes)',
  `orden` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3
```

### `alternative_activities`

**Usado por:**
- `new-admin`: (`app/Models/ActivityAlternative.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | NO | MUL | NULL |  |
| activity_id_alt | int | NO | MUL | NULL |  |
| type | int | NO | MUL | NULL |  |
| subtype | int | YES | MUL | NULL |  |
| active | tinyint(1) | NO |  | 1 |  |
| priority | int | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_alternative_activities_activity_id | BTREE | activity_id | No |
| fk_alternative_activities_activity_id_alt | BTREE | activity_id_alt | No |
| fk_alternative_activities_subtype | BTREE | subtype | No |
| fk_alternative_activities_type | BTREE | type | No |

#### DDL

```sql
CREATE TABLE `alternative_activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int NOT NULL,
  `activity_id_alt` int NOT NULL,
  `type` int NOT NULL,
  `subtype` int DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `priority` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_alternative_activities_activity_id` (`activity_id`),
  KEY `fk_alternative_activities_activity_id_alt` (`activity_id_alt`),
  KEY `fk_alternative_activities_type` (`type`),
  KEY `fk_alternative_activities_subtype` (`subtype`),
  CONSTRAINT `fk_alternative_activities_activity_id` FOREIGN KEY (`activity_id`) REFERENCES `actividades` (`id`),
  CONSTRAINT `fk_alternative_activities_activity_id_alt` FOREIGN KEY (`activity_id_alt`) REFERENCES `actividades` (`id`),
  CONSTRAINT `fk_alternative_activities_subtype` FOREIGN KEY (`subtype`) REFERENCES `alternative_activities_types` (`id`),
  CONSTRAINT `fk_alternative_activities_type` FOREIGN KEY (`type`) REFERENCES `alternative_activities_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1703 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `alternative_activities_types`

**Usado por:**
- `new-admin`: (`app/Models/AlternativeActivitiesType.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| parent_type | int | YES |  | NULL |  |
| description | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `alternative_activities_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_type` int DEFAULT NULL,
  `description` text COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `answers_additional_questions`

**Usado por:**
- `new-admin`: (`app/Models/AnswerAdditionalQuestion.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_question | int | NO |  | NULL |  |
| answer | text | NO |  | NULL |  |
| orden | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `answers_additional_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_question` int NOT NULL,
  `answer` text NOT NULL,
  `orden` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=139662 DEFAULT CHARSET=utf8mb3
```

### `antifraud_checks`

**Usado por:**
- `new-admin`: (`app/Models/AntifraudCheck.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(255) | NO |  | NULL |  |
| description | text | YES |  | NULL |  |
| enabled | tinyint | NO |  | 1 |  |
| score_pass | int | NO |  | 0 |  |
| score_fail | int | NO |  | 20 |  |
| score_notrun | int | NO |  | 10 |  |
| weight | double | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `antifraud_checks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `enabled` tinyint NOT NULL DEFAULT '1',
  `score_pass` int NOT NULL DEFAULT '0',
  `score_fail` int NOT NULL DEFAULT '20',
  `score_notrun` int NOT NULL DEFAULT '10',
  `weight` double NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3
```

### `antifraud_checks_params`

**Usado por:**
- `new-admin`: (`app/Models/AntifraudCheckParam.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| check_id | int | NO | MUL | NULL |  |
| param | varchar(255) | NO |  | NULL |  |
| description | text | YES |  | NULL |  |
| type | varchar(255) | NO |  | NULL |  |
| value | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| antifraud_checks_params_check_fk | BTREE | check_id | No |

#### DDL

```sql
CREATE TABLE `antifraud_checks_params` (
  `id` int NOT NULL AUTO_INCREMENT,
  `check_id` int NOT NULL,
  `param` varchar(255) NOT NULL,
  `description` text,
  `type` varchar(255) NOT NULL COMMENT 'INT/BOOL/FLOAT/TEXT/JSON',
  `value` text COMMENT 'se parseara al tipo determinado',
  PRIMARY KEY (`id`),
  KEY `antifraud_checks_params_check_fk` (`check_id`),
  CONSTRAINT `antifraud_checks_params_check_fk` FOREIGN KEY (`check_id`) REFERENCES `antifraud_checks` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb3
```

### `antifraud_entities`

**Usado por:**
- `new-admin`: (`app/Models/AntifraudEntity.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| value | varchar(255) | NO |  | NULL |  |
| value_type | varchar(255) | NO |  | NULL |  |
| list_type | tinyint | NO |  | NULL |  |
| valid_until | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `antifraud_entities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL,
  `value_type` varchar(255) NOT NULL,
  `list_type` tinyint NOT NULL COMMENT 'boolean 1 = white, 0 = black',
  `valid_until` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3
```

### `api_partners`

**Usado por:**
- `new-admin`: (`app/Models/ApiPartner.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| code | varchar(32) | NO |  | NULL |  |
| name | varchar(128) | NO |  | NULL |  |
| active | tinyint | NO |  | 1 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `api_partners` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL,
  `name` varchar(128) NOT NULL,
  `active` tinyint NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3
```

### `api_user`

**Usado por:**
- `new-admin`: (`app/Models/ApiUser.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(256) | NO |  | NULL |  |
| display_name | varchar(256) | NO |  | NULL |  |
| header | text | NO |  | NULL |  |
| footer | text | NO |  | NULL |  |
| username | varchar(256) | NO |  | NULL |  |
| password | varchar(256) | NO |  | NULL |  |
| debug_enabled | tinyint | NO |  | 0 |  |
| active | tinyint | NO |  | 0 |  |
| entity_type | varchar(20) | NO |  | NULL |  |
| entity_id | int | NO |  | NULL |  |
| return_url | text | YES |  | NULL |  |
| use_net_prices | tinyint | NO |  | 0 |  |
| partner_id | int | YES |  | NULL |  |
| share_copyright_images | tinyint | NO |  | 0 |  |
| share_activities_with_dynamic_prices | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `api_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `display_name` varchar(256) NOT NULL,
  `header` text NOT NULL,
  `footer` text NOT NULL,
  `username` varchar(256) NOT NULL,
  `password` varchar(256) NOT NULL,
  `debug_enabled` tinyint NOT NULL DEFAULT '0' COMMENT 'Debug is active for API requests. Defaults to 0 (no)',
  `active` tinyint NOT NULL DEFAULT '0' COMMENT 'API user is active or not. Defaults to 0 (no)',
  `entity_type` varchar(20) NOT NULL COMMENT 'AF - Afiliado, AG - Agencia',
  `entity_id` int NOT NULL,
  `return_url` text,
  `use_net_prices` tinyint NOT NULL DEFAULT '0' COMMENT '0.- NO se muestra el precio neto 1.- Se muestra el precio neto',
  `partner_id` int DEFAULT NULL,
  `share_copyright_images` tinyint NOT NULL DEFAULT '0' COMMENT '1 - Si, 0 - No',
  `share_activities_with_dynamic_prices` tinyint NOT NULL DEFAULT '1' COMMENT '1 - Si, 0 - No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1212 DEFAULT CHARSET=utf8mb3 COMMENT='The API users - Civitatis'
```

### `api_user_allow_domain`

**Usado por:**
- `new-admin`: (`app/Models/ApiUserAllowDomain.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| api_user_id | int | NO |  | NULL |  |
| domain | varchar(45) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `api_user_allow_domain` (
  `id` int NOT NULL AUTO_INCREMENT,
  `api_user_id` int NOT NULL,
  `domain` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `api_user_allow_email`

**Usado por:**
- `new-admin`: (`app/Models/ApiUserAllowEmail.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| api_user_id | int | NO |  | NULL |  |
| email | varchar(45) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `api_user_allow_email` (
  `id` int NOT NULL AUTO_INCREMENT,
  `api_user_id` int NOT NULL,
  `email` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `api_user_changelog`

**Usado por:**
- `new-admin`: (`app/Models/ApiUserChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| api_user_id | int | NO |  | NULL |  |
| field | varchar(32) | NO |  | NULL |  |
| old_value | text | NO |  | NULL |  |
| new_value | text | NO |  | NULL |  |
| user_id | int | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `api_user_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `api_user_id` int NOT NULL,
  `field` varchar(32) NOT NULL,
  `old_value` text NOT NULL,
  `new_value` text NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb3
```

### `api_usuarios_ventas`

**Usado por:**
- `new-admin`: (`app/Models/ApiUserSale.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_usuario | int | NO |  | NULL |  |
| id_producto | int | NO |  | NULL |  |
| type | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `api_usuarios_ventas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `id_producto` int NOT NULL,
  `type` int NOT NULL COMMENT '1- Actividad 2- Traslado',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `app_notification`

**Usado por:**
- `new-admin`: (`app/Models/AppNotification.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| title | blob | NO |  | NULL |  |
| body | blob | NO |  | NULL |  |
| date | datetime | NO |  | NULL |  |
| lang | varchar(3) | NO |  | NULL |  |
| send | int | NO |  | 0 |  |
| fail | int | NO |  | 0 |  |
| total | int | NO |  | 0 |  |
| status | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `app_notification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` blob NOT NULL,
  `body` blob NOT NULL,
  `date` datetime NOT NULL,
  `lang` varchar(3) NOT NULL,
  `send` int NOT NULL DEFAULT '0',
  `fail` int NOT NULL DEFAULT '0',
  `total` int NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `app_notification_token`

**Usado por:**
- `new-admin`: (`app/Models/AppNotificationToken.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| date | datetime | NO |  | NULL |  |
| token | varchar(250) | NO |  | NULL |  |
| provider | tinyint | NO |  | NULL |  |
| app_notification | int | NO |  | NULL |  |
| status | tinyint | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `app_notification_token` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `token` varchar(250) NOT NULL,
  `provider` tinyint NOT NULL,
  `app_notification` int NOT NULL,
  `status` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `app_token`

**Usado por:**
- `new-admin`: (`app/Models/AppToken.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| email | varchar(255) | YES |  | NULL |  |
| token | varchar(255) | YES | UNI | NULL |  |
| lang | char(3) | YES |  | NULL |  |
| provider | tinyint | YES |  | NULL |  |
| id | int | NO | PRI | NULL | auto_increment |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| unique_app_token | BTREE | token | Sí |

#### DDL

```sql
CREATE TABLE `app_token` (
  `email` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `lang` char(3) DEFAULT NULL,
  `provider` tinyint DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_app_token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `app_user_performance`

**Usado por:**
- `new-admin`: (`app/Models/AppUserPerformance.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| token | varchar(255) | NO | PRI | NULL |  |
| lang | varchar(3) | NO |  | NULL |  |
| platform | varchar(10) | NO |  | NULL |  |
| date | date | YES |  | NULL |  |
| version_app | varchar(45) | NO |  | NULL |  |
| locale | varchar(3) | NO |  | NULL |  |
| total | int | NO |  | 1 |  |
| active | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | token | Sí |

#### DDL

```sql
CREATE TABLE `app_user_performance` (
  `token` varchar(255) NOT NULL,
  `lang` varchar(3) NOT NULL,
  `platform` varchar(10) NOT NULL,
  `date` date DEFAULT NULL,
  `version_app` varchar(45) NOT NULL,
  `locale` varchar(3) NOT NULL,
  `total` int NOT NULL DEFAULT '1',
  `active` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Comprobacion de instalaciones activas de apps'
```

### `autofacturas_afiliados`

**Usado por:**
- `new-admin`: (`app/Models/AffiliateAutoInvoice.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_factura | varchar(256) | YES |  | NULL |  |
| id_afiliado | int | NO |  | NULL |  |
| total | double | NO |  | NULL |  |
| base_imponible | double | NO |  | 0 |  |
| iva | double | YES |  | 0 |  |
| irpf | double | YES |  | 0 |  |
| tipo_irpf | double | YES |  | 0 |  |
| tipo_impositivo | double | YES |  | 0 |  |
| divisa | varchar(4) | NO |  | NULL |  |
| concepto | text | NO |  | NULL |  |
| tipo_identificacion | varchar(3) | NO |  | NULL |  |
| identificacion | varchar(50) | NO |  | NULL |  |
| pais | varchar(2) | NO |  | NULL |  |
| nombre_razon | varchar(256) | NO |  | NULL |  |
| ciudad | varchar(100) | NO |  | NULL |  |
| cp | varchar(10) | NO |  | NULL |  |
| direccion | text | NO |  | NULL |  |
| fecha_envio | datetime | YES |  | NULL |  |
| estado | int | NO |  | 0 |  |
| pagada | int | NO |  | 0 |  |
| csv | varchar(50) | YES |  | NULL |  |
| codigo_error | varchar(20) | YES |  | NULL |  |
| error | text | YES |  | NULL |  |
| regimen_especial | varchar(3) | NO |  | NULL |  |
| tipo_operacion_sujeta | text | NO |  | NULL |  |
| fecha_factura | date | NO |  | NULL |  |
| tipo_factura | varchar(3) | NO |  | NULL |  |
| id_factura_master | int | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| status_pdf | tinyint | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `autofacturas_afiliados` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_factura` varchar(256) DEFAULT NULL,
  `id_afiliado` int NOT NULL,
  `total` double NOT NULL,
  `base_imponible` double NOT NULL DEFAULT '0',
  `iva` double DEFAULT '0',
  `irpf` double DEFAULT '0',
  `tipo_irpf` double DEFAULT '0',
  `tipo_impositivo` double DEFAULT '0',
  `divisa` varchar(4) NOT NULL,
  `concepto` text NOT NULL,
  `tipo_identificacion` varchar(3) NOT NULL,
  `identificacion` varchar(50) NOT NULL,
  `pais` varchar(2) NOT NULL,
  `nombre_razon` varchar(256) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `cp` varchar(10) NOT NULL,
  `direccion` text NOT NULL,
  `fecha_envio` datetime DEFAULT NULL,
  `estado` int NOT NULL DEFAULT '0',
  `pagada` int NOT NULL DEFAULT '0' COMMENT '0 Sin pagar 1 Pagada',
  `csv` varchar(50) DEFAULT NULL,
  `codigo_error` varchar(20) DEFAULT NULL,
  `error` text,
  `regimen_especial` varchar(3) NOT NULL,
  `tipo_operacion_sujeta` text NOT NULL,
  `fecha_factura` date NOT NULL,
  `tipo_factura` varchar(3) NOT NULL,
  `id_factura_master` int DEFAULT NULL,
  `orden` int DEFAULT NULL,
  `status_pdf` tinyint DEFAULT '0' COMMENT '0 - No disponible, 1 - Disponible',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb3 COMMENT='Autofacturas afiliados'
```

### `autofacturas_agencias`

**Usado por:**
- `new-admin`: (`app/Models/AgencyAutoInvoice.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_factura | varchar(256) | YES |  | NULL |  |
| iva | double | NO |  | 0 |  |
| tipo_impositivo | double | NO |  | 0 |  |
| total | double | NO |  | NULL |  |
| base_imponible | double | NO |  | NULL |  |
| concepto | text | NO |  | NULL |  |
| tipo_identificacion | varchar(3) | NO |  | NULL |  |
| identificacion | varchar(50) | NO |  | NULL |  |
| pais | varchar(2) | NO |  | NULL |  |
| nombre_razon | varchar(256) | NO |  | NULL |  |
| ciudad | varchar(100) | NO |  | NULL |  |
| cp | varchar(10) | NO |  | NULL |  |
| direccion | text | NO |  | NULL |  |
| fecha_envio | datetime | YES |  | NULL |  |
| estado | int | NO |  | 0 |  |
| csv | varchar(50) | YES |  | NULL |  |
| codigo_error | varchar(20) | YES |  | NULL |  |
| error | text | YES |  | NULL |  |
| regimen_especial | varchar(3) | NO |  | NULL |  |
| tipo_operacion_sujeta | text | NO |  | NULL |  |
| expediente_agencia | text | YES |  | NULL |  |
| fecha_factura | date | NO |  | NULL |  |
| tipo_factura | varchar(3) | NO |  | NULL |  |
| id_agencia | int | NO |  | NULL |  |
| id_servicio | int | NO | MUL | NULL |  |
| tipo_servicio | int | NO |  | NULL |  |
| id_factura_master | int | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| navision_status | tinyint | YES |  | 0 |  |
| email_sent | tinyint(1) | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_autofacturas_agencias | BTREE | id_servicio, tipo_servicio | No |

#### DDL

```sql
CREATE TABLE `autofacturas_agencias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_factura` varchar(256) DEFAULT NULL,
  `iva` double NOT NULL DEFAULT '0',
  `tipo_impositivo` double NOT NULL DEFAULT '0',
  `total` double NOT NULL,
  `base_imponible` double NOT NULL,
  `concepto` text NOT NULL,
  `tipo_identificacion` varchar(3) NOT NULL,
  `identificacion` varchar(50) NOT NULL,
  `pais` varchar(2) NOT NULL,
  `nombre_razon` varchar(256) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `cp` varchar(10) NOT NULL,
  `direccion` text NOT NULL,
  `fecha_envio` datetime DEFAULT NULL,
  `estado` int NOT NULL DEFAULT '0',
  `csv` varchar(50) DEFAULT NULL,
  `codigo_error` varchar(20) DEFAULT NULL,
  `error` text,
  `regimen_especial` varchar(3) NOT NULL,
  `tipo_operacion_sujeta` text NOT NULL,
  `expediente_agencia` text,
  `fecha_factura` date NOT NULL,
  `tipo_factura` varchar(3) NOT NULL,
  `id_agencia` int NOT NULL,
  `id_servicio` int NOT NULL,
  `tipo_servicio` int NOT NULL,
  `id_factura_master` int DEFAULT NULL,
  `orden` int DEFAULT NULL,
  `navision_status` tinyint DEFAULT '0' COMMENT '0. Pendiente de consultar estado. 1. Consultado y existente.',
  `email_sent` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_autofacturas_agencias` (`id_servicio`,`tipo_servicio`)
) ENGINE=InnoDB AUTO_INCREMENT=3681204 DEFAULT CHARSET=utf8mb3 COMMENT='Autofacturas agencias'
```

### `autofacturas_alojamientos`

**Usado por:**
- `new-admin`: (`app/Models/AutoInvoicesAccommodations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_factura | varchar(256) | YES |  | NULL |  |
| id_alojamiento | int | NO |  | NULL |  |
| total | double | NO |  | NULL |  |
| base_imponible | double | YES |  | 0 |  |
| iva | double | YES |  | 0 |  |
| irpf | double | YES |  | 0 |  |
| tipo_irpf | double | YES |  | 0 |  |
| tipo_impositivo | double | NO |  | 0 |  |
| divisa | varchar(4) | NO |  | NULL |  |
| concepto | text | NO |  | NULL |  |
| tipo_identificacion | varchar(3) | NO |  | NULL |  |
| identificacion | varchar(50) | NO |  | NULL |  |
| cod_pais | varchar(2) | NO |  | NULL |  |
| nombre_razon | varchar(256) | NO |  | NULL |  |
| ciudad | varchar(100) | NO |  | NULL |  |
| cp | varchar(10) | NO |  | NULL |  |
| direccion | text | NO |  | NULL |  |
| fecha_envio | datetime | YES |  | NULL |  |
| estado | int | NO |  | 0 |  |
| pagada | int | NO |  | 0 |  |
| csv | varchar(50) | YES |  | NULL |  |
| codigo_error | varchar(20) | YES |  | NULL |  |
| error | text | YES |  | NULL |  |
| regimen_especial | varchar(3) | NO |  | NULL |  |
| tipo_operacion_sujeta | text | NO |  | NULL |  |
| fecha_factura | date | NO |  | NULL |  |
| tipo_factura | varchar(3) | NO |  | NULL |  |
| id_factura_master | int | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| status_pdf | tinyint(1) | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `autofacturas_alojamientos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_factura` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `id_alojamiento` int NOT NULL,
  `total` double NOT NULL,
  `base_imponible` double DEFAULT '0',
  `iva` double DEFAULT '0',
  `irpf` double DEFAULT '0',
  `tipo_irpf` double DEFAULT '0',
  `tipo_impositivo` double NOT NULL DEFAULT '0',
  `divisa` varchar(4) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `concepto` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `tipo_identificacion` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `identificacion` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `cod_pais` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `nombre_razon` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `ciudad` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `cp` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `direccion` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `fecha_envio` datetime DEFAULT NULL,
  `estado` int NOT NULL DEFAULT '0',
  `pagada` int NOT NULL DEFAULT '0' COMMENT '0 Sin pagar 1 Pagada',
  `csv` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `codigo_error` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `error` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `regimen_especial` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `tipo_operacion_sujeta` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `fecha_factura` date NOT NULL,
  `tipo_factura` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `id_factura_master` int DEFAULT NULL,
  `orden` int DEFAULT NULL,
  `status_pdf` tinyint(1) DEFAULT '0' COMMENT '0 - No disponible, 1 - Disponible',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Autofacturas afiliados'
```

### `auto_reports`

**Usado por:**
- `new-admin`: (`app/Models/AutoReports.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| tag | varchar(250) | NO | UNI | NULL |  |
| title | varchar(250) | NO |  | NULL |  |
| description | varchar(250) | NO |  | NULL |  |
| query | longtext | NO |  | NULL |  |
| metadata | longtext | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| tag | BTREE | tag | Sí |

#### DDL

```sql
CREATE TABLE `auto_reports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tag` varchar(250) NOT NULL,
  `title` varchar(250) NOT NULL,
  `description` varchar(250) NOT NULL,
  `query` longtext NOT NULL,
  `metadata` longtext,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag` (`tag`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb3
```

### `b2b_categories`

**Usado por:**
- `new-admin`: (`app/Models/AffiliateCategory.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| parent_id | int | YES | MUL | NULL |  |
| label | varchar(250) | NO |  | NULL |  |
| name | varchar(250) | NO |  | NULL |  |
| is_partnership | tinyint(1) | NO |  | 0 |  |
| is_form_visible | tinyint(1) | NO |  | 1 |  |
| active | tinyint(1) | YES |  | 1 |  |
| order | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| b2b_category_parent_id | BTREE | parent_id | No |

#### DDL

```sql
CREATE TABLE `b2b_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int DEFAULT NULL,
  `label` varchar(250) NOT NULL,
  `name` varchar(250) NOT NULL,
  `is_partnership` tinyint(1) NOT NULL DEFAULT '0',
  `is_form_visible` tinyint(1) NOT NULL DEFAULT '1',
  `active` tinyint(1) DEFAULT '1',
  `order` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `b2b_category_parent_id` (`parent_id`),
  CONSTRAINT `b2b_category_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `b2b_categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb3
```

### `b2b_categories_relations`

**Usado por:**
- `new-admin`: (`app/Models/B2bCategoryRelation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| b2b_category_id | int | NO | MUL | NULL |  |
| entity | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| b2b_category_id | BTREE | b2b_category_id | No |

#### DDL

```sql
CREATE TABLE `b2b_categories_relations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `b2b_category_id` int NOT NULL,
  `entity` int NOT NULL COMMENT '1 - AFFILIATE 2 - AGENCY 3 - ACCOMMODATION',
  PRIMARY KEY (`id`),
  KEY `b2b_category_id` (`b2b_category_id`),
  CONSTRAINT `b2b_category_id` FOREIGN KEY (`b2b_category_id`) REFERENCES `b2b_categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb3
```

### `b2b_promotion`

**Usado por:**
- `new-admin`: (`app/Models/B2bPromotion.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int unsigned | NO | PRI | NULL | auto_increment |
| type | tinyint unsigned | NO | MUL | NULL |  |
| entity_type | tinyint unsigned | NO | MUL | NULL |  |
| status | tinyint unsigned | NO |  | 0 |  |
| start_date | date | NO |  | NULL |  |
| end_date | date | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_b2b_promotion_entity_type_start_date_end_date | BTREE | entity_type, start_date, end_date | No |
| idx_b2b_promotion_type_status | BTREE | type, status | No |

#### DDL

```sql
CREATE TABLE `b2b_promotion` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint unsigned NOT NULL,
  `entity_type` tinyint unsigned NOT NULL,
  `status` tinyint unsigned NOT NULL DEFAULT '0',
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_b2b_promotion_entity_type_start_date_end_date` (`entity_type`,`start_date`,`end_date`),
  KEY `idx_b2b_promotion_type_status` (`type`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `b2b_promotion_audience_filter`

**Usado por:**
- `new-admin`: (`app/Models/B2bPromotionAudienceFilter.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int unsigned | NO | PRI | NULL | auto_increment |
| promotion_id | int unsigned | NO | MUL | NULL |  |
| entity_type | tinyint unsigned | NO | MUL | NULL |  |
| entity_id | int unsigned | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_b2b_promotion_audience_filter_entity_type_entity_id | BTREE | entity_type, entity_id | No |
| idx_b2b_promotion_audience_filter_promotion_id | BTREE | promotion_id | No |

#### DDL

```sql
CREATE TABLE `b2b_promotion_audience_filter` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `promotion_id` int unsigned NOT NULL,
  `entity_type` tinyint unsigned NOT NULL,
  `entity_id` int unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_b2b_promotion_audience_filter_promotion_id` (`promotion_id`),
  KEY `idx_b2b_promotion_audience_filter_entity_type_entity_id` (`entity_type`,`entity_id`),
  CONSTRAINT `fk_b2b_promotion_audience_filter_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `b2b_promotion` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `b2b_promotion_audience_rule`

**Usado por:**
- `new-admin`: (`app/Models/B2bPromotionAudienceRule.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int unsigned | NO | PRI | NULL | auto_increment |
| promotion_id | int unsigned | NO | MUL | NULL |  |
| filter_type | varchar(50) | NO | MUL | NULL |  |
| filter_value | varchar(255) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_b2b_promo_audience_rule_filter_type_value | BTREE | filter_type, filter_value | No |
| idx_b2b_promo_audience_rule_promotion_id | BTREE | promotion_id | No |
| uq_b2b_promo_audience_rule_promo_type_value | BTREE | promotion_id, filter_type, filter_value | Sí |

#### DDL

```sql
CREATE TABLE `b2b_promotion_audience_rule` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `promotion_id` int unsigned NOT NULL,
  `filter_type` varchar(50) COLLATE utf8mb3_unicode_ci NOT NULL,
  `filter_value` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_b2b_promo_audience_rule_promo_type_value` (`promotion_id`,`filter_type`,`filter_value`),
  KEY `idx_b2b_promo_audience_rule_promotion_id` (`promotion_id`),
  KEY `idx_b2b_promo_audience_rule_filter_type_value` (`filter_type`,`filter_value`),
  CONSTRAINT `fk_b2b_promotion_audience_rule_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `b2b_promotion` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `b2b_promotion_raffle`

**Usado por:**
- `new-admin`: (`app/Models/B2bPromotionRaffle.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int unsigned | NO | PRI | NULL | auto_increment |
| promotion_id | int unsigned | NO | UNI | NULL |  |
| objective_target | int unsigned | NO |  | 0 |  |
| objective_type | tinyint unsigned | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| uq_b2b_promotion_raffle_promotion_id | BTREE | promotion_id | Sí |

#### DDL

```sql
CREATE TABLE `b2b_promotion_raffle` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `promotion_id` int unsigned NOT NULL,
  `objective_target` int unsigned NOT NULL DEFAULT '0',
  `objective_type` tinyint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_b2b_promotion_raffle_promotion_id` (`promotion_id`),
  CONSTRAINT `fk_b2b_promotion_raffle_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `b2b_promotion` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `b2b_promotion_raffle_progress`

**Usado por:**
- `new-admin`: (`app/Models/B2bPromotionRaffleProgress.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int unsigned | NO | PRI | NULL | auto_increment |
| raffle_id | int unsigned | NO | MUL | NULL |  |
| entity_type | tinyint unsigned | NO | MUL | NULL |  |
| entity_id | int unsigned | NO |  | NULL |  |
| current_progress | int unsigned | NO |  | 0 |  |
| updated_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_b2b_promotion_raffle_progress_entity_type_entity_id | BTREE | entity_type, entity_id | No |
| uq_b2b_promotion_raffle_progress_raffle_id_entity_type_entity_id | BTREE | raffle_id, entity_type, entity_id | Sí |

#### DDL

```sql
CREATE TABLE `b2b_promotion_raffle_progress` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `raffle_id` int unsigned NOT NULL,
  `entity_type` tinyint unsigned NOT NULL,
  `entity_id` int unsigned NOT NULL,
  `current_progress` int unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_b2b_promotion_raffle_progress_raffle_id_entity_type_entity_id` (`raffle_id`,`entity_type`,`entity_id`),
  KEY `idx_b2b_promotion_raffle_progress_entity_type_entity_id` (`entity_type`,`entity_id`),
  CONSTRAINT `fk_b2b_promotion_raffle_progress_raffle` FOREIGN KEY (`raffle_id`) REFERENCES `b2b_promotion_raffle` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `b2b_promotion_translation`

**Usado por:**
- `new-admin`: (`app/Models/B2bPromotionTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int unsigned | NO | PRI | NULL | auto_increment |
| promotion_id | int unsigned | NO | MUL | NULL |  |
| lang | varchar(5) | NO | MUL | NULL |  |
| title | varchar(255) | NO |  | NULL |  |
| description | text | YES |  | NULL |  |
| image_url | varchar(512) | NO |  | NULL |  |
| link | varchar(512) | YES |  | NULL |  |
| terms_url | varchar(512) | YES |  | NULL |  |
| call_to_action_url | varchar(512) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_b2b_promotion_translation_lang | BTREE | lang | No |
| uq_b2b_promotion_translation_promotion_id_lang | BTREE | promotion_id, lang | Sí |

#### DDL

```sql
CREATE TABLE `b2b_promotion_translation` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `promotion_id` int unsigned NOT NULL,
  `lang` varchar(5) COLLATE utf8mb3_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb3_unicode_ci,
  `image_url` varchar(512) COLLATE utf8mb3_unicode_ci NOT NULL,
  `link` varchar(512) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `terms_url` varchar(512) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `call_to_action_url` varchar(512) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_b2b_promotion_translation_promotion_id_lang` (`promotion_id`,`lang`),
  KEY `idx_b2b_promotion_translation_lang` (`lang`),
  CONSTRAINT `fk_b2b_promotion_translation_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `b2b_promotion` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `b2b_region_relations`

**Usado por:**
- `new-admin`: (`app/Models/B2bRegionRelation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| entity_id | int | NO |  | NULL |  |
| entity_type | tinyint | NO |  | NULL |  |
| b2b_region_id | int | NO | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_region_id | BTREE | b2b_region_id | No |

#### DDL

```sql
CREATE TABLE `b2b_region_relations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity_id` int NOT NULL COMMENT 'ID de la entidad (afiliado, agencia, alojamiento)',
  `entity_type` tinyint NOT NULL COMMENT '1 - AFFILIATE, 2 - AGENCY, 3 - ACCOMMODATION',
  `b2b_region_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_region_id` (`b2b_region_id`),
  CONSTRAINT `fk_region_id` FOREIGN KEY (`b2b_region_id`) REFERENCES `b2b_regions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `b2b_regions`

**Usado por:**
- `new-admin`: (`app/Models/B2bRegion.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| region | varchar(255) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `b2b_regions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `region` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `booking_currencies`

**Usado por:**
- `new-admin`: (`app/Models/BookingCurrency.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| booking_id | int | YES | MUL | NULL |  |
| booking_type | int | YES |  | NULL |  |
| currency | varchar(16) | YES |  | NULL |  |
| amount | float | YES |  | NULL |  |
| commission | float | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_booking_currencies_id_type_currency | BTREE | booking_id, booking_type, currency | No |

#### DDL

```sql
CREATE TABLE `booking_currencies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `booking_type` int DEFAULT NULL,
  `currency` varchar(16) DEFAULT NULL,
  `amount` float DEFAULT NULL,
  `commission` float DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_booking_currencies_id_type_currency` (`booking_id`,`booking_type`,`currency`)
) ENGINE=InnoDB AUTO_INCREMENT=56163385 DEFAULT CHARSET=utf8mb3
```

### `booking_monetary_transactions`

**Usado por:**
- `new-admin`: (`app/Models/BookingMonetaryTransaction.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| history_id | int | NO | MUL | NULL |  |
| payment_transaction_id | varchar(64) | NO | MUL | NULL |  |
| gateway | varchar(30) | NO |  | NULL |  |
| currency | varchar(3) | NO |  | NULL |  |
| xrt_payment | varchar(21) | NO |  | NULL |  |
| xrt_eur | varchar(21) | NO |  | NULL |  |
| exchange_plus | varchar(21) | YES |  | NULL |  |
| full_price_payment | varchar(30) | NO |  | NULL |  |
| full_price_without_exchange_plus | varchar(30) | NO |  | NULL |  |
| full_price_payment_with_exchange_plus | varchar(30) | NO |  | NULL |  |
| full_price_eur_with_exchange_plus | varchar(30) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| idx-booking_monetary_transactions-history_id-transaction_id | BTREE | history_id, payment_transaction_id | No |
| idx-booking_monetary_transactions-payment-transaction_id | BTREE | payment_transaction_id | No |

#### DDL

```sql
CREATE TABLE `booking_monetary_transactions` (
  `history_id` int NOT NULL,
  `payment_transaction_id` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `gateway` varchar(30) NOT NULL,
  `currency` varchar(3) NOT NULL,
  `xrt_payment` varchar(21) NOT NULL,
  `xrt_eur` varchar(21) NOT NULL,
  `exchange_plus` varchar(21) DEFAULT NULL,
  `full_price_payment` varchar(30) NOT NULL,
  `full_price_without_exchange_plus` varchar(30) NOT NULL,
  `full_price_payment_with_exchange_plus` varchar(30) NOT NULL,
  `full_price_eur_with_exchange_plus` varchar(30) NOT NULL,
  KEY `idx-booking_monetary_transactions-history_id-transaction_id` (`history_id`,`payment_transaction_id`) USING BTREE,
  KEY `idx-booking_monetary_transactions-payment-transaction_id` (`payment_transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `booking_payment_later`

**Usado por:**
- `new-admin`: (`app/Models/BookingPaymentLater.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| booking_id | int | NO | MUL | NULL |  |
| booking_type | int | NO |  | NULL |  |
| card_token | varchar(255) | YES |  | NULL |  |
| gateway_payment_id | varchar(255) | NO |  | NULL |  |
| gateway | varchar(255) | NO |  | NULL |  |
| status | int | NO |  | 0 |  |
| policy | tinyint | YES |  | NULL |  |
| config | text | NO |  | NULL |  |
| adjusted_amount | decimal(10,2) | YES |  | NULL |  |
| pending_refund_amount | decimal(10,2) | YES |  | 0.00 |  |
| pending_supplement_amount | decimal(10,2) | YES |  | 0.00 |  |
| currency | char(3) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| booking_payment_later_booking_IDX | BTREE | booking_id, booking_type | No |

#### DDL

```sql
CREATE TABLE `booking_payment_later` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `booking_type` int NOT NULL,
  `card_token` varchar(255) DEFAULT NULL,
  `gateway_payment_id` varchar(255) NOT NULL COMMENT 'Puede ser tanto el Id del wallet como el Id de la tarjeta en Adyen',
  `gateway` varchar(255) NOT NULL,
  `status` int NOT NULL DEFAULT '0' COMMENT '0 = No pagado, 1 = Pagado, 2 = Caducado, 3 = Error en el pago',
  `policy` tinyint DEFAULT NULL COMMENT 'Número de días hasta cancelar',
  `config` text NOT NULL COMMENT 'Configuración en JSON para el pago por BNPL (PCM)',
  `adjusted_amount` decimal(10,2) DEFAULT NULL,
  `pending_refund_amount` decimal(10,2) DEFAULT '0.00',
  `pending_supplement_amount` decimal(10,2) DEFAULT '0.00',
  `currency` char(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_payment_later_booking_IDX` (`booking_id`,`booking_type`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb3 COMMENT='Configuración en JSON para el pago por BNPL (PCM)'
```

### `bookings_admin_changelog`

**Usado por:**
- `new-admin`: (`app/Models/BookingAdminChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| tipo | varchar(16) | NO |  | NULL |  |
| idReserva | int | NO |  | NULL |  |
| field | varchar(32) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `bookings_admin_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(16) NOT NULL,
  `idReserva` int NOT NULL,
  `field` varchar(32) NOT NULL,
  `old_value` text,
  `new_value` text,
  `user` varchar(16) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1083 DEFAULT CHARSET=utf8mb3 COMMENT='Track the changes made in the bookings by admin'
```

### `bookings_admin_docs`

**Usado por:**
- `new-admin`: (`app/Models/BookingAdminDoc.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| booking_id | int | NO |  | NULL |  |
| type | int | NO |  | NULL |  |
| name | text | YES |  | NULL |  |
| user | varchar(32) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| filename | varchar(256) | NO |  | NULL |  |
| content_type | varchar(64) | YES |  | NULL |  |
| document_type | varchar(16) | NO |  | NULL |  |
| path | varchar(256) | NO |  | NULL |  |
| typology | int | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `bookings_admin_docs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `type` int NOT NULL COMMENT '1-Actividad 2-Traslado',
  `name` text,
  `user` varchar(32) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `filename` varchar(256) NOT NULL,
  `content_type` varchar(64) DEFAULT NULL,
  `document_type` varchar(16) NOT NULL,
  `path` varchar(256) NOT NULL,
  `typology` int NOT NULL DEFAULT '0' COMMENT '0.- Sin tipología 1.- Voucher/Bono',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3
```

### `bookings_cancellations`

**Usado por:**
- `new-admin`: (`app/Models/BookingCancellation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| bookingId | int | NO | PRI | NULL |  |
| bookingType | int | NO | PRI | NULL |  |
| agent | varchar(64) | YES |  | NULL |  |
| agentId | int | YES |  | NULL |  |
| amount | float | YES |  | NULL |  |
| amountRefunded | float | YES |  | NULL |  |
| refundCurrency | varchar(4) | YES |  | NULL |  |
| created_at | timestamp | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id, bookingId, bookingType | Sí |
| idx_bookingId-bookingType | BTREE | bookingId, bookingType | No |

#### DDL

```sql
CREATE TABLE `bookings_cancellations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookingId` int NOT NULL,
  `bookingType` int NOT NULL,
  `agent` varchar(64) DEFAULT NULL,
  `agentId` int DEFAULT NULL,
  `amount` float DEFAULT NULL,
  `amountRefunded` float DEFAULT NULL,
  `refundCurrency` varchar(4) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`bookingId`,`bookingType`),
  KEY `idx_bookingId-bookingType` (`bookingId`,`bookingType`)
) ENGINE=InnoDB AUTO_INCREMENT=2262348 DEFAULT CHARSET=utf8mb3
```

### `bookings_cancel_reasons`

**Usado por:**
- `new-admin`: (`app/Models/BookingsCancelReasons.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_booking | int | NO | MUL | NULL |  |
| type | int | NO |  | NULL |  |
| id_reason | int | NO |  | NULL |  |
| extra_reason | text | YES |  | NULL |  |
| extra_reason_provider | text | YES |  | NULL |  |
| booking_admin_doc_id | int | YES | MUL | NULL |  |
| added_by | int | YES |  | NULL |  |
| created_at | timestamp | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_bookings_cancel_reasons_admin_doc_id | BTREE | booking_admin_doc_id | No |
| idx-bookings_cancel_reasons-id_booking-type | BTREE | id_booking, type | No |

#### DDL

```sql
CREATE TABLE `bookings_cancel_reasons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_booking` int NOT NULL COMMENT 'id de la reserva de actividad o traslado',
  `type` int NOT NULL COMMENT '1.- actividad | 2.- traslado',
  `id_reason` int NOT NULL,
  `extra_reason` text,
  `extra_reason_provider` text,
  `booking_admin_doc_id` int DEFAULT NULL,
  `added_by` int DEFAULT NULL COMMENT '1.- Cliente 2.- Proveedor 3.- SAC/Civitatis',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro',
  PRIMARY KEY (`id`),
  KEY `idx-bookings_cancel_reasons-id_booking-type` (`id_booking`,`type`),
  KEY `fk_bookings_cancel_reasons_admin_doc_id` (`booking_admin_doc_id`),
  CONSTRAINT `fk_bookings_cancel_reasons_admin_doc_id` FOREIGN KEY (`booking_admin_doc_id`) REFERENCES `bookings_admin_docs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1611316 DEFAULT CHARSET=utf8mb3
```

### `bookings_chats`

**Usado por:**
- `new-admin`: (`app/Models/BookingChat.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| pnr | int | NO | MUL | NULL |  |
| type | int | NO |  | 0 |  |
| chat_type | int | NO |  | 0 |  |
| creation_timestamp | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx-idx_bookings_chats_pnr_type-id_booking-type | BTREE | pnr, type | No |

#### DDL

```sql
CREATE TABLE `bookings_chats` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pnr` int NOT NULL COMMENT 'id de la tabla referenciada en type',
  `type` int NOT NULL DEFAULT '0' COMMENT '1.- actividades_reservas 2.- traslados_reservas',
  `chat_type` int NOT NULL DEFAULT '0' COMMENT '0.- client with provider\
 1.- agency with provider',
  `creation_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx-idx_bookings_chats_pnr_type-id_booking-type` (`pnr`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=14942524 DEFAULT CHARSET=utf8mb3
```

### `bookings_clicks`

**Usado por:**
- `new-admin`: (`app/Models/BookingClick.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| booking_id | int | NO | PRI | NULL |  |
| booking_type | int | NO | PRI | NULL |  |
| click_id | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | booking_id, booking_type | Sí |

#### DDL

```sql
CREATE TABLE `bookings_clicks` (
  `booking_id` int NOT NULL,
  `booking_type` int NOT NULL,
  `click_id` int NOT NULL,
  PRIMARY KEY (`booking_id`,`booking_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `bookings_noshow_info`

**Usado por:**
- `new-admin`: (`app/Models/BookingNoShowInfo.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_booking | int | NO |  | NULL |  |
| type_booking | int | NO |  | NULL |  |
| message | text | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `bookings_noshow_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_booking` int NOT NULL COMMENT 'id de la reserva de actividad o traslado',
  `type_booking` int NOT NULL COMMENT '1.- actividad | 2.- traslado',
  `message` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `bookings_noshow_info_files`

**Usado por:**
- `new-admin`: (`app/Models/BookingNoShowInfoFile.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_booking | int | NO |  | NULL |  |
| type_booking | int | NO |  | NULL |  |
| filename | varchar(256) | NO |  | NULL |  |
| content_type | varchar(32) | NO |  | NULL |  |
| document_type | varchar(32) | NO |  | NULL |  |
| path | varchar(256) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `bookings_noshow_info_files` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_booking` int NOT NULL COMMENT 'id de la reserva de actividad o traslado',
  `type_booking` int NOT NULL COMMENT '1.- actividad | 2.- traslado',
  `filename` varchar(256) NOT NULL,
  `content_type` varchar(32) NOT NULL,
  `document_type` varchar(32) NOT NULL,
  `path` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `bookings_status_navision`

**Usado por:**
- `new-admin`: (`app/Models/BookingStatusNavision.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| booking_id | int | NO | MUL | NULL |  |
| type | int | NO |  | NULL |  |
| amount | double | YES |  | NULL |  |
| status | int | YES | MUL | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_bookings_status_nav_booking_type | BTREE | booking_id, type | No |
| idx_bookings_status_nav_booking_type_amount_status | BTREE | status, type, booking_id, id, amount | No |

#### DDL

```sql
CREATE TABLE `bookings_status_navision` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `type` int NOT NULL,
  `amount` double DEFAULT NULL,
  `status` int DEFAULT '0' COMMENT '(0: No enviada, 1:Enviada)',
  PRIMARY KEY (`id`),
  KEY `idx_bookings_status_nav_booking_type_amount_status` (`status`,`type`,`booking_id`,`id`,`amount`),
  KEY `idx_bookings_status_nav_booking_type` (`booking_id` DESC,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=10408793 DEFAULT CHARSET=utf8mb3
```

### `braze_user_events`

**Usado por:**
- `new-admin`: (`app/Models/BrazeUserEvent.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| event_name | varchar(256) | NO |  | NULL |  |
| email | varchar(256) | NO |  | NULL |  |
| entity_id | int | NO | MUL | NULL |  |
| entity_type | tinyint(1) | NO |  | NULL |  |
| trigger_at | timestamp | YES |  | NULL |  |
| status | tinyint(1) | NO | MUL | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_braze_user_events | BTREE | entity_id, entity_type | No |
| idx_braze_user_events_status_trigger_at | BTREE | status, trigger_at | No |

#### DDL

```sql
CREATE TABLE `braze_user_events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_name` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `email` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `entity_id` int NOT NULL,
  `entity_type` tinyint(1) NOT NULL COMMENT '1: activity, 2: transfer',
  `trigger_at` timestamp NULL DEFAULT NULL COMMENT 'Fecha (aproximada, dependiendo la ejecución del cron) en la que el evento se deberá lanzar',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0: pending, 1: sent',
  PRIMARY KEY (`id`),
  KEY `idx_braze_user_events` (`entity_id` DESC,`entity_type`),
  KEY `idx_braze_user_events_status_trigger_at` (`status`,`trigger_at` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='0: pending, 1: sent'
```

### `cancellation_reasons`

**Usado por:**
- `new-admin`: (`app/Models/CancellationReasons.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(256) | NO |  | NULL |  |
| type_client | int | NO |  | NULL |  |
| type_booking | int | NO |  | NULL |  |
| label | varchar(256) | YES |  | NULL |  |
| label_affiliates | varchar(256) | YES |  | NULL |  |
| label_providers | varchar(256) | YES |  | NULL |  |
| name_extra | varchar(256) | YES |  | NULL |  |
| label_extra | varchar(256) | YES |  | NULL |  |
| label_extra_text | varchar(256) | YES |  | NULL |  |
| label_extra_text_integration | varchar(256) | YES |  | NULL |  |
| label_extra_affiliates | varchar(256) | YES |  | NULL |  |
| label_extra_providers | varchar(256) | YES |  | NULL |  |
| status | tinyint | NO |  | NULL |  |
| sort | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `cancellation_reasons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `type_client` int NOT NULL COMMENT '0 - Automático, 1 - Cliente, 2 - Proveedor, 3 - SAC, 4 -Todos',
  `type_booking` int NOT NULL COMMENT '1.- Actividades 2.- Traslados 3.- Todos',
  `label` varchar(256) DEFAULT NULL COMMENT 'Label genérica',
  `label_affiliates` varchar(256) DEFAULT NULL COMMENT 'Label para afiliados',
  `label_providers` varchar(256) DEFAULT NULL COMMENT 'Label para proveedores',
  `name_extra` varchar(256) DEFAULT NULL COMMENT 'Posibles preguntas extra',
  `label_extra` varchar(256) DEFAULT NULL COMMENT 'Label extra genérica',
  `label_extra_text` varchar(256) DEFAULT NULL COMMENT 'Label extra que se mostrará como texto.',
  `label_extra_text_integration` varchar(256) DEFAULT NULL COMMENT 'Label extra que se mostrará como texto para actividades integradas.',
  `label_extra_affiliates` varchar(256) DEFAULT NULL COMMENT 'Label extra para afiliados',
  `label_extra_providers` varchar(256) DEFAULT NULL COMMENT 'Label extra para proveedores',
  `status` tinyint NOT NULL COMMENT '0.- Desactivada 1.- Activada',
  `sort` int NOT NULL COMMENT 'Ordenación a la hora de mostrar en listas',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3
```

### `cancel_reasons`

**Usado por:**
- `new-admin`: (`app/Models/CancelReason.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_reason | int | NO |  | NULL |  |
| type | int | NO |  | NULL |  |
| name | varchar(512) | NO |  | NULL |  |
| product_type | int | YES |  | NULL |  |
| status | int | YES |  | 1 |  |
| label_afiliados | varchar(256) | YES |  | NULL |  |
| label_proveedores | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `cancel_reasons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_reason` int NOT NULL,
  `type` int NOT NULL COMMENT '1 Interno 2 Publico 3 Ambas',
  `name` varchar(512) NOT NULL,
  `product_type` int DEFAULT NULL COMMENT '1- Actividad, 2- Traslado',
  `status` int DEFAULT '1' COMMENT '0 No 1 Sí',
  `label_afiliados` varchar(256) DEFAULT NULL,
  `label_proveedores` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb3
```

### `cart_checkout`

**Usado por:**
- `new-admin`: (`app/Models/CartCheckout.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| cart_id | varchar(512) | YES | MUL | NULL |  |
| json | mediumtext | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| retargeting_at | timestamp | YES |  | NULL |  |
| status | tinyint | NO |  | NULL |  |
| pin | varchar(256) | NO | MUL | NULL |  |
| origin | tinyint | NO |  | NULL |  |
| booking_attempts | tinyint | YES |  | 0 |  |
| sms_email_error | tinyint | NO |  | 0 |  |
| confirmation_visited | varchar(1) | YES |  | NULL |  |
| session_deleted | int | NO |  | 0 |  |
| confirmed_at | timestamp | YES |  | NULL |  |
| json_raw | mediumtext | YES |  | NULL |  |
| canal | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx-cart_id | BTREE | cart_id | No |
| idx-pin | BTREE | pin | No |

#### DDL

```sql
CREATE TABLE `cart_checkout` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cart_id` varchar(512) DEFAULT NULL,
  `json` mediumtext,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `retargeting_at` timestamp NULL DEFAULT NULL,
  `status` tinyint NOT NULL COMMENT '0 - Sin pagar, 1 - Pagado',
  `pin` varchar(256) NOT NULL,
  `origin` tinyint NOT NULL,
  `booking_attempts` tinyint DEFAULT '0',
  `sms_email_error` tinyint NOT NULL DEFAULT '0' COMMENT '0. No 1. Si',
  `confirmation_visited` varchar(1) DEFAULT NULL,
  `session_deleted` int NOT NULL DEFAULT '0',
  `confirmed_at` timestamp NULL DEFAULT NULL,
  `json_raw` mediumtext,
  `canal` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-cart_id` (`cart_id`(255)),
  KEY `idx-pin` (`pin`(255))
) ENGINE=InnoDB AUTO_INCREMENT=22123864 DEFAULT CHARSET=utf8mb3
```

### `cart_checkout_bookings`

**Usado por:**
- `new-admin`: (`app/Models/CartCheckoutBooking.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| cart_id | varchar(512) | YES | MUL | NULL |  |
| type | tinyint | NO |  | NULL |  |
| pnr | int | NO | MUL | NULL |  |
| precioTotalEuros | decimal(38,2) | YES |  | NULL |  |
| gananciaEuros | decimal(38,2) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx-cart_id | BTREE | cart_id | No |
| idx-pnr | BTREE | pnr | No |

#### DDL

```sql
CREATE TABLE `cart_checkout_bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cart_id` varchar(512) DEFAULT NULL,
  `type` tinyint NOT NULL COMMENT '1 - Actividad, 2 - Traslado',
  `pnr` int NOT NULL,
  `precioTotalEuros` decimal(38,2) DEFAULT NULL,
  `gananciaEuros` decimal(38,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx-cart_id` (`cart_id`(255)),
  KEY `idx-pnr` (`pnr`)
) ENGINE=InnoDB AUTO_INCREMENT=37054590 DEFAULT CHARSET=utf8mb3
```

### `carteras`

**Usado por:**
- `new-admin`: (`app/Models/Portfolio.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | text | NO |  | NULL |  |
| allow | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `carteras` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `allow` int NOT NULL COMMENT '1. Si 0. No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=utf8mb3
```

### `carteras_actividades_v2`

**Usado por:**
- `new-admin`: (`app/Models/PortfolioActivities.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| cartera_id | int | NO | PRI | NULL |  |
| activity_id | int | NO | PRI | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | cartera_id, activity_id | Sí |
| idx_carteras_actividades_v2_activity_id | BTREE | activity_id | No |
| idx_carteras_actividades_v2_cartera_id | BTREE | cartera_id | No |

#### DDL

```sql
CREATE TABLE `carteras_actividades_v2` (
  `cartera_id` int NOT NULL,
  `activity_id` int NOT NULL,
  PRIMARY KEY (`cartera_id`,`activity_id`),
  KEY `idx_carteras_actividades_v2_activity_id` (`activity_id`),
  KEY `idx_carteras_actividades_v2_cartera_id` (`cartera_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `carteras_productos`

**Usado por:**
- `new-admin`: (`app/Models/PortfolioProducts.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| cartera_id | int | NO | MUL | NULL |  |
| cartera_tipo_producto_id | int | NO | MUL | NULL |  |
| producto_id | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_cartera_tipo_producto | BTREE | cartera_id, cartera_tipo_producto_id, producto_id | No |
| idx_carteras_productos_tipo_producto | BTREE | cartera_tipo_producto_id | No |

#### DDL

```sql
CREATE TABLE `carteras_productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cartera_id` int NOT NULL,
  `cartera_tipo_producto_id` int NOT NULL,
  `producto_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cartera_tipo_producto` (`cartera_id`,`cartera_tipo_producto_id`,`producto_id`),
  KEY `idx_carteras_productos_tipo_producto` (`cartera_tipo_producto_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2714 DEFAULT CHARSET=utf8mb3
```

### `carteras_usuarios`

**Usado por:**
- `new-admin`: (`app/Models/Cartera.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| cartera_id | int | NO |  | NULL |  |
| cartera_tipo_usuario_id | int | NO | MUL | NULL |  |
| usuario_id | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_carteras_usuarios_carteraTipo_usuarioId | BTREE | cartera_tipo_usuario_id, usuario_id | No |

#### DDL

```sql
CREATE TABLE `carteras_usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cartera_id` int NOT NULL,
  `cartera_tipo_usuario_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_carteras_usuarios_carteraTipo_usuarioId` (`cartera_tipo_usuario_id`,`usuario_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50849 DEFAULT CHARSET=utf8mb3
```

### `cashback_campaign`

**Usado por:**
- `new-admin`: (`app/Models/Cobrandings/CashbackCampaign.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| cobranding_id | int | NO | MUL | NULL |  |
| currency | varchar(3) | NO |  | NULL |  |
| accumulation_formula | decimal(10,7) | YES |  | NULL |  |
| start_date | date | NO |  | NULL |  |
| end_date | date | NO |  | NULL |  |
| active | tinyint(1) | NO |  | 0 |  |
| start_time | varchar(5) | NO |  | 00:00 |  |
| end_time | varchar(5) | NO |  | 23:59 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| uk_cashback_campaign_active_only | BTREE | cobranding_id, currency | Sí |

#### DDL

```sql
CREATE TABLE `cashback_campaign` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cobranding_id` int NOT NULL,
  `currency` varchar(3) COLLATE utf8mb3_unicode_ci NOT NULL,
  `accumulation_formula` decimal(10,7) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Campaign active or not. Defaults to 0 (no)',
  `start_time` varchar(5) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '00:00',
  `end_time` varchar(5) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '23:59',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cashback_campaign_active_only` (`cobranding_id`,`currency`,((case when (`active` = 1) then 1 else NULL end))),
  CONSTRAINT `fk_cashback_campaign_cobranding` FOREIGN KEY (`cobranding_id`) REFERENCES `cobranding` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `cashback_currency_formula`

**Usado por:**
- `new-admin`: (`app/Models/Cobrandings/CashbackCurrencyFormula.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| cobranding_id | int | NO | MUL | NULL |  |
| currency_code | varchar(3) | NO |  | NULL |  |
| accumulation_formula | decimal(10,7) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| uk_cashback_currency_unique | BTREE | cobranding_id, currency_code | Sí |

#### DDL

```sql
CREATE TABLE `cashback_currency_formula` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cobranding_id` int NOT NULL,
  `currency_code` varchar(3) COLLATE utf8mb3_unicode_ci NOT NULL,
  `accumulation_formula` decimal(10,7) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cashback_currency_unique` (`cobranding_id`,`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `categories`

**Usado por:**
- `new-admin`: (`app/Models/Category.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| title | varchar(256) | NO |  | NULL |  |
| orden | int | NO |  | NULL |  |
| icon | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(256) NOT NULL,
  `orden` int NOT NULL,
  `icon` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb3
```

### `categories_destinations`

**Usado por:**
- `new-admin`: (`app/Models/ActivityCategoryTranslationDestination.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_cat_translation | int | YES | MUL | NULL |  |
| id_master_destination | int | NO | MUL | NULL |  |
| enabled | tinyint(1) | NO |  | 1 |  |
| indexable | tinyint(1) | YES |  | 0 |  |
| image | varchar(255) | YES |  | NULL |  |
| title | varchar(256) | YES |  | NULL |  |
| url | varchar(100) | YES |  | NULL |  |
| meta_title | varchar(70) | YES |  | NULL |  |
| meta_description | varchar(160) | YES |  | NULL |  |
| content | text | YES |  | NULL |  |
| bookings_last_year | mediumint unsigned | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_categories_destinations_acate_translations | BTREE | id_cat_translation | No |
| id_master_destination | BTREE | id_master_destination, id_cat_translation | Sí |
| idx_cd_destid_cat_enabled | BTREE | id_master_destination, id_cat_translation, enabled | No |

#### DDL

```sql
CREATE TABLE `categories_destinations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_cat_translation` int DEFAULT NULL COMMENT 'Id de la traduccion de la categoria',
  `id_master_destination` int NOT NULL COMMENT 'Relación con el destino',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0 - Inactivo 1 - Activo',
  `indexable` tinyint(1) DEFAULT '0' COMMENT '0. No indexable, 1. Indexable',
  `image` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'URL de la imagen para la relación categoría-destino',
  `title` varchar(256) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Alternative title for the category',
  `url` varchar(100) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Alternative url for the category',
  `meta_title` varchar(70) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `meta_description` varchar(160) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb3_unicode_ci,
  `bookings_last_year` mediumint unsigned NOT NULL DEFAULT '0' COMMENT 'Number of bookings in the last year',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_master_destination` (`id_master_destination`,`id_cat_translation`),
  KEY `fk_categories_destinations_acate_translations` (`id_cat_translation`),
  KEY `idx_cd_destid_cat_enabled` (`id_master_destination`,`id_cat_translation`,`enabled`),
  CONSTRAINT `fk_categories_destinations_acate_translations` FOREIGN KEY (`id_cat_translation`) REFERENCES `actividades_categorias_translations` (`id`),
  CONSTRAINT `fk_categories_destinations_destinos` FOREIGN KEY (`id_master_destination`) REFERENCES `destinos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Number of bookings in the last year'
```

### `categories_destinations_changelog`

**Usado por:**
- `new-admin`: (`app/Models/CategoriesDestinationsChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_category_destination | int | NO | MUL | NULL |  |
| id_admin_user | int | NO | MUL | NULL |  |
| field | varchar(126) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| source | varchar(126) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_cat_dest_changelog_id_admin_user | BTREE | id_admin_user | No |
| idx_cat_dest_changelog_id_cat_dest | BTREE | id_category_destination | No |

#### DDL

```sql
CREATE TABLE `categories_destinations_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_category_destination` int NOT NULL,
  `id_admin_user` int NOT NULL,
  `field` varchar(126) COLLATE utf8mb3_unicode_ci NOT NULL,
  `old_value` text COLLATE utf8mb3_unicode_ci,
  `new_value` text COLLATE utf8mb3_unicode_ci,
  `source` varchar(126) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_cat_dest_changelog_id_admin_user` (`id_admin_user`),
  KEY `idx_cat_dest_changelog_id_cat_dest` (`id_category_destination`),
  CONSTRAINT `fk_cat_dest_changelog_id_admin_user` FOREIGN KEY (`id_admin_user`) REFERENCES `admin_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cat_dest_changelog_id_cat_dest` FOREIGN KEY (`id_category_destination`) REFERENCES `categories_destinations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `categories_translations`

**Usado por:**
- `new-admin`: (`app/Models/CategoriesTranslations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_category | int | NO |  | NULL |  |
| title | varchar(256) | YES |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `categories_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_category` int NOT NULL,
  `title` varchar(256) DEFAULT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=utf8mb3
```

### `channel`

**Usado por:**
- `new-admin`: (`app/Models/Channel.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| type_agent_id | int | NO |  | NULL |  |
| type_origin_id | int | NO |  | NULL |  |
| description | varchar(256) | YES |  |  |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `channel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type_agent_id` int NOT NULL,
  `type_origin_id` int NOT NULL,
  `description` varchar(256) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb3
```

### `chargebacks`

**Usado por:**
- `new-admin`: (`app/Models/ChargeBack.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| service_type | tinyint | NO |  | NULL |  |
| service_id | int | NO |  | NULL |  |
| status_id | int | NO |  | NULL |  |
| comment | text | YES |  | NULL |  |
| active | tinyint | NO |  | 1 |  |
| created_at | timestamp | YES |  | NULL |  |
| updated_at | timestamp | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| reason | int | YES |  | 0 |  |
| reference_id | varchar(50) | YES |  | NULL |  |
| jira_id | varchar(50) | YES |  | NULL |  |
| notification | int | YES |  | 0 |  |
| tipo_pago | int | YES |  | NULL |  |
| civitatis_reason_id | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `chargebacks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `service_type` tinyint NOT NULL COMMENT '1 Actividades 2 Traslados 3 Viajes',
  `service_id` int NOT NULL,
  `status_id` int NOT NULL,
  `comment` text,
  `active` tinyint NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reason` int DEFAULT '0',
  `reference_id` varchar(50) DEFAULT NULL,
  `jira_id` varchar(50) DEFAULT NULL,
  `notification` int DEFAULT '0',
  `tipo_pago` int DEFAULT NULL COMMENT 'EN ADYEN: 0.- Pago no seguro. 1.- Pago seguro',
  `civitatis_reason_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54546 DEFAULT CHARSET=utf8mb3
```

### `chargebacks_civitatis_reasons`

**Usado por:**
- `new-admin`: (`app/Models/ChargebacksCivitatisReasons.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| reason | varchar(255) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `chargebacks_civitatis_reasons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reason` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3
```

### `chargebacks_reasons`

**Usado por:**
- `new-admin`: (`app/Models/ChargebackReason.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| reason | varchar(100) | NO |  | NULL |  |
| type | varchar(10) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `chargebacks_reasons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reason` varchar(100) NOT NULL,
  `type` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb3
```

### `chargebacks_status`

**Usado por:**
- `new-admin`: (`app/Models/ChargebackStatus.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(128) | NO |  | NULL |  |
| type | varchar(50) | YES |  | NULL |  |
| determine | varchar(50) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `chargebacks_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `determine` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3
```

### `check_tokens`

**Usado por:**
- `new-admin`: (`app/Models/CheckToken.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| token | text | NO | MUL | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| open_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_check_tokens_token | BTREE | token | No |

#### DDL

```sql
CREATE TABLE `check_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `token` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `open_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_check_tokens_token` (`token`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='verificar tokens'
```

### `cobranding`

**Usado por:**
- `new-admin`: (`app/Models/Cobrandings/Cobranding.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| type | int | NO |  | NULL |  |
| brand_id | int | NO |  | NULL |  |
| adyen_key | varchar(256) | NO |  | NULL |  |
| domain | varchar(256) | NO |  | NULL |  |
| title | varchar(256) | YES |  | NULL |  |
| image | varchar(256) | YES |  | NULL |  |
| content_type | varchar(16) | YES |  | NULL |  |
| newsletter | tinyint | NO |  | 0 |  |
| default_aid | int | NO |  | 0 |  |
| title_header | varchar(128) | NO |  | cobranding_collaborationWith |  |
| image_header | varchar(256) | NO |  | NULL |  |
| brand_color | varchar(25) | YES |  | NULL |  |
| brand_text_color | varchar(25) | YES |  | NULL |  |
| brand_secondary_color | varchar(25) | YES |  | NULL |  |
| brand_button_text_color | varchar(25) | YES |  | NULL |  |
| image_white | varchar(256) | YES |  | NULL |  |
| image_white_mobile | varchar(256) | YES |  | NULL |  |
| allowed_currency | varchar(3) | YES |  | NULL |  |
| timezone | varchar(70) | NO |  | Europe/Madrid |  |
| has_loyalty | tinyint unsigned | NO |  | 0 |  |
| is_active | tinyint unsigned | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `cobranding` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` int NOT NULL COMMENT '1.- afiliado | 2.- agencia | 3.- grupo',
  `brand_id` int NOT NULL COMMENT 'ID de la agencia,afiliado o grupo',
  `adyen_key` varchar(256) NOT NULL,
  `domain` varchar(256) NOT NULL,
  `title` varchar(256) DEFAULT NULL,
  `image` varchar(256) DEFAULT NULL,
  `content_type` varchar(16) DEFAULT NULL,
  `newsletter` tinyint NOT NULL DEFAULT '0' COMMENT '1.- SI | 0.- NO',
  `default_aid` int NOT NULL DEFAULT '0',
  `title_header` varchar(128) NOT NULL DEFAULT 'cobranding_collaborationWith',
  `image_header` varchar(256) NOT NULL,
  `brand_color` varchar(25) DEFAULT NULL,
  `brand_text_color` varchar(25) DEFAULT NULL,
  `brand_secondary_color` varchar(25) DEFAULT NULL,
  `brand_button_text_color` varchar(25) DEFAULT NULL,
  `image_white` varchar(256) DEFAULT NULL,
  `image_white_mobile` varchar(256) DEFAULT NULL,
  `allowed_currency` varchar(3) DEFAULT NULL,
  `timezone` varchar(70) NOT NULL DEFAULT 'Europe/Madrid',
  `has_loyalty` tinyint unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3
```

### `cobranding_loyalty_config`

**Usado por:**
- `new-admin`: (`app/Models/Cobrandings/CobrandingLoyaltyConfig.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| cobranding_id | int | NO | MUL | NULL |  |
| cashback_type | tinyint | NO |  | 1 |  |
| notification_type | tinyint | YES |  | NULL |  |
| new_bookings_url | varchar(256) | YES |  | NULL |  |
| change_bookings_url | varchar(256) | YES |  | NULL |  |
| auth_url | varchar(256) | YES |  | NULL |  |
| identification_type | tinyint | YES |  | NULL |  |
| helper | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_cobranding_loyalty_config_cobranding_id | BTREE | cobranding_id | No |

#### DDL

```sql
CREATE TABLE `cobranding_loyalty_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cobranding_id` int NOT NULL,
  `cashback_type` tinyint NOT NULL DEFAULT '1',
  `notification_type` tinyint DEFAULT NULL,
  `new_bookings_url` varchar(256) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `change_bookings_url` varchar(256) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `auth_url` varchar(256) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `identification_type` tinyint DEFAULT NULL,
  `helper` varchar(256) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cobranding_loyalty_config_cobranding_id` (`cobranding_id`),
  CONSTRAINT `fk_cobranding_loyalty_config_cobranding` FOREIGN KEY (`cobranding_id`) REFERENCES `cobranding` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `cobranding_top_activities`

**Usado por:**
- `new-admin`: (`app/Models/Cobrandings/CobrandingTopActivities.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| cobranding_id | int | NO |  | NULL |  |
| activity_id | int | NO |  | NULL |  |
| order | int | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `cobranding_top_activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cobranding_id` int NOT NULL,
  `activity_id` int NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Top actividades a mostrar en la home del cobranding'
```

### `cobranding_top_destinations`

**Usado por:**
- `new-admin`: (`app/Models/Cobrandings/CobrandingTopDestination.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| cobranding_id | int | NO |  | NULL |  |
| destination_id | int | NO |  | NULL |  |
| order | int | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `cobranding_top_destinations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cobranding_id` int NOT NULL,
  `destination_id` int NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Top destinos a mostrar en la home del cobranding'
```

### `cobranding_translation_labels`

**Usado por:**
- `new-admin`: (`app/Models/Cobrandings/CobrandingTranslationLabel.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| cobranding_id | int | NO | PRI | NULL |  |
| cobranding_label_type_id | int | NO | PRI | NULL |  |
| label | varchar(255) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | cobranding_id, cobranding_label_type_id | Sí |
| fk_cobranding_translation_labels_type_id | BTREE | cobranding_label_type_id | No |

#### DDL

```sql
CREATE TABLE `cobranding_translation_labels` (
  `cobranding_id` int NOT NULL,
  `cobranding_label_type_id` int NOT NULL,
  `label` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`cobranding_id`,`cobranding_label_type_id`),
  KEY `fk_cobranding_translation_labels_type_id` (`cobranding_label_type_id`),
  CONSTRAINT `fk_cobranding_translation_labels_cobranding_id` FOREIGN KEY (`cobranding_id`) REFERENCES `cobranding` (`id`),
  CONSTRAINT `fk_cobranding_translation_labels_type_id` FOREIGN KEY (`cobranding_label_type_id`) REFERENCES `cobranding_translation_labels_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `cobranding_translation_labels_types`

**Usado por:**
- `new-admin`: (`app/Models/Cobrandings/CobrandingTranslationLabelType.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(128) | NO | UNI | NULL |  |
| description | varchar(255) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| uk_cobranding_translation_labels_types_name | BTREE | name | Sí |

#### DDL

```sql
CREATE TABLE `cobranding_translation_labels_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cobranding_translation_labels_types_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `colaborator_faq`

**Usado por:**
- `new-admin`: (`app/Models/ColaboratorFaq.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | YES |  | 0 |  |
| colaborator_type | int | YES |  | 0 |  |
| title | text | YES |  | NULL |  |
| answer | text | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| status | tinyint | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| active | tinyint | YES |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `colaborator_faq` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int DEFAULT '0',
  `colaborator_type` int DEFAULT '0' COMMENT '0.Ninguno 1.Proveedores 2.Agencia 3.Afiliado',
  `title` text,
  `answer` text,
  `orden` int DEFAULT NULL,
  `status` tinyint DEFAULT NULL COMMENT '0.No publicado 1.Publicado',
  `lang` varchar(2) DEFAULT NULL,
  `active` tinyint DEFAULT '1' COMMENT '0.Desactivada 1.Activa',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='faqs de agencias,afiliados y proveedores'
```

### `colaborator_faq_changelog`

**Usado por:**
- `new-admin`: (`app/Models/ColaboratorFaqChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idFaq | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validation | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `colaborator_faq_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idFaq` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validation` int DEFAULT '0' COMMENT '1-Si 0-No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='changelog de faqs'
```

### `colaborator_faq_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/ColaboratorFaqChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idChange | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `colaborator_faq_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idChange` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `lang` varchar(2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Validadores de faqs'
```

### `colaborator_faq_internal`

**Usado por:**
- `new-admin`: (`app/Models/ColaboratorFaqInternal.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | YES |  | NULL |  |
| colaborator_type | int | NO |  | NULL |  |
| internal_category | int | NO |  | NULL |  |
| title | varchar(256) | YES |  | NULL |  |
| answer | text | YES |  | NULL |  |
| order | int | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| active | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `colaborator_faq_internal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int DEFAULT NULL,
  `colaborator_type` int NOT NULL COMMENT '1-Proveedores 2-Agencia 3-Afiliado',
  `internal_category` int NOT NULL COMMENT 'ID from colaborator_faq_internal_categories',
  `title` varchar(256) DEFAULT NULL,
  `answer` text,
  `order` int NOT NULL,
  `lang` varchar(2) NOT NULL,
  `active` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `colaborator_faq_internal_categories`

**Usado por:**
- `new-admin`: (`app/Models/ColaboratorFaqInternalCategories.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| title | text | YES |  | NULL |  |
| label | text | YES |  | NULL |  |
| order | int | NO |  | NULL |  |
| active | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `colaborator_faq_internal_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` text,
  `label` text,
  `order` int NOT NULL,
  `active` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `colaborator_faq_internal_changelog`

**Usado por:**
- `new-admin`: (`app/Models/ColaboratorFaqInternalChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idFaq | int | YES |  | NULL |  |
| field | varchar(16) | NO |  | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `colaborator_faq_internal_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idFaq` int DEFAULT NULL,
  `field` varchar(16) NOT NULL,
  `user` varchar(16) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `colaborator_faq_internal_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/ColaboratorFaqInternalChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idChange | int | YES |  | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `colaborator_faq_internal_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idChange` int DEFAULT NULL,
  `user` varchar(16) NOT NULL,
  `lang` varchar(2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `colaborator_testimony`

**Usado por:**
- `new-admin`: (`app/Models/Testimonies.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | YES |  | 0 |  |
| colaborator_type | int | YES |  | NULL |  |
| colaborator_id | int | YES |  | NULL |  |
| web_choose | int | YES |  | 0 |  |
| testimony | text | NO |  | NULL |  |
| title | varchar(64) | NO |  | NULL |  |
| image | varchar(128) | YES |  | NULL |  |
| status | tinyint | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| active | tinyint | YES |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `colaborator_testimony` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int DEFAULT '0',
  `colaborator_type` int DEFAULT NULL COMMENT '0.Ninguno 1.Proveedores 2.Agencia 3.Afiliado',
  `colaborator_id` int DEFAULT NULL,
  `web_choose` int DEFAULT '0',
  `testimony` text NOT NULL,
  `title` varchar(64) NOT NULL,
  `image` varchar(128) DEFAULT NULL,
  `status` tinyint DEFAULT NULL COMMENT '0.No publicado 1.Publicado',
  `lang` varchar(2) DEFAULT NULL,
  `active` tinyint DEFAULT '1' COMMENT '0.Desactivada 1.Activa',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='testimonios de agencias,afiliados y proveedores'
```

### `colaborator_testimony_changelog`

**Usado por:**
- `new-admin`: (`app/Models/TestimoniesChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idTestimony | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| field | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validation | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `colaborator_testimony_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idTestimony` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `field` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validation` int DEFAULT '0' COMMENT '1-Si 0-No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='changelog de testimonios'
```

### `colaborator_testimony_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/TestimoniesChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idChange | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `colaborator_testimony_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idChange` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `lang` varchar(2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Validadores de testimonios'
```

### `collections_images`

**Usado por:**
- `new-admin`: (`app/Models/CollectionImage.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_collection | int | NO | MUL | NULL |  |
| id_master_photo | int | NO |  | NULL |  |
| orden | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| ct_master_idx | BTREE | id_master_collection, id_master_photo | No |

#### DDL

```sql
CREATE TABLE `collections_images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_collection` int NOT NULL,
  `id_master_photo` int NOT NULL,
  `orden` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ct_master_idx` (`id_master_collection`,`id_master_photo`)
) ENGINE=InnoDB AUTO_INCREMENT=65479 DEFAULT CHARSET=utf8mb3
```

### `collections_pages`

**Usado por:**
- `new-admin`: (`app/Models/CollectionPage.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_collection | int | NO |  | NULL |  |
| id_master_page | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `collections_pages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_collection` int NOT NULL,
  `id_master_page` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12543 DEFAULT CHARSET=utf8mb3
```

### `collections_photos`

**Usado por:**
- `new-admin`: (`app/Models/CollectionPhoto.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_collection | int | NO |  | NULL |  |
| id_master_album | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `collections_photos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_collection` int NOT NULL,
  `id_master_album` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1266 DEFAULT CHARSET=utf8mb3
```

### `collections_tags`

**Usado por:**
- `new-admin`: (`app/Models/CollectionTag.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_collection | int | NO | MUL | NULL |  |
| id_master_tag | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| ct_master_idx | BTREE | id_master_collection, id_master_tag | No |

#### DDL

```sql
CREATE TABLE `collections_tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_collection` int NOT NULL,
  `id_master_tag` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ct_master_idx` (`id_master_collection`,`id_master_tag`)
) ENGINE=InnoDB AUTO_INCREMENT=1430 DEFAULT CHARSET=utf8mb3
```

### `collections_text`

**Usado por:**
- `new-admin`: (`app/Models/CollectionText.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_collection | int | NO | MUL | NULL |  |
| text | text | YES |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| ct_master_idx | BTREE | id_master_collection, lang | No |

#### DDL

```sql
CREATE TABLE `collections_text` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_collection` int NOT NULL,
  `text` text,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ct_master_idx` (`id_master_collection`,`lang`)
) ENGINE=InnoDB AUTO_INCREMENT=31479 DEFAULT CHARSET=utf8mb3
```

### `comentarios_facturacion`

**Usado por:**
- `new-admin`: (`app/Models/CommentInvoicing.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| comments | text | YES |  | NULL |  |
| id_provider | int | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| month | varchar(2) | YES |  | NULL |  |
| year | varchar(5) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `comentarios_facturacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comments` text,
  `id_provider` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `month` varchar(2) DEFAULT NULL,
  `year` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COMMENT='Comentarios'
```

### `commision_refunds`

**Usado por:**
- `new-admin`: (`app/Models/CommisionRefunds.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| client_type | int | NO |  | NULL |  |
| client_id | int | NO |  | NULL |  |
| product_type | int | NO |  | NULL |  |
| pnr | int | NO |  | NULL |  |
| amount | decimal(38,2) | NO |  | NULL |  |
| currency | char(3) | NO |  | NULL |  |
| status | int | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| applied_at | timestamp | YES |  | NULL |  |
| wallet_move | varchar(255) | YES |  | NULL |  |
| invoice_id | varchar(255) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `commision_refunds` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_type` int NOT NULL COMMENT 'admin = 1, user = 2, agency = 3, agency_group = 4, affiliate = 5, agency_affiliate = 6',
  `client_id` int NOT NULL COMMENT 'id agency/affiliate/user/...',
  `product_type` int NOT NULL COMMENT '1 = actividad, 2 = traslado',
  `pnr` int NOT NULL COMMENT 'id actividad/traslado',
  `amount` decimal(38,2) NOT NULL COMMENT 'amount to refund',
  `currency` char(3) NOT NULL COMMENT 'divisa XXX',
  `status` int NOT NULL COMMENT '1 - pendiente, 2 - aplicado, 3 - cancelado',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `applied_at` timestamp NULL DEFAULT NULL,
  `wallet_move` varchar(255) DEFAULT NULL COMMENT 'movimiento wallet, si aplica',
  `invoice_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `compensations_bookings`

**Usado por:**
- `new-admin`: (`app/Models/Compensatory.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| booking_id | int | NO |  | NULL |  |
| type | tinyint | NO |  | NULL |  |
| provider_id | int | YES |  | NULL |  |
| amount | double | NO |  | NULL |  |
| amount_euros | double | YES |  | NULL |  |
| currency | varchar(4) | NO |  | NULL |  |
| status | tinyint | NO |  | 0 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| fechaRevisado | timestamp | YES |  | NULL |  |
| fechaPagado | timestamp | YES |  | NULL |  |
| facturaPago | varchar(50) | YES |  | NULL |  |
| reason | text | YES |  | NULL |  |
| agente | varchar(60) | YES |  | NULL |  |
| fecha | datetime | YES |  | NULL |  |
| total_price | double | YES |  | NULL |  |
| total_price_eur | double | YES |  | NULL |  |
| profit | double | YES |  | NULL |  |
| profit_eur | double | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `compensations_bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `type` tinyint NOT NULL COMMENT '1- Actividades 2 Traslados',
  `provider_id` int DEFAULT NULL,
  `amount` double NOT NULL,
  `amount_euros` double DEFAULT NULL,
  `currency` varchar(4) NOT NULL,
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0- Sin pagar 1 - Pagado 2 - Validado por el proveedor 3- Eliminada',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechaRevisado` timestamp NULL DEFAULT NULL,
  `fechaPagado` timestamp NULL DEFAULT NULL,
  `facturaPago` varchar(50) DEFAULT NULL,
  `reason` text,
  `agente` varchar(60) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `total_price` double DEFAULT NULL,
  `total_price_eur` double DEFAULT NULL,
  `profit` double DEFAULT NULL,
  `profit_eur` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32375 DEFAULT CHARSET=utf8mb3
```

### `compensatory_types`

**Usado por:**
- `new-admin`: (`app/Models/CompensatoryType.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| type | int | NO |  | 2 |  |
| label | varchar(256) | NO |  | NULL |  |
| name | varchar(256) | YES |  |  |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `compensatory_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` int NOT NULL DEFAULT '2' COMMENT '0-Civitatis 1-Proveedor 2-Ambos',
  `label` varchar(256) NOT NULL,
  `name` varchar(256) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='Tipos de compensatoria(Motivo)'
```

### `comun_images_attributes_translations`

**Usado por:**
- `new-admin`: (`app/Models/CommonVariablesTranslationsImage.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| label | varchar(256) | NO |  | NULL |  |
| idVariableMaster | int | NO | MUL | NULL |  |
| src | text | NO |  | NULL |  |
| alt | text | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_comun_images_attributes_translations_idVariableMaster | BTREE | idVariableMaster | No |

#### DDL

```sql
CREATE TABLE `comun_images_attributes_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label` varchar(256) NOT NULL,
  `idVariableMaster` int NOT NULL,
  `src` text NOT NULL,
  `alt` text NOT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_comun_images_attributes_translations_idVariableMaster` (`idVariableMaster`),
  CONSTRAINT `fk_comun_images_attributes_translations_idVariableMaster` FOREIGN KEY (`idVariableMaster`) REFERENCES `comun_variables_translations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `comun_links_attributes_translations`

**Usado por:**
- `new-admin`: (`app/Models/CommonVariablesTranslationsLink.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| label | varchar(256) | NO | MUL | NULL |  |
| idVariableMaster | int | NO | MUL | NULL |  |
| href | text | NO |  | NULL |  |
| alt | text | NO |  | NULL |  |
| lang | varchar(2) | NO | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| comun_links_attributes_translations_lang_IDX | BTREE | lang | No |
| fk_comun_links_attributes_translations_idVariableMaster | BTREE | idVariableMaster | No |
| idx_label_lang_comun_links_attributes_translations | BTREE | label, lang | No |

#### DDL

```sql
CREATE TABLE `comun_links_attributes_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label` varchar(256) NOT NULL,
  `idVariableMaster` int NOT NULL,
  `href` text NOT NULL,
  `alt` text NOT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_comun_links_attributes_translations_idVariableMaster` (`idVariableMaster`),
  KEY `idx_label_lang_comun_links_attributes_translations` (`label`,`lang`),
  KEY `comun_links_attributes_translations_lang_IDX` (`lang`) USING BTREE,
  CONSTRAINT `fk_comun_links_attributes_translations_idVariableMaster` FOREIGN KEY (`idVariableMaster`) REFERENCES `comun_variables_translations` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=4554 DEFAULT CHARSET=utf8mb3
```

### `comun_variables_translations`

**Usado por:**
- `new-admin`: (`app/Models/CommonVariablesTranslations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | NO | MUL | NULL |  |
| label | varchar(128) | NO | MUL | NULL |  |
| value | text | YES |  | NULL |  |
| value_plural | text | YES |  | NULL |  |
| type | varchar(16) | NO |  | NULL |  |
| lang | varchar(2) | NO | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_comun_variables_label_lang | BTREE | label, lang | No |
| idx_comun_variables_translations_lang | BTREE | lang | No |
| idx_id_lang_comun_variables_translations | BTREE | id, lang | No |
| idx_idMaster_lang_comun_variables_translations | BTREE | idMaster, lang | No |

#### DDL

```sql
CREATE TABLE `comun_variables_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int NOT NULL,
  `label` varchar(128) NOT NULL,
  `value` text,
  `value_plural` text,
  `type` varchar(16) NOT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_idMaster_lang_comun_variables_translations` (`idMaster`,`lang`),
  KEY `idx_id_lang_comun_variables_translations` (`id`,`lang`),
  KEY `idx_comun_variables_label_lang` (`label`,`lang`),
  KEY `idx_comun_variables_translations_lang` (`lang`)
) ENGINE=InnoDB AUTO_INCREMENT=93769 DEFAULT CHARSET=utf8mb3
```

### `contact_faq`

**Usado por:**
- `new-admin`: (`app/Models/ContactFaq.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | YES |  | 0 |  |
| idCategory | int | NO |  | NULL |  |
| title | mediumtext | YES |  | NULL |  |
| answer | mediumtext | YES |  | NULL |  |
| type | int | NO |  | 0 |  |
| orden | int | YES |  | NULL |  |
| status | tinyint | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| active | tinyint | YES |  | 1 |  |
| show_to | int | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `contact_faq` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int DEFAULT '0',
  `idCategory` int NOT NULL COMMENT 'id de contact_faq_categories',
  `title` mediumtext,
  `answer` mediumtext,
  `type` int NOT NULL DEFAULT '0' COMMENT '0.-Consulta(1y2) | 1.- Antes De reservar | 2.- Despues de reservar | 3- Mi cuenta',
  `orden` int DEFAULT NULL,
  `status` tinyint DEFAULT NULL COMMENT '0.No publicado 1.Publicado',
  `lang` varchar(2) DEFAULT NULL,
  `active` tinyint DEFAULT '1' COMMENT '0.Desactivada 1.Activa',
  `show_to` int NOT NULL DEFAULT '0' COMMENT '0.- Todos 1.- Clientes 2.- Agencias',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1121 DEFAULT CHARSET=utf8mb3
```

### `contact_faq_categories`

**Usado por:**
- `new-admin`: (`app/Models/ContactFaqCategory.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | YES |  | 0 |  |
| title | varchar(256) | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| status | tinyint | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| label | varchar(256) | NO |  | NULL |  |
| active | tinyint | YES |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `contact_faq_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int DEFAULT '0',
  `title` varchar(256) DEFAULT NULL,
  `orden` int DEFAULT NULL,
  `status` tinyint DEFAULT NULL COMMENT '0.No publicado 1.Publicado',
  `lang` varchar(2) DEFAULT NULL,
  `label` varchar(256) NOT NULL COMMENT 'Importante para Zendesk',
  `active` tinyint DEFAULT '1' COMMENT '0.Desactivada 1.Activa',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb3
```

### `contact_faq_categories_changelog`

**Usado por:**
- `new-admin`: (`app/Models/ContactFaqCategoryChangeLog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idFaq | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | mediumtext | YES |  | NULL |  |
| new_value | mediumtext | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validation | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `contact_faq_categories_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idFaq` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` mediumtext,
  `new_value` mediumtext,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validation` int DEFAULT '0' COMMENT '1-Si 0-No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb3 COMMENT='changelog de contact_faq_categories'
```

### `contact_faq_categories_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/ContactFaqCategoryChangeLogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idChange | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `contact_faq_categories_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idChange` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `lang` varchar(2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=297 DEFAULT CHARSET=utf8mb3 COMMENT='Validadores de contact_faq_categories'
```

### `contact_faq_categories_orden_type`

**Usado por:**
- `new-admin`: (`app/Models/ContactFaqCategoryOrderType.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idFaqCategory | int | YES |  | 0 |  |
| tipo | int | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `contact_faq_categories_orden_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idFaqCategory` int DEFAULT '0',
  `tipo` int DEFAULT NULL,
  `orden` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb3 COMMENT='Orden por tipo para categorias de faqs de contacto'
```

### `contact_faq_changelog`

**Usado por:**
- `new-admin`: (`app/Models/ContactFaqChangeLog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idFaq | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | mediumtext | YES |  | NULL |  |
| new_value | mediumtext | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validation | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `contact_faq_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idFaq` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` mediumtext,
  `new_value` mediumtext,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validation` int DEFAULT '0' COMMENT '1-Si 0-No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1106 DEFAULT CHARSET=utf8mb3 COMMENT='changelog de contact_faq'
```

### `contact_faq_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/ContactFaqChangeLogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idChange | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `contact_faq_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idChange` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `lang` varchar(2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2856 DEFAULT CHARSET=utf8mb3 COMMENT='Validadores de contact_faq'
```

### `contact_phones`

**Usado por:**
- `new-admin`: (`app/Models/ContactPhone.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| phone | varchar(32) | NO |  | NULL |  |
| country | int | NO |  | NULL |  |
| enabled | int | NO |  | NULL |  |
| position | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `contact_phones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `phone` varchar(32) NOT NULL,
  `country` int NOT NULL,
  `enabled` int NOT NULL,
  `position` int NOT NULL COMMENT 'El orden en el que aparecerán. Ascendente.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3
```

### `contact_phones_b2b`

**Usado por:**
- `new-admin`: (`app/Models/ContactPhoneB2B.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| lang | varchar(2) | NO |  | NULL |  |
| phone | varchar(50) | YES |  | NULL |  |
| type_number | tinyint | NO |  | 1 |  |
| type | tinyint | NO |  | 1 |  |
| country | int | NO |  | NULL |  |
| enabled | int | NO |  | NULL |  |
| position | int | NO |  | NULL |  |
| startTime | time | NO |  | NULL |  |
| endTime | time | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `contact_phones_b2b` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` varchar(2) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `type_number` tinyint NOT NULL DEFAULT '1' COMMENT '1.- Llamadas 2.- Whatsapp 3.- Ambos',
  `type` tinyint NOT NULL DEFAULT '1' COMMENT '1.- Contacto Agencias 2.- Contacto Afiliados 3.- Contacto Reservas',
  `country` int NOT NULL,
  `enabled` int NOT NULL,
  `position` int NOT NULL COMMENT 'El orden en el que aparecerán. Ascendente.',
  `startTime` time NOT NULL,
  `endTime` time NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb3
```

### `contests`

**Usado por:**
- `new-admin`: (`app/Models/Contest.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| type | int | YES |  | 0 |  |
| title | text | YES |  | NULL |  |
| url | varchar(25) | YES |  | NULL |  |
| source | varchar(128) | YES |  | NULL |  |
| prize | int | YES |  | NULL |  |
| currency | varchar(3) | YES |  | NULL |  |
| end_date | date | YES |  | NULL |  |
| active | tinyint | YES |  | 0 |  |
| how_meet_us | tinyint | YES |  | 0 |  |
| bases_url | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `contests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` int DEFAULT '0' COMMENT '0- Todos 2- Clientes 3- Agencia 5- Afiliado 6- Proveedor',
  `title` text,
  `url` varchar(25) DEFAULT NULL,
  `source` varchar(128) DEFAULT NULL,
  `prize` int DEFAULT NULL,
  `currency` varchar(3) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `active` tinyint DEFAULT '0' COMMENT '0.Desactivado 1.Activo',
  `how_meet_us` tinyint DEFAULT '0' COMMENT '0 - No, 1 - Sí',
  `bases_url` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='Concursos Civitatis'
```

### `contests_translations`

**Usado por:**
- `new-admin`: (`app/Models/ContestTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_contest | int | YES |  | NULL |  |
| title | text | YES |  | NULL |  |
| url | varchar(25) | YES |  | NULL |  |
| email_content | text | YES |  | NULL |  |
| email_subject_content | text | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| bases_url | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `contests_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_contest` int DEFAULT NULL,
  `title` text,
  `url` varchar(25) DEFAULT NULL,
  `email_content` text,
  `email_subject_content` text,
  `lang` varchar(2) DEFAULT NULL,
  `bases_url` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3
```

### `cookies`

**Usado por:**
- `new-admin`: (`app/Models/Cookie.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | YES |  | 0 |  |
| title | text | YES |  | NULL |  |
| answer | text | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| status | tinyint | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| active | tinyint | YES |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `cookies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int DEFAULT '0',
  `title` text,
  `answer` text,
  `orden` int DEFAULT NULL,
  `status` tinyint DEFAULT NULL COMMENT '0.No publicado 1.Publicado',
  `lang` varchar(2) DEFAULT NULL,
  `active` tinyint DEFAULT '1' COMMENT '0.Desactivada 1.Activa',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Pagina de cookies'
```

### `cookies_changelog`

**Usado por:**
- `new-admin`: (`app/Models/CookieChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCookie | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validation | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `cookies_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCookie` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validation` int DEFAULT '0' COMMENT '1-Si 0-No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='changelog de cookies'
```

### `cookies_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/CookieChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idChange | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `cookies_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idChange` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `lang` varchar(2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Validadores de cookies'
```

### `currencies_ratio_history`

**Usado por:**
- `new-admin`: (`app/Models/CurrencyRatioHistory.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| currency_id | int | NO | MUL | NULL |  |
| codigo | char(3) | NO |  | NULL |  |
| valor | float | NO |  | NULL |  |
| fecha | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| exchange_plus | decimal(4,2) | NO |  | 0.00 |  |
| taxes | decimal(4,2) | NO |  | 0.00 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_currencies_ratio_history | BTREE | currency_id, codigo, valor, fecha | No |

#### DDL

```sql
CREATE TABLE `currencies_ratio_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `currency_id` int NOT NULL,
  `codigo` char(3) NOT NULL,
  `valor` float NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `exchange_plus` decimal(4,2) NOT NULL DEFAULT '0.00',
  `taxes` decimal(4,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `idx_currencies_ratio_history` (`currency_id`,`codigo`,`valor`,`fecha`)
) ENGINE=InnoDB AUTO_INCREMENT=176503 DEFAULT CHARSET=utf8mb3
```

### `departments`

**Usado por:**
- `new-admin`: (`app/Models/Department.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| level | tinyint | YES |  | NULL |  |
| name | varchar(128) | NO |  | NULL |  |
| phone_ext | varchar(50) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `level` tinyint DEFAULT NULL,
  `name` varchar(128) NOT NULL,
  `phone_ext` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3
```

### `destination_manager_responsible`

**Usado por:**
- `new-admin`: (`app/Models/DestinationManagerResponsible.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id_user | int | NO | PRI | NULL |  |
| id_responsible | int | NO | PRI | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id_user, id_responsible | Sí |
| fk_responsible | BTREE | id_responsible | No |

#### DDL

```sql
CREATE TABLE `destination_manager_responsible` (
  `id_user` int NOT NULL,
  `id_responsible` int NOT NULL,
  PRIMARY KEY (`id_user`,`id_responsible`),
  KEY `fk_responsible` (`id_responsible`),
  CONSTRAINT `fk_responsible` FOREIGN KEY (`id_responsible`) REFERENCES `admin_user` (`id`),
  CONSTRAINT `fk_user` FOREIGN KEY (`id_user`) REFERENCES `admin_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `destinos`

**Usado por:**
- `new-admin`: (`app/Models/Destination.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_pais | int | NO | MUL | NULL |  |
| nombre | varchar(64) | NO |  | NULL |  |
| iata | char(3) | NO |  | NULL |  |
| latitud | double | NO |  | NULL |  |
| longitud | double | NO |  | NULL |  |
| zonaHoraria | varchar(32) | NO |  | NULL |  |
| actividades | tinyint(1) | NO |  | NULL |  |
| traslados | tinyint(1) | NO |  | NULL |  |
| viajes | tinyint(1) | NO |  | NULL |  |
| audioguias | tinyint | NO |  | NULL |  |
| priority | int | NO |  | NULL |  |
| url | varchar(64) | YES |  | NULL |  |
| tituloDestacados | varchar(256) | YES |  | NULL |  |
| booking_id | varchar(256) | YES |  | NULL |  |
| hb_id | varchar(256) | YES |  | NULL |  |
| zoom | tinyint | NO |  | 12 |  |
| tipo_destino | varchar(32) | YES |  | city |  |
| copy_transfers_from | int | YES |  | 0 |  |
| island | tinyint | NO |  | 0 |  |
| tax_region_id | tinyint | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_destinos_pais | BTREE | id_pais | No |

#### DDL

```sql
CREATE TABLE `destinos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_pais` int NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `iata` char(3) NOT NULL,
  `latitud` double NOT NULL,
  `longitud` double NOT NULL,
  `zonaHoraria` varchar(32) NOT NULL,
  `actividades` tinyint(1) NOT NULL,
  `traslados` tinyint(1) NOT NULL,
  `viajes` tinyint(1) NOT NULL,
  `audioguias` tinyint NOT NULL,
  `priority` int NOT NULL,
  `url` varchar(64) DEFAULT NULL,
  `tituloDestacados` varchar(256) DEFAULT NULL,
  `booking_id` varchar(256) DEFAULT NULL,
  `hb_id` varchar(256) DEFAULT NULL,
  `zoom` tinyint NOT NULL DEFAULT '12',
  `tipo_destino` varchar(32) DEFAULT 'city',
  `copy_transfers_from` int DEFAULT '0',
  `island` tinyint NOT NULL DEFAULT '0' COMMENT 'Determina si el destino se encuentra en una isla o no.',
  `tax_region_id` tinyint DEFAULT NULL COMMENT '1 - ESPAÑA PENÍNSULA Y BALEARES, 2 - CANARIAS, 3 - CEUTA, 4 - MELILLA, 5 - RESTO UE, 6 - INTERNACIONAL',
  PRIMARY KEY (`id`),
  KEY `idx_destinos_pais` (`id_pais`)
) ENGINE=InnoDB AUTO_INCREMENT=5775 DEFAULT CHARSET=utf8mb3
```

### `destinos_google_pois`

**Usado por:**
- `new-admin`: (`app/Models/PoiDestination.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| destino_id | int | NO | MUL | NULL |  |
| place_id | varchar(200) | NO | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| fk_destinos_google_pois_destino_id_destinos | BTREE | destino_id | No |
| fk_destinos_google_pois_place_id_google_pois | BTREE | place_id | No |

#### DDL

```sql
CREATE TABLE `destinos_google_pois` (
  `destino_id` int NOT NULL,
  `place_id` varchar(200) NOT NULL,
  KEY `fk_destinos_google_pois_place_id_google_pois` (`place_id`),
  KEY `fk_destinos_google_pois_destino_id_destinos` (`destino_id`),
  CONSTRAINT `fk_destinos_google_pois_destino_id_destinos` FOREIGN KEY (`destino_id`) REFERENCES `destinos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_destinos_google_pois_place_id_google_pois` FOREIGN KEY (`place_id`) REFERENCES `google_pois` (`place_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `destinos_translations`

**Usado por:**
- `new-admin`: (`app/Models/DestinationTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterDestino | int | NO | MUL | NULL |  |
| nombre | varchar(128) | YES |  | NULL |  |
| actividades | int | YES |  | 0 |  |
| traslados | int | YES |  | 0 |  |
| audioguias | int | YES |  | 0 |  |
| similar | text | YES |  | NULL |  |
| url | varchar(56) | YES |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| video | varchar(512) | YES |  | NULL |  |
| actividadesen | varchar(256) | YES |  | NULL |  |
| trasladosen | varchar(256) | YES |  | NULL |  |
| vuelosen | varchar(256) | YES |  | NULL |  |
| hotelesen | varchar(256) | YES |  | NULL |  |
| apartamentosen | varchar(256) | YES |  | NULL |  |
| alquiler_coches | varchar(256) | YES |  | NULL |  |
| daytrip_to_singular | varchar(256) | YES |  | NULL |  |
| daytrip_to | varchar(256) | YES |  | NULL |  |
| on_destiny | varchar(256) | YES |  | NULL |  |
| to_destiny | varchar(256) | YES |  | NULL |  |
| of_destiny | varchar(256) | YES |  | NULL |  |
| from_destiny | varchar(256) | YES |  | NULL |  |
| hora_de | varchar(64) | NO |  | NULL |  |
| activities_near_to | varchar(64) | NO |  | NULL |  |
| activation_date | timestamp | YES |  | NULL |  |
| show_country_metaoptions | tinyint(1) | NO |  | 0 |  |
| meta_title | varchar(70) | YES |  | NULL |  |
| meta_description | varchar(160) | YES |  | NULL |  |
| content | text | YES |  | NULL |  |
| indexable | tinyint(1) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_destinos_translations_lang | BTREE | idMasterDestino, lang | No |
| idx_dt_master_lang | BTREE | idMasterDestino, lang | No |
| idx_dt_master_lang_traslados | BTREE | idMasterDestino, lang, traslados | No |

#### DDL

```sql
CREATE TABLE `destinos_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterDestino` int NOT NULL,
  `nombre` varchar(128) DEFAULT NULL,
  `actividades` int DEFAULT '0',
  `traslados` int DEFAULT '0',
  `audioguias` int DEFAULT '0',
  `similar` text,
  `url` varchar(56) DEFAULT NULL,
  `lang` varchar(2) NOT NULL,
  `video` varchar(512) DEFAULT NULL,
  `actividadesen` varchar(256) DEFAULT NULL,
  `trasladosen` varchar(256) DEFAULT NULL,
  `vuelosen` varchar(256) DEFAULT NULL,
  `hotelesen` varchar(256) DEFAULT NULL,
  `apartamentosen` varchar(256) DEFAULT NULL,
  `alquiler_coches` varchar(256) DEFAULT NULL,
  `daytrip_to_singular` varchar(256) DEFAULT NULL,
  `daytrip_to` varchar(256) DEFAULT NULL,
  `on_destiny` varchar(256) DEFAULT NULL,
  `to_destiny` varchar(256) DEFAULT NULL,
  `of_destiny` varchar(256) DEFAULT NULL,
  `from_destiny` varchar(256) DEFAULT NULL,
  `hora_de` varchar(64) NOT NULL,
  `activities_near_to` varchar(64) NOT NULL,
  `activation_date` timestamp NULL DEFAULT NULL,
  `show_country_metaoptions` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Mostramos el pais en los meta si hay destinos iguales en nombre. 0.No 1.Si',
  `meta_title` varchar(70) DEFAULT NULL,
  `meta_description` varchar(160) DEFAULT NULL,
  `content` text,
  `indexable` tinyint(1) DEFAULT NULL COMMENT '0- No tiene actividades. 1- Tiene actividades propias. 2- Tiene actividades cercanas',
  PRIMARY KEY (`id`),
  KEY `idx_destinos_translations_lang` (`idMasterDestino`,`lang`),
  KEY `idx_dt_master_lang` (`idMasterDestino`,`lang`),
  KEY `idx_dt_master_lang_traslados` (`idMasterDestino`,`lang`,`traslados`)
) ENGINE=InnoDB AUTO_INCREMENT=37107 DEFAULT CHARSET=utf8mb3 COMMENT='0- No tiene actividades. 1- Tiene actividades propias. 2- Tiene actividades cercanas'
```

### `destinos_translations_changelog`

**Usado por:**
- `new-admin`: (`app/Models/DestinationsTranslationsChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterDestino | int | NO | MUL | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validated | int | YES | MUL | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_destinos_translations_changelog | BTREE | idMasterDestino, created_at | No |
| idx_destinos_translations_changelog_validated | BTREE | validated | No |

#### DDL

```sql
CREATE TABLE `destinos_translations_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterDestino` int NOT NULL,
  `field` varchar(256) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validated` int DEFAULT '0' COMMENT '1 - Si 0 - No',
  PRIMARY KEY (`id`),
  KEY `idx_destinos_translations_changelog` (`idMasterDestino`,`created_at`),
  KEY `idx_destinos_translations_changelog_validated` (`validated`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COMMENT='Track the changes made in the destinos'
```

### `destinos_translations_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/DestinationTranslationsChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCambio | int | NO |  | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| idioma | varchar(2) | NO | MUL | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_destinos_translations_changelog_validation | BTREE | idioma | No |

#### DDL

```sql
CREATE TABLE `destinos_translations_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCambio` int NOT NULL,
  `user` varchar(16) NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_destinos_translations_changelog_validation` (`idioma`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3
```

### `divisas`

**Usado por:**
- `new-admin`: (`app/Models/Currency.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| codigo | char(3) | NO | MUL | NULL |  |
| nombre | varchar(32) | YES |  | NULL |  |
| simbolo | varchar(6) | YES |  | NULL |  |
| valor | float | NO |  | NULL |  |
| fecha | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| pais | int | YES | MUL | NULL |  |
| active_to_test | varchar(1) | YES |  | 0 |  |
| exchange_plus | decimal(3,2) | NO |  | 0.00 |  |
| active | varchar(1) | NO |  | 0 |  |
| front_class | varchar(64) | YES |  | NULL |  |
| position | int | YES |  | 1 |  |
| mark | varchar(1) | YES |  | , |  |
| taxes | decimal(4,2) | NO |  | NULL |  |
| taxName | varchar(56) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| code | BTREE | codigo | No |
| fk-divisas-pais-versus-paises-id | BTREE | pais | No |

#### DDL

```sql
CREATE TABLE `divisas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `codigo` char(3) NOT NULL,
  `nombre` varchar(32) DEFAULT NULL,
  `simbolo` varchar(6) DEFAULT NULL,
  `valor` float NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pais` int DEFAULT NULL,
  `active_to_test` varchar(1) DEFAULT '0',
  `exchange_plus` decimal(3,2) NOT NULL DEFAULT '0.00',
  `active` varchar(1) NOT NULL DEFAULT '0',
  `front_class` varchar(64) DEFAULT NULL,
  `position` int DEFAULT '1' COMMENT 'Posicion simbolo 0-Antes 1-Despues',
  `mark` varchar(1) DEFAULT ',' COMMENT 'Simbolo de los decimales',
  `taxes` decimal(4,2) NOT NULL,
  `taxName` varchar(56) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `code` (`codigo`),
  KEY `fk-divisas-pais-versus-paises-id` (`pais`),
  CONSTRAINT `fk-divisas-pais-versus-paises-id` FOREIGN KEY (`pais`) REFERENCES `paises` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8mb3
```

### `divisas_translations`

**Usado por:**
- `new-admin`: (`app/Models/DivisasTranslations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| divisa_id | int | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| value | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `divisas_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `divisa_id` int NOT NULL,
  `lang` varchar(2) NOT NULL,
  `value` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=797 DEFAULT CHARSET=utf8mb3
```

### `email_logs`

**Usado por:**
- `new-admin`: (`app/Models/EmailLogs.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| pnr | int | NO | MUL | NULL |  |
| service_type | int | NO |  | NULL |  |
| email | varchar(200) | NO |  | NULL |  |
| smtp_id | varchar(100) | NO | MUL | NULL |  |
| msg_id | varchar(100) | NO | MUL | NULL |  |
| notification_type | varchar(512) | NO |  | NULL |  |
| customer | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_email_logs_msg_id | BTREE | msg_id | No |
| idx_email_logs_pnr | BTREE | pnr, service_type | No |
| idx_email_logs_smtp_id | BTREE | smtp_id | No |

#### DDL

```sql
CREATE TABLE `email_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pnr` int NOT NULL,
  `service_type` int NOT NULL,
  `email` varchar(200) NOT NULL,
  `smtp_id` varchar(100) NOT NULL,
  `msg_id` varchar(100) NOT NULL,
  `notification_type` varchar(512) NOT NULL,
  `customer` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_email_logs_smtp_id` (`smtp_id`),
  KEY `idx_email_logs_msg_id` (`msg_id`),
  KEY `idx_email_logs_pnr` (`pnr`,`service_type`)
) ENGINE=InnoDB AUTO_INCREMENT=160583396 DEFAULT CHARSET=utf8mb3
```

### `email_messages_logs`

**Usado por:**
- `new-admin`: (`app/Models/EmailMessagesLogs.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| email_logs_id | int | NO | MUL | NULL |  |
| event | varchar(200) | NO |  | NULL |  |
| ip | varchar(20) | YES |  | NULL |  |
| tls | int | YES |  | NULL |  |
| reason | text | YES |  | NULL |  |
| url | varchar(512) | YES |  | NULL |  |
| timestamp | timestamp | YES |  | NULL |  |
| send_at | timestamp | YES |  | NULL |  |
| event_id | varchar(100) | YES | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_email_logs_id | BTREE | email_logs_id | No |
| idx_email_messages_logs_event_id | BTREE | event_id | No |

#### DDL

```sql
CREATE TABLE `email_messages_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email_logs_id` int NOT NULL,
  `event` varchar(200) NOT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `tls` int DEFAULT NULL,
  `reason` text,
  `url` varchar(512) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT NULL,
  `send_at` timestamp NULL DEFAULT NULL,
  `event_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_email_messages_logs_event_id` (`event_id`),
  KEY `idx_email_logs_id` (`email_logs_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3544 DEFAULT CHARSET=utf8mb3
```

### `facturas_agencias_tours`

**Usado por:**
- `new-admin`: (`app/Models/AgencyTourInvoices.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_factura | varchar(256) | YES |  | NULL |  |
| group_id | int | YES |  | NULL |  |
| total | double | NO |  | NULL |  |
| divisa | varchar(3) | NO |  | NULL |  |
| total_euros | double | NO |  | NULL |  |
| concepto | text | NO |  | NULL |  |
| tipo_identificacion | varchar(3) | NO |  | NULL |  |
| identificacion | varchar(50) | NO |  | NULL |  |
| pais | varchar(2) | NO |  | NULL |  |
| nombre_razon | varchar(256) | NO |  | NULL |  |
| ciudad | varchar(100) | NO |  | NULL |  |
| cp | varchar(10) | NO |  | NULL |  |
| direccion | text | NO |  | NULL |  |
| pagada | int | NO |  | 0 |  |
| fecha_factura | date | NO |  | NULL |  |
| id_factura_master | int | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `facturas_agencias_tours` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_factura` varchar(256) DEFAULT NULL,
  `group_id` int DEFAULT NULL,
  `total` double NOT NULL,
  `divisa` varchar(3) NOT NULL,
  `total_euros` double NOT NULL,
  `concepto` text NOT NULL,
  `tipo_identificacion` varchar(3) NOT NULL,
  `identificacion` varchar(50) NOT NULL,
  `pais` varchar(2) NOT NULL,
  `nombre_razon` varchar(256) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `cp` varchar(10) NOT NULL,
  `direccion` text NOT NULL,
  `pagada` int NOT NULL DEFAULT '0',
  `fecha_factura` date NOT NULL,
  `id_factura_master` int DEFAULT NULL,
  `orden` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Facturas de la comision de agencia pagada cada mes'
```

### `facturas_clientes`

**Usado por:**
- `new-admin`: (`app/Models/ClientInvoice.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO |  | NULL |  |
| id_servicio | int | NO |  | NULL |  |
| id_proveedor | int | NO |  | 0 |  |
| tipo_servicio | int | NO |  | NULL |  |
| concepto | text | NO |  | NULL |  |
| cliente | text | NO |  | NULL |  |
| fecha_servicio | date | NO |  | NULL |  |
| fecha_factura | date | NO |  | NULL |  |
| pvp | double | YES |  | NULL |  |
| iva | double | NO |  | NULL |  |
| total | double | NO |  | NULL |  |
| neto | double | NO |  | NULL |  |
| regimen_especial | tinyint | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|

#### DDL

```sql
CREATE TABLE `facturas_clientes` (
  `id` int NOT NULL,
  `id_servicio` int NOT NULL,
  `id_proveedor` int NOT NULL DEFAULT '0',
  `tipo_servicio` int NOT NULL,
  `concepto` text NOT NULL,
  `cliente` text NOT NULL,
  `fecha_servicio` date NOT NULL,
  `fecha_factura` date NOT NULL,
  `pvp` double DEFAULT NULL,
  `iva` double NOT NULL,
  `total` double NOT NULL,
  `neto` double NOT NULL,
  `regimen_especial` tinyint DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `facturas_clientes_datos`

**Usado por:**
- `new-admin`: (`app/Models/ClientInvoiceData.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id_factura | int | NO | MUL | NULL |  |
| id_servicio | int | NO | PRI | NULL |  |
| tipo_servicio | int | NO | PRI | NULL |  |
| nombre_fiscal | varchar(100) | YES |  | NULL |  |
| direccion | text | YES |  | NULL |  |
| tipo_identificacion | varchar(2) | YES |  | 01 |  |
| cif | varchar(50) | YES |  | NULL |  |
| cp | varchar(10) | YES |  | NULL |  |
| cod_pais | varchar(2) | YES |  | NULL |  |
| ciudad | varchar(100) | YES |  | NULL |  |
| expediente_agencia | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id_servicio, tipo_servicio | Sí |
| idx_facturas_clientes_datos_factura | BTREE | id_factura | No |

#### DDL

```sql
CREATE TABLE `facturas_clientes_datos` (
  `id_factura` int NOT NULL,
  `id_servicio` int NOT NULL,
  `tipo_servicio` int NOT NULL,
  `nombre_fiscal` varchar(100) DEFAULT NULL,
  `direccion` text,
  `tipo_identificacion` varchar(2) DEFAULT '01' COMMENT '01 - NIF/CIF, 02 - NIF-IVA, 03 - Pasaporte, 04 - Documento oficial de identificación expedido por el país o territorio de residencia, 05 - Certificado de residencia, 06 -  Otro documento probatorio, 07 - No censado',
  `cif` varchar(50) DEFAULT NULL,
  `cp` varchar(10) DEFAULT NULL,
  `cod_pais` varchar(2) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `expediente_agencia` text,
  PRIMARY KEY (`id_servicio`,`tipo_servicio`),
  KEY `idx_facturas_clientes_datos_factura` (`id_factura`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `facturas_proveedores_tours`

**Usado por:**
- `new-admin`: (`app/Models/ProviderInvoicesTours.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_factura | varchar(256) | YES |  | NULL |  |
| id_proveedor | int | YES |  | NULL |  |
| total | double | NO |  | NULL |  |
| divisa | varchar(3) | NO |  | NULL |  |
| total_euros | double | NO |  | NULL |  |
| concepto | text | YES |  | NULL |  |
| tipo_identificacion | varchar(3) | YES |  | NULL |  |
| identificacion | varchar(50) | YES |  | NULL |  |
| pais | varchar(2) | YES |  | NULL |  |
| nombre_razon | varchar(256) | YES |  | NULL |  |
| ciudad | varchar(100) | YES |  | NULL |  |
| cp | varchar(10) | YES |  | NULL |  |
| direccion | text | YES |  | NULL |  |
| pagada | int | NO |  | 0 |  |
| fecha_pago | date | YES |  | NULL |  |
| fecha_factura | date | NO |  | NULL |  |
| id_factura_master | int | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| total_sepa | double | YES |  | 0 |  |
| total_ebury | double | YES |  | 0 |  |
| status | int | YES |  | 0 |  |
| error | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `facturas_proveedores_tours` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_factura` varchar(256) DEFAULT NULL,
  `id_proveedor` int DEFAULT NULL,
  `total` double NOT NULL,
  `divisa` varchar(3) NOT NULL,
  `total_euros` double NOT NULL,
  `concepto` text,
  `tipo_identificacion` varchar(3) DEFAULT NULL,
  `identificacion` varchar(50) DEFAULT NULL,
  `pais` varchar(2) DEFAULT NULL,
  `nombre_razon` varchar(256) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `cp` varchar(10) DEFAULT NULL,
  `direccion` text,
  `pagada` int NOT NULL DEFAULT '0',
  `fecha_pago` date DEFAULT NULL,
  `fecha_factura` date NOT NULL,
  `id_factura_master` int DEFAULT NULL,
  `orden` int DEFAULT NULL,
  `total_sepa` double DEFAULT '0',
  `total_ebury` double DEFAULT '0',
  `status` int DEFAULT '0' COMMENT '0 No enviada, 1 enviada, 3, lista para enviar,  2 error al enviar',
  `error` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COMMENT='0 No enviada, 1 enviada, 3, lista para enviar,  2 error al enviar'
```

### `facturas_reservas_beneficio_afiliados`

**Usado por:**
- `new-admin`: (`app/Models/AffiliateInvoiceBookings.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_factura | int | YES | MUL | NULL |  |
| id_producto | int | YES | MUL | NULL |  |
| type | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_facturas_reservas_beneficio_afiliados_id_factura | BTREE | id_factura | No |
| idx_facturas_reservas_beneficio_afiliados_id_producto_type | BTREE | id_producto, type | No |

#### DDL

```sql
CREATE TABLE `facturas_reservas_beneficio_afiliados` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_factura` int DEFAULT NULL,
  `id_producto` int DEFAULT NULL,
  `type` int NOT NULL COMMENT '1 Actividad 2 Traslado',
  PRIMARY KEY (`id`),
  KEY `idx_facturas_reservas_beneficio_afiliados_id_factura` (`id_factura`),
  KEY `idx_facturas_reservas_beneficio_afiliados_id_producto_type` (`id_producto`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4469 DEFAULT CHARSET=utf8mb3 COMMENT='Relacion de las reservas con las facturas del beneficio de afiliados'
```

### `facturas_reservas_beneficio_civitatis`

**Usado por:**
- `new-admin`: (`app/Models/ProviderInvoicesNewModel.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_factura | int | YES | MUL | NULL |  |
| id_producto | int | YES | MUL | NULL |  |
| type | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| facturas_reservas_beneficio_civitatis_unique_id_producto_type | BTREE | id_producto, type | Sí |
| idx_facturas_reservas_beneficio_civitatis_id_factura | BTREE | id_factura | No |
| idx_facturas_reservas_beneficio_civitatis_id_producto_type | BTREE | id_producto, type | No |

#### DDL

```sql
CREATE TABLE `facturas_reservas_beneficio_civitatis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_factura` int DEFAULT NULL,
  `id_producto` int DEFAULT NULL,
  `type` int NOT NULL COMMENT '1 Actividad 2 Traslado 3 Compensatoria',
  PRIMARY KEY (`id`),
  UNIQUE KEY `facturas_reservas_beneficio_civitatis_unique_id_producto_type` (`id_producto`,`type`),
  KEY `idx_facturas_reservas_beneficio_civitatis_id_factura` (`id_factura`),
  KEY `idx_facturas_reservas_beneficio_civitatis_id_producto_type` (`id_producto`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=8342838 DEFAULT CHARSET=utf8mb3 COMMENT='Relacion de las reservas con las facturas del beneficio'
```

### `facturas_reservas_pago_agencia`

**Usado por:**
- `new-admin`: (`app/Models/AgencyPaymentReservationInvoices.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_factura | int | YES |  | NULL |  |
| id_producto | int | YES |  | NULL |  |
| type | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `facturas_reservas_pago_agencia` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_factura` int DEFAULT NULL,
  `id_producto` int DEFAULT NULL,
  `type` int NOT NULL COMMENT '1 Actividad 2 Traslado 3 Compensatoria',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Relacion de las reservas con las facturas del pago mensual de la comision de agencia modelo antiguo'
```

### `facturas_reservas_pago_proveedor`

**Usado por:**
- `new-admin`: (`app/Models/ProviderInvoicesBookingPay.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_factura | int | YES |  | NULL |  |
| id_producto | int | YES |  | NULL |  |
| type | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `facturas_reservas_pago_proveedor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_factura` int DEFAULT NULL,
  `id_producto` int DEFAULT NULL,
  `type` int NOT NULL COMMENT '1 Actividad 2 Traslado 3 Compensatoria',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1161 DEFAULT CHARSET=utf8mb3 COMMENT='Relacion de las reservas con las facturas del pago mensual del proveedor modelo antiguo'
```

### `facturas_sii`

**Usado por:**
- `new-admin`: (`app/Models/InvoicesSii.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_factura | varchar(256) | YES | MUL | NULL |  |
| iva | double | NO |  | NULL |  |
| iva_rectificativa | double | NO |  | NULL |  |
| tipo_impositivo | double | NO |  | 21 |  |
| total | double | NO |  | NULL |  |
| concepto | text | YES |  | NULL |  |
| tipo_identificacion | varchar(3) | YES |  | NULL |  |
| identificacion | varchar(50) | YES |  | NULL |  |
| pais | varchar(2) | YES |  | NULL |  |
| nombre_razon | varchar(100) | YES |  | NULL |  |
| fecha_envio | datetime | YES |  | NULL |  |
| estado | int | NO | MUL | 0 |  |
| csv | varchar(50) | YES |  | NULL |  |
| codigo_error | varchar(20) | YES |  | NULL |  |
| error | text | YES |  | NULL |  |
| tipo_operacion_sujeta | text | YES |  | NULL |  |
| situacion_inmueble | tinyint | YES |  | NULL |  |
| referencia_catastral | text | YES |  | NULL |  |
| id_servicio | int | YES | MUL | NULL |  |
| tipo_servicio | int | YES |  | NULL |  |
| fecha_factura | date | YES |  | NULL |  |
| tipo_factura | varchar(3) | YES |  | F2 |  |
| tipo_rectificativa | varchar(2) | YES |  |  |  |
| regimen_especial | varchar(2) | YES |  | NULL |  |
| base_imponible | double | YES |  | NULL |  |
| base_rectificativa | double | YES |  | NULL |  |
| num_reintentos | int | YES |  | 0 |  |
| expediente_agencia | text | YES |  | NULL |  |
| ciudad | varchar(100) | YES |  | NULL |  |
| cp | varchar(10) | YES |  | NULL |  |
| direccion | text | YES |  | NULL |  |
| cliente | text | YES |  | NULL |  |
| id_proveedor | int | YES |  | NULL |  |
| fecha_servicio | date | YES |  | NULL |  |
| id_factura_master | int | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| prefix_invoice | varchar(256) | YES |  | NULL |  |
| navision_status | tinyint | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_facturas_sii_estado_nav_fecha_id_factura | BTREE | estado, navision_status, fecha_factura, id_factura | No |
| idx_facturas_sii_id_factura | BTREE | id_factura | No |
| idx_facturas_sii_id_servicio_tipo_servicio | BTREE | id_servicio, tipo_servicio | No |

#### DDL

```sql
CREATE TABLE `facturas_sii` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_factura` varchar(256) DEFAULT NULL,
  `iva` double NOT NULL,
  `iva_rectificativa` double NOT NULL,
  `tipo_impositivo` double NOT NULL DEFAULT '21',
  `total` double NOT NULL,
  `concepto` text,
  `tipo_identificacion` varchar(3) DEFAULT NULL,
  `identificacion` varchar(50) DEFAULT NULL,
  `pais` varchar(2) DEFAULT NULL,
  `nombre_razon` varchar(100) DEFAULT NULL,
  `fecha_envio` datetime DEFAULT NULL,
  `estado` int NOT NULL DEFAULT '0' COMMENT '0 - Not sended, 1 - Reject, 2 - Accepted with errors, 3 - Accepted',
  `csv` varchar(50) DEFAULT NULL,
  `codigo_error` varchar(20) DEFAULT NULL,
  `error` text,
  `tipo_operacion_sujeta` text COMMENT 'S1- sin inversion sujeto pasivo, S2-con inversion sujeto pasivo (iva a otro pais), S3',
  `situacion_inmueble` tinyint DEFAULT NULL COMMENT '1 - Inmueble con referencia catastral (excepto País Vasco y Navarra), 2 - Inmueble en el País Vasco o Navarra, 3 - Sin referencia catastral, 4 - inmueble en el extranjero',
  `referencia_catastral` text,
  `id_servicio` int DEFAULT NULL,
  `tipo_servicio` int DEFAULT NULL,
  `fecha_factura` date DEFAULT NULL,
  `tipo_factura` varchar(3) DEFAULT 'F2',
  `tipo_rectificativa` varchar(2) DEFAULT '',
  `regimen_especial` varchar(2) DEFAULT NULL,
  `base_imponible` double DEFAULT NULL,
  `base_rectificativa` double DEFAULT NULL,
  `num_reintentos` int DEFAULT '0',
  `expediente_agencia` text,
  `ciudad` varchar(100) DEFAULT NULL,
  `cp` varchar(10) DEFAULT NULL,
  `direccion` text,
  `cliente` text,
  `id_proveedor` int DEFAULT NULL,
  `fecha_servicio` date DEFAULT NULL,
  `id_factura_master` int DEFAULT NULL,
  `orden` int DEFAULT NULL,
  `prefix_invoice` varchar(256) DEFAULT NULL,
  `navision_status` tinyint DEFAULT '0' COMMENT '0.- Pendiente de consultar estado. 1.- Consultado y existente.',
  PRIMARY KEY (`id`),
  KEY `idx_facturas_sii_id_servicio_tipo_servicio` (`id_servicio`,`tipo_servicio`),
  KEY `idx_facturas_sii_id_factura` (`id_factura`(255)),
  KEY `idx_facturas_sii_estado_nav_fecha_id_factura` (`estado`,`navision_status`,`fecha_factura`,`id_factura`(255))
) ENGINE=InnoDB AUTO_INCREMENT=6182606 DEFAULT CHARSET=utf8mb3
```

### `facturas_sii_civitatis`

**Usado por:**
- `new-admin`: (`app/Models/InvoicesSiiCivitatis.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_factura | varchar(256) | YES |  | NULL |  |
| iva | double | NO |  | NULL |  |
| total | double | NO |  | NULL |  |
| concepto | text | NO |  | NULL |  |
| tipo_identificacion | varchar(3) | NO |  | NULL |  |
| identificacion | varchar(50) | NO |  | NULL |  |
| pais | varchar(2) | NO |  | NULL |  |
| nombre_razon | varchar(256) | NO |  | NULL |  |
| ciudad | varchar(100) | NO |  | NULL |  |
| cp | varchar(10) | NO |  | NULL |  |
| direccion | text | NO |  | NULL |  |
| fecha_envio | datetime | YES |  | NULL |  |
| estado | int | NO |  | 0 |  |
| csv | varchar(50) | YES |  | NULL |  |
| codigo_error | varchar(20) | YES |  | NULL |  |
| error | text | YES |  | NULL |  |
| regimen_especial | varchar(3) | NO |  | NULL |  |
| tipo_operacion_sujeta | text | NO |  | NULL |  |
| fecha_factura | date | NO |  | NULL |  |
| tipo_factura | varchar(3) | NO |  | NULL |  |
| base_imponible | double | NO |  | NULL |  |
| id_factura_master | int | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| tipo_impositivo | double | YES |  | NULL |  |
| pagada | int | YES |  | 0 |  |
| iva_original | double | YES |  | NULL |  |
| total_original | double | YES |  | NULL |  |
| base_imponible_original | double | YES |  | NULL |  |
| divisa | varchar(3) | NO |  | NULL |  |
| id_proveedor | int | YES |  | NULL |  |
| total_sepa | double | YES |  | 0 |  |
| total_ebury | double | YES |  | 0 |  |
| total_proveedor | double | YES |  | NULL |  |
| total_proveedor_euros | double | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `facturas_sii_civitatis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_factura` varchar(256) DEFAULT NULL,
  `iva` double NOT NULL,
  `total` double NOT NULL,
  `concepto` text NOT NULL,
  `tipo_identificacion` varchar(3) NOT NULL,
  `identificacion` varchar(50) NOT NULL,
  `pais` varchar(2) NOT NULL,
  `nombre_razon` varchar(256) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `cp` varchar(10) NOT NULL,
  `direccion` text NOT NULL,
  `fecha_envio` datetime DEFAULT NULL,
  `estado` int NOT NULL DEFAULT '0',
  `csv` varchar(50) DEFAULT NULL,
  `codigo_error` varchar(20) DEFAULT NULL,
  `error` text,
  `regimen_especial` varchar(3) NOT NULL,
  `tipo_operacion_sujeta` text NOT NULL,
  `fecha_factura` date NOT NULL,
  `tipo_factura` varchar(3) NOT NULL,
  `base_imponible` double NOT NULL,
  `id_factura_master` int DEFAULT NULL,
  `orden` int DEFAULT NULL,
  `tipo_impositivo` double DEFAULT NULL,
  `pagada` int DEFAULT '0' COMMENT '0 Sin pagar 1 Pagada',
  `iva_original` double DEFAULT NULL,
  `total_original` double DEFAULT NULL,
  `base_imponible_original` double DEFAULT NULL,
  `divisa` varchar(3) NOT NULL,
  `id_proveedor` int DEFAULT NULL,
  `total_sepa` double DEFAULT '0',
  `total_ebury` double DEFAULT '0',
  `total_proveedor` double DEFAULT NULL,
  `total_proveedor_euros` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7941 DEFAULT CHARSET=utf8mb3 COMMENT='Facturas de la ganancia Civitatis para Hacienda'
```

### `facturas_sii_seq`

**Usado por:**
- `new-admin`: (`app/Models/InvoicesSiiSeq.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| prefix | varchar(30) | NO | MUL | NULL |  |
| next_id | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_facturas_sii_seq_prefix | BTREE | prefix | No |

#### DDL

```sql
CREATE TABLE `facturas_sii_seq` (
  `id` int NOT NULL AUTO_INCREMENT,
  `prefix` varchar(30) NOT NULL,
  `next_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_facturas_sii_seq_prefix` (`prefix`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb3
```

### `faq`

**Usado por:**
- `new-admin`: (`app/Models/Faq.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_proveedor | int | NO |  | NULL |  |
| id_actividad | int | NO | MUL | NULL |  |
| pregunta | text | NO |  | NULL |  |
| respuesta | text | NO |  | NULL |  |
| created_at | timestamp | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| public | int | NO |  | 0 |  |
| preference | int | NO |  | 1 |  |
| seo_content_date | date | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_faqs_idActividad_public | BTREE | id_actividad, public | No |

#### DDL

```sql
CREATE TABLE `faq` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_proveedor` int NOT NULL,
  `id_actividad` int NOT NULL,
  `pregunta` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `respuesta` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `public` int NOT NULL DEFAULT '0',
  `preference` int NOT NULL DEFAULT '1',
  `seo_content_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_faqs_idActividad_public` (`id_actividad`,`public`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `faq_translation`

**Usado por:**
- `new-admin`: (`app/Models/FaqTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int unsigned | NO | PRI | NULL | auto_increment |
| faq_id | int | NO | MUL | NULL |  |
| lang | char(2) | NO |  | NULL |  |
| question | text | NO |  | NULL |  |
| answer | text | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| uq_faq_translation_faq_id_lang | BTREE | faq_id, lang | Sí |

#### DDL

```sql
CREATE TABLE `faq_translation` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `faq_id` int NOT NULL,
  `lang` char(2) COLLATE utf8mb3_unicode_ci NOT NULL,
  `question` text COLLATE utf8mb3_unicode_ci NOT NULL,
  `answer` text COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_faq_translation_faq_id_lang` (`faq_id`,`lang`),
  CONSTRAINT `fk_faq_translation_faq_id` FOREIGN KEY (`faq_id`) REFERENCES `faq` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `feed_users`

**Usado por:**
- `new-admin`: (`app/Models/FeedUser.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(128) | NO |  | NULL |  |
| token | varchar(256) | NO | MUL | NULL |  |
| active | tinyint | NO |  | 1 |  |
| entity_type | varchar(20) | YES |  | NULL |  |
| entity_id | int | NO |  | 0 |  |
| url_template | varchar(255) | YES |  | NULL |  |
| limit_time | int | NO |  | 5 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_feed_users_token | BTREE | token | No |

#### DDL

```sql
CREATE TABLE `feed_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `token` varchar(256) NOT NULL,
  `active` tinyint NOT NULL DEFAULT '1' COMMENT 'Active or not. Defaults to 1 (yes)',
  `entity_type` varchar(20) DEFAULT NULL,
  `entity_id` int NOT NULL DEFAULT '0',
  `url_template` varchar(255) DEFAULT NULL,
  `limit_time` int NOT NULL DEFAULT '5' COMMENT 'Time between queries',
  PRIMARY KEY (`id`),
  KEY `idx_feed_users_token` (`token`(255))
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3
```

### `feed_users_activities_query`

**Usado por:**
- `new-admin`: (`app/Models/FeedUserActivityQuery.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| feed_user_id | int | NO |  | NULL |  |
| fields | varchar(512) | NO |  | NULL |  |
| show_inactive | tinyint | NO |  | 1 |  |
| show_availability | tinyint | NO |  | 1 |  |
| show_target_cpa | tinyint | NO |  | 1 |  |
| active | tinyint | NO |  | 1 |  |
| show_image | tinyint | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `feed_users_activities_query` (
  `id` int NOT NULL AUTO_INCREMENT,
  `feed_user_id` int NOT NULL,
  `fields` varchar(512) NOT NULL,
  `show_inactive` tinyint NOT NULL DEFAULT '1' COMMENT 'Show inactives or not. Defaults to 1 (yes)',
  `show_availability` tinyint NOT NULL DEFAULT '1' COMMENT 'Show availability or not. Defaults to 1 (yes)',
  `show_target_cpa` tinyint NOT NULL DEFAULT '1' COMMENT 'Show target cpa or not. Defaults to 1 (yes)',
  `active` tinyint NOT NULL DEFAULT '1' COMMENT 'Active or not. Defaults to 1 (yes)',
  `show_image` tinyint DEFAULT '0' COMMENT '1-Show 0-No Show',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3
```

### `feed_users_destinations_query`

**Usado por:**
- `new-admin`: (`app/Models/FeedUserDestinationQuery.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| feed_user_id | int | NO |  | NULL |  |
| active | tinyint | NO |  | 1 |  |
| show_image | tinyint | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `feed_users_destinations_query` (
  `id` int NOT NULL AUTO_INCREMENT,
  `feed_user_id` int NOT NULL,
  `active` tinyint NOT NULL DEFAULT '1' COMMENT 'Active or not. Defaults to 1 (yes)',
  `show_image` tinyint DEFAULT '0' COMMENT '1-Show 0-No Show',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3
```

### `feed_users_transfers_query`

**Usado por:**
- `new-admin`: (`app/Models/FeedUserTransferQuery.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| feed_user_id | int | NO |  | NULL |  |
| fields | varchar(512) | NO |  | NULL |  |
| show_rating | tinyint | NO |  | 1 |  |
| show_num_reviews | tinyint | NO |  | 1 |  |
| show_target_cpa | tinyint | NO |  | 1 |  |
| active | tinyint | NO |  | 1 |  |
| show_image | tinyint | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `feed_users_transfers_query` (
  `id` int NOT NULL AUTO_INCREMENT,
  `feed_user_id` int NOT NULL,
  `fields` varchar(512) NOT NULL,
  `show_rating` tinyint NOT NULL DEFAULT '1' COMMENT 'Show rating or not. Defaults to 1 (yes)',
  `show_num_reviews` tinyint NOT NULL DEFAULT '1' COMMENT 'Show num reviews or not. Defaults to 1 (yes)',
  `show_target_cpa` tinyint NOT NULL DEFAULT '1' COMMENT 'Show target cpa or not. Defaults to 1 (yes)',
  `active` tinyint NOT NULL DEFAULT '1' COMMENT 'Active or not. Defaults to 1 (yes)',
  `show_image` tinyint DEFAULT '0' COMMENT '1-Show 0-No Show',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3
```

### `fichajes`

**Usado por:**
- `new-admin`: (`app/Models/Fichaje.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| user_id | int | NO |  | NULL |  |
| type | varchar(50) | NO |  | NULL |  |
| date | datetime | NO |  | NULL |  |
| latitude | varchar(50) | YES |  | NULL |  |
| longitude | varchar(50) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `fichajes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` varchar(50) NOT NULL,
  `date` datetime NOT NULL,
  `latitude` varchar(50) DEFAULT NULL,
  `longitude` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `formas_contacto`

**Usado por:**
- `new-admin`: (`app/Models/ContactForm.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_type_contact | int | NO |  | NULL |  |
| enabled | int | NO |  | NULL |  |
| comments | varchar(32) | NO |  | NULL |  |
| start_hour | time | YES |  | NULL |  |
| end_hour | time | YES |  | NULL |  |
| is_24_hour_schedule | tinyint | YES |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `formas_contacto` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_type_contact` int NOT NULL,
  `enabled` int NOT NULL,
  `comments` varchar(32) NOT NULL,
  `start_hour` time DEFAULT NULL,
  `end_hour` time DEFAULT NULL,
  `is_24_hour_schedule` tinyint DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3
```

### `fotos`

**Usado por:**
- `new-admin`: (`app/Models/Photo.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idAlbum | int | NO | MUL | NULL |  |
| archivo | varchar(64) | NO |  | NULL |  |
| alt | varchar(128) | NO |  | NULL |  |
| titulo | varchar(128) | NO |  | NULL |  |
| principal | tinyint(1) | NO |  | 0 |  |
| noMostrar | tinyint(1) | YES |  | 0 |  |
| anchoMini | int | NO |  | NULL |  |
| altoMini | int | NO |  | NULL |  |
| anchoThumb | int | NO |  | NULL |  |
| altoThumb | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idAlbum | BTREE | idAlbum, archivo | Sí |

#### DDL

```sql
CREATE TABLE `fotos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idAlbum` int NOT NULL,
  `archivo` varchar(64) NOT NULL,
  `alt` varchar(128) NOT NULL,
  `titulo` varchar(128) NOT NULL,
  `principal` tinyint(1) NOT NULL DEFAULT '0',
  `noMostrar` tinyint(1) DEFAULT '0',
  `anchoMini` int NOT NULL,
  `altoMini` int NOT NULL,
  `anchoThumb` int NOT NULL,
  `altoThumb` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idAlbum` (`idAlbum`,`archivo`)
) ENGINE=InnoDB AUTO_INCREMENT=5231 DEFAULT CHARSET=utf8mb3
```

### `fotos_master`

**Usado por:**
- `new-admin`: (`app/Models/PhotoMaster.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterAlbum | int | NO | MUL | NULL |  |
| archivo | varchar(64) | NO |  | NULL |  |
| principal | tinyint | NO |  | 0 |  |
| noMostrar | tinyint | YES |  | 0 |  |
| anchoMini | int | NO |  | NULL |  |
| altoMini | int | NO |  | NULL |  |
| anchoThumb | int | NO |  | NULL |  |
| altoThumb | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_fotos_master_idMasterAlbum | BTREE | idMasterAlbum | No |

#### DDL

```sql
CREATE TABLE `fotos_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterAlbum` int NOT NULL,
  `archivo` varchar(64) NOT NULL,
  `principal` tinyint NOT NULL DEFAULT '0',
  `noMostrar` tinyint DEFAULT '0',
  `anchoMini` int NOT NULL,
  `altoMini` int NOT NULL,
  `anchoThumb` int NOT NULL,
  `altoThumb` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_fotos_master_idMasterAlbum` (`idMasterAlbum`)
) ENGINE=InnoDB AUTO_INCREMENT=16800 DEFAULT CHARSET=utf8mb3
```

### `fotos_translations`

**Usado por:**
- `new-admin`: (`app/Models/PhotoTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterFoto | int | NO | MUL | NULL |  |
| idioma | varchar(2) | NO |  | NULL |  |
| alt | varchar(128) | NO |  | NULL |  |
| titulo | varchar(128) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_fotos_translations_idMasterFoto_idioma | BTREE | idMasterFoto, idioma | No |

#### DDL

```sql
CREATE TABLE `fotos_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterFoto` int NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `alt` varchar(128) NOT NULL,
  `titulo` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_fotos_translations_idMasterFoto_idioma` (`idMasterFoto`,`idioma`)
) ENGINE=InnoDB AUTO_INCREMENT=100328 DEFAULT CHARSET=utf8mb3
```

### `general_condition`

**Usado por:**
- `new-admin`: (`app/Models/GeneralCondition.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | YES |  | 0 |  |
| colaborator_type | varchar(255) | YES |  | NULL |  |
| title | text | YES |  | NULL |  |
| answer | text | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| status | tinyint | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| active | tinyint | YES |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `general_condition` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int DEFAULT '0',
  `colaborator_type` varchar(255) DEFAULT NULL COMMENT '0.Generales 1.Proveedores 2.Agencia 3.Afiliado 4. Grupos Agencias 5. Alojamientos 6.Grupos Alojamientos 7.Particulares',
  `title` text,
  `answer` text,
  `orden` int DEFAULT NULL,
  `status` tinyint DEFAULT NULL COMMENT '0.No publicado 1.Publicado',
  `lang` varchar(2) DEFAULT NULL,
  `active` tinyint DEFAULT '1' COMMENT '0.Desactivada 1.Activa',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Condiciones generales y de agencias,afiliados y proveedores'
```

### `general_condition_changelog`

**Usado por:**
- `new-admin`: (`app/Models/GeneralConditionChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idGc | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| field | varchar(64) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validation | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `general_condition_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idGc` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `field` varchar(64) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validation` int DEFAULT '0' COMMENT '1-Si 0-No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='changelog de general_condition'
```

### `general_condition_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/GeneralConditionChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idChange | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `general_condition_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idChange` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `lang` varchar(2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Validadores de general_condition'
```

### `google_pois`

**Usado por:**
- `new-admin`: (`app/Models/Poi.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| place_id | varchar(200) | NO | PRI | NULL |  |
| address | varchar(255) | NO |  | NULL |  |
| name | varchar(100) | NO |  | NULL |  |
| lat | double | YES |  | NULL |  |
| long | double | YES |  | NULL |  |
| image | varchar(255) | YES |  | NULL |  |
| has_landing | tinyint | NO |  | 0 |  |
| meta_title | varchar(70) | YES |  | NULL |  |
| meta_description | varchar(160) | YES |  | NULL |  |
| content | text | YES |  | NULL |  |
| weight | int | NO | MUL | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | place_id | Sí |
| idx_google_pois_weight | BTREE | weight | No |

#### DDL

```sql
CREATE TABLE `google_pois` (
  `place_id` varchar(200) NOT NULL,
  `address` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `lat` double DEFAULT NULL,
  `long` double DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL COMMENT 'Imagen de cabecera del POI',
  `has_landing` tinyint NOT NULL DEFAULT '0' COMMENT '1 activo 0 inactivo',
  `meta_title` varchar(70) DEFAULT NULL,
  `meta_description` varchar(160) DEFAULT NULL,
  `content` text,
  `weight` int NOT NULL DEFAULT '0' COMMENT 'Cantidad de actividades activas en el POI',
  PRIMARY KEY (`place_id`),
  KEY `idx_google_pois_weight` (`weight`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Cantidad de actividades activas en el POI'
```

### `google_pois_related`

**Usado por:**
- `new-admin`: (`app/Models/PoiRelated.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| parent_id | varchar(200) | NO | MUL | NULL |  |
| place_id | varchar(200) | NO | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| fk_google_pois_related_parent_id_google_pois | BTREE | parent_id | No |
| fk_google_pois_related_place_id_google_pois | BTREE | place_id | No |

#### DDL

```sql
CREATE TABLE `google_pois_related` (
  `parent_id` varchar(200) NOT NULL,
  `place_id` varchar(200) NOT NULL,
  KEY `fk_google_pois_related_parent_id_google_pois` (`parent_id`),
  KEY `fk_google_pois_related_place_id_google_pois` (`place_id`),
  CONSTRAINT `fk_google_pois_related_parent_id_google_pois` FOREIGN KEY (`parent_id`) REFERENCES `google_pois` (`place_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_google_pois_related_place_id_google_pois` FOREIGN KEY (`place_id`) REFERENCES `google_pois` (`place_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `google_pois_secondary_destinations`

**Usado por:**
- `new-admin`: (`app/Models/PoiSecondaryDestination.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| destination_id | int | NO | MUL | NULL |  |
| place_id | varchar(200) | NO | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| fk_google_pois_secondary_destinations_destination_id_destinos | BTREE | destination_id | No |
| fk_google_pois_secondary_destinations_place_id_google_pois | BTREE | place_id | No |

#### DDL

```sql
CREATE TABLE `google_pois_secondary_destinations` (
  `destination_id` int NOT NULL,
  `place_id` varchar(200) NOT NULL,
  KEY `fk_google_pois_secondary_destinations_place_id_google_pois` (`place_id`),
  KEY `fk_google_pois_secondary_destinations_destination_id_destinos` (`destination_id`),
  CONSTRAINT `fk_google_pois_secondary_destinations_destination_id_destinos` FOREIGN KEY (`destination_id`) REFERENCES `destinos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_google_pois_secondary_destinations_place_id_google_pois` FOREIGN KEY (`place_id`) REFERENCES `google_pois` (`place_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `google_pois_translations`

**Usado por:**
- `new-admin`: (`app/Models/PoiTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| place_id | varchar(200) | NO | MUL | NULL |  |
| title | varchar(255) | NO |  | NULL |  |
| url | varchar(100) | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| actividadesen | varchar(255) | YES |  | NULL |  |
| trasladosen | varchar(255) | YES |  | NULL |  |
| on_poi | varchar(255) | YES |  | NULL |  |
| to_poi | varchar(255) | YES |  | NULL |  |
| near_to | varchar(255) | YES |  | NULL |  |
| meta_title | varchar(70) | YES |  | NULL |  |
| meta_description | varchar(160) | YES |  | NULL |  |
| content | text | YES |  | NULL |  |
| indexable | tinyint(1) | YES |  | 0 |  |
| bookings_last_year | int | YES |  | NULL |  |
| primary_activity_id | int unsigned | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_google_pois_translations_place_id_google_pois | BTREE | place_id | No |

#### DDL

```sql
CREATE TABLE `google_pois_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `place_id` varchar(200) NOT NULL,
  `title` varchar(255) NOT NULL,
  `url` varchar(100) NOT NULL,
  `lang` varchar(2) NOT NULL,
  `actividadesen` varchar(255) DEFAULT NULL,
  `trasladosen` varchar(255) DEFAULT NULL,
  `on_poi` varchar(255) DEFAULT NULL,
  `to_poi` varchar(255) DEFAULT NULL,
  `near_to` varchar(255) DEFAULT NULL,
  `meta_title` varchar(70) DEFAULT NULL,
  `meta_description` varchar(160) DEFAULT NULL,
  `content` text,
  `indexable` tinyint(1) DEFAULT '0' COMMENT '1 - Si, 0 - No',
  `bookings_last_year` int DEFAULT NULL,
  `primary_activity_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_google_pois_translations_place_id_google_pois` (`place_id`),
  CONSTRAINT `fk_google_pois_translations_place_id_google_pois` FOREIGN KEY (`place_id`) REFERENCES `google_pois` (`place_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Determina la posicion del poi en funcion de las reservas que haya tenido en el ultimo año'
```

### `google_pois_translations_changelog`

**Usado por:**
- `new-admin`: (`app/Models/PoiTranslationChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO |  | NULL |  |
| place_id | varchar(255) | NO |  | NULL |  |
| field | varchar(255) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validated | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|

#### DDL

```sql
CREATE TABLE `google_pois_translations_changelog` (
  `id` int NOT NULL,
  `place_id` varchar(255) NOT NULL,
  `field` varchar(255) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validated` int DEFAULT '0' COMMENT '1 - Si 0 - No'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `google_pois_translations_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/PoiTranslationChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCambio | int | NO |  | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| idioma | varchar(2) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `google_pois_translations_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCambio` int NOT NULL,
  `user` varchar(16) NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `guias`

**Usado por:**
- `new-admin`: (`app/Models/Guide.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_destino | int | NO | MUL | NULL |  |
| nombre | varchar(32) | NO |  | NULL |  |
| nombreWeb | varchar(32) | NO |  | NULL |  |
| dominio | varchar(64) | NO | UNI | NULL |  |
| idioma | char(2) | NO |  | NULL |  |
| continente | tinyint | YES |  | NULL |  |
| publicada | int | YES |  | 0 |  |
| analytics | varchar(32) | YES |  | NULL |  |
| hotjar | varchar(32) | YES |  | NULL |  |
| guiade | varchar(256) | YES |  | NULL |  |
| activities_from_zone | int | YES |  | NULL |  |
| adyen_js_test_key | tinytext | YES |  | NULL |  |
| adyen_js_live_key | tinytext | YES |  | NULL |  |
| transfers_from_city | int | YES |  | NULL |  |
| fb_appid | varchar(128) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_guias_destino_idioma | BTREE | id_destino, idioma | No |
| idx_guias_dominio | BTREE | dominio | Sí |

#### DDL

```sql
CREATE TABLE `guias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_destino` int NOT NULL COMMENT 'Positivo ciudad negativo país',
  `nombre` varchar(32) NOT NULL,
  `nombreWeb` varchar(32) NOT NULL,
  `dominio` varchar(64) NOT NULL,
  `idioma` char(2) NOT NULL,
  `continente` tinyint DEFAULT NULL COMMENT '1 = Europa , 2 = Norteamérica, 3 = Sudamérica, 4 = Asia, 5 = África, 6 = Oceanía, 7 = Antártida',
  `publicada` int DEFAULT '0' COMMENT '1 - Si 0 - No / No se pone publicada hasta que sistemas no chequea que no existen 404',
  `analytics` varchar(32) DEFAULT NULL,
  `hotjar` varchar(32) DEFAULT NULL,
  `guiade` varchar(256) DEFAULT NULL,
  `activities_from_zone` int DEFAULT NULL,
  `adyen_js_test_key` tinytext,
  `adyen_js_live_key` tinytext,
  `transfers_from_city` int DEFAULT NULL,
  `fb_appid` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_guias_dominio` (`dominio`),
  KEY `idx_guias_destino_idioma` (`id_destino`,`idioma`)
) ENGINE=InnoDB AUTO_INCREMENT=614 DEFAULT CHARSET=utf8mb3
```

### `guias_apps`

**Usado por:**
- `new-admin`: (`app/Models/GuideApp.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idGuide | int | NO |  | NULL |  |
| type | int | NO |  | NULL |  |
| url | varchar(256) | YES |  | NULL |  |
| idApp | varchar(256) | YES |  | NULL |  |
| icon_link | varchar(256) | YES |  | NULL |  |
| android_package | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `guias_apps` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idGuide` int NOT NULL,
  `type` int NOT NULL COMMENT '1 - Apple 2- Android',
  `url` varchar(256) DEFAULT NULL,
  `idApp` varchar(256) DEFAULT NULL,
  `icon_link` varchar(256) DEFAULT NULL,
  `android_package` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1044 DEFAULT CHARSET=utf8mb3
```

### `guias_navbar`

**Usado por:**
- `new-admin`: (`app/Models/GuideNavbar.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| title | varchar(256) | NO |  | NULL |  |
| idParent | int | NO | MUL | NULL |  |
| orden | int | NO |  | NULL |  |
| icon | varchar(256) | YES |  | NULL |  |
| label_title | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| gn_id_idx | BTREE | idParent, orden | No |

#### DDL

```sql
CREATE TABLE `guias_navbar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(256) NOT NULL,
  `idParent` int NOT NULL,
  `orden` int NOT NULL,
  `icon` varchar(256) DEFAULT NULL,
  `label_title` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gn_id_idx` (`idParent`,`orden`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3
```

### `guias_navbar_relations`

**Usado por:**
- `new-admin`: (`app/Models/GuideNavbarRelations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_guide | int | NO |  | NULL |  |
| id_navbar | int | NO |  | NULL |  |
| status | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `guias_navbar_relations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_guide` int NOT NULL,
  `id_navbar` int NOT NULL,
  `status` int DEFAULT '0' COMMENT '1: mostrar, 0: no mostrar',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25087 DEFAULT CHARSET=utf8mb3
```

### `guias_navbar_translations`

**Usado por:**
- `new-admin`: (`app/Models/GuideNavbarTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idNavBarMaster | int | NO |  | NULL |  |
| title | varchar(256) | NO |  | NULL |  |
| url | varchar(256) | NO |  | NULL |  |
| lang | varchar(2) | NO | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| gnt_lang_status_idx | BTREE | lang | No |

#### DDL

```sql
CREATE TABLE `guias_navbar_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idNavBarMaster` int NOT NULL,
  `title` varchar(256) NOT NULL,
  `url` varchar(256) NOT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gnt_lang_status_idx` (`lang`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb3
```

### `guias_relations`

**Usado por:**
- `new-admin`: (`app/Models/GuideRelations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idGuideMaster | int | NO | MUL | NULL |  |
| idGuideRelated | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| gr_master_idx | BTREE | idGuideMaster | No |

#### DDL

```sql
CREATE TABLE `guias_relations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idGuideMaster` int NOT NULL,
  `idGuideRelated` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gr_master_idx` (`idGuideMaster`)
) ENGINE=InnoDB AUTO_INCREMENT=13851 DEFAULT CHARSET=utf8mb3
```

### `guide_options`

**Usado por:**
- `new-admin`: (`app/Models/GuideOptions.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| label | varchar(100) | NO |  | NULL |  |
| type | varchar(100) | NO |  | NULL |  |
| meta | varchar(255) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `guide_options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label` varchar(100) NOT NULL COMMENT 'Descripcion del modo de guía',
  `type` varchar(100) NOT NULL COMMENT 'guide/realization/language',
  `meta` varchar(255) DEFAULT NULL COMMENT 'guide/realization/language',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb3
```

### `guides_pages_activities`

**Usado por:**
- `new-admin`: (`app/Models/GuidePageActivity.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_page | int | YES | MUL | NULL |  |
| id_activity | int | NO |  | NULL |  |
| orden | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| gpa_translation_page_idx | BTREE | id_master_page, orden | No |

#### DDL

```sql
CREATE TABLE `guides_pages_activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_page` int DEFAULT NULL,
  `id_activity` int NOT NULL,
  `orden` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gpa_translation_page_idx` (`id_master_page`,`orden`)
) ENGINE=InnoDB AUTO_INCREMENT=17585 DEFAULT CHARSET=utf8mb3
```

### `guides_pages_call_to_action`

**Usado por:**
- `new-admin`: (`app/Models/GuidePageCallToAction.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| page_id | int | NO |  | NULL |  |
| activity_id | int | YES |  | NULL |  |
| title | varchar(256) | NO |  | NULL |  |
| url | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `guides_pages_call_to_action` (
  `id` int NOT NULL AUTO_INCREMENT,
  `page_id` int NOT NULL,
  `activity_id` int DEFAULT NULL,
  `title` varchar(256) NOT NULL,
  `url` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41968 DEFAULT CHARSET=utf8mb3
```

### `guides_pages_master`

**Usado por:**
- `new-admin`: (`app/Models/GuidePageMaster.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| city_id | int | NO | MUL | NULL |  |
| title | varchar(256) | NO |  | NULL |  |
| latitude | varchar(64) | YES |  | NULL |  |
| longitude | varchar(64) | YES |  | NULL |  |
| zoom | varchar(64) | YES |  | NULL |  |
| type | int | NO |  | NULL |  |
| orden | int | NO |  | NULL |  |
| icon | varchar(256) | YES |  | NULL |  |
| aside_order | varchar(128) | YES |  | activities-first |  |
| category | int | YES |  | 0 |  |
| image | int | YES |  | 0 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| gpm_city_orden_idx | BTREE | city_id, orden | No |

#### DDL

```sql
CREATE TABLE `guides_pages_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `city_id` int NOT NULL,
  `title` varchar(256) NOT NULL,
  `latitude` varchar(64) DEFAULT NULL,
  `longitude` varchar(64) DEFAULT NULL,
  `zoom` varchar(64) DEFAULT NULL,
  `type` int NOT NULL COMMENT '0 - Home 1 - Main 2 - Detail',
  `orden` int NOT NULL,
  `icon` varchar(256) DEFAULT NULL,
  `aside_order` varchar(128) DEFAULT 'activities-first',
  `category` int DEFAULT '0',
  `image` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `gpm_city_orden_idx` (`city_id`,`orden`)
) ENGINE=InnoDB AUTO_INCREMENT=7828 DEFAULT CHARSET=utf8mb3
```

### `guides_pages_master_collections`

**Usado por:**
- `new-admin`: (`app/Models/GuidePageMasterCollection.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_page | int | NO | MUL | NULL |  |
| type | int | NO |  | NULL |  |
| orden | int | YES |  | NULL |  |
| display | varchar(256) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| co_master_idx | BTREE | id_master_page, orden | No |

#### DDL

```sql
CREATE TABLE `guides_pages_master_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_page` int NOT NULL,
  `type` int NOT NULL COMMENT '1 - Texto 2 - Tags 3 - Galería',
  `orden` int DEFAULT NULL,
  `display` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `co_master_idx` (`id_master_page`,`orden`)
) ENGINE=InnoDB AUTO_INCREMENT=16309 DEFAULT CHARSET=utf8mb3
```

### `guides_pages_master_collections_translations`

**Usado por:**
- `new-admin`: (`app/Models/GuidePageMasterCollectionTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_collection | int | NO | MUL | NULL |  |
| title | varchar(256) | YES |  | NULL |  |
| mostrar | int | NO |  | 0 |  |
| lang | varchar(2) | NO |  | NULL |  |
| target_url | varchar(128) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| ct_master_lang_idx | BTREE | id_master_collection, lang | No |

#### DDL

```sql
CREATE TABLE `guides_pages_master_collections_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_collection` int NOT NULL,
  `title` varchar(256) DEFAULT NULL,
  `mostrar` int NOT NULL DEFAULT '0',
  `lang` varchar(2) NOT NULL,
  `target_url` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ct_master_lang_idx` (`id_master_collection`,`lang`)
) ENGINE=InnoDB AUTO_INCREMENT=96893 DEFAULT CHARSET=utf8mb3
```

### `guides_pages_master_translations`

**Usado por:**
- `new-admin`: (`app/Models/GuidePageMasterTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_page | int | NO | MUL | NULL |  |
| title | varchar(256) | YES |  | NULL |  |
| title_menu | varchar(256) | YES |  | NULL |  |
| title_short | varchar(256) | YES |  | NULL |  |
| subtitle | text | YES |  | NULL |  |
| short_description | text | YES |  | NULL |  |
| url | varchar(64) | YES | MUL | NULL |  |
| keywords | varchar(512) | YES |  | NULL |  |
| mostrar | int | NO |  | 0 |  |
| lang | varchar(2) | NO |  | NULL |  |
| schedule | text | YES |  | NULL |  |
| price | text | YES |  | NULL |  |
| location | text | YES |  | NULL |  |
| transport | text | YES |  | NULL |  |
| actualizacion | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| message_app | text | YES |  | NULL |  |
| introduction | text | YES |  | NULL |  |
| title_app | varchar(256) | YES |  | NULL |  |
| seo_content_date | date | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| gpmt_master_lang_idx | BTREE | id_master_page, lang | No |
| gpmt_url_lang_idx | BTREE | url, lang | No |

#### DDL

```sql
CREATE TABLE `guides_pages_master_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_page` int NOT NULL,
  `title` varchar(256) DEFAULT NULL,
  `title_menu` varchar(256) DEFAULT NULL,
  `title_short` varchar(256) DEFAULT NULL,
  `subtitle` text,
  `short_description` text,
  `url` varchar(64) DEFAULT NULL,
  `keywords` varchar(512) DEFAULT NULL,
  `mostrar` int NOT NULL DEFAULT '0',
  `lang` varchar(2) NOT NULL,
  `schedule` text,
  `price` text,
  `location` text,
  `transport` text,
  `actualizacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `message_app` text,
  `introduction` text,
  `title_app` varchar(256) DEFAULT NULL,
  `seo_content_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gpmt_url_lang_idx` (`url`,`lang`),
  KEY `gpmt_master_lang_idx` (`id_master_page`,`lang`)
) ENGINE=InnoDB AUTO_INCREMENT=46849 DEFAULT CHARSET=utf8mb3
```

### `guides_pages_master_translations_changelog`

**Usado por:**
- `new-admin`: (`app/Models/GuidePageMasterTranslationChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterPage | int | NO | MUL | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validated | int | YES | MUL | 0 |  |
| user | varchar(16) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_guides_pages_master_translations_changelog | BTREE | idMasterPage, created_at | No |
| idx_guides_pages_master_translations_changelog_validated | BTREE | validated | No |

#### DDL

```sql
CREATE TABLE `guides_pages_master_translations_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterPage` int NOT NULL,
  `field` varchar(256) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validated` int DEFAULT '0' COMMENT '1 - Si 0 - No',
  `user` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_guides_pages_master_translations_changelog` (`idMasterPage`,`created_at`),
  KEY `idx_guides_pages_master_translations_changelog_validated` (`validated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Track the changes made in the pages'
```

### `guides_pages_master_translations_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/GuidePageMasterTranslationChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCambio | int | NO | MUL | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| idioma | varchar(2) | NO | MUL | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_gpmt_idCambio_idioma | BTREE | idCambio, idioma | No |
| idx_guides_pages_translations_changelog_validation | BTREE | idioma | No |

#### DDL

```sql
CREATE TABLE `guides_pages_master_translations_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCambio` int NOT NULL,
  `user` varchar(16) NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_guides_pages_translations_changelog_validation` (`idioma`),
  KEY `idx_gpmt_idCambio_idioma` (`idCambio`,`idioma`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `guides_pages_tags`

**Usado por:**
- `new-admin`: (`app/Models/GuidePageTag.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_page | int | NO |  | NULL |  |
| id_master_tag | int | NO | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| gpt_master_idx | BTREE | id_master_tag, id_master_page | No |

#### DDL

```sql
CREATE TABLE `guides_pages_tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_page` int NOT NULL,
  `id_master_tag` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gpt_master_idx` (`id_master_tag`,`id_master_page`)
) ENGINE=InnoDB AUTO_INCREMENT=33024 DEFAULT CHARSET=utf8mb3
```

### `historical_providers_conditions`

**Usado por:**
- `new-admin`: (`app/Models/HistoricalProvidersConditions.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| provider_id | int | NO |  | NULL |  |
| agreement_id | varchar(64) | YES |  | NULL |  |
| version_id | int | NO |  | NULL |  |
| responsable_name | varchar(512) | YES |  | NULL |  |
| ip | varchar(128) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| user_email | varchar(128) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `historical_providers_conditions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int NOT NULL,
  `agreement_id` varchar(64) DEFAULT NULL COMMENT 'Id del documento firmado por el proveedor en DocuSign',
  `version_id` int NOT NULL,
  `responsable_name` varchar(512) DEFAULT NULL,
  `ip` varchar(128) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_email` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COMMENT='Id del documento firmado por el proveedor en DocuSign'
```

### `image`

**Usado por:**
- `new-admin`: (`app/Models/Image.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL |  |
| path | varchar(128) | NO |  | NULL |  |
| original_url | varchar(256) | YES |  | NULL |  |
| preset_id | int | YES |  | NULL |  |
| width | int | YES |  | NULL |  |
| height | int | YES |  | NULL |  |
| created_at | datetime | YES |  | NULL |  |
| updated_at | datetime | YES |  | NULL |  |
| checked_at | datetime | YES |  | NULL |  |
| md5 | varchar(100) | YES | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| image_md5_index | BTREE | md5 | No |

#### DDL

```sql
CREATE TABLE `image` (
  `id` int NOT NULL,
  `path` varchar(128) NOT NULL,
  `original_url` varchar(256) DEFAULT NULL,
  `preset_id` int DEFAULT NULL,
  `width` int DEFAULT NULL,
  `height` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `md5` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `image_md5_index` (`md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `image_entity`

**Usado por:**
- `new-admin`: (`app/Models/ImageEntity.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| image_id | int | YES |  | NULL |  |
| entity_id | int | YES | MUL | NULL |  |
| entity_type | int | YES |  | NULL |  |
| image_type | varchar(100) | YES |  | NULL |  |
| owner | tinyint | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| image_entity_entity_id_entity_type_index | BTREE | entity_id, entity_type | No |

#### DDL

```sql
CREATE TABLE `image_entity` (
  `image_id` int DEFAULT NULL,
  `entity_id` int DEFAULT NULL,
  `entity_type` int DEFAULT NULL,
  `image_type` varchar(100) DEFAULT NULL,
  `owner` tinyint DEFAULT NULL,
  KEY `image_entity_entity_id_entity_type_index` (`entity_id`,`entity_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `image_preset`

**Usado por:**
- `new-admin`: (`app/Models/ImagePreset.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL |  |
| label | varchar(128) | NO |  | NULL |  |
| prefix | varchar(32) | NO |  | NULL |  |
| width | int | YES |  | NULL |  |
| height | int | YES |  | NULL |  |
| bucket_prefix | varchar(100) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `image_preset` (
  `id` int NOT NULL,
  `label` varchar(128) NOT NULL,
  `prefix` varchar(32) NOT NULL,
  `width` int DEFAULT NULL,
  `height` int DEFAULT NULL,
  `bucket_prefix` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `integration_booking_incidences`

**Usado por:**
- `new-admin`: (`app/Models/IntegrationBookingIncidence.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_booking_id | int | NO | UNI | NULL |  |
| log_id | int | NO | UNI | NULL |  |
| agent | varchar(32) | YES |  | NULL |  |
| incidence_date | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| status | int | NO |  | NULL |  |
| managed_by | varchar(32) | YES |  | NULL |  |
| updated_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| activity_booking_id | BTREE | activity_booking_id | Sí |
| log_id | BTREE | log_id | Sí |

#### DDL

```sql
CREATE TABLE `integration_booking_incidences` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_booking_id` int NOT NULL,
  `log_id` int NOT NULL,
  `agent` varchar(32) DEFAULT NULL,
  `incidence_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` int NOT NULL COMMENT '1 = unprocessed, 2 = ok, 3 = ko, 4 = manual',
  `managed_by` varchar(32) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `activity_booking_id` (`activity_booking_id`),
  UNIQUE KEY `log_id` (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `integration_booking_relaunch_log`

**Usado por:**
- `new-admin`: (`app/Models/IntegrationBookingRelaunchLog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_booking_id | int | NO | MUL | NULL |  |
| relaunch_date | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| status | int | NO |  | NULL |  |
| managed_by | varchar(32) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_activity_booking_id_integration_booking_relaunch_log | BTREE | activity_booking_id | No |

#### DDL

```sql
CREATE TABLE `integration_booking_relaunch_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_booking_id` int NOT NULL,
  `relaunch_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` int NOT NULL COMMENT '1 = OK, 2 = KO, 3 = NOT FOUND, 4 = CONFLICT',
  `managed_by` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_activity_booking_id_integration_booking_relaunch_log` (`activity_booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `integrations_provider_error_messages`

**Usado por:**
- `new-admin`: (`app/Models/IntegrationProviderErrorMessage.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| integration | varchar(128) | YES |  |  |  |
| error_code | varchar(128) | YES |  | NULL |  |
| label | varchar(128) | YES |  | NULL |  |
| default_text | text | YES |  | NULL |  |
| provider_error | int | YES |  | 0 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `integrations_provider_error_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `integration` varchar(128) DEFAULT '' COMMENT 'nombre de la integración',
  `error_code` varchar(128) DEFAULT NULL,
  `label` varchar(128) DEFAULT NULL,
  `default_text` text,
  `provider_error` int DEFAULT '0' COMMENT '0 No, 1 Sí',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=585 DEFAULT CHARSET=utf8mb3
```

### `internal_notifications`

**Usado por:**
- `new-admin`: (`app/Models/InternalNotifications.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| author_id | int | NO |  | NULL |  |
| reciever_id | int | NO |  | NULL |  |
| maker_id | int | YES |  | NULL |  |
| reply_to | int | YES |  | NULL |  |
| entity_type | int | NO |  | NULL |  |
| entity_id | int | NO |  | NULL |  |
| title | varchar(100) | NO |  | NULL |  |
| content | text | NO |  | NULL |  |
| schedule_timestamp | timestamp | YES |  | NULL |  |
| sent_timestamp | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| view_timestamp | timestamp | YES |  | NULL |  |
| check_timestamp | timestamp | YES |  | NULL |  |
| done_timestamp | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `internal_notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `author_id` int NOT NULL COMMENT 'Usuario creador de la notificacion',
  `reciever_id` int NOT NULL COMMENT 'Usuario receptor de la notificacion',
  `maker_id` int DEFAULT NULL COMMENT 'Usuario que marca la notificacion hecha (con done_timestamp)',
  `reply_to` int DEFAULT NULL,
  `entity_type` int NOT NULL COMMENT 'tipo de entidad',
  `entity_id` int NOT NULL COMMENT 'id de entidad',
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL COMMENT 'contenido de la información',
  `schedule_timestamp` timestamp NULL DEFAULT NULL,
  `sent_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'tiempo de envío de la notificación',
  `view_timestamp` timestamp NULL DEFAULT NULL COMMENT 'tiempo de la visualización de la notificación',
  `check_timestamp` timestamp NULL DEFAULT NULL COMMENT 'tiempo de marcado leído de la notificación',
  `done_timestamp` timestamp NULL DEFAULT NULL COMMENT 'Fecha en que se marca como hecha',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3
```

### `ip_antifraud`

**Usado por:**
- `new-admin`: (`app/Models/IpAntifraud.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| ip | varchar(128) | NO | MUL | NULL |  |
| date_limit | datetime | YES |  | NULL |  |
| pnr | varchar(27) | YES |  | NULL |  |
| product_type | varchar(32) | YES |  | NULL |  |
| block_type | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_ip-date_limit | BTREE | ip, date_limit | No |

#### DDL

```sql
CREATE TABLE `ip_antifraud` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ip` varchar(128) NOT NULL,
  `date_limit` datetime DEFAULT NULL,
  `pnr` varchar(27) DEFAULT NULL,
  `product_type` varchar(32) DEFAULT NULL,
  `block_type` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ip-date_limit` (`ip`,`date_limit`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb3
```

### `jira_associate`

**Usado por:**
- `new-admin`: (`app/Models/JiraAssociate.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_management | int | NO | MUL | NULL |  |
| type_management | mediumtext | NO |  | NULL |  |
| name | text | NO |  | NULL |  |
| url | text | YES |  | NULL |  |
| type_link | text | NO |  | NULL |  |
| created_at | timestamp | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_jira_associate | BTREE | id_management | No |

#### DDL

```sql
CREATE TABLE `jira_associate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_management` int NOT NULL,
  `type_management` mediumtext NOT NULL,
  `name` text NOT NULL,
  `url` text,
  `type_link` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_jira_associate` (`id_management`),
  CONSTRAINT `fk_jira_associate` FOREIGN KEY (`id_management`) REFERENCES `massive_change_log` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `job_locations`

**Usado por:**
- `new-admin`: (`app/Models/JobOfferLocation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| city | varchar(128) | NO |  | NULL |  |
| address | varchar(128) | YES |  | NULL |  |
| details | varchar(50) | YES |  | NULL |  |
| postal_code | varchar(50) | YES |  | NULL |  |
| latitude | varchar(50) | YES |  | NULL |  |
| longitude | varchar(50) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `job_locations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `city` varchar(128) NOT NULL,
  `address` varchar(128) DEFAULT NULL,
  `details` varchar(50) DEFAULT NULL,
  `postal_code` varchar(50) DEFAULT NULL,
  `latitude` varchar(50) DEFAULT NULL,
  `longitude` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3
```

### `job_offers`

**Usado por:**
- `new-admin`: (`app/Models/JobOffer.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| title | varchar(400) | YES |  | NULL |  |
| date | date | YES |  | NULL |  |
| shortDescription | text | YES |  | NULL |  |
| description | text | YES |  | NULL |  |
| requirements | text | YES |  | NULL |  |
| status | tinyint | NO |  | 0 |  |
| tag | varchar(50) | YES |  | NULL |  |
| banner | varchar(50) | NO |  | detalle-empleo-01 |  |
| lang | varchar(4) | YES |  | es |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `job_offers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(400) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `shortDescription` text,
  `description` text,
  `requirements` text,
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0 = no publicada, 1 = publicada',
  `tag` varchar(50) DEFAULT NULL,
  `banner` varchar(50) NOT NULL DEFAULT 'detalle-empleo-01',
  `lang` varchar(4) DEFAULT 'es',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=158 DEFAULT CHARSET=utf8mb3
```

### `jobs`

**Usado por:**
- `new-admin`: (`app/Models/Job.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| title | varchar(128) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3
```

### `kyc_results`

**Usado por:**
- `new-admin`: (`app/Modules/KYC/Models/KycResults.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| entity | varchar(20) | NO | MUL | NULL |  |
| entity_id | int | NO |  | NULL |  |
| matches | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_kyc_results_entity | BTREE | entity | No |

#### DDL

```sql
CREATE TABLE `kyc_results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity` varchar(20) NOT NULL,
  `entity_id` int NOT NULL,
  `matches` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_kyc_results_entity` (`entity`),
  CONSTRAINT `fk_kyc_results_entity` FOREIGN KEY (`entity`) REFERENCES `kyc_entities` (`entity_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `landing_pages`

**Usado por:**
- `new-admin`: (`app/Models/LandingPage.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(255) | NO |  | NULL |  |
| url | varchar(64) | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| structure | text | NO |  | NULL |  |
| status | tinyint(1) | NO | MUL | 0 |  |
| indexable | tinyint(1) | NO |  | NULL |  |
| meta_title | varchar(70) | NO |  | NULL |  |
| meta_description | varchar(160) | NO |  | NULL |  |
| keywords | varchar(255) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | YES |  | NULL |  |
| deleted_at | timestamp | YES |  | NULL |  |
| start_date | timestamp | NO |  | NULL |  |
| end_date | timestamp | YES |  | NULL |  |
| timezone | varchar(70) | NO |  | Europe/Madrid |  |
| preview_hash | varchar(32) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_landing_pages_status | BTREE | status | No |

#### DDL

```sql
CREATE TABLE `landing_pages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `url` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `lang` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `structure` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1=Activa, 0=Inactiva',
  `indexable` tinyint(1) NOT NULL COMMENT '1=Indexable, 0=No indexable',
  `meta_title` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `meta_description` varchar(160) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `keywords` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `start_date` timestamp NOT NULL,
  `end_date` timestamp NULL DEFAULT NULL,
  `timezone` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'Europe/Madrid',
  `preview_hash` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_landing_pages_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `landing_pages_changelog`

**Usado por:**
- `new-admin`: (`app/Models/LandingChangeLog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| landing_page_id | int | NO |  | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| field | varchar(32) | YES | MUL | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_landing_pages_changelog_field | BTREE | field | No |

#### DDL

```sql
CREATE TABLE `landing_pages_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `landing_page_id` int NOT NULL,
  `user` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `field` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Columna modificada',
  `old_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `new_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_landing_pages_changelog_field` (`field`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `languages`

**Usado por:**
- `new-admin`: (`app/Models/Languages.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(25) | YES |  | NULL |  |
| label | varchar(50) | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| locale | varchar(11) | YES |  | NULL |  |
| main_lang | varchar(2) | YES |  | NULL |  |
| status | int | YES |  | NULL |  |
| region | varchar(150) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `languages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(25) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `lang` varchar(2) DEFAULT NULL,
  `locale` varchar(11) DEFAULT NULL,
  `main_lang` varchar(2) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `region` varchar(150) NOT NULL COMMENT 'Region para version localizada en html',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COMMENT='Region para version localizada en html'
```

### `legal`

**Usado por:**
- `new-admin`: (`app/Models/LegalNotice.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | YES |  | 0 |  |
| title | text | YES |  | NULL |  |
| answer | text | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| status | tinyint | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| active | tinyint | YES |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `legal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int DEFAULT '0',
  `title` text,
  `answer` text,
  `orden` int DEFAULT NULL,
  `status` tinyint DEFAULT NULL COMMENT '0.No publicado 1.Publicado',
  `lang` varchar(2) DEFAULT NULL,
  `active` tinyint DEFAULT '1' COMMENT '0.Desactivada 1.Activa',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Pagina de avisos legales'
```

### `legal_changelog`

**Usado por:**
- `new-admin`: (`app/Models/LegalNoticeChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idLegal | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| field | varchar(64) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validation | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `legal_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idLegal` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `field` varchar(64) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validation` int DEFAULT '0' COMMENT '1-Si 0-No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='changelog de avisos legales'
```

### `legal_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/LegalNoticeChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idChange | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `legal_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idChange` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `lang` varchar(2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Validadores de avisos legales'
```

### `links`

**Usado por:**
- `new-admin`: (`app/Models/Links.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| entity_type | int | NO |  | NULL |  |
| entity_id | int | YES |  | NULL |  |
| url | text | YES |  | NULL |  |
| type | text | YES |  | NULL |  |
| title | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `links` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity_type` int NOT NULL COMMENT '(0: actividades, 1:reservas actividades, 2: reservas traslados)',
  `entity_id` int DEFAULT NULL,
  `url` text,
  `type` text COMMENT 'drive,jira,web',
  `title` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `log_actividades_fechas_ocupadas_proveedor`

**Usado por:**
- `new-admin`: (`app/Models/ActivityDateCloseProvider.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_proveedor | int | NO |  | NULL |  |
| id_actividad | int | NO |  | NULL |  |
| fecha_cerrada | date | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| ip | varchar(32) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `log_actividades_fechas_ocupadas_proveedor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_proveedor` int NOT NULL,
  `id_actividad` int NOT NULL,
  `fecha_cerrada` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3
```

### `log_actividades_fechas_reabiertas_proveedor`

**Usado por:**
- `new-admin`: (`app/Models/ActivityDateOpenProvider.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_proveedor | int | NO |  | NULL |  |
| id_actividad | int | NO |  | NULL |  |
| fecha_reabierta | date | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| ip | varchar(32) | YES |  | NULL |  |
| hora | varchar(10) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `log_actividades_fechas_reabiertas_proveedor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_proveedor` int NOT NULL,
  `id_actividad` int NOT NULL,
  `fecha_reabierta` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(32) DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3
```

### `log_activity_changes`

**Usado por:**
- `new-admin`: (`app/Models/LogActivityChanges.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activityId | int | NO |  | NULL |  |
| author | varchar(256) | NO |  | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO | MUL | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_log_activity_changes_created_at_activityid | BTREE | created_at, activityId | No |

#### DDL

```sql
CREATE TABLE `log_activity_changes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activityId` int NOT NULL,
  `author` varchar(256) NOT NULL,
  `field` varchar(256) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_log_activity_changes_created_at_activityid` (`created_at`,`activityId`)
) ENGINE=InnoDB AUTO_INCREMENT=4204892 DEFAULT CHARSET=utf8mb3
```

### `log_affiliate_changes`

**Usado por:**
- `new-admin`: (`app/Models/LogAffiliateChanges.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_affiliate | int | NO | MUL | NULL |  |
| author | varchar(256) | NO |  | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_lac_id_affiliate_created_at | BTREE | id_affiliate, created_at | No |

#### DDL

```sql
CREATE TABLE `log_affiliate_changes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_affiliate` int NOT NULL,
  `author` varchar(256) NOT NULL,
  `field` varchar(256) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_lac_id_affiliate_created_at` (`id_affiliate`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=utf8mb3
```

### `log_agency_changes`

**Usado por:**
- `new-admin`: (`app/Models/LogAgencyChanges.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_agency | int | NO |  | NULL |  |
| id_user | int | YES |  | NULL |  |
| author | varchar(256) | NO |  | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `log_agency_changes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_agency` int NOT NULL,
  `id_user` int DEFAULT NULL,
  `author` varchar(256) NOT NULL,
  `field` varchar(256) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=707 DEFAULT CHARSET=utf8mb3
```

### `log_agency_group_changes`

**Usado por:**
- `new-admin`: (`app/Models/LogAgencyGroupChange.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| agency_group_id | int | NO |  | NULL |  |
| user_id | int | NO |  | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `log_agency_group_changes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `agency_group_id` int NOT NULL,
  `user_id` int NOT NULL,
  `field` varchar(256) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `log_country_changes`

**Usado por:**
- `new-admin`: (`app/Models/LogCountryChange.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| country_id | int | NO |  | NULL |  |
| author | varchar(256) | NO |  | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `log_country_changes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `country_id` int NOT NULL,
  `author` varchar(256) NOT NULL,
  `field` varchar(256) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `log_destination_changes`

**Usado por:**
- `new-admin`: (`app/Models/LogDestinationChange.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| destination_id | int | NO |  | NULL |  |
| author | varchar(256) | NO |  | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `log_destination_changes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination_id` int NOT NULL,
  `author` varchar(256) NOT NULL,
  `field` varchar(256) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `log_disabled_tours`

**Usado por:**
- `new-admin`: (`app/Models/LogDisabledTours.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| tour_id | int | NO | PRI | NULL |  |
| user_id | int | YES |  | NULL |  |
| created_at | timestamp | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | tour_id | Sí |

#### DDL

```sql
CREATE TABLE `log_disabled_tours` (
  `tour_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`tour_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `login_as`

**Usado por:**
- `new-admin`: (`app/Models/LoginAs.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| user_id | int | NO |  | NULL |  |
| loginAs_id | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `login_as` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `loginAs_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3
```

### `log_provider_changes`

**Usado por:**
- `new-admin`: (`app/Models/LogProvidersChanges.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_proveedor | int | YES |  | NULL |  |
| author | varchar(256) | YES |  | NULL |  |
| field | varchar(256) | YES |  | NULL |  |
| old_value | varchar(256) | YES |  | NULL |  |
| new_value | varchar(256) | YES |  | NULL |  |
| created_at | timestamp | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `log_provider_changes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_proveedor` int DEFAULT NULL,
  `author` varchar(256) DEFAULT NULL,
  `field` varchar(256) DEFAULT NULL,
  `old_value` varchar(256) DEFAULT NULL,
  `new_value` varchar(256) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=270 DEFAULT CHARSET=utf8mb3
```

### `logs`

**Usado por:**
- `new-admin`: (`app/Models/Log.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| tipo_servicio | tinyint | NO | MUL | NULL |  |
| id_servicio | int | NO | MUL | NULL |  |
| agente | varchar(16) | NO |  | NULL |  |
| texto | text | NO |  | NULL |  |
| fecha | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| prioridad | tinyint | YES |  | NULL |  |
| alarma | date | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_logs_indexes | BTREE | tipo_servicio, prioridad, alarma | No |
| idx_logs_service | BTREE | id_servicio | No |
| idx_logs_service_priority | BTREE | tipo_servicio, prioridad | No |

#### DDL

```sql
CREATE TABLE `logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo_servicio` tinyint NOT NULL COMMENT '1 Actividades 2 Traslados 3 Viajes',
  `id_servicio` int NOT NULL,
  `agente` varchar(16) NOT NULL,
  `texto` text NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `prioridad` tinyint DEFAULT NULL,
  `alarma` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_logs_service` (`id_servicio`),
  KEY `idx_logs_indexes` (`tipo_servicio`,`prioridad`,`alarma`),
  KEY `idx_logs_service_priority` (`tipo_servicio`,`prioridad`)
) ENGINE=InnoDB AUTO_INCREMENT=74866359 DEFAULT CHARSET=utf8mb3
```

### `logs_descargas`

**Usado por:**
- `new-admin`: (`app/Models/LogDownload.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| booking_id | int | YES |  | NULL |  |
| booking_type | int | YES |  | NULL |  |
| doc_id | int | YES |  | NULL |  |
| ip | varchar(50) | YES |  | NULL |  |
| status | int | YES |  | 0 |  |
| fecha | timestamp | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `logs_descargas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `booking_type` int DEFAULT NULL,
  `doc_id` int DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `status` int DEFAULT '0' COMMENT '0. No descargado/No encontrado 1.Descargado ',
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3
```

### `log_ticketing_errors`

**Usado por:**
- `new-admin`: (`app/Models/TicketingIntegrationErrorLog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| field | varchar(256) | NO |  | NULL |  |
| value | int | NO |  | NULL |  |
| code | int | NO |  | NULL |  |
| message | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `log_ticketing_errors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `field` varchar(256) NOT NULL,
  `value` int NOT NULL,
  `code` int NOT NULL,
  `message` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `log_zone_changes`

**Usado por:**
- `new-admin`: (`app/Models/LogZoneChange.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| zone_id | int | NO |  | NULL |  |
| author | varchar(256) | NO |  | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `log_zone_changes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `zone_id` int NOT NULL,
  `author` varchar(256) NOT NULL,
  `field` varchar(256) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3
```

### `management_software`

**Usado por:**
- `new-admin`: (`app/Models/ManagementSoftware.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| value | varchar(256) | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| show_on_register | int | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `management_software` (
  `id` int NOT NULL AUTO_INCREMENT,
  `value` varchar(256) NOT NULL,
  `lang` varchar(2) NOT NULL,
  `show_on_register` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `market_responsible`

**Usado por:**
- `new-admin`: (`app/Models/MarketResponsible.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| market_id | int | NO | MUL | NULL |  |
| user_id | int | NO | MUL | NULL |  |
| entity_type | tinyint | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_market_responsible_market_id | BTREE | market_id | No |
| fk_market_responsible_user_id | BTREE | user_id | No |

#### DDL

```sql
CREATE TABLE `market_responsible` (
  `id` int NOT NULL AUTO_INCREMENT,
  `market_id` int NOT NULL,
  `user_id` int NOT NULL,
  `entity_type` tinyint NOT NULL COMMENT '1=AGE,2=grup AGE,3=ALO, 4=grup ALO, 5=AFI',
  PRIMARY KEY (`id`),
  KEY `fk_market_responsible_market_id` (`market_id`),
  KEY `fk_market_responsible_user_id` (`user_id`),
  CONSTRAINT `fk_market_responsible_market_id` FOREIGN KEY (`market_id`) REFERENCES `markets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_market_responsible_user_id` FOREIGN KEY (`user_id`) REFERENCES `admin_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `markets`

**Usado por:**
- `new-admin`: (`app/Models/Market.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | text | NO |  | NULL |  |
| translation_label | text | YES |  | NULL |  |
| status | int | NO |  | 1 |  |
| short_name | text | YES |  | NULL |  |
| payLater | tinyint | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `markets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `translation_label` text,
  `status` int NOT NULL DEFAULT '1',
  `short_name` text,
  `payLater` tinyint DEFAULT '0' COMMENT '0.- no, 1.- si',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3
```

### `massive_change_log`

**Usado por:**
- `new-admin`: (`app/Models/MassiveChangeLog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| user_id | int | YES |  | NULL |  |
| type_management_id | int | NO | MUL | NULL |  |
| type_booking | tinyint | NO |  | NULL |  |
| date_management | datetime | NO |  | NULL |  |
| num_booking | int | NO |  | NULL |  |
| payload | text | YES |  | NULL |  |
| email_sent | tinyint | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_massive_change_log_type_management | BTREE | type_management_id | No |

#### DDL

```sql
CREATE TABLE `massive_change_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `type_management_id` int NOT NULL,
  `type_booking` tinyint NOT NULL COMMENT '1 actividades, 2 traslados',
  `date_management` datetime NOT NULL,
  `num_booking` int NOT NULL,
  `payload` text,
  `email_sent` tinyint DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_massive_change_log_type_management` (`type_management_id`),
  CONSTRAINT `fk_massive_change_log_type_management` FOREIGN KEY (`type_management_id`) REFERENCES `massive_change_log_type_management` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3
```

### `massive_change_log_booking`

**Usado por:**
- `new-admin`: (`app/Models/MassiveChangeLogBooking.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| massive_change_log_id | int | NO | MUL | NULL |  |
| booking_id | int | NO |  | NULL |  |
| created_timestamp | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| done | tinyint | NO |  | 0 |  |
| done_timestamp | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_massive_change_log_booking | BTREE | massive_change_log_id | No |

#### DDL

```sql
CREATE TABLE `massive_change_log_booking` (
  `id` int NOT NULL AUTO_INCREMENT,
  `massive_change_log_id` int NOT NULL,
  `booking_id` int NOT NULL,
  `created_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `done` tinyint NOT NULL DEFAULT '0',
  `done_timestamp` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_massive_change_log_booking` (`massive_change_log_id`),
  CONSTRAINT `fk_massive_change_log_booking` FOREIGN KEY (`massive_change_log_id`) REFERENCES `massive_change_log` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3
```

### `massive_change_log_changes`

**Usado por:**
- `new-admin`: (`app/Models/MassiveChangeLogChanges.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| massive_change_log_id | int | NO | MUL | NULL |  |
| data_type | int | NO | MUL | NULL |  |
| data_name | varchar(30) | NO |  | NULL |  |
| data_value | text | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_massive_change_log_change | BTREE | massive_change_log_id | No |
| fk_massive_change_log_changes_data_type | BTREE | data_type | No |

#### DDL

```sql
CREATE TABLE `massive_change_log_changes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `massive_change_log_id` int NOT NULL,
  `data_type` int NOT NULL,
  `data_name` varchar(30) NOT NULL,
  `data_value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_massive_change_log_change` (`massive_change_log_id`),
  KEY `fk_massive_change_log_changes_data_type` (`data_type`),
  CONSTRAINT `fk_massive_change_log_change` FOREIGN KEY (`massive_change_log_id`) REFERENCES `massive_change_log` (`id`),
  CONSTRAINT `fk_massive_change_log_changes_data_type` FOREIGN KEY (`data_type`) REFERENCES `massive_change_log_data_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb3
```

### `massive_change_log_filter`

**Usado por:**
- `new-admin`: (`app/Models/MassiveChangeLogFilter.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| massive_change_log_id | int | NO | MUL | NULL |  |
| data_type | int | NO | MUL | NULL |  |
| data_name | varchar(30) | NO |  | NULL |  |
| data_value | text | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_massive_change_log_filter | BTREE | massive_change_log_id | No |
| fk_massive_change_log_filter_data_type | BTREE | data_type | No |

#### DDL

```sql
CREATE TABLE `massive_change_log_filter` (
  `id` int NOT NULL AUTO_INCREMENT,
  `massive_change_log_id` int NOT NULL,
  `data_type` int NOT NULL,
  `data_name` varchar(30) NOT NULL,
  `data_value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_massive_change_log_filter_data_type` (`data_type`),
  KEY `fk_massive_change_log_filter` (`massive_change_log_id`),
  CONSTRAINT `fk_massive_change_log_filter` FOREIGN KEY (`massive_change_log_id`) REFERENCES `massive_change_log` (`id`),
  CONSTRAINT `fk_massive_change_log_filter_data_type` FOREIGN KEY (`data_type`) REFERENCES `massive_change_log_data_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3
```

### `massive_change_log_type_management`

**Usado por:**
- `new-admin`: (`app/Models/MassiveChangeLogTypeManagement.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name_management | varchar(25) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `massive_change_log_type_management` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name_management` varchar(25) NOT NULL COMMENT 'textos de los tipos de gestion masiva',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3
```

### `method_of_payment`

**Usado por:**
- `new-admin`: (`app/Models/MethodOfPayment.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| code | varchar(5) | NO |  | NULL |  |
| name | varchar(30) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `method_of_payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(5) NOT NULL,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3
```

### `modal_data_panel`

**Usado por:**
- `new-admin`: (`app/Models/ModalDataPanel.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| start_date | date | YES |  | NULL |  |
| end_date | date | YES |  | NULL |  |
| active | tinyint(1) | YES |  | 1 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| deleted_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `modal_data_panel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `modal_data_panel_filters`

**Usado por:**
- `new-admin`: (`app/Models/ModalDataPanelFilter.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| modal_data_panel_id | int | NO | MUL | NULL |  |
| filter | varchar(255) | NO |  | NULL |  |
| value | varchar(255) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| mmf_master_filter_idx | BTREE | modal_data_panel_id, filter | No |

#### DDL

```sql
CREATE TABLE `modal_data_panel_filters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `modal_data_panel_id` int NOT NULL,
  `filter` varchar(255) NOT NULL COMMENT 'MARKET | CATEGORY | COUNTRY | REGION',
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mmf_master_filter_idx` (`modal_data_panel_id`,`filter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `modal_data_panel_relations`

**Usado por:**
- `new-admin`: (`app/Models/ModalDataPanelRelations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| modal_data_panel_id | int | NO |  | NULL |  |
| entity | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `modal_data_panel_relations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `modal_data_panel_id` int NOT NULL,
  `entity` int NOT NULL COMMENT '1 - AFFILIATE 2 - AGENCY 3 - ACCOMMODATION',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `modal_data_panel_translations`

**Usado por:**
- `new-admin`: (`app/Models/ModalDataPanelTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| modal_data_panel_id | int | NO | MUL | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| title | varchar(50) | YES |  | NULL |  |
| content | text | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| mmt_master_lang_idx | BTREE | modal_data_panel_id, lang | No |

#### DDL

```sql
CREATE TABLE `modal_data_panel_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `modal_data_panel_id` int NOT NULL,
  `lang` varchar(2) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `content` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mmt_master_lang_idx` (`modal_data_panel_id`,`lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `monthly_notifications_managers`

**Usado por:**
- `new-admin`: (`app/Models/MonthlyNotifications.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| type | int | YES |  | NULL |  |
| id_account_manager | int | YES |  | NULL |  |
| data | mediumtext | YES |  | NULL |  |
| validate | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `monthly_notifications_managers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` int DEFAULT NULL,
  `id_account_manager` int DEFAULT NULL,
  `data` mediumtext,
  `validate` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=471 DEFAULT CHARSET=utf8mb3
```

### `multi_users`

**Usado por:**
- `new-admin`: (`app/Models/MultiUser.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(100) | YES |  | NULL |  |
| email | varchar(100) | NO | MUL | NULL |  |
| user_type | int | NO | MUL | NULL |  |
| related_id | int | NO |  | NULL |  |
| status | tinyint | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_multi_users_email_status | BTREE | email, status | No |
| user_type | BTREE | user_type, related_id | Sí |

#### DDL

```sql
CREATE TABLE `multi_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `user_type` int NOT NULL COMMENT 'Relaciona con la tabla user_type.',
  `related_id` int NOT NULL COMMENT 'Relaciona con el ID de la tabla correspondiente.',
  `status` tinyint NOT NULL COMMENT 'Estado del usuario. Coincide con el de su tipología.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_type` (`user_type`,`related_id`),
  KEY `idx_multi_users_email_status` (`email`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=19676 DEFAULT CHARSET=utf8mb3
```

### `newadmin_accesses`

**Usado por:**
- `new-admin`: (`app/Models/NewadminAccesses.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | varchar(100) | NO | PRI | - |  |
| method | varchar(6) | YES |  | NULL |  |
| route | varchar(255) | NO |  | NULL |  |
| admin_user_id | int | NO |  | NULL |  |
| date | date | NO |  | NULL |  |
| last_access_time | time | NO |  | 00:00:00 |  |
| counter | int | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `newadmin_accesses` (
  `id` varchar(100) NOT NULL DEFAULT '-',
  `method` varchar(6) DEFAULT NULL,
  `route` varchar(255) NOT NULL,
  `admin_user_id` int NOT NULL,
  `date` date NOT NULL,
  `last_access_time` time NOT NULL DEFAULT '00:00:00',
  `counter` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `opinion_bad_words`

**Usado por:**
- `new-admin`: (`app/Models/BadWords.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| lang | varchar(2) | YES |  | NULL |  |
| word | varchar(32) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `opinion_bad_words` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` varchar(2) DEFAULT NULL,
  `word` varchar(32) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3749 DEFAULT CHARSET=utf8mb3
```

### `opiniones_ficheros`

**Usado por:**
- `new-admin`: (`app/Models/OpinionFiles.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_booking | int | NO |  | NULL |  |
| type_booking | int | NO |  | NULL |  |
| status | int | NO |  | -1 |  |
| filename | varchar(256) | NO |  | NULL |  |
| content_type | varchar(32) | NO |  | NULL |  |
| document_type | varchar(32) | NO |  | NULL |  |
| path | varchar(256) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `opiniones_ficheros` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_booking` int NOT NULL COMMENT 'id de la reserva de actividad o traslado',
  `type_booking` int NOT NULL COMMENT '1.- actividad | 2.- traslado',
  `status` int NOT NULL DEFAULT '-1' COMMENT '-1.- no revisada 0.- no aprobada 1.- aprobada 2.- destacada',
  `filename` varchar(256) NOT NULL,
  `content_type` varchar(32) NOT NULL,
  `document_type` varchar(32) NOT NULL,
  `path` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3
```

### `opinion_review`

**Usado por:**
- `new-admin`: (`app/Models/OpinionReview.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| opinionId | int | NO | MUL | NULL |  |
| bookingType | tinyint(1) | NO |  | NULL |  |
| original_opinion | text | YES |  | NULL |  |
| reviewed_opinion | text | YES |  | NULL |  |
| reviewed_by | int | NO |  | NULL |  |
| is_active | tinyint(1) | NO |  | 1 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_opinion_review_opinion_booking_active | BTREE | opinionId, bookingType, is_active | No |
| uq_opinion_review_active | BTREE | opinionId, is_active | Sí |

#### DDL

```sql
CREATE TABLE `opinion_review` (
  `id` int NOT NULL AUTO_INCREMENT,
  `opinionId` int NOT NULL,
  `bookingType` tinyint(1) NOT NULL COMMENT '1-Actividad 2-Traslado',
  `original_opinion` text COLLATE utf8mb3_unicode_ci,
  `reviewed_opinion` text COLLATE utf8mb3_unicode_ci,
  `reviewed_by` int NOT NULL COMMENT 'admin_user id',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0-Non Active 1-Active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_opinion_review_active` (`opinionId`,`is_active`),
  KEY `idx_opinion_review_opinion_booking_active` (`opinionId`,`bookingType`,`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `opinions_pending_answer`

**Usado por:**
- `new-admin`: (`app/Models/OpinionsPendingAnswer.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_booking | int | NO |  | NULL |  |
| type_booking | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `opinions_pending_answer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_booking` int NOT NULL,
  `type_booking` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `opinion_translations`

**Usado por:**
- `new-admin`: (`app/Models/OpinionTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idOpinion | int | NO | MUL | NULL |  |
| type | tinyint | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| opinion | text | YES |  | NULL |  |
| reply | text | YES |  | NULL |  |
| verified | tinyint | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idOpinion | BTREE | idOpinion, type, lang | Sí |

#### DDL

```sql
CREATE TABLE `opinion_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idOpinion` int NOT NULL,
  `type` tinyint NOT NULL,
  `lang` varchar(2) NOT NULL,
  `opinion` text,
  `reply` text,
  `verified` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idOpinion` (`idOpinion`,`type`,`lang`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3
```

### `other_payments`

**Usado por:**
- `new-admin`: (`app/Models/OtherPayment.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| pin | int | NO |  | NULL |  |
| reporter | varchar(64) | NO |  | NULL |  |
| cced | varchar(64) | NO |  | NULL |  |
| customer_name | varchar(64) | NO |  | NULL |  |
| customer_email | varchar(64) | NO |  | NULL |  |
| subject | varchar(64) | NO |  | NULL |  |
| body | text | NO |  | NULL |  |
| other_payment_reason_id | varchar(256) | YES |  | NULL |  |
| amount | decimal(38,2) | YES |  | NULL |  |
| currency | varchar(3) | NO |  | NULL |  |
| status | tinyint | NO |  | 0 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| last_update | timestamp | YES |  | 0000-00-00 00:00:00 |  |
| deleted | tinyint | YES | MUL | 0 |  |
| fp | varchar(16) | YES |  | NULL |  |
| booking_attempts | tinyint | YES |  | 0 |  |
| textoPersonas | varchar(256) | YES |  | NULL |  |
| payment_currency | varchar(3) | NO |  | NULL |  |
| id_recibo | varchar(32) | NO |  | NULL |  |
| num_transaccion | varchar(20) | NO |  | NULL |  |
| payment_amount | float | YES |  | NULL |  |
| lang | varchar(2) | YES |  | es |  |
| postpay_extra_url | mediumtext | YES |  | NULL |  |
| postpay_extra_data | mediumtext | YES |  | NULL |  |
| valid_until | timestamp | NO |  | 0000-00-00 00:00:00 |  |
| xrt_payment_currency | float | YES |  | NULL |  |
| xrt_eur | float | YES |  | NULL |  |
| amount_euros | float | YES |  | NULL |  |
| auv_id | int | YES |  | NULL |  |
| auvc_id | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx-other_payments-deleted | BTREE | deleted | No |

#### DDL

```sql
CREATE TABLE `other_payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pin` int NOT NULL,
  `reporter` varchar(64) NOT NULL,
  `cced` varchar(64) NOT NULL,
  `customer_name` varchar(64) NOT NULL,
  `customer_email` varchar(64) NOT NULL,
  `subject` varchar(64) NOT NULL,
  `body` text NOT NULL,
  `other_payment_reason_id` varchar(256) DEFAULT NULL COMMENT 'Motivo del pago que nos dará info sobre que campos actualizar en la reserva',
  `amount` decimal(38,2) DEFAULT NULL,
  `currency` varchar(3) NOT NULL,
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0 Nuevo 1 Pagado 2 Cancelado',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `deleted` tinyint DEFAULT '0',
  `fp` varchar(16) DEFAULT NULL,
  `booking_attempts` tinyint DEFAULT '0',
  `textoPersonas` varchar(256) DEFAULT NULL COMMENT 'Se añadirá en la reserva cuando se complete el pago genérico',
  `payment_currency` varchar(3) NOT NULL,
  `id_recibo` varchar(32) NOT NULL,
  `num_transaccion` varchar(20) NOT NULL,
  `payment_amount` float DEFAULT NULL COMMENT 'The amount in the currency the customer has paid',
  `lang` varchar(2) DEFAULT 'es',
  `postpay_extra_url` mediumtext,
  `postpay_extra_data` mediumtext,
  `valid_until` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `xrt_payment_currency` float DEFAULT NULL,
  `xrt_eur` float DEFAULT NULL,
  `amount_euros` float DEFAULT NULL,
  `auv_id` int DEFAULT NULL,
  `auvc_id` int DEFAULT NULL COMMENT 'Id from agencias_usuarios_ventas_comisiones',
  PRIMARY KEY (`id`),
  KEY `idx-other_payments-deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=3574 DEFAULT CHARSET=utf8mb3 COMMENT='Id from agencias_usuarios_ventas_comisiones'
```

### `pages_master`

**Usado por:**
- `new-admin`: (`app/Models/PageMaster.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCiudad | int | NO | MUL | NULL |  |
| titulo | varchar(256) | NO |  | NULL |  |
| categoria | tinyint | NO |  | 0 |  |
| superior | int | YES |  | 0 |  |
| hotelesCercanos | varchar(64) | NO |  | NULL |  |
| latitud | double | NO |  | NULL |  |
| longitud | double | NO |  | NULL |  |
| zoom | int | NO |  | 0 |  |
| orden | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_pages_master_ciudad | BTREE | idCiudad | No |

#### DDL

```sql
CREATE TABLE `pages_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCiudad` int NOT NULL,
  `titulo` varchar(256) NOT NULL,
  `categoria` tinyint NOT NULL DEFAULT '0',
  `superior` int DEFAULT '0',
  `hotelesCercanos` varchar(64) NOT NULL,
  `latitud` double NOT NULL,
  `longitud` double NOT NULL,
  `zoom` int NOT NULL DEFAULT '0',
  `orden` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_pages_master_ciudad` (`idCiudad`)
) ENGINE=InnoDB AUTO_INCREMENT=2915 DEFAULT CHARSET=utf8mb3
```

### `pages_translations`

**Usado por:**
- `new-admin`: (`app/Models/PageTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterPage | int | NO | MUL | NULL |  |
| idioma | varchar(2) | NO |  | NULL |  |
| url | varchar(64) | NO | MUL | NULL |  |
| titulo | varchar(256) | NO |  | NULL |  |
| subtitulo | varchar(256) | NO |  | NULL |  |
| descripcion | varchar(256) | NO |  | NULL |  |
| keywords | varchar(512) | NO |  | NULL |  |
| texto | text | NO |  | NULL |  |
| horario | varchar(512) | YES |  | NULL |  |
| precio | varchar(640) | YES |  | NULL |  |
| transporte | varchar(512) | NO |  | NULL |  |
| localizacion | varchar(512) | NO |  | NULL |  |
| nombreMenu | varchar(64) | YES |  | NULL |  |
| mostrar | int | NO |  | 0 |  |
| actividades | varchar(32) | YES |  | NULL |  |
| actualizacion | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_pages_translations_idMasterPage_idioma | BTREE | idMasterPage, idioma | No |
| idx_pages_translations_url | BTREE | url | No |

#### DDL

```sql
CREATE TABLE `pages_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterPage` int NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `url` varchar(64) NOT NULL,
  `titulo` varchar(256) NOT NULL,
  `subtitulo` varchar(256) NOT NULL,
  `descripcion` varchar(256) NOT NULL,
  `keywords` varchar(512) NOT NULL,
  `texto` text NOT NULL,
  `horario` varchar(512) DEFAULT NULL,
  `precio` varchar(640) DEFAULT NULL,
  `transporte` varchar(512) NOT NULL,
  `localizacion` varchar(512) NOT NULL,
  `nombreMenu` varchar(64) DEFAULT NULL,
  `mostrar` int NOT NULL DEFAULT '0',
  `actividades` varchar(32) DEFAULT NULL,
  `actualizacion` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_pages_translations_idMasterPage_idioma` (`idMasterPage`,`idioma`),
  KEY `idx_pages_translations_url` (`url`)
) ENGINE=InnoDB AUTO_INCREMENT=33179 DEFAULT CHARSET=utf8mb3
```

### `paises`

**Usado por:**
- `new-admin`: (`app/Models/Country.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| isoNum | smallint | YES |  | NULL |  |
| iso2 | char(2) | YES | MUL | NULL |  |
| iso2_lower | varchar(3) | YES | MUL | NULL |  |
| iso3 | char(3) | YES |  | NULL |  |
| nombre | varchar(80) | YES |  | NULL |  |
| nombre_corto | varchar(32) | YES |  | NULL |  |
| prefijo | varchar(4) | YES | MUL | NULL |  |
| latitud | double | NO |  | NULL |  |
| longitud | double | NO |  | NULL |  |
| viajes | smallint | NO |  | 0 |  |
| union_europea | tinyint | YES |  | 1 |  |
| id_responsable | int | YES |  | NULL |  |
| id_redactor | int | YES |  | NULL |  |
| travel_insurance | tinyint | YES |  | 0 |  |
| active | tinyint | NO |  | 1 |  |
| region | int | YES | MUL | NULL |  |
| default_account_type | int | NO |  | 0 |  |
| sim_activity | int | YES |  | NULL |  |
| show_prefix | tinyint(1) | YES |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_region | BTREE | region | No |
| idx_paises_iso2 | BTREE | iso2 | No |
| idx_paises_iso2_lower | BTREE | iso2_lower | No |
| prefijo | BTREE | prefijo | No |

#### DDL

```sql
CREATE TABLE `paises` (
  `id` int NOT NULL AUTO_INCREMENT,
  `isoNum` smallint DEFAULT NULL,
  `iso2` char(2) DEFAULT NULL,
  `iso2_lower` varchar(3) DEFAULT NULL,
  `iso3` char(3) DEFAULT NULL,
  `nombre` varchar(80) DEFAULT NULL,
  `nombre_corto` varchar(32) DEFAULT NULL,
  `prefijo` varchar(4) DEFAULT NULL,
  `latitud` double NOT NULL,
  `longitud` double NOT NULL,
  `viajes` smallint NOT NULL DEFAULT '0',
  `union_europea` tinyint DEFAULT '1' COMMENT '1 - Si 0 - No',
  `id_responsable` int DEFAULT NULL,
  `id_redactor` int DEFAULT NULL,
  `travel_insurance` tinyint DEFAULT '0' COMMENT '1 Si 0 No',
  `active` tinyint NOT NULL DEFAULT '1',
  `region` int DEFAULT NULL,
  `default_account_type` int NOT NULL DEFAULT '0',
  `sim_activity` int DEFAULT NULL,
  `show_prefix` tinyint(1) DEFAULT '1' COMMENT '0. Prefijo inactivo, 1. Prefijo activo',
  PRIMARY KEY (`id`),
  KEY `idx_paises_iso2` (`iso2`),
  KEY `prefijo` (`prefijo`),
  KEY `fk_region` (`region`),
  KEY `idx_paises_iso2_lower` (`iso2_lower`),
  CONSTRAINT `fk_region` FOREIGN KEY (`region`) REFERENCES `region` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=397 DEFAULT CHARSET=utf8mb3 COMMENT='0. Prefijo inactivo, 1. Prefijo activo'
```

### `paises_translations`

**Usado por:**
- `new-admin`: (`app/Models/CountryTranslations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterPais | int | NO | MUL | NULL |  |
| nombre | varchar(128) | YES |  | NULL |  |
| nombre_corto | varchar(128) | YES |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| url | varchar(256) | YES |  | NULL |  |
| destinationIn_title | varchar(128) | YES |  | NULL |  |
| destinationsIn_title | varchar(256) | YES |  | NULL |  |
| on_country | varchar(255) | YES |  | NULL |  |
| to_country | varchar(255) | YES |  | NULL |  |
| of_country | varchar(256) | YES |  | NULL |  |
| from_country | varchar(256) | YES |  | NULL |  |
| actividadesen | varchar(256) | YES |  | NULL |  |
| trasladosen | varchar(256) | YES |  | NULL |  |
| meta_title | varchar(70) | YES |  | NULL |  |
| meta_description | varchar(160) | YES |  | NULL |  |
| content | text | YES |  | NULL |  |
| official_lang | varchar(50) | YES |  | NULL |  |
| capital | varchar(100) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| pt_master_lang_idx | BTREE | idMasterPais, lang | No |

#### DDL

```sql
CREATE TABLE `paises_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterPais` int NOT NULL,
  `nombre` varchar(128) DEFAULT NULL,
  `nombre_corto` varchar(128) DEFAULT NULL,
  `lang` varchar(2) NOT NULL,
  `url` varchar(256) DEFAULT NULL,
  `destinationIn_title` varchar(128) DEFAULT NULL,
  `destinationsIn_title` varchar(256) DEFAULT NULL,
  `on_country` varchar(255) DEFAULT NULL,
  `to_country` varchar(255) DEFAULT NULL,
  `of_country` varchar(256) DEFAULT NULL,
  `from_country` varchar(256) DEFAULT NULL,
  `actividadesen` varchar(256) DEFAULT NULL,
  `trasladosen` varchar(256) DEFAULT NULL,
  `meta_title` varchar(70) DEFAULT NULL,
  `meta_description` varchar(160) DEFAULT NULL,
  `content` text,
  `official_lang` varchar(50) DEFAULT NULL,
  `capital` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pt_master_lang_idx` (`idMasterPais`,`lang`)
) ENGINE=InnoDB AUTO_INCREMENT=3276 DEFAULT CHARSET=utf8mb3
```

### `paises_translations_changelog`

**Usado por:**
- `new-admin`: (`app/Models/CountriesTranslationsChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterPais | int | NO | MUL | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validated | int | YES | MUL | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_paises_translations_changelog | BTREE | idMasterPais, created_at | No |
| idx_paises_translations_changelog_validated | BTREE | validated | No |

#### DDL

```sql
CREATE TABLE `paises_translations_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterPais` int NOT NULL,
  `field` varchar(256) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validated` int DEFAULT '0' COMMENT '1 - Si 0 - No',
  PRIMARY KEY (`id`),
  KEY `idx_paises_translations_changelog` (`idMasterPais`,`created_at`),
  KEY `idx_paises_translations_changelog_validated` (`validated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Track the changes made in the paises'
```

### `paises_translations_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/CountriesTranslationsChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCambio | int | NO |  | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| idioma | varchar(2) | NO | MUL | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_paises_translations_changelog_validation | BTREE | idioma | No |

#### DDL

```sql
CREATE TABLE `paises_translations_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCambio` int NOT NULL,
  `user` varchar(16) NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_paises_translations_changelog_validation` (`idioma`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `panel_resources_media`

**Usado por:**
- `new-admin`: (`app/Models/PanelResourcesMedia.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| entity_id | int | NO | MUL | NULL |  |
| category_id | int | NO |  | NULL |  |
| title | varchar(255) | YES |  | NULL |  |
| lang | varchar(255) | NO |  | NULL |  |
| resource_type | varchar(255) | NO |  | NULL |  |
| link | varchar(255) | YES |  | NULL |  |
| path | varchar(255) | YES |  | NULL |  |
| thumbnail | varchar(255) | YES |  | NULL |  |
| size | varchar(255) | NO |  | NULL |  |
| published | tinyint(1) | NO |  | 0 |  |
| deleted | tinyint(1) | NO |  | 0 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | YES |  | NULL |  |
| deleted_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_prm_entity_category_lang | BTREE | entity_id, category_id, lang | No |
| idx_prm_entity_category_lang_pub_dlt | BTREE | entity_id, category_id, lang, published, deleted | No |
| idx_prm_entity_lang | BTREE | entity_id, lang | No |
| idx_prm_entity_lang_pub_dlt | BTREE | entity_id, lang, published, deleted | No |

#### DDL

```sql
CREATE TABLE `panel_resources_media` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity_id` int NOT NULL,
  `category_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `lang` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `resource_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `link` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `path` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `thumbnail` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `size` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `published` tinyint(1) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_prm_entity_category_lang` (`entity_id`,`category_id`,`lang`),
  KEY `idx_prm_entity_lang` (`entity_id`,`lang`),
  KEY `idx_prm_entity_category_lang_pub_dlt` (`entity_id`,`category_id`,`lang`,`published`,`deleted`),
  KEY `idx_prm_entity_lang_pub_dlt` (`entity_id`,`lang`,`published`,`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `parent_pages`

**Usado por:**
- `new-admin`: (`app/Models/ParentPage.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id_master_page | int | NO | PRI | NULL |  |
| parent_id | int | NO | PRI | NULL |  |
| main | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id_master_page, parent_id | Sí |
| pp_master_idx | BTREE | id_master_page | No |

#### DDL

```sql
CREATE TABLE `parent_pages` (
  `id_master_page` int NOT NULL,
  `parent_id` int NOT NULL,
  `main` int DEFAULT '0' COMMENT '1 - Si 0 - No',
  PRIMARY KEY (`id_master_page`,`parent_id`),
  KEY `pp_master_idx` (`id_master_page`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `passenger_info_fields`

**Usado por:**
- `new-admin`: (`app/Models/PassengerInfoFields.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(256) | NO |  | NULL |  |
| label | varchar(256) | NO |  | NULL |  |
| input_type | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `passenger_info_fields` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `label` varchar(256) NOT NULL,
  `input_type` int DEFAULT NULL COMMENT '1- Input 2- Textarea 3- Fecha 4- Select, 5- Number 6- Phone 7-Date',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb3
```

### `payments_reservations`

**Usado por:**
- `new-admin`: (`app/Models/PaymentReservation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| payment_id | int | NO | PRI | 0 |  |
| reservation | int | NO | PRI | 0 |  |
| kind | char(1) | NO | PRI |  |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | payment_id, reservation, kind | Sí |

#### DDL

```sql
CREATE TABLE `payments_reservations` (
  `payment_id` int NOT NULL DEFAULT '0',
  `reservation` int NOT NULL DEFAULT '0',
  `kind` char(1) NOT NULL DEFAULT '' COMMENT 'a= activity, t=transfer',
  PRIMARY KEY (`payment_id`,`reservation`,`kind`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Stores reservations related to other_payments'
```

### `payment_transaction`

**Usado por:**
- `new-admin`: (`app/Models/PaymentTransaction.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| gateway | varchar(32) | NO |  | NULL |  |
| transaction_id | varchar(64) | NO | MUL | NULL |  |
| pnr | varchar(64) | NO | MUL | NULL |  |
| product_type | varchar(32) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| result | varchar(2) | YES |  | NULL |  |
| result_at | timestamp | YES |  | NULL |  |
| response | text | YES |  | NULL |  |
| payment_type | varchar(32) | YES |  | NULL |  |
| id | int | NO | PRI | NULL | auto_increment |
| extra_data | varchar(512) | YES |  | NULL |  |
| amount | decimal(38,2) | YES |  | NULL |  |
| currency | varchar(5) | YES |  | NULL |  |
| last_4credit_chars | varchar(11) | YES |  | NULL |  |
| secured | tinyint | YES |  | NULL |  |
| secure_returned | tinyint | YES |  | NULL |  |
| geo_ip | varchar(2) | YES |  | NULL |  |
| card_country | varchar(3) | YES |  | NULL |  |
| instalments | int | YES |  | NULL |  |
| ebanx_total | float | YES |  | NULL |  |
| sub_mop | varchar(512) | YES |  | NULL |  |
| discount_to_wallet | int | NO |  | 0 |  |
| pnr_related | varchar(512) | YES |  | NULL |  |
| product_type_related | varchar(512) | YES |  | NULL |  |
| providedByPcm | tinyint(1) | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_payment_transaction_update | BTREE | transaction_id, gateway, payment_type | No |
| idx_pnr | BTREE | pnr | No |

#### DDL

```sql
CREATE TABLE `payment_transaction` (
  `gateway` varchar(32) NOT NULL,
  `transaction_id` varchar(64) NOT NULL,
  `pnr` varchar(64) NOT NULL COMMENT 'Our booking reference',
  `product_type` varchar(32) NOT NULL COMMENT 'The product type: activity, transfer, ...',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `result` varchar(2) DEFAULT NULL COMMENT 'The payment result (OK / KO) or null if payment was not attempted',
  `result_at` timestamp NULL DEFAULT NULL COMMENT 'The timestamp we got the payment result at',
  `response` text,
  `payment_type` varchar(32) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `extra_data` varchar(512) DEFAULT NULL COMMENT 'To store extra uuid in paylands',
  `amount` decimal(38,2) DEFAULT NULL,
  `currency` varchar(5) DEFAULT NULL,
  `last_4credit_chars` varchar(11) DEFAULT NULL,
  `secured` tinyint DEFAULT NULL COMMENT 'null-no guardado, 0 - no, 1 - yes',
  `secure_returned` tinyint DEFAULT NULL COMMENT 'null-no guardado, 0 - no, 1 - yes',
  `geo_ip` varchar(2) DEFAULT NULL COMMENT 'ISO2',
  `card_country` varchar(3) DEFAULT NULL COMMENT 'paises->isoNum (M49) ',
  `instalments` int DEFAULT NULL,
  `ebanx_total` float DEFAULT NULL,
  `sub_mop` varchar(512) DEFAULT NULL,
  `discount_to_wallet` int NOT NULL DEFAULT '0' COMMENT 'porcentaje de la canitidad aplicada al wallet (Agencias)',
  `pnr_related` varchar(512) DEFAULT NULL,
  `product_type_related` varchar(512) DEFAULT NULL,
  `providedByPcm` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0.- Lamp 1.- Pcm',
  PRIMARY KEY (`id`),
  KEY `idx_payment_transaction_update` (`transaction_id`,`gateway`,`payment_type`),
  KEY `idx_pnr` (`pnr`)
) ENGINE=InnoDB AUTO_INCREMENT=10573321 DEFAULT CHARSET=utf8mb3 COMMENT='0.- Lamp 1.- Pcm'
```

### `payment_transaction_aditional_data`

**Usado por:**
- `new-admin`: (`app/Models/PaymentTransactionAditionalData.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| transaction_id | varchar(255) | YES |  | NULL |  |
| cardPaymentMethod | varchar(255) | YES |  | NULL |  |
| bankAccountName | varchar(255) | YES |  | NULL |  |
| acquirerAccountCode | varchar(255) | YES |  | NULL |  |
| acquirerCode | varchar(255) | YES |  | NULL |  |
| threeDSVersion | varchar(255) | YES |  | NULL |  |
| threeDAuthenticated | varchar(255) | YES |  | NULL |  |
| threeDOffered | varchar(255) | YES |  | NULL |  |
| threeDOfferedResponse | varchar(255) | YES |  | NULL |  |
| avsResult | varchar(255) | YES |  | NULL |  |
| issuerCountry | varchar(255) | YES |  | NULL |  |
| countryCode | varchar(255) | YES |  | NULL |  |
| authorisationMid | varchar(255) | YES |  | NULL |  |
| inferredRefusalReason | varchar(255) | YES |  | NULL |  |
| refusalReasonRaw | varchar(255) | YES |  | NULL |  |
| expiryDate | varchar(255) | NO |  | NULL |  |
| paymentMethod | varchar(255) | NO |  | NULL |  |
| paymentMethodVariant | varchar(255) | NO |  | NULL |  |
| cardBin | varchar(255) | NO |  | NULL |  |
| cardHolder | varchar(255) | NO |  | NULL |  |
| card_fingerprint | varchar(64) | YES |  | NULL |  |
| diff_days_first_booking_between_last | smallint unsigned | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `payment_transaction_aditional_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transaction_id` varchar(255) DEFAULT NULL,
  `cardPaymentMethod` varchar(255) DEFAULT NULL,
  `bankAccountName` varchar(255) DEFAULT NULL,
  `acquirerAccountCode` varchar(255) DEFAULT NULL,
  `acquirerCode` varchar(255) DEFAULT NULL,
  `threeDSVersion` varchar(255) DEFAULT NULL,
  `threeDAuthenticated` varchar(255) DEFAULT NULL,
  `threeDOffered` varchar(255) DEFAULT NULL,
  `threeDOfferedResponse` varchar(255) DEFAULT NULL,
  `avsResult` varchar(255) DEFAULT NULL,
  `issuerCountry` varchar(255) DEFAULT NULL,
  `countryCode` varchar(255) DEFAULT NULL,
  `authorisationMid` varchar(255) DEFAULT NULL,
  `inferredRefusalReason` varchar(255) DEFAULT NULL,
  `refusalReasonRaw` varchar(255) DEFAULT NULL,
  `expiryDate` varchar(255) NOT NULL COMMENT 'Fecha expiración tarjeta',
  `paymentMethod` varchar(255) NOT NULL COMMENT 'Forma de pago',
  `paymentMethodVariant` varchar(255) NOT NULL COMMENT 'Variante de la forma de pago',
  `cardBin` varchar(255) NOT NULL COMMENT 'Bin de la tarjeta',
  `cardHolder` varchar(255) NOT NULL COMMENT 'Titular de la tarjeta',
  `card_fingerprint` varchar(64) DEFAULT NULL,
  `diff_days_first_booking_between_last` smallint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=utf8mb3 COMMENT='Titular de la tarjeta'
```

### `permission`

**Usado por:**
- `new-admin`: (`app/Models/Permission.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| perm_id | int | NO | PRI | NULL | auto_increment |
| perm_desc | varchar(50) | NO |  | NULL |  |
| parent | int | YES |  | 0 |  |
| kind | char(1) | YES |  | NULL |  |
| long_desc | tinytext | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | perm_id | Sí |

#### DDL

```sql
CREATE TABLE `permission` (
  `perm_id` int NOT NULL AUTO_INCREMENT,
  `perm_desc` varchar(50) NOT NULL,
  `parent` int DEFAULT '0',
  `kind` char(1) DEFAULT NULL COMMENT 'm = menu, o = operacional',
  `long_desc` tinytext,
  PRIMARY KEY (`perm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=339 DEFAULT CHARSET=utf8mb3
```

### `postopinion_results`

**Usado por:**
- `new-admin`: (`app/Models/PostOpinionResult.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| booking_id | int | NO |  | NULL |  |
| booking_type | int | NO |  | NULL |  |
| question_id | int | NO |  | NULL |  |
| answer_id | int | YES |  | NULL |  |
| free_text | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `postopinion_results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `booking_type` int NOT NULL,
  `question_id` int NOT NULL COMMENT 'id de la pregunta',
  `answer_id` int DEFAULT NULL COMMENT 'id de la respuesta',
  `free_text` varchar(256) DEFAULT NULL COMMENT 'En caso de que la respuesta sea un texto libre, en lugar de answer_id vendrá esto relleno.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Resultados de las preguntas tras opinar'
```

### `presets`

**Usado por:**
- `new-admin`: (`app/Models/Preset.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| type | varchar(30) | NO |  | NULL |  |
| preset | varchar(250) | NO |  | NULL |  |
| user_id | int | YES |  | NULL |  |
| last_accessed | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| created_at | timestamp | NO |  | 0000-00-00 00:00:00 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `presets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(30) NOT NULL,
  `preset` varchar(250) NOT NULL,
  `user_id` int DEFAULT NULL,
  `last_accessed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `press`

**Usado por:**
- `new-admin`: (`app/Models/Press.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| lang | varchar(32) | YES |  | es |  |
| title | varchar(400) | YES |  | NULL |  |
| date | date | YES |  | NULL |  |
| description | text | YES |  | NULL |  |
| media | varchar(256) | YES |  | NULL |  |
| url | text | YES |  | NULL |  |
| status | tinyint | NO |  | 0 |  |
| category_id | tinyint | YES |  | NULL |  |
| country_id | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `press` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` varchar(32) DEFAULT 'es',
  `title` varchar(400) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `description` text,
  `media` varchar(256) DEFAULT NULL,
  `url` text,
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0 = no publicada, 1 = publicada',
  `category_id` tinyint DEFAULT NULL COMMENT '1-tier1, 2-tier2, 3-tier3',
  `country_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `privacy`

**Usado por:**
- `new-admin`: (`app/Models/PrivacyPolicy.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | YES |  | 0 |  |
| title | text | YES |  | NULL |  |
| answer | text | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| status | tinyint | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| active | tinyint | YES |  | 1 |  |
| type | tinyint(1) | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `privacy` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int DEFAULT '0',
  `title` text,
  `answer` text,
  `orden` int DEFAULT NULL,
  `status` tinyint DEFAULT NULL COMMENT '0.No publicado 1.Publicado',
  `lang` varchar(2) DEFAULT NULL,
  `active` tinyint DEFAULT '1' COMMENT '0.Desactivada 1.Activa',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0: Web, 1: Apps',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=233 DEFAULT CHARSET=utf8mb3 COMMENT='0: Web, 1: Apps'
```

### `privacy_changelog`

**Usado por:**
- `new-admin`: (`app/Models/PrivacyPolicyChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idPriv | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validation | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `privacy_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idPriv` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validation` int DEFAULT '0' COMMENT '1-Si 0-No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb3 COMMENT='changelog de privacy'
```

### `privacy_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/PrivacyPolicyChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idChange | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `privacy_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idChange` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `lang` varchar(2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=908 DEFAULT CHARSET=utf8mb3 COMMENT='Validadores de privacy'
```

### `proveedores`

**Usado por:**
- `new-admin`: (`app/Models/Provider.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| nombre | varchar(128) | NO | MUL | NULL |  |
| descripcion | text | NO |  | NULL |  |
| email | varchar(128) | NO |  | NULL |  |
| emailCopia | varchar(128) | YES |  | NULL |  |
| email_facturacion | varchar(128) | YES |  | NULL |  |
| telefono | varchar(128) | NO |  | NULL |  |
| zona_horaria | varchar(32) | NO |  | NULL |  |
| usuario | varchar(128) | NO |  | NULL |  |
| password | varchar(32) | NO |  | NULL |  |
| nombre_contacto | varchar(32) | NO |  | NULL |  |
| idioma | char(2) | NO |  | NULL |  |
| iva | tinyint(1) | NO |  | 0 |  |
| empresa | tinyint(1) | NO |  | 1 |  |
| facturacion | tinyint(1) | NO |  | 0 |  |
| fecha_pago | tinyint(1) | NO |  | 0 |  |
| resumen_diario | tinyint(1) | NO |  | 0 |  |
| insertar_url_listado | tinyint(1) | NO |  | 0 |  |
| metodo_pago | varchar(128) | NO |  | NULL |  |
| datos_facturacion | text | NO |  | NULL |  |
| concepto | varchar(128) | NO |  | NULL |  |
| actividades | int | YES |  | NULL |  |
| traslados | int | YES |  | NULL |  |
| solo_freetours | tinyint | NO |  | 0 |  |
| activation_token | varchar(256) | NO |  | NULL |  |
| lost_password_request | tinyint | NO |  | 0 |  |
| lost_password_timestamp | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| id_responsable | int | YES |  | NULL |  |
| comision | text | YES |  | NULL |  |
| historial | text | YES |  | NULL |  |
| rappel | int | YES |  | 0 |  |
| use_antifraud_logic | tinyint | YES |  | 0 |  |
| estado | int | YES |  | 1 |  |
| created_at | timestamp | YES |  | NULL |  |
| updated_at | timestamp | YES |  | NULL |  |
| web | varchar(256) | YES |  | NULL |  |
| idioma_servicios | varchar(256) | YES |  | NULL |  |
| deposito | varchar(32) | YES |  | 0//0//0 |  |
| tipo | int | YES |  | 0 |  |
| email_integracion | int | YES |  | 0 |  |
| log_reservas | int | YES |  | 0 |  |
| accept_comments | tinyint | YES |  | 1 |  |
| tipo_facturacion | tinyint | NO |  | 1 |  |
| region | int | YES |  | 0 |  |
| mostrar_telefono_cliente | tinyint | NO |  | 1 |  |
| mostrar_email_cliente | tinyint | NO |  | 0 |  |
| accept_cash | int | YES |  | 0 |  |
| join_date | datetime | YES |  | NULL |  |
| email_integracion_modif | int | YES |  | 0 |  |
| email_integracion_cancel | int | YES |  | 0 |  |
| frecuencia_pago | int | YES |  | 1 |  |
| fechaAltaNuevaFacturacion | datetime | YES |  | NULL |  |
| incidencias_pago | int | YES |  | 0 |  |
| attach_json | int | YES |  | 0 |  |
| pending_conditions | int | NO |  | 0 |  |
| type_conditions | int | NO |  | 0 |  |
| bank_details_completed | int | YES |  | 0 |  |
| auto_invoice_to_customers | varchar(1) | YES |  | 0 |  |
| auto_invoice_to_customers_tax_rate | float(10,2) | YES |  | 0.00 |  |
| provider_invoice_id | int | YES |  | 1 |  |
| tipo_servicio | int | YES |  | NULL |  |
| minimo_participantes | int | YES |  | NULL |  |
| cancelacion_gratuita | int | YES |  | NULL |  |
| software_gestion | int | YES |  | NULL |  |
| admin_messages_log | text | YES |  | NULL |  |
| log_horarios | int | YES |  | 0 |  |
| invoice_comments | varchar(256) | YES |  | NULL |  |
| firstSaleNotification | tinyint | NO |  | 0 |  |
| date_last_login | datetime | YES |  | NULL |  |
| date_change_range | int | NO |  | 48 |  |
| autopay_freetour_invoices | tinyint | NO |  | 0 |  |
| price_type | tinyint | NO |  | 1 |  |
| reason_for_rejection | tinyint | YES |  | NULL |  |
| ticketing | tinyint | NO |  | 0 |  |
| show_in_activities | tinyint | NO |  | 1 |  |
| payment_responsible | int | YES |  | NULL |  |
| address | varchar(255) | YES |  | NULL |  |
| place_id | varchar(200) | YES |  | NULL |  |
| compensates_freetour | tinyint(1) | YES |  | 0 |  |
| enabled_2fa | tinyint(1) | NO |  | 0 |  |
| hide_social_denomination | tinyint(1) | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| proveedores_idx_id | BTREE | id | No |
| proveedores_nombre_IDX | BTREE | nombre | No |

#### DDL

```sql
CREATE TABLE `proveedores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(128) NOT NULL,
  `descripcion` text NOT NULL,
  `email` varchar(128) NOT NULL,
  `emailCopia` varchar(128) DEFAULT NULL,
  `email_facturacion` varchar(128) DEFAULT NULL,
  `telefono` varchar(128) NOT NULL,
  `zona_horaria` varchar(32) NOT NULL,
  `usuario` varchar(128) NOT NULL,
  `password` varchar(32) NOT NULL,
  `nombre_contacto` varchar(32) NOT NULL,
  `idioma` char(2) NOT NULL,
  `iva` tinyint(1) NOT NULL DEFAULT '0',
  `empresa` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 Civitatis 2 Viajes con Encanto',
  `facturacion` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 Facturo al proveedor 1 Facturo al cliente 3 Factura que deben pagar 4 Autofactura',
  `fecha_pago` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 Pago mes reserva 1 Pago mes realiza 2 Prepago',
  `resumen_diario` tinyint(1) NOT NULL DEFAULT '0',
  `insertar_url_listado` tinyint(1) NOT NULL DEFAULT '0',
  `metodo_pago` varchar(128) NOT NULL,
  `datos_facturacion` text NOT NULL,
  `concepto` varchar(128) NOT NULL,
  `actividades` int DEFAULT NULL,
  `traslados` int DEFAULT NULL,
  `solo_freetours` tinyint NOT NULL DEFAULT '0' COMMENT 'Si el proveedor solo ofrecerá freetours',
  `activation_token` varchar(256) NOT NULL,
  `lost_password_request` tinyint NOT NULL DEFAULT '0',
  `lost_password_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_responsable` int DEFAULT NULL,
  `comision` text,
  `historial` text,
  `rappel` int DEFAULT '0' COMMENT '0 No 1 Si',
  `use_antifraud_logic` tinyint DEFAULT '0',
  `estado` int DEFAULT '1' COMMENT '1.- Pendiente de revisión 2.- En negociación 3.- Rechazado 4.- Activos 5.- Inactivo 6.- Pendiente firma 7.- Pendiente validación documentos 8.- Pendiente de administración 9.- Falta información',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `web` varchar(256) DEFAULT NULL,
  `idioma_servicios` varchar(256) DEFAULT NULL,
  `deposito` varchar(32) DEFAULT '0//0//0',
  `tipo` int DEFAULT '0' COMMENT '1.- Operador final 2.- Intermediario',
  `email_integracion` int DEFAULT '0' COMMENT '0.- No 1.- Sí',
  `log_reservas` int DEFAULT '0' COMMENT '0.- No 1.- Sí',
  `accept_comments` tinyint DEFAULT '1',
  `tipo_facturacion` tinyint NOT NULL DEFAULT '1' COMMENT '1-cliente 2-proveedor',
  `region` int DEFAULT '0' COMMENT '0  Canarias y Resto 1 Peninsula y Baleares',
  `mostrar_telefono_cliente` tinyint NOT NULL DEFAULT '1',
  `mostrar_email_cliente` tinyint NOT NULL DEFAULT '0',
  `accept_cash` int DEFAULT '0' COMMENT 'Acepta dinero en metálico a pagar en destino',
  `join_date` datetime DEFAULT NULL,
  `email_integracion_modif` int DEFAULT '0' COMMENT '0.- No 1.- Sí',
  `email_integracion_cancel` int DEFAULT '0' COMMENT '0.- No 1.- Sí',
  `frecuencia_pago` int DEFAULT '1' COMMENT '0 Quincenal, 1 Mensual',
  `fechaAltaNuevaFacturacion` datetime DEFAULT NULL,
  `incidencias_pago` int DEFAULT '0' COMMENT '0.- No 1.- Embargado',
  `attach_json` int DEFAULT '0' COMMENT '0.- No 1.- Se adjunta el JSON con los datos de la reserva en el correo',
  `pending_conditions` int NOT NULL DEFAULT '0' COMMENT '1 - Si 0 - No',
  `type_conditions` int NOT NULL DEFAULT '0' COMMENT '0 - Modelo Civitatis Antiguo, 1 - Modelo Civitatis Nuevo, 2 - Contrato del proveedor',
  `bank_details_completed` int DEFAULT '0' COMMENT '0 no, 1 si',
  `auto_invoice_to_customers` varchar(1) DEFAULT '0',
  `auto_invoice_to_customers_tax_rate` float(10,2) DEFAULT '0.00',
  `provider_invoice_id` int DEFAULT '1' COMMENT 'invoice num to client',
  `tipo_servicio` int DEFAULT NULL COMMENT '0.-undefined 1.- Privado 2.- Colectivo 3.- Ambas',
  `minimo_participantes` int DEFAULT NULL COMMENT '1.- Uno (sin mínimo) 2.- Dos',
  `cancelacion_gratuita` int DEFAULT NULL COMMENT '1.- 0 horas 2.- 2 horas 3.- 6 horas 4.- 12 horas 5.- 24 horas 6.- 48 horas',
  `software_gestion` int DEFAULT NULL,
  `admin_messages_log` text,
  `log_horarios` int DEFAULT '0',
  `invoice_comments` varchar(256) DEFAULT NULL,
  `firstSaleNotification` tinyint NOT NULL DEFAULT '0' COMMENT '0-No se ha enviado, 1-Si. se ha enviado',
  `date_last_login` datetime DEFAULT NULL,
  `date_change_range` int NOT NULL DEFAULT '48' COMMENT 'Ambito de horas para modificar fecha/hora',
  `autopay_freetour_invoices` tinyint NOT NULL DEFAULT '0' COMMENT '(0 ó 1) Permitir al proveedor que pague sus facturas de freetours online automáticamente',
  `price_type` tinyint NOT NULL DEFAULT '1' COMMENT ' 0=neto, 1=pvp, 2=ambos',
  `reason_for_rejection` tinyint DEFAULT NULL COMMENT '1 - ya tenemos actividades similares disponibles en el destino, 2 - este producto no encaja con nuestros criterios de selección, 3 - No hemos recibido la información imprescindible para activar la colaboración',
  `ticketing` tinyint NOT NULL DEFAULT '0' COMMENT '0 - Falso, 1 - Verdadero',
  `show_in_activities` tinyint NOT NULL DEFAULT '1',
  `payment_responsible` int DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `place_id` varchar(200) DEFAULT NULL,
  `compensates_freetour` tinyint(1) DEFAULT '0' COMMENT '1 - Si, 0 - No',
  `enabled_2fa` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 - 2FA inactivo 1 - 2FA activo',
  `hide_social_denomination` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 - No, 1 - Sí',
  PRIMARY KEY (`id`),
  KEY `proveedores_idx_id` (`id`),
  KEY `proveedores_nombre_IDX` (`nombre`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=46040 DEFAULT CHARSET=utf8mb3 COMMENT='Ambito de horas para modificar fecha/hora'
```

### `proveedores_destinos`

**Usado por:**
- `new-admin`: (`app/Models/ProviderDestination.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| providerId | int | NO | PRI | NULL |  |
| destinoId | int | NO | PRI | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | providerId, destinoId | Sí |

#### DDL

```sql
CREATE TABLE `proveedores_destinos` (
  `providerId` int NOT NULL,
  `destinoId` int NOT NULL,
  PRIMARY KEY (`providerId`,`destinoId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `provider_activity_change_requests`

**Usado por:**
- `new-admin`: (`app/Models/ProviderActivityChangeRequest.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| provider_id | int | NO |  | NULL |  |
| activity_id | int | NO |  | NULL |  |
| request_description | text | NO |  | NULL |  |
| schedule_timestamp | timestamp | YES |  | NULL |  |
| resolution_description | text | YES |  | NULL |  |
| resolution_timestamp | timestamp | YES |  | NULL |  |
| status | int | NO |  | 1 |  |
| creation_timestamp | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| file | varchar(256) | YES |  | NULL |  |
| content_type | varchar(256) | YES |  | NULL |  |
| request_dm | text | YES |  | NULL |  |
| resolution_dm | text | YES |  | NULL |  |
| supply_support_user_id | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `provider_activity_change_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int NOT NULL,
  `activity_id` int NOT NULL,
  `request_description` text NOT NULL COMMENT 'Información sobre la petición del proveedor',
  `schedule_timestamp` timestamp NULL DEFAULT NULL,
  `resolution_description` text COMMENT 'Respuesta a la resolución dada',
  `resolution_timestamp` timestamp NULL DEFAULT NULL,
  `status` int NOT NULL DEFAULT '1' COMMENT '1.- pendiente de revisión, 2.- rechazado, 3.- aprobado parcialmente, 4.- aprobado completo',
  `creation_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `file` varchar(256) DEFAULT NULL,
  `content_type` varchar(256) DEFAULT NULL,
  `request_dm` text COMMENT 'Mensaje al DM',
  `resolution_dm` text COMMENT 'Respuesta del DM',
  `supply_support_user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Respuesta del DM'
```

### `provider_activity_change_requests_to_activity_changes`

**Usado por:**
- `new-admin`: (`app/Models/ProviderActivityChangeRequestToActivityChange.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_provider_activity_change_request | int | NO | MUL | NULL |  |
| id_activity_change | int | NO | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_provActReq_activityReq | BTREE | id_activity_change | No |
| fk_provActReq_providerReq | BTREE | id_provider_activity_change_request | No |

#### DDL

```sql
CREATE TABLE `provider_activity_change_requests_to_activity_changes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_provider_activity_change_request` int NOT NULL,
  `id_activity_change` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_provActReq_providerReq` (`id_provider_activity_change_request`),
  KEY `fk_provActReq_activityReq` (`id_activity_change`),
  CONSTRAINT `fk_provActReq_activityReq` FOREIGN KEY (`id_activity_change`) REFERENCES `activity_change` (`id`),
  CONSTRAINT `fk_provActReq_providerReq` FOREIGN KEY (`id_provider_activity_change_request`) REFERENCES `provider_activity_change_requests` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `provider_admin_messages_log`

**Usado por:**
- `new-admin`: (`app/Models/ProviderAdminMessagesLog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| provider_id | int | NO |  | NULL |  |
| message_from | int | NO |  | NULL |  |
| message | text | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `provider_admin_messages_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int NOT NULL,
  `message_from` int NOT NULL COMMENT 'Usuario que crea el mensaje. 0-Account Manager 1-Admon',
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `provider_contact_details`

**Usado por:**
- `new-admin`: (`app/Models/ProviderContactDetails.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| providerId | int | NO | MUL | NULL |  |
| contactName | varchar(256) | NO |  | NULL |  |
| email | varchar(128) | NO |  | NULL |  |
| emailCC | varchar(128) | YES |  | NULL |  |
| phone | varchar(128) | YES |  | NULL |  |
| created_at | timestamp | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| provider_contact_details_providerId_IDX | BTREE | providerId | No |

#### DDL

```sql
CREATE TABLE `provider_contact_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `providerId` int NOT NULL,
  `contactName` varchar(256) NOT NULL,
  `email` varchar(128) NOT NULL,
  `emailCC` varchar(128) DEFAULT NULL,
  `phone` varchar(128) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `provider_contact_details_providerId_IDX` (`providerId`)
) ENGINE=InnoDB AUTO_INCREMENT=43670 DEFAULT CHARSET=utf8mb3
```

### `provider_contact_relations`

**Usado por:**
- `new-admin`: (`app/Models/ProviderContactRelations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| providerId | int | NO | MUL | NULL |  |
| contactDetailsId | int | NO |  | NULL |  |
| type | varchar(128) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| provider_contact_relations_providerId_IDX | BTREE | providerId, type | No |

#### DDL

```sql
CREATE TABLE `provider_contact_relations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `providerId` int NOT NULL,
  `contactDetailsId` int NOT NULL,
  `type` varchar(128) NOT NULL COMMENT '1 Reservas 2 Facturación 3 Comercial 4 Atención al cliente 5-Informacion Voucher 6-Postventa',
  PRIMARY KEY (`id`),
  KEY `provider_contact_relations_providerId_IDX` (`providerId`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=118830 DEFAULT CHARSET=utf8mb3
```

### `provider_deposit_moves`

**Usado por:**
- `new-admin`: (`app/Models/ProviderDepositMove.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| deposit_id | int | NO |  | NULL |  |
| author | varchar(32) | NO |  | NULL |  |
| amount | float | NO |  | 0 |  |
| notes | varchar(256) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `provider_deposit_moves` (
  `id` int NOT NULL AUTO_INCREMENT,
  `deposit_id` int NOT NULL,
  `author` varchar(32) NOT NULL,
  `amount` float NOT NULL DEFAULT '0',
  `notes` varchar(256) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `provider_deposits`

**Usado por:**
- `new-admin`: (`app/Models/ProviderDeposit.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| provider_id | int | NO | UNI | NULL |  |
| amount | float | NO |  | 0 |  |
| currency | varchar(3) | NO |  | NULL |  |
| type | int | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| provider_id | BTREE | provider_id | Sí |

#### DDL

```sql
CREATE TABLE `provider_deposits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int NOT NULL,
  `amount` float NOT NULL DEFAULT '0',
  `currency` varchar(3) NOT NULL,
  `type` int NOT NULL COMMENT '1 = Fijo 2 = Flotante',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `provider_id` (`provider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `provider_docs`

**Usado por:**
- `new-admin`: (`app/Models/ProviderDocs.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| provider_id | int | NO | MUL | NULL |  |
| typology | int | NO |  | NULL |  |
| name | text | YES |  | NULL |  |
| filename | varchar(256) | NO |  | NULL |  |
| content_type | varchar(16) | NO |  | NULL |  |
| document_type | varchar(16) | NO |  | NULL |  |
| path | varchar(256) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_provider_docs_id_provider_id_typology | BTREE | provider_id, typology | No |

#### DDL

```sql
CREATE TABLE `provider_docs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int NOT NULL,
  `typology` int NOT NULL,
  `name` text,
  `filename` varchar(256) NOT NULL,
  `content_type` varchar(16) NOT NULL,
  `document_type` varchar(16) NOT NULL,
  `path` varchar(256) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_provider_docs_id_provider_id_typology` (`provider_id`,`typology`)
) ENGINE=InnoDB AUTO_INCREMENT=4167 DEFAULT CHARSET=utf8mb3
```

### `provider_docs_typology`

**Usado por:**
- `new-admin`: (`app/Models/ProviderDocsTypology.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | text | YES |  | NULL |  |
| multiple | tinyint | NO |  | 0 |  |
| label | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `provider_docs_typology` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` text,
  `multiple` tinyint NOT NULL DEFAULT '0',
  `label` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3
```

### `provider_faq_responses`

**Usado por:**
- `new-admin`: (`app/Models/ProviderFaqResponses.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_provider | int | NO | MUL | NULL |  |
| id_faq | int | NO | MUL | NULL |  |
| response | varchar(255) | NO |  | NULL |  |
| valid_until | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_provider_faq_response | BTREE | id_faq | No |
| fk_provider_faq_response_provider | BTREE | id_provider | No |

#### DDL

```sql
CREATE TABLE `provider_faq_responses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_provider` int NOT NULL COMMENT 'FK proveedores',
  `id_faq` int NOT NULL COMMENT 'FK provider_faq',
  `response` varchar(255) NOT NULL COMMENT 'del tipo definido en response_type de provider_faq',
  `valid_until` timestamp NULL DEFAULT NULL COMMENT 'null si no caduca',
  PRIMARY KEY (`id`),
  KEY `fk_provider_faq_response_provider` (`id_provider`),
  KEY `fk_provider_faq_response` (`id_faq`),
  CONSTRAINT `fk_provider_faq_response` FOREIGN KEY (`id_faq`) REFERENCES `provider_faq` (`id`),
  CONSTRAINT `fk_provider_faq_response_provider` FOREIGN KEY (`id_provider`) REFERENCES `proveedores` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3
```

### `provider_fiscal_data`

**Usado por:**
- `new-admin`: (`app/Models/ProviderFiscalData.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| provider_id | int | NO | MUL | NULL |  |
| country_id | int | YES | MUL | NULL |  |
| type_identification | varchar(2) | YES |  | NULL |  |
| identification | varchar(50) | YES |  | NULL |  |
| social_denomination | varchar(150) | YES |  | NULL |  |
| address | varchar(250) | YES |  | NULL |  |
| cp | varchar(10) | YES |  | NULL |  |
| city | varchar(100) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_provider_fiscal_data_country_id | BTREE | country_id | No |
| fk_provider_fiscal_data_provider_id | BTREE | provider_id | No |

#### DDL

```sql
CREATE TABLE `provider_fiscal_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int NOT NULL,
  `country_id` int DEFAULT NULL,
  `type_identification` varchar(2) DEFAULT NULL,
  `identification` varchar(50) DEFAULT NULL,
  `social_denomination` varchar(150) DEFAULT NULL,
  `address` varchar(250) DEFAULT NULL,
  `cp` varchar(10) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_provider_fiscal_data_provider_id` (`provider_id`),
  KEY `fk_provider_fiscal_data_country_id` (`country_id`),
  CONSTRAINT `FK_provider_fiscal_data_civitatis.proveedores` FOREIGN KEY (`provider_id`) REFERENCES `proveedores` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44919 DEFAULT CHARSET=utf8mb3
```

### `provider_method_of_payment`

**Usado por:**
- `new-admin`: (`app/Models/ProviderPaymentMethod.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| provider_id | int | NO | MUL | NULL |  |
| method_of_payment_id | int | NO | MUL | NULL |  |
| currency_id | int | YES | MUL | NULL |  |
| country_bank_id | int | YES | MUL | NULL |  |
| city_bank_name | varchar(128) | YES |  | NULL |  |
| name_bank | varchar(256) | YES |  | NULL |  |
| name_account | varchar(150) | YES |  | NULL |  |
| bank_account | varchar(100) | YES |  | NULL |  |
| swift_bic | varchar(50) | YES |  | NULL |  |
| extra_data | varchar(100) | YES |  | NULL |  |
| email | varchar(50) | YES |  | NULL |  |
| email_paypal | varchar(50) | YES |  | NULL |  |
| credit_card | varchar(128) | YES |  | NULL |  |
| bank_address | varchar(256) | YES |  | NULL |  |
| bank_account_type | int | YES |  | 0 |  |
| type_bank_identification | int | YES |  | 1 |  |
| ebury | int | YES |  | 0 |  |
| internal_account_type | int | NO |  | 0 |  |
| internal_number_acc | int | NO |  | 0 |  |
| provider_doc_id | int | YES |  | NULL |  |
| last_request_id | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_provider_method_of_payment_method_of_payment_id | BTREE | method_of_payment_id | No |
| fk_provider_method_of_payment_provider_id | BTREE | provider_id | No |
| idx_country_bank_id | BTREE | country_bank_id | No |
| idx_currency_id | BTREE | currency_id | No |

#### DDL

```sql
CREATE TABLE `provider_method_of_payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int NOT NULL,
  `method_of_payment_id` int NOT NULL,
  `currency_id` int DEFAULT NULL,
  `country_bank_id` int DEFAULT NULL,
  `city_bank_name` varchar(128) DEFAULT NULL,
  `name_bank` varchar(256) DEFAULT NULL,
  `name_account` varchar(150) DEFAULT NULL,
  `bank_account` varchar(100) DEFAULT NULL,
  `swift_bic` varchar(50) DEFAULT NULL,
  `extra_data` varchar(100) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `email_paypal` varchar(50) DEFAULT NULL,
  `credit_card` varchar(128) DEFAULT NULL,
  `bank_address` varchar(256) DEFAULT NULL,
  `bank_account_type` int DEFAULT '0' COMMENT '1. Cuenta corriente 2. Cuenta ahorro',
  `type_bank_identification` int DEFAULT '1',
  `ebury` int DEFAULT '0' COMMENT '0 no 1 sí',
  `internal_account_type` int NOT NULL DEFAULT '0' COMMENT '1.-IBAN 2.-C.C.C 3.-CBU 4.-CLABE INTERBANCARIA 5.-CCI',
  `internal_number_acc` int NOT NULL DEFAULT '0' COMMENT '1.-ABA 2.-ROUTING NUMBER 3.-SORT CODE 4.-IFSC 5.-CNAP 6.-TRANSIT NUMBER 7.-BSB',
  `provider_doc_id` int DEFAULT NULL,
  `last_request_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_provider_method_of_payment_provider_id` (`provider_id`),
  KEY `fk_provider_method_of_payment_method_of_payment_id` (`method_of_payment_id`),
  KEY `idx_currency_id` (`currency_id`),
  KEY `idx_country_bank_id` (`country_bank_id`),
  CONSTRAINT `FK_provider_method_of_payment_civitatis.proveedores` FOREIGN KEY (`provider_id`) REFERENCES `proveedores` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_provider_method_of_payment_method_of_payment_id` FOREIGN KEY (`method_of_payment_id`) REFERENCES `method_of_payment` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11416 DEFAULT CHARSET=utf8mb3
```

### `provider_method_of_payment_requests`

**Usado por:**
- `new-admin`: (`app/Models/ProviderPaymentMethodRequest.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| provider_id | int | NO |  | NULL |  |
| method_of_payment_id | int | NO |  | NULL |  |
| currency_id | int | YES |  | NULL |  |
| country_bank_id | int | YES |  | NULL |  |
| city_bank_name | varchar(125) | YES |  | NULL |  |
| name_bank | varchar(256) | YES |  | NULL |  |
| name_account | varchar(150) | YES |  | NULL |  |
| bank_account | varchar(100) | YES |  | NULL |  |
| swift_bic | varchar(50) | YES |  | NULL |  |
| extra_data | varchar(100) | YES |  | NULL |  |
| email | varchar(50) | YES |  | NULL |  |
| email_paypal | varchar(50) | YES |  | NULL |  |
| credit_card | varchar(128) | YES |  | NULL |  |
| bank_address | varchar(256) | YES |  | NULL |  |
| bank_account_type | int | YES |  | NULL |  |
| type_bank_identification | int | YES |  | NULL |  |
| ebury | int | YES |  | NULL |  |
| internal_account_type | int | NO |  | NULL |  |
| internal_number_acc | int | NO |  | NULL |  |
| provider_doc_id | int | YES |  | NULL |  |
| status | int | NO |  | 3 |  |
| date_request | datetime | YES |  | NULL |  |
| date_review | datetime | YES |  | NULL |  |
| reviewer_id | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `provider_method_of_payment_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int NOT NULL,
  `method_of_payment_id` int NOT NULL,
  `currency_id` int DEFAULT NULL,
  `country_bank_id` int DEFAULT NULL,
  `city_bank_name` varchar(125) DEFAULT NULL,
  `name_bank` varchar(256) DEFAULT NULL,
  `name_account` varchar(150) DEFAULT NULL,
  `bank_account` varchar(100) DEFAULT NULL,
  `swift_bic` varchar(50) DEFAULT NULL,
  `extra_data` varchar(100) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `email_paypal` varchar(50) DEFAULT NULL,
  `credit_card` varchar(128) DEFAULT NULL,
  `bank_address` varchar(256) DEFAULT NULL,
  `bank_account_type` int DEFAULT NULL,
  `type_bank_identification` int DEFAULT NULL,
  `ebury` int DEFAULT NULL,
  `internal_account_type` int NOT NULL,
  `internal_number_acc` int NOT NULL,
  `provider_doc_id` int DEFAULT NULL,
  `status` int NOT NULL DEFAULT '3' COMMENT '1 - Aprobada, 2 - Rechazada, 3 - Pendiente',
  `date_request` datetime DEFAULT NULL,
  `date_review` datetime DEFAULT NULL,
  `reviewer_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `provider_offer`

**Usado por:**
- `new-admin`: (`app/Models/ProviderOffer.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| status | tinyint | NO |  | 1 |  |
| provider_id | int | NO |  | NULL |  |
| name | varchar(256) | NO |  | NULL |  |
| discount_rate | tinyint | NO |  | NULL |  |
| booking_date_type | tinyint | NO |  | NULL |  |
| start_booking_date | date | YES |  | NULL |  |
| end_booking_date | date | YES |  | NULL |  |
| date_type | tinyint | NO |  | NULL |  |
| start_date | date | YES |  | NULL |  |
| end_date | date | YES |  | NULL |  |
| advance_days | smallint | YES |  | NULL |  |
| weekly_days | varchar(32) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `provider_offer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '0- Desactivada 1-Activa 2-Borrada 3-Borrador',
  `provider_id` int NOT NULL,
  `name` varchar(256) NOT NULL,
  `discount_rate` tinyint NOT NULL,
  `booking_date_type` tinyint NOT NULL COMMENT '0->Cualquier fecha reserva 1-> Rango de fechas 2->Reserva con antelacion de X dias (advance_days)',
  `start_booking_date` date DEFAULT NULL,
  `end_booking_date` date DEFAULT NULL,
  `date_type` tinyint NOT NULL COMMENT '0-> Cualquier fecha realizacion 1-> Rango de fechas de realizacion con posibles (weekly_days)',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `advance_days` smallint DEFAULT NULL,
  `weekly_days` varchar(32) DEFAULT NULL COMMENT 'From 1 to 7 Ej: 1,3,6  ',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3
```

### `provider_permissions`

**Usado por:**
- `new-admin`: (`app/Models/ProviderPermission.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| perm_name | varchar(100) | NO |  | NULL |  |
| parent | varchar(100) | YES |  | NULL |  |
| kind | varchar(1) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `provider_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `perm_name` varchar(100) NOT NULL,
  `parent` varchar(100) DEFAULT NULL,
  `kind` varchar(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb3 COMMENT='Are the same to all users'
```

### `provider_phone_request_log`

**Usado por:**
- `new-admin`: (`app/Models/ProviderPhoneRequestLog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| provider_id | int | NO |  | 0 |  |
| booking_id | int | NO |  | 0 |  |
| booking_type | int | NO |  | 0 |  |
| reason_id | int | NO |  | 0 |  |
| reason_description | text | YES |  | NULL |  |
| ip | varchar(255) | YES |  | NULL |  |
| created_at | timestamp | YES |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `provider_phone_request_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int NOT NULL DEFAULT '0',
  `booking_id` int NOT NULL DEFAULT '0',
  `booking_type` int NOT NULL DEFAULT '0',
  `reason_id` int NOT NULL DEFAULT '0',
  `reason_description` text,
  `ip` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4752035 DEFAULT CHARSET=utf8mb3 COMMENT='Peticiones de teléfono de un cliente por parte de proveedor'
```

### `provider_role_perm`

**Usado por:**
- `new-admin`: (`app/Models/ProviderRolePerm.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| provider_role_id | int | NO | PRI | NULL |  |
| provider_perm_id | int | NO | PRI | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | provider_role_id, provider_perm_id | Sí |
| fk_provider_role_perm_with_perm_id | BTREE | provider_perm_id | No |

#### DDL

```sql
CREATE TABLE `provider_role_perm` (
  `provider_role_id` int NOT NULL,
  `provider_perm_id` int NOT NULL,
  PRIMARY KEY (`provider_role_id`,`provider_perm_id`),
  KEY `fk_provider_role_perm_with_perm_id` (`provider_perm_id`),
  CONSTRAINT `fk_provider_role_perm_with_perm_id` FOREIGN KEY (`provider_perm_id`) REFERENCES `provider_permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_provider_role_perm_with_role_id` FOREIGN KEY (`provider_role_id`) REFERENCES `provider_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `provider_roles`

**Usado por:**
- `new-admin`: (`app/Models/ProviderRole.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| role_name | varchar(50) | NO |  | NULL |  |
| provider_id | int | NO | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| provider_id | BTREE | provider_id | No |

#### DDL

```sql
CREATE TABLE `provider_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  `provider_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `provider_id` (`provider_id`)
) ENGINE=InnoDB AUTO_INCREMENT=242345 DEFAULT CHARSET=utf8mb3
```

### `provider_role_user`

**Usado por:**
- `new-admin`: (`app/Models/ProviderRoleUser.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| provider_user_id | int | NO | PRI | NULL |  |
| provider_role_id | int | NO | PRI | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | provider_user_id, provider_role_id | Sí |
| fk_provider_user_role_with_role_id | BTREE | provider_role_id | No |

#### DDL

```sql
CREATE TABLE `provider_role_user` (
  `provider_user_id` int NOT NULL,
  `provider_role_id` int NOT NULL,
  PRIMARY KEY (`provider_user_id`,`provider_role_id`),
  KEY `fk_provider_user_role_with_role_id` (`provider_role_id`),
  CONSTRAINT `fk_provider_user_role_with_role_id` FOREIGN KEY (`provider_role_id`) REFERENCES `provider_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_provider_user_role_with_user_id` FOREIGN KEY (`provider_user_id`) REFERENCES `provider_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `providers_conditions_files`

**Usado por:**
- `new-admin`: (`app/Models/ProviderConditionFile.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_version | int | NO |  | NULL |  |
| filename | varchar(256) | NO |  | NULL |  |
| content_type | varchar(16) | NO |  | NULL |  |
| document_type | varchar(16) | NO |  | NULL |  |
| path | varchar(256) | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `providers_conditions_files` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_version` int NOT NULL,
  `filename` varchar(256) NOT NULL,
  `content_type` varchar(16) NOT NULL,
  `document_type` varchar(16) NOT NULL,
  `path` varchar(256) NOT NULL,
  `lang` varchar(2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3
```

### `provider_users`

**Usado por:**
- `new-admin`: (`app/Models/ProviderUser.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| provider_id | int | NO | MUL | NULL |  |
| name | varchar(50) | YES |  | NULL |  |
| surname | varchar(50) | YES |  | NULL |  |
| email | varchar(50) | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| password | varchar(50) | YES |  | NULL |  |
| phone | varchar(50) | YES |  | NULL |  |
| lost_password_request | tinyint | NO |  | 0 |  |
| lost_password_timestamp | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| activation_token | varchar(256) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| provider_id | BTREE | provider_id | No |

#### DDL

```sql
CREATE TABLE `provider_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `surname` varchar(50) DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `lang` varchar(2) NOT NULL,
  `password` varchar(50) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `lost_password_request` tinyint NOT NULL DEFAULT '0',
  `lost_password_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `activation_token` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `provider_id` (`provider_id`)
) ENGINE=InnoDB AUTO_INCREMENT=935 DEFAULT CHARSET=utf8mb3
```

### `provinces`

**Usado por:**
- `new-admin`: (`app/Models/Province.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | text | NO |  | NULL |  |
| country_id | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `provinces` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `country_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb3
```

### `queue_action_payload`

**Usado por:**
- `new-admin`: (`app/Models/QueueActionPayload.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| queue | varchar(250) | NO |  | NULL |  |
| action | varchar(250) | NO |  | NULL |  |
| payload | longtext | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `queue_action_payload` (
  `id` int NOT NULL AUTO_INCREMENT,
  `queue` varchar(250) NOT NULL,
  `action` varchar(250) NOT NULL,
  `payload` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb3
```

### `reembolsos_pendientes`

**Usado por:**
- `new-admin`: (`app/Models/PendingRefund.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| booking_id | int | NO |  | NULL |  |
| amount | float | YES |  | NULL |  |
| type | tinyint | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| deleted_at | timestamp | YES |  | NULL |  |
| status | tinyint | YES |  | NULL |  |
| user | int | YES |  | NULL |  |
| currency | varchar(4) | YES |  | NULL |  |
| approved_by | int | YES |  | NULL |  |
| compensation_type | tinyint | YES |  | NULL |  |
| civitatis_compensation | double | YES |  | NULL |  |
| provider_compensation | double | YES |  | NULL |  |
| compensation_percent_amount | int | YES |  | NULL |  |
| comment | varchar(1000) | YES |  | NULL |  |
| solved | int | YES |  | 0 |  |
| solved_comment | varchar(1000) | YES |  | NULL |  |
| refund_to_wallet | int | YES |  | 0 |  |
| is_bnpl_booking | tinyint unsigned | YES |  | 0 |  |
| bnpl_status_type | tinyint unsigned | YES |  | NULL |  |
| is_adjust_next_payment | tinyint unsigned | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `reembolsos_pendientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `amount` float DEFAULT NULL,
  `type` tinyint NOT NULL COMMENT '1- Actividad 2- Traslado 3- Pagos',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `status` tinyint DEFAULT NULL COMMENT '0. Pendiente 1. Aprobado 2. Revisar 3. Revisado',
  `user` int DEFAULT NULL,
  `currency` varchar(4) DEFAULT NULL,
  `approved_by` int DEFAULT NULL,
  `compensation_type` tinyint DEFAULT NULL COMMENT '2. Civitatis 3. Proveedor 4. 50% 5. Porcentaje compartido 6. Cantidad compartida',
  `civitatis_compensation` double DEFAULT NULL,
  `provider_compensation` double DEFAULT NULL,
  `compensation_percent_amount` int DEFAULT NULL COMMENT '0 Percent, 1 Amount Pago, 2 Amount Contratacion',
  `comment` varchar(1000) DEFAULT NULL COMMENT 'Comentario que explica por qué se ha de revisar',
  `solved` int DEFAULT '0',
  `solved_comment` varchar(1000) DEFAULT NULL COMMENT 'Comentario que explica la revisión',
  `refund_to_wallet` int DEFAULT '0' COMMENT '1 Si 0 No',
  `is_bnpl_booking` tinyint unsigned DEFAULT '0',
  `bnpl_status_type` tinyint unsigned DEFAULT NULL,
  `is_adjust_next_payment` tinyint unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3
```

### `reembolsos_pendientes_tienda`

**Usado por:**
- `new-admin`: (`app/Models/StoreRefund.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| booking_id | int | NO |  | NULL |  |
| booking_type | tinyint | NO |  | NULL |  |
| amount | float | YES |  | NULL |  |
| currency | varchar(4) | YES |  | NULL |  |
| status | tinyint | NO |  | 0 |  |
| user | int | YES |  | NULL |  |
| approved_by | int | YES |  | NULL |  |
| comment | varchar(1000) | YES |  | NULL |  |
| solved | int | YES |  | NULL |  |
| solved_comment | varchar(1000) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| deleted_at | timestamp | YES |  | NULL |  |
| reimbursed_at | datetime | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `reembolsos_pendientes_tienda` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `booking_type` tinyint NOT NULL COMMENT '1- Actividad 2- Traslado',
  `amount` float DEFAULT NULL,
  `currency` varchar(4) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0. Pendiente 1. Aprobado 2. Revisar 3. Revisado 4. Realizado',
  `user` int DEFAULT NULL,
  `approved_by` int DEFAULT NULL,
  `comment` varchar(1000) DEFAULT NULL COMMENT 'Comentario que explica por qué se ha de revisar',
  `solved` int DEFAULT NULL,
  `solved_comment` varchar(1000) DEFAULT NULL COMMENT 'Comentario que explica la revisión',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `reimbursed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `reembolsos_pendientes_tienda_changelog`

**Usado por:**
- `new-admin`: (`app/Models/StoreRefundChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| refund_id | int | NO |  | NULL |  |
| field | varchar(32) | NO |  | NULL |  |
| old_value | text | NO |  | NULL |  |
| new_value | text | NO |  | NULL |  |
| user | int | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `reembolsos_pendientes_tienda_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `refund_id` int NOT NULL,
  `field` varchar(32) NOT NULL,
  `old_value` text NOT NULL,
  `new_value` text NOT NULL,
  `user` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `regala_civitatis`

**Usado por:**
- `new-admin`: (`app/Models/RegalarCivitatis.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| token | varchar(256) | NO |  | NULL |  |
| author_email | varchar(256) | NO |  | NULL |  |
| author_name | varchar(256) | NO |  | NULL |  |
| reciever_email | varchar(256) | YES |  | NULL |  |
| reciever_name | varchar(256) | YES |  | NULL |  |
| amount | double | NO |  | NULL |  |
| currency | varchar(3) | NO |  | NULL |  |
| amount_euro | double | NO |  | NULL |  |
| message | text | YES |  | NULL |  |
| signature | varchar(256) | NO |  | NULL |  |
| lang | varchar(10) | NO |  | es |  |
| creation_timestamp | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| schedule_timestamp | timestamp | YES |  | NULL |  |
| step | int | NO |  | 1 |  |
| payment_transaction_id | int | YES |  | NULL |  |
| wallet_code_id | int | YES |  | NULL |  |
| aid | varchar(256) | YES |  | NULL |  |
| aid_timestamp | timestamp | YES |  | NULL |  |
| aid_referral | varchar(256) | YES |  | NULL |  |
| campana_afiliado | varchar(256) | YES |  | NULL |  |
| campana_afiliado_interna | varchar(256) | YES |  | NULL |  |
| channel_id | varchar(256) | YES |  | NULL |  |
| url_referer | varchar(256) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `regala_civitatis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `token` varchar(256) NOT NULL,
  `author_email` varchar(256) NOT NULL,
  `author_name` varchar(256) NOT NULL,
  `reciever_email` varchar(256) DEFAULT NULL,
  `reciever_name` varchar(256) DEFAULT NULL,
  `amount` double NOT NULL,
  `currency` varchar(3) NOT NULL,
  `amount_euro` double NOT NULL,
  `message` text,
  `signature` varchar(256) NOT NULL,
  `lang` varchar(10) NOT NULL DEFAULT 'es',
  `creation_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `schedule_timestamp` timestamp NULL DEFAULT NULL,
  `step` int NOT NULL DEFAULT '1' COMMENT '1.- formulario relleno | 2.- pagado y notificado comprador | 3.- enviado receptor | 4.- canjeado',
  `payment_transaction_id` int DEFAULT NULL,
  `wallet_code_id` int DEFAULT NULL,
  `aid` varchar(256) DEFAULT NULL,
  `aid_timestamp` timestamp NULL DEFAULT NULL,
  `aid_referral` varchar(256) DEFAULT NULL,
  `campana_afiliado` varchar(256) DEFAULT NULL,
  `campana_afiliado_interna` varchar(256) DEFAULT NULL,
  `channel_id` varchar(256) DEFAULT NULL,
  `url_referer` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3
```

### `region`

**Usado por:**
- `new-admin`: (`app/Models/Region.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(50) | NO |  | NULL |  |
| id_rol_responsable | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `region` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `id_rol_responsable` int DEFAULT NULL COMMENT 'Id del rol responsable de la región',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3
```

### `rejected_related_activities`

**Usado por:**
- `new-admin`: (`app/Models/RejectedActivityRelation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| rejected_activity_id | int | NO |  | NULL |  |
| parent_activity_id | int | NO |  | NULL |  |
| active | tinyint(1) | NO |  | 1 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `rejected_related_activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rejected_activity_id` int NOT NULL,
  `parent_activity_id` int NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `request_invoices_provider`

**Usado por:**
- `new-admin`: (`app/Models/RequestedInvoiceProvider.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| booking_id | int | NO | MUL | NULL |  |
| type | int | NO | MUL | NULL |  |
| concepto | text | YES |  | NULL |  |
| nombre_razon | varchar(100) | YES |  | NULL |  |
| tipo_identificacion | varchar(3) | YES |  | NULL |  |
| identificacion | varchar(50) | YES |  | NULL |  |
| pais | varchar(2) | YES |  | NULL |  |
| ciudad | varchar(100) | YES |  | NULL |  |
| cp | varchar(10) | YES |  | NULL |  |
| direccion | text | YES |  | NULL |  |
| expediente_agencia | text | YES |  | NULL |  |
| fecha_peticion | datetime | YES |  | NULL |  |
| fecha_subida_factura | datetime | YES |  | NULL |  |
| filename | varchar(256) | NO |  | NULL |  |
| content_type | varchar(16) | NO |  | NULL |  |
| document_type | varchar(16) | NO |  | NULL |  |
| path | varchar(256) | NO |  | NULL |  |
| idProveedor | int | YES |  | NULL |  |
| re_upload | varchar(1) | YES |  | 0 |  |
| status | int | YES |  | 0 |  |
| amount | decimal(38,2) | YES |  | NULL |  |
| currency | varchar(3) | YES |  | NULL |  |
| invoice_id | varchar(128) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_booking_id_status_type_provider | BTREE | booking_id, type, status, idProveedor | No |
| idx_type_status_upload_path | BTREE | type, status, re_upload, path | No |

#### DDL

```sql
CREATE TABLE `request_invoices_provider` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `type` int NOT NULL COMMENT '1-Actividad 2-Traslado',
  `concepto` text,
  `nombre_razon` varchar(100) DEFAULT NULL,
  `tipo_identificacion` varchar(3) DEFAULT NULL,
  `identificacion` varchar(50) DEFAULT NULL,
  `pais` varchar(2) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `cp` varchar(10) DEFAULT NULL,
  `direccion` text,
  `expediente_agencia` text,
  `fecha_peticion` datetime DEFAULT NULL,
  `fecha_subida_factura` datetime DEFAULT NULL,
  `filename` varchar(256) NOT NULL,
  `content_type` varchar(16) NOT NULL,
  `document_type` varchar(16) NOT NULL,
  `path` varchar(256) NOT NULL,
  `idProveedor` int DEFAULT NULL,
  `re_upload` varchar(1) DEFAULT '0',
  `status` int DEFAULT '0' COMMENT '0 Pendiente de subir 1 Enviada 2 Rechazada',
  `amount` decimal(38,2) DEFAULT NULL,
  `currency` varchar(3) DEFAULT NULL,
  `invoice_id` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_booking_id_status_type_provider` (`booking_id`,`type`,`status`,`idProveedor`),
  KEY `idx_type_status_upload_path` (`type`,`status`,`re_upload`,`path`)
) ENGINE=InnoDB AUTO_INCREMENT=783314 DEFAULT CHARSET=utf8mb3
```

### `review_boost_rules`

**Usado por:**
- `new-admin`: (`app/Models/ReviewBoostRule.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| code | varchar(32) | NO |  | NULL |  |
| description | tinytext | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `review_boost_rules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL,
  `description` tinytext NOT NULL COMMENT 'role text',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `review_boost_rules_options`

**Usado por:**
- `new-admin`: (`app/Models/ReviewBoostRuleOption.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| rule_id | int | NO |  | NULL |  |
| type | varchar(32) | NO |  | NULL |  |
| operator | varchar(32) | YES |  | NULL |  |
| value | varchar(32) | YES |  | NULL |  |
| value_type | varchar(32) | YES |  | NULL |  |
| weight | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `review_boost_rules_options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rule_id` int NOT NULL,
  `type` varchar(32) NOT NULL,
  `operator` varchar(32) DEFAULT NULL,
  `value` varchar(32) DEFAULT NULL,
  `value_type` varchar(32) DEFAULT NULL,
  `weight` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `role`

**Usado por:**
- `new-admin`: (`app/Models/Role.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| role_id | int | NO | PRI | NULL | auto_increment |
| role_name | varchar(50) | NO |  | NULL |  |
| description | varchar(250) | NO |  | NULL |  |
| meta | varchar(250) | YES |  | NULL |  |
| parent_id | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | role_id | Sí |

#### DDL

```sql
CREATE TABLE `role` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  `description` varchar(250) NOT NULL,
  `meta` varchar(250) DEFAULT NULL COMMENT 'Formato JSON para almacenar info',
  `parent_id` int DEFAULT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=238 DEFAULT CHARSET=utf8mb3
```

### `role_perm`

**Usado por:**
- `new-admin`: (`app/Models/RolePermission.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| role_id | int | NO | PRI | NULL |  |
| perm_id | int | NO | PRI | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | role_id, perm_id | Sí |
| fk_role_perm_with_perm_id | BTREE | perm_id | No |

#### DDL

```sql
CREATE TABLE `role_perm` (
  `role_id` int NOT NULL,
  `perm_id` int NOT NULL,
  PRIMARY KEY (`role_id`,`perm_id`),
  KEY `fk_role_perm_with_perm_id` (`perm_id`),
  CONSTRAINT `fk_role_perm_with_perm_id` FOREIGN KEY (`perm_id`) REFERENCES `permission` (`perm_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_role_perm_with_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `roles_permissions_changelog`

**Usado por:**
- `new-admin`: (`app/Models/RolePermissionChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| type_id | tinyint | NO |  | NULL |  |
| role_permission_id | int | NO |  | NULL |  |
| field | varchar(32) | NO |  | NULL |  |
| old_value | text | NO |  | NULL |  |
| new_value | text | NO |  | NULL |  |
| user_id | int | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `roles_permissions_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type_id` tinyint NOT NULL COMMENT '1 - Role, 2 - Permission',
  `role_permission_id` int NOT NULL,
  `field` varchar(32) NOT NULL,
  `old_value` text NOT NULL,
  `new_value` text NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3
```

### `rsc`

**Usado por:**
- `new-admin`: (`app/Models/RSCLastNew.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| lang | varchar(2) | NO |  | NULL |  |
| title | varchar(400) | YES |  | NULL |  |
| date | date | YES |  | NULL |  |
| description | text | YES |  | NULL |  |
| media | varchar(256) | YES |  | NULL |  |
| url | text | YES |  | NULL |  |
| status | tinyint | NO |  | 0 |  |
| fileUploaded | int | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `rsc` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` varchar(2) NOT NULL,
  `title` varchar(400) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `description` text,
  `media` varchar(256) DEFAULT NULL,
  `url` text,
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0 = no publicada, 1 = publicada',
  `fileUploaded` int NOT NULL DEFAULT '0' COMMENT '0-No, 1-Si',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `rsc_decalogue`

**Usado por:**
- `new-admin`: (`app/Models/RSCDecalogue.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | YES |  | 0 |  |
| decalogue_type | int | YES |  | 0 |  |
| title | text | YES |  | NULL |  |
| answer | text | YES |  | NULL |  |
| orden | int | YES |  | NULL |  |
| status | tinyint | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| active | tinyint | YES |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `rsc_decalogue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int DEFAULT '0',
  `decalogue_type` int DEFAULT '0' COMMENT '1- Manifiesto , 2- Compromiso 3- Conducta',
  `title` text,
  `answer` text,
  `orden` int DEFAULT NULL,
  `status` tinyint DEFAULT NULL COMMENT '0.No publicado 1.Publicado',
  `lang` varchar(2) DEFAULT NULL,
  `active` tinyint DEFAULT '1' COMMENT '0.Desactivada 1.Activa',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Decalogos de sostenibilidad'
```

### `rsc_decalogue_changelog`

**Usado por:**
- `new-admin`: (`app/Models/RSCDecalogueChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idDec | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validation | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `rsc_decalogue_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idDec` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validation` int DEFAULT '0' COMMENT '1-Si 0-No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='changelog de decalogue'
```

### `rsc_decalogue_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/RSCDecalogueChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idDec | int | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| lang | varchar(2) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `rsc_decalogue_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idDec` int DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `lang` varchar(2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Validadores de decalogue'
```

### `rsc_downloads`

**Usado por:**
- `new-admin`: (`app/Models/RSCFile.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(128) | YES |  | NULL |  |
| url | varchar(256) | YES |  | NULL |  |
| active | int | YES |  | 0 |  |
| size | varchar(128) | YES |  | NULL |  |
| fileUploaded | int | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `rsc_downloads` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `url` varchar(256) DEFAULT NULL,
  `active` int DEFAULT '0',
  `size` varchar(128) DEFAULT NULL,
  `fileUploaded` int NOT NULL DEFAULT '0' COMMENT '0-No, 1-Si',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `rsc_downloads_translations`

**Usado por:**
- `new-admin`: (`app/Models/RSCFileTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| rsc_download_id | int | NO |  | NULL |  |
| title | varchar(128) | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `rsc_downloads_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rsc_download_id` int NOT NULL,
  `title` varchar(128) NOT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `secondary_activities`

**Usado por:**
- `new-admin`: (`app/Models/SecondaryActivities.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| main_activity_id | int | NO | PRI | NULL |  |
| secondary_activity_id | int | NO | PRI | NULL |  |
| active | tinyint | NO | MUL | 1 |  |
| priority | smallint | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | main_activity_id, secondary_activity_id | Sí |
| idx_secondary_activities_active | BTREE | active | No |
| idx_secondary_activities_secondary_activity_id | BTREE | secondary_activity_id | No |

#### DDL

```sql
CREATE TABLE `secondary_activities` (
  `main_activity_id` int NOT NULL,
  `secondary_activity_id` int NOT NULL,
  `active` tinyint NOT NULL DEFAULT '1',
  `priority` smallint NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`main_activity_id`,`secondary_activity_id`),
  KEY `idx_secondary_activities_active` (`active`),
  KEY `idx_secondary_activities_secondary_activity_id` (`secondary_activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `subcategories_destinations`

**Usado por:**
- `new-admin`: (`app/Models/ActivitySubCategoryTranslationDestination.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_subcat_translation | int | YES | MUL | NULL |  |
| id_master_destination | int | NO | MUL | NULL |  |
| indexable | tinyint(1) | YES |  | 0 |  |
| enabled | tinyint(1) | NO |  | 1 |  |
| image | varchar(255) | YES |  | NULL |  |
| title | varchar(256) | YES |  | NULL |  |
| url | varchar(100) | YES |  | NULL |  |
| meta_title | varchar(70) | YES |  | NULL |  |
| meta_description | varchar(160) | YES |  | NULL |  |
| content | text | YES |  | NULL |  |
| bookings_last_year | mediumint unsigned | NO |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_subcategories_destinations_subcategories_translations | BTREE | id_subcat_translation | No |
| id_master_destination | BTREE | id_master_destination, id_subcat_translation | Sí |
| idx_sd_destid_subcat_enabled | BTREE | id_master_destination, id_subcat_translation, enabled | No |

#### DDL

```sql
CREATE TABLE `subcategories_destinations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_subcat_translation` int DEFAULT NULL COMMENT 'Id de la traduccion de la subcategoria',
  `id_master_destination` int NOT NULL COMMENT 'Relación con el destino',
  `indexable` tinyint(1) DEFAULT '0' COMMENT '1=Si, 0=No',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0 - Inactivo 1 - Activo',
  `image` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'URL de la imagen para la relación subcategoría-destino',
  `title` varchar(256) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Alternative title for the subcategory',
  `url` varchar(100) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Alternative url for the subcategory',
  `meta_title` varchar(70) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `meta_description` varchar(160) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb3_unicode_ci,
  `bookings_last_year` mediumint unsigned NOT NULL DEFAULT '0' COMMENT 'Number of bookings in the last year',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_master_destination` (`id_master_destination`,`id_subcat_translation`),
  KEY `fk_subcategories_destinations_subcategories_translations` (`id_subcat_translation`),
  KEY `idx_sd_destid_subcat_enabled` (`id_master_destination`,`id_subcat_translation`,`enabled`),
  CONSTRAINT `fk_subcategories_destinations_destinos` FOREIGN KEY (`id_master_destination`) REFERENCES `destinos` (`id`),
  CONSTRAINT `fk_subcategories_destinations_subcategories_translations` FOREIGN KEY (`id_subcat_translation`) REFERENCES `subcategories_translations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Number of bookings in the last year'
```

### `subcategories_destinations_changelog`

**Usado por:**
- `new-admin`: (`app/Models/SubcategoriesDestinationsChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_subcategory_destination | int | NO | MUL | NULL |  |
| id_admin_user | int | NO | MUL | NULL |  |
| field | varchar(126) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| source | varchar(126) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_subcat_dest_changelog_id_admin_user | BTREE | id_admin_user | No |
| idx_subcat_dest_changelog_id_subcat_dest | BTREE | id_subcategory_destination | No |

#### DDL

```sql
CREATE TABLE `subcategories_destinations_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_subcategory_destination` int NOT NULL,
  `id_admin_user` int NOT NULL,
  `field` varchar(126) COLLATE utf8mb3_unicode_ci NOT NULL,
  `old_value` text COLLATE utf8mb3_unicode_ci,
  `new_value` text COLLATE utf8mb3_unicode_ci,
  `source` varchar(126) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_subcat_dest_changelog_id_admin_user` (`id_admin_user`),
  KEY `idx_subcat_dest_changelog_id_subcat_dest` (`id_subcategory_destination`),
  CONSTRAINT `fk_subcat_dest_changelog_id_admin_user` FOREIGN KEY (`id_admin_user`) REFERENCES `admin_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_subcat_dest_changelog_id_subcat_dest` FOREIGN KEY (`id_subcategory_destination`) REFERENCES `subcategories_destinations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `subcategories_translations`

**Usado por:**
- `new-admin`: (`app/Models/ActivitySubCategoryTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_subcategory | int | NO | MUL | NULL |  |
| name | varchar(256) | YES |  | NULL |  |
| url | varchar(100) | YES |  | NULL |  |
| lang | varchar(2) | NO | MUL | NULL |  |
| meta_title | varchar(70) | YES |  | NULL |  |
| meta_description | varchar(160) | YES |  | NULL |  |
| content | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_subcategories_translations_actividades_sub_categorias | BTREE | id_master_subcategory | No |
| idx_subcategories_translations_lang_url | BTREE | lang, url | No |

#### DDL

```sql
CREATE TABLE `subcategories_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_subcategory` int NOT NULL,
  `name` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `url` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `lang` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `meta_title` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `meta_description` varchar(160) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `fk_subcategories_translations_actividades_sub_categorias` (`id_master_subcategory`),
  KEY `idx_subcategories_translations_lang_url` (`lang`,`url`),
  CONSTRAINT `fk_subcategories_translations_actividades_sub_categorias` FOREIGN KEY (`id_master_subcategory`) REFERENCES `actividades_sub_categorias` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1024 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `subcategories_translations_changelog`

**Usado por:**
- `new-admin`: (`app/Models/ActivitySubCategoryChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_subcategory | int | NO | MUL | NULL |  |
| field | varchar(160) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validated | int | YES | MUL | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_subcat_trans_change_subcategory_created_at | BTREE | id_master_subcategory, created_at | No |
| idx_subcategories_translations_changelog_validated | BTREE | validated | No |

#### DDL

```sql
CREATE TABLE `subcategories_translations_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_subcategory` int NOT NULL,
  `field` varchar(160) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `old_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `new_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validated` int DEFAULT '0' COMMENT '1 - Si, 0 - No',
  PRIMARY KEY (`id`),
  KEY `idx_subcat_trans_change_subcategory_created_at` (`id_master_subcategory`,`created_at`),
  KEY `idx_subcategories_translations_changelog_validated` (`validated`),
  CONSTRAINT `fk_subcategories_translations_changelog_sub_categorias` FOREIGN KEY (`id_master_subcategory`) REFERENCES `actividades_sub_categorias` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Track the changes made in the subcategory'
```

### `subcategories_translations_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/ActivitySubCategoryChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_change | int | NO | MUL | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| lang | varchar(2) | NO | MUL | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_subcategories_translations_changelog_validation_changelog | BTREE | id_change | No |
| idx_subcat_trans_changelog_validation_lang | BTREE | lang | No |

#### DDL

```sql
CREATE TABLE `subcategories_translations_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_change` int NOT NULL,
  `user` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `lang` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_subcategories_translations_changelog_validation_changelog` (`id_change`),
  KEY `idx_subcat_trans_changelog_validation_lang` (`lang`),
  CONSTRAINT `fk_subcategories_translations_changelog_validation_changelog` FOREIGN KEY (`id_change`) REFERENCES `subcategories_translations_changelog` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `tags_master`

**Usado por:**
- `new-admin`: (`app/Models/Tag.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCiudad | int | NO |  | NULL |  |
| title | varchar(256) | NO |  | NULL |  |
| icon | varchar(64) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `tags_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCiudad` int NOT NULL COMMENT '0 - Todos los destinos',
  `title` varchar(256) NOT NULL,
  `icon` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8mb3
```

### `tags_master_translations`

**Usado por:**
- `new-admin`: (`app/Models/TagTranslations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterTag | int | NO | MUL | NULL |  |
| idioma | varchar(2) | NO |  | NULL |  |
| title | varchar(256) | NO |  | NULL |  |
| text | varchar(256) | NO |  | NULL |  |
| mostrar | int | NO |  | 0 |  |
| actualizacion | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| tmt_master_lang_idx | BTREE | idMasterTag, idioma | No |

#### DDL

```sql
CREATE TABLE `tags_master_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterTag` int NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `title` varchar(256) NOT NULL,
  `text` varchar(256) NOT NULL,
  `mostrar` int NOT NULL DEFAULT '0',
  `actualizacion` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tmt_master_lang_idx` (`idMasterTag`,`idioma`)
) ENGINE=InnoDB AUTO_INCREMENT=1095 DEFAULT CHARSET=utf8mb3
```

### `tags_master_translations_changelog`

**Usado por:**
- `new-admin`: (`app/Models/TagTranslationsChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterTag | int | NO | MUL | NULL |  |
| field | varchar(32) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validated | int | YES | MUL | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_tags_master_translations_changelog | BTREE | idMasterTag, created_at | No |
| idx_tags_master_translations_changelog_validated | BTREE | validated | No |

#### DDL

```sql
CREATE TABLE `tags_master_translations_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterTag` int NOT NULL,
  `field` varchar(32) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validated` int DEFAULT '0' COMMENT '1 - Si 0 - No',
  PRIMARY KEY (`id`),
  KEY `idx_tags_master_translations_changelog` (`idMasterTag`,`created_at`),
  KEY `idx_tags_master_translations_changelog_validated` (`validated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Track the changes made in the tags'
```

### `tags_master_translations_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/TagTranslationsChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCambio | int | NO |  | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| idioma | varchar(2) | NO | MUL | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_tag_translations_changelog_validation | BTREE | idioma | No |

#### DDL

```sql
CREATE TABLE `tags_master_translations_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCambio` int NOT NULL,
  `user` varchar(16) NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_tag_translations_changelog_validation` (`idioma`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `taxon`

**Usado por:**
- `new-admin`: (`app/Models/Tickets/Taxon.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| uuid | char(36) | NO | PRI | NULL |  |
| tag | varchar(255) | YES |  | NULL |  |
| description | varchar(255) | YES |  | NULL |  |
| show_by_default | tinyint | YES |  | 0 |  |
| data_type_uuid | varchar(36) | YES | MUL | NULL |  |
| default_value | text | YES |  | NULL |  |
| meta | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | uuid | Sí |
| fk_taxon_data_type | BTREE | data_type_uuid | No |

#### DDL

```sql
CREATE TABLE `taxon` (
  `uuid` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `tag` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `show_by_default` tinyint DEFAULT '0',
  `data_type_uuid` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `default_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `meta` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`uuid`),
  KEY `fk_taxon_data_type` (`data_type_uuid`),
  CONSTRAINT `fk_taxon_data_type` FOREIGN KEY (`data_type_uuid`) REFERENCES `taxon_data_types` (`uuid`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `ticketing_paxes_changelog`

**Usado por:**
- `new-admin`: (`app/Models/TicketingPaxesChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| pax_id | varchar(50) | NO |  | NULL |  |
| ticketing_id | varchar(50) | YES |  | NULL |  |
| code | varchar(50) | NO |  | NULL |  |
| user_id | int | NO |  | NULL |  |
| field | varchar(100) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `ticketing_paxes_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pax_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `ticketing_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_id` int NOT NULL,
  `field` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `old_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `new_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `transfer_fee_changelog`

**Usado por:**
- `new-admin`: (`app/Models/TransferFeeChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| transfer_fee_id | int | YES |  | NULL |  |
| field | varchar(32) | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `transfer_fee_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transfer_fee_id` int DEFAULT NULL,
  `field` varchar(32) DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `transfer_images_attributes_translations`

**Usado por:**
- `new-admin`: (`app/Models/TransferVariablesTranslationsImage.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| label | varchar(256) | NO |  | NULL |  |
| idVariableMaster | int | NO | MUL | NULL |  |
| src | text | NO |  | NULL |  |
| alt | text | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_transfer_images_attributes_translations_idVariableMaster | BTREE | idVariableMaster | No |

#### DDL

```sql
CREATE TABLE `transfer_images_attributes_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label` varchar(256) NOT NULL,
  `idVariableMaster` int NOT NULL,
  `src` text NOT NULL,
  `alt` text NOT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_transfer_images_attributes_translations_idVariableMaster` (`idVariableMaster`),
  CONSTRAINT `fk_transfer_images_attributes_translations_idVariableMaster` FOREIGN KEY (`idVariableMaster`) REFERENCES `transfer_variables_translations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `transfer_links_attributes_translations`

**Usado por:**
- `new-admin`: (`app/Models/TransferVariablesTranslationsLink.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| label | varchar(256) | NO |  | NULL |  |
| idVariableMaster | int | NO | MUL | NULL |  |
| href | text | NO |  | NULL |  |
| alt | text | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_transfer_links_attributes_translations_idVariableMaster | BTREE | idVariableMaster | No |

#### DDL

```sql
CREATE TABLE `transfer_links_attributes_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label` varchar(256) NOT NULL,
  `idVariableMaster` int NOT NULL,
  `href` text NOT NULL,
  `alt` text NOT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_transfer_links_attributes_translations_idVariableMaster` (`idVariableMaster`),
  CONSTRAINT `fk_transfer_links_attributes_translations_idVariableMaster` FOREIGN KEY (`idVariableMaster`) REFERENCES `transfer_variables_translations` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8mb3
```

### `transfer_promos_master`

**Usado por:**
- `new-admin`: (`app/Models/TransferPromo.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_tarifa | int | NO |  | NULL |  |
| id_city | int | NO |  | NULL |  |
| priority | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `transfer_promos_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tarifa` int NOT NULL,
  `id_city` int NOT NULL,
  `priority` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3
```

### `transfer_promos_master_translations`

**Usado por:**
- `new-admin`: (`app/Models/TransferPromoTranslation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_promo | int | NO |  | NULL |  |
| promo1 | varchar(512) | NO |  | NULL |  |
| promo2 | varchar(512) | YES |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| status | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `transfer_promos_master_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_promo` int NOT NULL,
  `promo1` varchar(512) NOT NULL,
  `promo2` varchar(512) DEFAULT NULL,
  `lang` varchar(2) NOT NULL,
  `status` int NOT NULL COMMENT '1 - Si 0 - No',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb3
```

### `transfer_promos_master_translations_changelog`

**Usado por:**
- `new-admin`: (`app/Models/TransferPromoTranslationChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterPromo | int | NO | MUL | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validated | int | YES | MUL | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_transfer_promos_master_translations_changelog | BTREE | idMasterPromo, created_at | No |
| idx_transfer_promos_master_translations_changelog_validated | BTREE | validated | No |

#### DDL

```sql
CREATE TABLE `transfer_promos_master_translations_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterPromo` int NOT NULL,
  `field` varchar(256) NOT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validated` int DEFAULT '0' COMMENT '1 - Si 0 - No',
  PRIMARY KEY (`id`),
  KEY `idx_transfer_promos_master_translations_changelog` (`idMasterPromo`,`created_at`),
  KEY `idx_transfer_promos_master_translations_changelog_validated` (`validated`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COMMENT='Track the changes made in promos'
```

### `transfer_promos_master_translations_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/TransferPromoTranslationChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCambio | int | NO |  | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| idioma | varchar(2) | NO | MUL | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_transfer_promos_master_translations_changelog_validation | BTREE | idioma | No |

#### DDL

```sql
CREATE TABLE `transfer_promos_master_translations_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCambio` int NOT NULL,
  `user` varchar(16) NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_transfer_promos_master_translations_changelog_validation` (`idioma`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `transfer_rate_period`

**Usado por:**
- `new-admin`: (`app/Models/TransferRatePeriod.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int unsigned | NO | PRI | NULL | auto_increment |
| traslados_tarifa_id | int | NO | MUL | NULL |  |
| name | varchar(255) | NO |  | NULL |  |
| date_start | date | YES |  | NULL |  |
| date_end | date | YES |  | NULL |  |
| is_monday | tinyint unsigned | NO |  | 0 |  |
| is_tuesday | tinyint unsigned | NO |  | 0 |  |
| is_wednesday | tinyint unsigned | NO |  | 0 |  |
| is_thursday | tinyint unsigned | NO |  | 0 |  |
| is_friday | tinyint unsigned | NO |  | 0 |  |
| is_saturday | tinyint unsigned | NO |  | 0 |  |
| is_sunday | tinyint unsigned | NO |  | 0 |  |
| net_amount | decimal(10,2) | NO |  | NULL |  |
| commission_amount | decimal(10,2) | NO |  | NULL |  |
| currency | char(3) | NO |  | NULL |  |
| priority | smallint unsigned | NO |  | 0 |  |
| is_active | tinyint unsigned | NO |  | 1 |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_transfer_rate_period_traslados_tarifa_id | BTREE | traslados_tarifa_id | No |

#### DDL

```sql
CREATE TABLE `transfer_rate_period` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `traslados_tarifa_id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `date_start` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `is_monday` tinyint unsigned NOT NULL DEFAULT '0',
  `is_tuesday` tinyint unsigned NOT NULL DEFAULT '0',
  `is_wednesday` tinyint unsigned NOT NULL DEFAULT '0',
  `is_thursday` tinyint unsigned NOT NULL DEFAULT '0',
  `is_friday` tinyint unsigned NOT NULL DEFAULT '0',
  `is_saturday` tinyint unsigned NOT NULL DEFAULT '0',
  `is_sunday` tinyint unsigned NOT NULL DEFAULT '0',
  `net_amount` decimal(10,2) NOT NULL,
  `commission_amount` decimal(10,2) NOT NULL,
  `currency` char(3) COLLATE utf8mb3_unicode_ci NOT NULL,
  `priority` smallint unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint unsigned NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_transfer_rate_period_traslados_tarifa_id` (`traslados_tarifa_id`),
  CONSTRAINT `fk_transfer_rate_period_traslados_tarifa` FOREIGN KEY (`traslados_tarifa_id`) REFERENCES `traslados_tarifas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `transfers_zones_delay_minutes`

**Usado por:**
- `new-admin`: (`app/Models/TransferTime.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| destination_id | int | NO |  | NULL |  |
| zone_a_id | int | NO | MUL | NULL |  |
| zone_b_id | int | NO | MUL | NULL |  |
| minutes | int | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_zone_b_id | BTREE | zone_b_id | No |
| idx_zone_a_id_zone_b_id | BTREE | zone_a_id, zone_b_id | No |
| unique_zone_a_id_zone_b_id | BTREE | zone_a_id, zone_b_id | Sí |

#### DDL

```sql
CREATE TABLE `transfers_zones_delay_minutes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination_id` int NOT NULL,
  `zone_a_id` int NOT NULL,
  `zone_b_id` int NOT NULL,
  `minutes` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_zone_a_id_zone_b_id` (`zone_a_id`,`zone_b_id`),
  KEY `fk_zone_b_id` (`zone_b_id`),
  KEY `idx_zone_a_id_zone_b_id` (`zone_a_id`,`zone_b_id`),
  CONSTRAINT `fk_zone_a_id` FOREIGN KEY (`zone_a_id`) REFERENCES `traslados_zonas` (`id`),
  CONSTRAINT `fk_zone_b_id` FOREIGN KEY (`zone_b_id`) REFERENCES `traslados_zonas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `transfers_zones_delay_minutes_changelog`

**Usado por:**
- `new-admin`: (`app/Models/TransferTimeChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| transfer_zone_delay_id | int | NO |  | NULL |  |
| user_id | int | NO |  | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `transfers_zones_delay_minutes_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transfer_zone_delay_id` int NOT NULL,
  `user_id` int NOT NULL,
  `field` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `old_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `new_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `transfers_zones_providers_kml`

**Usado por:**
- `new-admin`: (`app/Models/TransferZoneProviderKml.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | bigint unsigned | NO | PRI | NULL | auto_increment |
| destination_id | int | YES | MUL | NULL |  |
| zone_id | int | YES | MUL | NULL |  |
| provider_id | int | YES | MUL | NULL |  |
| kml | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| transfers_zone_providers_kml_destination_id_IDX | BTREE | destination_id | No |
| transfers_zone_providers_kml_provider_id_IDX | BTREE | provider_id | No |
| transfers_zone_providers_kml_zone_id_IDX | BTREE | zone_id | No |
| unique_zone_provider | BTREE | zone_id, provider_id | Sí |

#### DDL

```sql
CREATE TABLE `transfers_zones_providers_kml` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `destination_id` int DEFAULT NULL,
  `zone_id` int DEFAULT NULL,
  `provider_id` int DEFAULT NULL,
  `kml` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_zone_provider` (`zone_id`,`provider_id`),
  KEY `transfers_zone_providers_kml_destination_id_IDX` (`destination_id`),
  KEY `transfers_zone_providers_kml_zone_id_IDX` (`zone_id`),
  KEY `transfers_zone_providers_kml_provider_id_IDX` (`provider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `transfer_variables_translations`

**Usado por:**
- `new-admin`: (`app/Models/TransferVariablesTranslations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMaster | int | NO | MUL | NULL |  |
| label | varchar(128) | NO | MUL | NULL |  |
| value | text | YES |  | NULL |  |
| value_plural | text | YES |  | NULL |  |
| type | varchar(16) | NO |  | NULL |  |
| lang | varchar(2) | NO | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_id_lang_transfer_variables_translations | BTREE | id, lang | No |
| idx_idMaster_lang_transfer_variables_translations | BTREE | idMaster, lang | No |
| idx_transfer_variables_label_lang | BTREE | label, lang | No |
| idx_transfer_variables_translations_lang | BTREE | lang | No |

#### DDL

```sql
CREATE TABLE `transfer_variables_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMaster` int NOT NULL,
  `label` varchar(128) NOT NULL,
  `value` text,
  `value_plural` text,
  `type` varchar(16) NOT NULL,
  `lang` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_idMaster_lang_transfer_variables_translations` (`idMaster`,`lang`),
  KEY `idx_id_lang_transfer_variables_translations` (`id`,`lang`),
  KEY `idx_transfer_variables_label_lang` (`label`,`lang`),
  KEY `idx_transfer_variables_translations_lang` (`lang`)
) ENGINE=InnoDB AUTO_INCREMENT=84841 DEFAULT CHARSET=utf8mb3
```

### `transfer_vehicle_changelog`

**Usado por:**
- `new-admin`: (`app/Models/TransferVehicleChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| transfer_vehicle_id | int | YES |  | NULL |  |
| field | varchar(32) | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `transfer_vehicle_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transfer_vehicle_id` int DEFAULT NULL,
  `field` varchar(32) DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `traslados_destinos_proveedores`

**Usado por:**
- `new-admin`: (`app/Models/TransferDestinationProvider.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_destino | int | NO |  | NULL |  |
| id_proveedor | int | NO |  | NULL |  |
| suplemento_espera_minutos | int | YES |  | NULL |  |
| suplemento_espera_importe | float | YES |  | NULL |  |
| silla_bebe | int | YES |  | 0 |  |
| suplemento_silla_bebe | float | YES |  | NULL |  |
| divisa | varchar(4) | YES |  | NULL |  |
| silla_bebe_required | int | YES |  | 0 |  |
| silla_bebe_edad | int | YES |  | NULL |  |
| silla_bebe_peso | int | YES |  | NULL |  |
| silla_bebe_availability | int | YES |  | 0 |  |
| voucher | int | YES |  | 0 |  |
| cancellation | int | YES |  | NULL |  |
| tipo_iva_proveedor | tinyint | YES |  | 0 |  |
| silla_bebe_edad_minima | int | YES |  | NULL |  |
| silla_bebe_peso_minimo | int | YES |  | NULL |  |
| advance | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `traslados_destinos_proveedores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_destino` int NOT NULL,
  `id_proveedor` int NOT NULL,
  `suplemento_espera_minutos` int DEFAULT NULL,
  `suplemento_espera_importe` float DEFAULT NULL,
  `silla_bebe` int DEFAULT '0' COMMENT '1. Si 0. No',
  `suplemento_silla_bebe` float DEFAULT NULL,
  `divisa` varchar(4) DEFAULT NULL,
  `silla_bebe_required` int DEFAULT '0' COMMENT '0. Los vehículos de transporte de pasajeros no tienen la obligación de llevar sillitas para niños.                     1. El uso de sillas para niños es obligatorio.',
  `silla_bebe_edad` int DEFAULT NULL,
  `silla_bebe_peso` int DEFAULT NULL,
  `silla_bebe_availability` int DEFAULT '0' COMMENT '0. La disponibilidad está garantizada. 1 La disponibilidad no puede ser garantizada, está sujeta a disponibilidad. 2. La disponibilidad está garantizada cuando se reserva con más de 24 horas de antelación. 3 La disponibilidad está garantizada cuando se reserva con más de 48 horas de antelación.',
  `voucher` int DEFAULT '0' COMMENT '0. No necesario 1. Electrónico 2. Impreso 3 Ambas',
  `cancellation` int DEFAULT NULL,
  `tipo_iva_proveedor` tinyint DEFAULT '0' COMMENT '0 - Sin IVA 1 - IVA General 2 - Régimen especial 3 - IVA Reducido 4 - IVA exento',
  `silla_bebe_edad_minima` int DEFAULT NULL,
  `silla_bebe_peso_minimo` int DEFAULT NULL,
  `advance` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=904 DEFAULT CHARSET=utf8mb3
```

### `traslados_destinos_proveedores_changelog`

**Usado por:**
- `new-admin`: (`app/Models/TransferDestinationProviderChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| transfer_provider_id | int | YES |  | NULL |  |
| field | varchar(32) | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `traslados_destinos_proveedores_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transfer_provider_id` int DEFAULT NULL,
  `field` varchar(32) DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `traslados_detalles`

**Usado por:**
- `new-admin`: (`app/Models/TransferDetails.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id_ciudad | int | NO | PRI | NULL | auto_increment |
| consejos | text | NO |  | NULL |  |
| antelacion | tinyint | NO |  | NULL |  |
| otros_traslados | tinyint | NO |  | NULL |  |
| pago_anticipado | tinyint | NO |  | 1 |  |
| forma_pago | varchar(8) | NO |  | NULL |  |
| divisa | char(3) | NO |  | NULL |  |
| personas | int | NO |  | NULL |  |
| personas_privados | int | YES |  | 0 |  |
| personas_compartidos | int | YES |  | 0 |  |
| opiniones | int | NO |  | NULL |  |
| opiniones_privados | int | YES |  | 0 |  |
| opiniones_compartidos | int | YES |  | 0 |  |
| puntuacion | double | NO |  | NULL |  |
| puntuacion_privados | double | YES |  | 0 |  |
| puntuacion_compartidos | double | YES |  | 0 |  |
| puntualidad | double | NO |  | NULL |  |
| vehiculo | double | NO |  | NULL |  |
| conductor | double | NO |  | NULL |  |
| recomienda | double | NO |  | NULL |  |
| tipo_iva | tinyint | NO |  | 0 |  |
| shared_advice | varchar(64) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id_ciudad | Sí |
| idx_td_ciudad | BTREE | id_ciudad | No |

#### DDL

```sql
CREATE TABLE `traslados_detalles` (
  `id_ciudad` int NOT NULL AUTO_INCREMENT,
  `consejos` text NOT NULL,
  `antelacion` tinyint NOT NULL,
  `otros_traslados` tinyint NOT NULL,
  `pago_anticipado` tinyint NOT NULL DEFAULT '1',
  `forma_pago` varchar(8) NOT NULL,
  `divisa` char(3) NOT NULL,
  `personas` int NOT NULL,
  `personas_privados` int DEFAULT '0',
  `personas_compartidos` int DEFAULT '0',
  `opiniones` int NOT NULL,
  `opiniones_privados` int DEFAULT '0',
  `opiniones_compartidos` int DEFAULT '0',
  `puntuacion` double NOT NULL,
  `puntuacion_privados` double DEFAULT '0',
  `puntuacion_compartidos` double DEFAULT '0',
  `puntualidad` double NOT NULL,
  `vehiculo` double NOT NULL,
  `conductor` double NOT NULL,
  `recomienda` double NOT NULL,
  `tipo_iva` tinyint NOT NULL DEFAULT '0' COMMENT '0 - Sin IVA 1 - IVA General 2 - Régimen especial',
  `shared_advice` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id_ciudad`),
  KEY `idx_td_ciudad` (`id_ciudad`)
) ENGINE=InnoDB AUTO_INCREMENT=3282 DEFAULT CHARSET=utf8mb3
```

### `traslados_detalles_changelog`

**Usado por:**
- `new-admin`: (`app/Models/TransferDetailsChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| transfer_detail_id | int | YES |  | NULL |  |
| field | varchar(32) | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `traslados_detalles_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transfer_detail_id` int DEFAULT NULL,
  `field` varchar(32) DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `traslados_fechas_ocupadas`

**Usado por:**
- `new-admin`: (`app/Models/TransferOccupiedDate.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCiudad | int | NO |  | NULL |  |
| idProveedor | int | YES |  | NULL |  |
| fecha | varchar(256) | NO |  | NULL |  |
| start_date | date | YES |  | NULL |  |
| end_date | date | YES |  | NULL |  |
| start_hour | time | YES |  | NULL |  |
| end_hour | time | YES |  | NULL |  |
| range_date | tinyint(1) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `traslados_fechas_ocupadas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCiudad` int NOT NULL,
  `idProveedor` int DEFAULT NULL COMMENT 'Id del proveedor que está cerrado para dicha fecha. Null para todos',
  `fecha` varchar(256) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `start_hour` time DEFAULT NULL,
  `end_hour` time DEFAULT NULL,
  `range_date` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `traslados_fechas_ocupadas_changelog`

**Usado por:**
- `new-admin`: (`app/Models/TransferOccupiedDateChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| transfer_destination_id | int | YES |  | NULL |  |
| field | varchar(32) | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `traslados_fechas_ocupadas_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transfer_destination_id` int DEFAULT NULL,
  `field` varchar(32) DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `traslados_opiniones`

**Usado por:**
- `new-admin`: (`app/Models/TransferOpinion.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id_traslado | int | NO | PRI | NULL |  |
| id_ciudad | int | NO | MUL | NULL |  |
| nombre | varchar(32) | NO |  | NULL |  |
| puntualidad | int | NO |  | NULL |  |
| vehiculo | int | NO |  | NULL |  |
| conductor | int | NO |  | NULL |  |
| puntuacion | int | NO |  | NULL |  |
| recomienda | tinyint | NO |  | NULL |  |
| texto | text | NO |  | NULL |  |
| respuesta | text | NO |  | NULL |  |
| preguntaProveedor | text | YES |  | NULL |  |
| fecha_pregunta | datetime | YES |  | NULL |  |
| ticket_automatico | tinyint | YES |  | NULL |  |
| comentarios_proveedor | text | NO |  | NULL |  |
| fecha | date | NO |  | NULL |  |
| fecha_insercion | timestamp | NO |  | 0000-00-00 00:00:00 |  |
| fecha_aprobada | timestamp | NO |  | 0000-00-00 00:00:00 |  |
| fechaEliminada | timestamp | YES |  | NULL |  |
| fechaMalaResolucion | timestamp | YES |  | NULL |  |
| fecha_respuesta_proveedor | timestamp | YES |  | NULL |  |
| idioma | varchar(2) | YES |  | es |  |
| aprobada | tinyint | NO |  | NULL |  |
| tipoViajero | varchar(8) | YES |  | NULL |  |
| pais | varchar(2) | YES | MUL | es |  |
| ciudad | varchar(32) | YES |  | NULL |  |
| id_ticket | int | YES |  | NULL |  |
| aprobada_por | int | YES |  | NULL |  |
| eliminada_por | int | YES |  | NULL |  |
| mala_resolucion | tinyint | YES |  | 0 |  |
| reason_refuse | int | YES |  | NULL |  |
| motivo_rechazo | text | YES |  | NULL |  |
| lang_detected | varchar(3) | YES |  | NULL |  |
| submitted | tinyint | NO |  | NULL |  |
| notaInterna | text | YES |  | NULL |  |
| pending_provider_answer | tinyint | NO |  | 0 |  |
| boost | int | YES | MUL | NULL |  |
| utility | int | NO | MUL | 0 |  |
| opinion_visited | tinyint(1) | YES |  | 0 |  |
| nps_sent | tinyint(1) | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id_traslado | Sí |
| idx_texto_descriptivo | BTREE | id_traslado, pending_provider_answer | No |
| idx_traslados_opiniones | BTREE | pais, id_ciudad, aprobada | No |
| idx_traslados_opiniones_2 | BTREE | id_ciudad, aprobada | No |
| idx_traslados_opiniones_boost | BTREE | boost | No |
| idx_traslados_opiniones_utility | BTREE | utility | No |

#### DDL

```sql
CREATE TABLE `traslados_opiniones` (
  `id_traslado` int NOT NULL,
  `id_ciudad` int NOT NULL,
  `nombre` varchar(32) NOT NULL,
  `puntualidad` int NOT NULL,
  `vehiculo` int NOT NULL,
  `conductor` int NOT NULL,
  `puntuacion` int NOT NULL,
  `recomienda` tinyint NOT NULL,
  `texto` text NOT NULL,
  `respuesta` text NOT NULL,
  `preguntaProveedor` text,
  `fecha_pregunta` datetime DEFAULT NULL,
  `ticket_automatico` tinyint DEFAULT NULL,
  `comentarios_proveedor` text NOT NULL,
  `fecha` date NOT NULL,
  `fecha_insercion` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `fecha_aprobada` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `fechaEliminada` timestamp NULL DEFAULT NULL,
  `fechaMalaResolucion` timestamp NULL DEFAULT NULL,
  `fecha_respuesta_proveedor` timestamp NULL DEFAULT NULL,
  `idioma` varchar(2) DEFAULT 'es',
  `aprobada` tinyint NOT NULL,
  `tipoViajero` varchar(8) DEFAULT NULL,
  `pais` varchar(2) DEFAULT 'es',
  `ciudad` varchar(32) DEFAULT NULL,
  `id_ticket` int DEFAULT NULL,
  `aprobada_por` int DEFAULT NULL,
  `eliminada_por` int DEFAULT NULL,
  `mala_resolucion` tinyint DEFAULT '0',
  `reason_refuse` int DEFAULT NULL,
  `motivo_rechazo` text,
  `lang_detected` varchar(3) DEFAULT NULL,
  `submitted` tinyint NOT NULL,
  `notaInterna` text COMMENT 'opinion en la moderación',
  `pending_provider_answer` tinyint NOT NULL DEFAULT '0',
  `boost` int DEFAULT NULL,
  `utility` int NOT NULL DEFAULT '0' COMMENT 'Cantidad de votos acumulados',
  `opinion_visited` tinyint(1) DEFAULT '0',
  `nps_sent` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_traslado`),
  KEY `idx_traslados_opiniones` (`pais`,`id_ciudad`,`aprobada`),
  KEY `idx_traslados_opiniones_2` (`id_ciudad`,`aprobada`),
  KEY `idx_texto_descriptivo` (`id_traslado`,`pending_provider_answer`),
  KEY `idx_traslados_opiniones_boost` (`boost`),
  KEY `idx_traslados_opiniones_utility` (`utility`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Cantidad de votos acumulados'
```

### `traslados_reservas`

**Usado por:**
- `new-admin`: (`app/Models/TransferBooking.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_ciudad | int | NO |  | NULL |  |
| id_zona_a | int | NO |  | NULL |  |
| id_zona_b | int | NO |  | NULL |  |
| id_vehiculo | int | NO |  | NULL |  |
| id_proveedor | int | NO | MUL | NULL |  |
| numero_personas | int | NO |  | NULL |  |
| datos_origen_a | varchar(64) | NO |  | NULL |  |
| datos_origen_b | varchar(256) | NO |  | NULL |  |
| datos_destino_a | varchar(64) | NO |  | NULL |  |
| datos_destino_b | varchar(256) | NO |  | NULL |  |
| trayecto_texto | varchar(128) | NO |  | NULL |  |
| precio | float | NO |  | NULL |  |
| precioEuros | float | NO |  | NULL |  |
| anticipo | float | NO |  | NULL |  |
| anticipoEuros | float | NO |  | NULL |  |
| ganancia | float | NO |  | NULL |  |
| gananciaEuros | float | NO |  | NULL |  |
| comision | float | NO |  | NULL |  |
| divisa | char(3) | NO |  | NULL |  |
| nombre | varchar(64) | NO |  | NULL |  |
| apellidos | varchar(128) | NO |  | NULL |  |
| email | varchar(128) | NO | MUL | NULL |  |
| pais | char(4) | NO |  | NULL |  |
| telefono | varchar(32) | NO | MUL | NULL |  |
| pais_procedencia | int | YES | MUL | NULL |  |
| comentarios | text | NO |  | NULL |  |
| equipaje_facturado | tinyint | NO |  | 0 |  |
| descuento_compartir | tinyint | NO |  | NULL |  |
| fecha | datetime | NO | MUL | NULL |  |
| fecha_reserva | timestamp | NO | MUL | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| fecha_modificacion | timestamp | NO |  | 0000-00-00 00:00:00 |  |
| origen | tinyint | NO |  | NULL |  |
| ip | varchar(32) | NO |  | NULL |  |
| ipv6 | varchar(50) | YES |  | NULL |  |
| id_recibo | varchar(32) | NO |  | NULL |  |
| num_transaccion | varchar(20) | NO |  | NULL |  |
| num_factura | int | NO |  | NULL |  |
| pin | int | NO |  | NULL |  |
| estado | tinyint | NO |  | 0 |  |
| recordatorio | timestamp | YES |  | NULL |  |
| id_antiguo | int | NO |  | NULL |  |
| trayectos | int | NO |  | NULL |  |
| fp | varchar(16) | YES |  | NULL |  |
| booking_attempts | tinyint | YES |  | 0 |  |
| dispositivo | tinyint | YES |  | NULL |  |
| fechaPago | date | YES |  | NULL |  |
| fechaPagoAfiliado | date | YES |  | NULL |  |
| fechaPagoAgencia | date | YES |  | NULL |  |
| divisaPago | varchar(3) | NO |  | NULL |  |
| importePago | decimal(38,2) | YES |  | NULL |  |
| userAgent | text | YES |  | NULL |  |
| id_afiliado | int | YES | MUL | NULL |  |
| url_referencia | text | YES |  | NULL |  |
| comision_afiliado | tinyint | YES |  | NULL |  |
| campana_afiliado | varchar(32) | YES |  | NULL |  |
| xrt_payment_currency | float | YES |  | NULL |  |
| xrt_eur | float | YES |  | NULL |  |
| agent | varchar(16) | YES |  | web |  |
| lang_site | varchar(2) | YES |  | es |  |
| fechaRevision | timestamp | YES |  | NULL |  |
| motivo_cancelacion | int | YES |  | NULL |  |
| facturaPago | varchar(50) | YES |  | NULL |  |
| affiliated_intern_campaign | varchar(85) | YES |  | NULL |  |
| amount_supplement | int | YES |  | 0 |  |
| supplement_date | int | YES |  | 0 |  |
| base_commission | tinyint | YES |  | NULL |  |
| type | varchar(1) | YES |  | 1 |  |
| initial_affiliate_commission_amount | float | YES |  | NULL |  |
| affiliate_commission_amount | float | YES |  | 0 |  |
| initial_agency_commission_amount | decimal(38,2) | YES |  | NULL |  |
| agency_commission_amount | decimal(38,2) | YES |  | NULL |  |
| driver_name | varchar(128) | YES |  | NULL |  |
| driver_phone | varchar(128) | YES |  | NULL |  |
| channel_id | int | YES |  | NULL |  |
| week_reminder | tinyint | YES |  | 0 |  |
| precioInicialEuros | float | YES |  | NULL |  |
| gananciaInicialEuros | float | YES |  | NULL |  |
| driver_license | tinytext | YES |  | NULL |  |
| driver_vehicle_model | tinytext | YES |  | NULL |  |
| driver_car_plate | tinytext | YES |  | NULL |  |
| driver_langs | tinytext | YES |  | NULL |  |
| nifCustomer | varchar(32) | YES |  | NULL |  |
| fechaAnticipo | date | YES |  | NULL |  |
| provider_destination_info | text | YES |  | NULL |  |
| revisionFacturacion | date | YES |  | NULL |  |
| cancel_policy | int | YES |  | NULL |  |
| fechaRevisionAfiliado | timestamp | YES |  | NULL |  |
| hora_recogida | time | YES |  | NULL |  |
| affiliate_timestamp_cookie | timestamp | YES |  | NULL |  |
| fechaCobroAgencia | date | YES |  | NULL |  |
| facturaCobroAgenciaV2 | varchar(256) | YES |  | NULL |  |
| fecha_cobrado_agencia_credito | date | YES |  | NULL |  |
| facturaCobroAgencia | date | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_traslados_reservas_pais_id | BTREE | pais_procedencia | No |
| idx_afiliados_stats_traslados | BTREE | id_afiliado, estado, fecha_reserva | No |
| idx_idproveedor_traslados_estado_fecha_precios | BTREE | id_proveedor, estado, fecha, precio, ganancia | No |
| idx_traslados_reservas_admin | BTREE | fecha_reserva, estado | No |
| idx_traslados_reservas_email | BTREE | email | No |
| idx_traslados_reservas_fecha_estado | BTREE | fecha, estado | No |
| idx_traslados_reservas_telefono | BTREE | telefono | No |

#### DDL

```sql
CREATE TABLE `traslados_reservas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_ciudad` int NOT NULL,
  `id_zona_a` int NOT NULL,
  `id_zona_b` int NOT NULL,
  `id_vehiculo` int NOT NULL,
  `id_proveedor` int NOT NULL,
  `numero_personas` int NOT NULL,
  `datos_origen_a` varchar(64) NOT NULL,
  `datos_origen_b` varchar(256) NOT NULL,
  `datos_destino_a` varchar(64) NOT NULL,
  `datos_destino_b` varchar(256) NOT NULL,
  `trayecto_texto` varchar(128) NOT NULL,
  `precio` float NOT NULL,
  `precioEuros` float NOT NULL,
  `anticipo` float NOT NULL,
  `anticipoEuros` float NOT NULL,
  `ganancia` float NOT NULL,
  `gananciaEuros` float NOT NULL,
  `comision` float NOT NULL,
  `divisa` char(3) NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `pais` char(4) NOT NULL,
  `telefono` varchar(32) NOT NULL,
  `pais_procedencia` int DEFAULT NULL,
  `comentarios` text NOT NULL,
  `equipaje_facturado` tinyint NOT NULL DEFAULT '0',
  `descuento_compartir` tinyint NOT NULL,
  `fecha` datetime NOT NULL,
  `fecha_reserva` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `origen` tinyint NOT NULL,
  `ip` varchar(32) NOT NULL,
  `ipv6` varchar(50) DEFAULT NULL COMMENT 'Ip buena. El campo IP de esta tabla se queda corto para IPV6',
  `id_recibo` varchar(32) NOT NULL,
  `num_transaccion` varchar(20) NOT NULL,
  `num_factura` int NOT NULL,
  `pin` int NOT NULL,
  `estado` tinyint NOT NULL DEFAULT '0' COMMENT '0 Reservado 1 Pagado 2 Confirmado 3 Opinión solicitada 4 Opinado 5 No show 6 Cancelado 7 Cancelado y reintegrado',
  `recordatorio` timestamp NULL DEFAULT NULL,
  `id_antiguo` int NOT NULL,
  `trayectos` int NOT NULL,
  `fp` varchar(16) DEFAULT NULL,
  `booking_attempts` tinyint DEFAULT '0',
  `dispositivo` tinyint DEFAULT NULL,
  `fechaPago` date DEFAULT NULL,
  `fechaPagoAfiliado` date DEFAULT NULL,
  `fechaPagoAgencia` date DEFAULT NULL,
  `divisaPago` varchar(3) NOT NULL,
  `importePago` decimal(38,2) DEFAULT NULL,
  `userAgent` text,
  `id_afiliado` int DEFAULT NULL,
  `url_referencia` text,
  `comision_afiliado` tinyint DEFAULT NULL,
  `campana_afiliado` varchar(32) DEFAULT NULL,
  `xrt_payment_currency` float DEFAULT NULL COMMENT 'Stores the effective exchange rate from contract currency to selected payment currency',
  `xrt_eur` float DEFAULT NULL COMMENT 'Stores the effective exchange rate from contract currency to euro',
  `agent` varchar(16) DEFAULT 'web',
  `lang_site` varchar(2) DEFAULT 'es',
  `fechaRevision` timestamp NULL DEFAULT NULL,
  `motivo_cancelacion` int DEFAULT NULL,
  `facturaPago` varchar(50) DEFAULT NULL,
  `affiliated_intern_campaign` varchar(85) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `amount_supplement` int DEFAULT '0',
  `supplement_date` int DEFAULT '0',
  `base_commission` tinyint DEFAULT NULL,
  `type` varchar(1) DEFAULT '1' COMMENT '1->privado (normal), 2 -> compartido',
  `initial_affiliate_commission_amount` float DEFAULT NULL,
  `affiliate_commission_amount` float DEFAULT '0',
  `initial_agency_commission_amount` decimal(38,2) DEFAULT NULL,
  `agency_commission_amount` decimal(38,2) DEFAULT NULL,
  `driver_name` varchar(128) DEFAULT NULL,
  `driver_phone` varchar(128) DEFAULT NULL,
  `channel_id` int DEFAULT NULL,
  `week_reminder` tinyint DEFAULT '0',
  `precioInicialEuros` float DEFAULT NULL,
  `gananciaInicialEuros` float DEFAULT NULL,
  `driver_license` tinytext,
  `driver_vehicle_model` tinytext,
  `driver_car_plate` tinytext,
  `driver_langs` tinytext,
  `nifCustomer` varchar(32) DEFAULT NULL,
  `fechaAnticipo` date DEFAULT NULL,
  `provider_destination_info` text COMMENT 'Info proveedor destino momento reserva',
  `revisionFacturacion` date DEFAULT NULL,
  `cancel_policy` int DEFAULT NULL,
  `fechaRevisionAfiliado` timestamp NULL DEFAULT NULL,
  `hora_recogida` time DEFAULT NULL,
  `affiliate_timestamp_cookie` timestamp NULL DEFAULT NULL,
  `fechaCobroAgencia` date DEFAULT NULL,
  `facturaCobroAgenciaV2` varchar(256) DEFAULT NULL,
  `fecha_cobrado_agencia_credito` date DEFAULT NULL,
  `facturaCobroAgencia` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_traslados_reservas_fecha_estado` (`fecha`,`estado`),
  KEY `idx_afiliados_stats_traslados` (`id_afiliado`,`estado`,`fecha_reserva`),
  KEY `idx_traslados_reservas_email` (`email`),
  KEY `idx_traslados_reservas_admin` (`fecha_reserva`,`estado`),
  KEY `fk_traslados_reservas_pais_id` (`pais_procedencia`),
  KEY `idx_idproveedor_traslados_estado_fecha_precios` (`id_proveedor`,`estado`,`fecha`,`precio`,`ganancia`) USING BTREE,
  KEY `idx_traslados_reservas_telefono` (`telefono`)
) ENGINE=InnoDB AUTO_INCREMENT=2702327 DEFAULT CHARSET=utf8mb3
```

### `traslados_reservas_sillitas_bebe`

**Usado por:**
- `new-admin`: (`app/Models/TransferBookingChildSeat.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| booking_id | int | YES | MUL | NULL |  |
| baby_seat_number | int | YES |  | NULL |  |
| baby_seat_age | int | YES |  | NULL |  |
| baby_seat_weight | int | YES |  | NULL |  |
| baby_seat_amount | int | YES |  | NULL |  |
| baby_seat_currency | varchar(4) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| traslados_reservas_sillitas_bebe_booking_id | BTREE | booking_id | No |

#### DDL

```sql
CREATE TABLE `traslados_reservas_sillitas_bebe` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `baby_seat_number` int DEFAULT NULL,
  `baby_seat_age` int DEFAULT NULL,
  `baby_seat_weight` int DEFAULT NULL,
  `baby_seat_amount` int DEFAULT NULL,
  `baby_seat_currency` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `traslados_reservas_sillitas_bebe_booking_id` (`booking_id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3
```

### `traslados_suplementos`

**Usado por:**
- `new-admin`: (`app/Models/TransferSupplement.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_tarifa | int | NO |  | NULL |  |
| id_proveedor | int | NO |  | NULL |  |
| id_destino | int | YES |  | NULL |  |
| nombre | varchar(64) | NO |  | NULL |  |
| inicio | varchar(16) | NO |  | NULL |  |
| fin | varchar(16) | NO |  | NULL |  |
| suplemento | float | NO |  | NULL |  |
| anticipo | float | NO |  | NULL |  |
| amount_percent | varchar(8) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `traslados_suplementos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tarifa` int NOT NULL,
  `id_proveedor` int NOT NULL,
  `id_destino` int DEFAULT NULL COMMENT 'Id destino sobre el que aplica. Si es null aplica a todos',
  `nombre` varchar(64) NOT NULL,
  `inicio` varchar(16) NOT NULL,
  `fin` varchar(16) NOT NULL,
  `suplemento` float NOT NULL,
  `anticipo` float NOT NULL,
  `amount_percent` varchar(8) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1091 DEFAULT CHARSET=utf8mb3
```

### `traslados_suplementos_changelog`

**Usado por:**
- `new-admin`: (`app/Models/TransferSupplementChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| transfer_supplement_id | int | YES |  | NULL |  |
| field | varchar(32) | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `traslados_suplementos_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transfer_supplement_id` int DEFAULT NULL,
  `field` varchar(32) DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `traslados_tarifas`

**Usado por:**
- `new-admin`: (`app/Models/TransferFee.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_zona_a | int | NO | MUL | NULL |  |
| id_zona_b | int | NO | MUL | NULL |  |
| id_vehiculo | int | NO |  | NULL |  |
| id_proveedor | int | NO |  | NULL |  |
| neto | float | YES |  | NULL |  |
| comision | float | YES |  | NULL |  |
| beneficio | float | NO |  | 0 |  |
| tipo_comision | int | NO |  | 0 |  |
| auto | tinyint | NO |  | 0 |  |
| divisa | char(3) | NO |  | NULL |  |
| suplementos | text | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_tt_zona_a | BTREE | id_zona_a, id_vehiculo, id_proveedor | No |
| idx_tt_zona_b | BTREE | id_zona_b, id_vehiculo, id_proveedor | No |

#### DDL

```sql
CREATE TABLE `traslados_tarifas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_zona_a` int NOT NULL,
  `id_zona_b` int NOT NULL,
  `id_vehiculo` int NOT NULL,
  `id_proveedor` int NOT NULL,
  `neto` float DEFAULT NULL,
  `comision` float DEFAULT NULL,
  `beneficio` float NOT NULL DEFAULT '0',
  `tipo_comision` int NOT NULL DEFAULT '0' COMMENT 'switch => 0:neto, 1:beneficio',
  `auto` tinyint NOT NULL DEFAULT '0',
  `divisa` char(3) NOT NULL,
  `suplementos` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tt_zona_a` (`id_zona_a`,`id_vehiculo`,`id_proveedor`),
  KEY `idx_tt_zona_b` (`id_zona_b`,`id_vehiculo`,`id_proveedor`)
) ENGINE=InnoDB AUTO_INCREMENT=9628 DEFAULT CHARSET=utf8mb3
```

### `traslados_vehiculos`

**Usado por:**
- `new-admin`: (`app/Models/TransferVehicle.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | smallint | NO | PRI | NULL | auto_increment |
| id_ciudad | smallint | NO |  | NULL |  |
| nombre | varchar(64) | NO |  | NULL |  |
| vehicle_type | int | NO |  | 0 |  |
| meet_and_greet | tinyint(1) | NO |  | 1 |  |
| plazas | int | NO |  | NULL |  |
| maletas_grandes | tinyint | NO |  | NULL |  |
| maletas_mano | tinyint | NO |  | NULL |  |
| tipo | tinyint | NO |  | NULL |  |
| adapted | tinyint | NO |  | 0 |  |
| quality | tinyint | NO |  | 1 |  |
| imagen | varchar(256) | NO |  | NULL |  |
| label | varchar(128) | NO |  | NULL |  |
| estado | int | NO | MUL | 1 |  |
| hour_from | varchar(64) | YES |  | NULL |  |
| hour_to | varchar(64) | YES |  | NULL |  |
| advance | int | YES |  | NULL |  |
| cancellation | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_tv_estado | BTREE | estado, id | No |

#### DDL

```sql
CREATE TABLE `traslados_vehiculos` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `id_ciudad` smallint NOT NULL,
  `nombre` varchar(64) NOT NULL,
  `vehicle_type` int NOT NULL DEFAULT '0' COMMENT '0- Combustion, 1- Eléctrico, 2- Híbrido',
  `meet_and_greet` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Boolean 0-No 1-Sí',
  `plazas` int NOT NULL,
  `maletas_grandes` tinyint NOT NULL,
  `maletas_mano` tinyint NOT NULL,
  `tipo` tinyint NOT NULL,
  `adapted` tinyint NOT NULL DEFAULT '0' COMMENT '0-No, 1-Yes',
  `quality` tinyint NOT NULL DEFAULT '1' COMMENT '1-standard, 2-premium',
  `imagen` varchar(256) NOT NULL,
  `label` varchar(128) NOT NULL,
  `estado` int NOT NULL DEFAULT '1' COMMENT '1 - Si 0 - No',
  `hour_from` varchar(64) DEFAULT NULL,
  `hour_to` varchar(64) DEFAULT NULL,
  `advance` int DEFAULT NULL,
  `cancellation` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tv_estado` (`estado`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2655 DEFAULT CHARSET=utf8mb3 COMMENT='1-standard, 2-premium'
```

### `traslados_zonas`

**Usado por:**
- `new-admin`: (`app/Models/TransferZone.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_ciudad | int | NO | MUL | NULL |  |
| nombre | varchar(128) | NO |  | NULL |  |
| tipo | tinyint | NO |  | NULL |  |
| iata | char(3) | NO |  | NULL |  |
| descripcion | text | NO |  | NULL |  |
| informacion_adicional | text | NO |  | NULL |  |
| importancia | tinyint | NO |  | NULL |  |
| label | varchar(128) | NO |  | NULL |  |
| status | int | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_tz_ciudad_status | BTREE | id_ciudad, status, id | No |

#### DDL

```sql
CREATE TABLE `traslados_zonas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_ciudad` int NOT NULL,
  `nombre` varchar(128) NOT NULL,
  `tipo` tinyint NOT NULL COMMENT '1 Aeropuerto 2 Puerto 3 Tren 5 Zona 9 Ciudad',
  `iata` char(3) NOT NULL,
  `descripcion` text NOT NULL,
  `informacion_adicional` text NOT NULL,
  `importancia` tinyint NOT NULL,
  `label` varchar(128) NOT NULL,
  `status` int NOT NULL DEFAULT '1' COMMENT '1 Activo 0 Inactivo',
  PRIMARY KEY (`id`),
  KEY `idx_tz_ciudad_status` (`id_ciudad`,`status`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3004 DEFAULT CHARSET=utf8mb3
```

### `traslados_zonas_changelog`

**Usado por:**
- `new-admin`: (`app/Models/TransferZoneChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| transfer_zone_id | int | YES |  | NULL |  |
| field | varchar(32) | YES |  | NULL |  |
| user | varchar(16) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `traslados_zonas_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transfer_zone_id` int DEFAULT NULL,
  `field` varchar(32) DEFAULT NULL,
  `user` varchar(16) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `traslados_zonas_info_provider`

**Usado por:**
- `new-admin`: (`app/Models/TransferZoneInfoProvider.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| provider_id | int | NO |  | NULL |  |
| zone_id | int | NO |  | NULL |  |
| label | varchar(512) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `traslados_zonas_info_provider` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int NOT NULL,
  `zone_id` int NOT NULL,
  `label` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb3
```

### `type_accesibility_activities`

**Usado por:**
- `new-admin`: (`app/Models/AccessibilityType.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(256) | NO |  | NULL |  |
| label | varchar(256) | NO |  | NULL |  |
| public_label | varchar(256) | YES |  | NULL |  |
| sort | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `type_accesibility_activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `label` varchar(256) NOT NULL,
  `public_label` varchar(256) DEFAULT NULL COMMENT 'Label usada para la descripción en web',
  `sort` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3
```

### `type_accesibility_activities_answers`

**Usado por:**
- `new-admin`: (`app/Models/AccessibilityTypeAnswer.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| question_id | int | NO |  | NULL |  |
| name | varchar(256) | NO |  | NULL |  |
| label | varchar(256) | NO |  | NULL |  |
| public_label | varchar(256) | YES |  | NULL |  |
| sort | int | NO |  | NULL |  |
| show_in_web | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `type_accesibility_activities_answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_id` int NOT NULL,
  `name` varchar(256) NOT NULL,
  `label` varchar(256) NOT NULL,
  `public_label` varchar(256) DEFAULT NULL COMMENT 'Label usada para la descripción en web',
  `sort` int NOT NULL,
  `show_in_web` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3
```

### `type_accesibility_activities_questions`

**Usado por:**
- `new-admin`: (`app/Models/AccessibilityTypeQuestion.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| type_id | int | NO |  | NULL |  |
| name | varchar(256) | NO |  | NULL |  |
| label | varchar(256) | NO |  | NULL |  |
| public_label | varchar(256) | YES |  | NULL |  |
| sort | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `type_accesibility_activities_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type_id` int NOT NULL,
  `name` varchar(256) NOT NULL,
  `label` varchar(256) NOT NULL,
  `public_label` varchar(256) DEFAULT NULL COMMENT 'Label usada para la descripción en web',
  `sort` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3
```

### `type_accesibility_activities_sub_answers`

**Usado por:**
- `new-admin`: (`app/Models/AccessibilityTypeSubAnswer.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| sub_question_id | int | NO |  | NULL |  |
| name | varchar(256) | NO |  | NULL |  |
| label | varchar(256) | NO |  | NULL |  |
| public_label | varchar(256) | YES |  | NULL |  |
| sort | int | NO |  | NULL |  |
| show_in_web | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `type_accesibility_activities_sub_answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sub_question_id` int NOT NULL,
  `name` varchar(256) NOT NULL,
  `label` varchar(256) NOT NULL,
  `public_label` varchar(256) DEFAULT NULL COMMENT 'Label usada para la descripción en web',
  `sort` int NOT NULL,
  `show_in_web` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3
```

### `type_accesibility_activities_sub_question`

**Usado por:**
- `new-admin`: (`app/Models/AccessibilityTypeSubQuestion.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(256) | NO |  | NULL |  |
| label | varchar(256) | NO |  | NULL |  |
| public_label | varchar(256) | YES |  | NULL |  |
| sort | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `type_accesibility_activities_sub_question` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `label` varchar(256) NOT NULL,
  `public_label` varchar(256) DEFAULT NULL COMMENT 'Label usada para la descripción en web',
  `sort` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3
```

### `type_accesibility_activity_info`

**Usado por:**
- `new-admin`: (`app/Models/AccessibilityActivityInfo.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| activity_id | int | NO | MUL | NULL |  |
| question_id | int | NO |  | NULL |  |
| answer_id | int | NO |  | NULL |  |
| sub_question_id | int | YES |  | NULL |  |
| sub_answer_id | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_accesibility_activity_info_id | BTREE | activity_id | No |

#### DDL

```sql
CREATE TABLE `type_accesibility_activity_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_id` int NOT NULL,
  `question_id` int NOT NULL,
  `answer_id` int NOT NULL,
  `sub_question_id` int DEFAULT NULL,
  `sub_answer_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_accesibility_activity_info_id` (`activity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3
```

### `type_agent`

**Usado por:**
- `new-admin`: (`app/Models/TypeAgent.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL |  |
| name | varchar(128) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `type_agent` (
  `id` int NOT NULL,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `type_origin`

**Usado por:**
- `new-admin`: (`app/Models/TypeOrigin.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL |  |
| name | varchar(128) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `type_origin` (
  `id` int NOT NULL,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `type_sustainability_activities`

**Usado por:**
- `new-admin`: (`app/Models/SustainabilityType.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(256) | NO |  | NULL |  |
| label | varchar(256) | NO |  | NULL |  |
| public_label | varchar(256) | YES |  | NULL |  |
| sort | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `type_sustainability_activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `label` varchar(256) NOT NULL,
  `public_label` varchar(256) DEFAULT NULL COMMENT 'Label usada para la descripción en web',
  `sort` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3
```

### `type_sustainability_activities_answers`

**Usado por:**
- `new-admin`: (`app/Models/SustainabilityTypeAnswer.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| question_id | int | NO |  | NULL |  |
| name | varchar(256) | NO |  | NULL |  |
| label | varchar(256) | NO |  | NULL |  |
| public_label | varchar(256) | YES |  | NULL |  |
| sort | int | NO |  | NULL |  |
| show_in_web | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `type_sustainability_activities_answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_id` int NOT NULL,
  `name` varchar(256) NOT NULL,
  `label` varchar(256) NOT NULL,
  `public_label` varchar(256) DEFAULT NULL COMMENT 'Label usada para la descripción en web',
  `sort` int NOT NULL,
  `show_in_web` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb3
```

### `type_sustainability_activities_questions`

**Usado por:**
- `new-admin`: (`app/Models/SustainabilityTypeQuestion.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| type_id | int | NO |  | NULL |  |
| name | varchar(256) | NO |  | NULL |  |
| label | varchar(256) | NO |  | NULL |  |
| public_label | varchar(256) | YES |  | NULL |  |
| sort | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `type_sustainability_activities_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type_id` int NOT NULL,
  `name` varchar(256) NOT NULL,
  `label` varchar(256) NOT NULL,
  `public_label` varchar(256) DEFAULT NULL COMMENT 'Label usada para la descripción en web',
  `sort` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3
```

### `type_sustainability_activity_info`

**Usado por:**
- `new-admin`: (`app/Models/SustainabilityActivityInfo.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| provider_id | int | NO |  | NULL |  |
| activity_id | int | NO | MUL | NULL |  |
| question_id | int | NO |  | NULL |  |
| answer_id | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_sustainability_activity_info_id | BTREE | activity_id | No |

#### DDL

```sql
CREATE TABLE `type_sustainability_activity_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int NOT NULL,
  `activity_id` int NOT NULL COMMENT '0 = generico para el proveedor, solo valido para tipo 1',
  `question_id` int NOT NULL,
  `answer_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sustainability_activity_info_id` (`activity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=668964 DEFAULT CHARSET=utf8mb3
```

### `uf_user`

**Usado por:**
- `new-admin`: (`app/Models/Client.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(50) | NO |  | NULL |  |
| surname | varchar(50) | NO |  | NULL |  |
| password | varchar(255) | NO |  | NULL |  |
| email | varchar(150) | NO | MUL | NULL |  |
| prefix | int | NO |  | NULL |  |
| phone | varchar(32) | NO |  | NULL |  |
| city | varchar(32) | NO |  | NULL |  |
| country | varchar(2) | NO |  | NULL |  |
| birth_date | date | YES |  | NULL |  |
| instagram | varchar(50) | YES |  | NULL |  |
| newsletter | tinyint | YES |  | NULL |  |
| activation_token | varchar(255) | NO | MUL | NULL |  |
| last_activation_request | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| deactivation_token | varchar(50) | YES | MUL | NULL |  |
| last_deactivation_request | timestamp | YES |  | NULL |  |
| lost_password_request | tinyint | NO |  | 0 |  |
| lost_password_timestamp | timestamp | YES |  | NULL |  |
| active | tinyint | NO |  | 1 |  |
| title | varchar(150) | NO |  | NULL |  |
| sign_up_stamp | timestamp | NO |  | 0000-00-00 00:00:00 |  |
| last_sign_in_stamp | timestamp | YES |  | NULL |  |
| enabled | tinyint | NO |  | 1 |  |
| primary_group_id | tinyint | NO |  | 1 |  |
| locale | varchar(10) | NO |  | es_ES |  |
| source | varchar(64) | YES |  | NULL |  |
| ip | varchar(32) | YES |  | NULL |  |
| mobile_token | varchar(255) | NO | MUL | NULL |  |
| fiscalDataType | int | YES |  | NULL |  |
| fiscalName | varchar(100) | YES |  | NULL |  |
| fiscalIdType | varchar(3) | YES |  | NULL |  |
| fiscalIdentification | varchar(50) | YES |  | NULL |  |
| fiscalAddress | text | YES |  | NULL |  |
| fiscalCity | varchar(100) | YES |  | NULL |  |
| fiscalCp | varchar(10) | YES |  | NULL |  |
| fiscalCountry | varchar(2) | YES |  | NULL |  |
| yearFirstBuy | int | YES |  | NULL |  |
| monthFirstBuy | int | YES |  | NULL |  |
| appleToken | varchar(128) | YES |  | NULL |  |
| trustPilotLastMail | timestamp | YES |  | NULL |  |
| gender | tinyint(1) | YES |  | NULL |  |
| preferred_language | varchar(2) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_uf_user_activation_token | BTREE | activation_token | No |
| idx_uf_user_deactivation_token | BTREE | deactivation_token | No |
| idx_uf_user_email | BTREE | email | No |
| idx_uf_user_mobile_token | BTREE | mobile_token | No |

#### DDL

```sql
CREATE TABLE `uf_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(150) NOT NULL,
  `prefix` int NOT NULL COMMENT 'References the ''paises'' table',
  `phone` varchar(32) NOT NULL,
  `city` varchar(32) NOT NULL,
  `country` varchar(2) NOT NULL COMMENT 'References the ''paises'' table',
  `birth_date` date DEFAULT NULL,
  `instagram` varchar(50) DEFAULT NULL,
  `newsletter` tinyint DEFAULT NULL COMMENT '0 - Subscribed = Nunca me he suscrito; 1 - opt-in = Estoy suscrito; 2 - Unsubscribed = Me he dado de baja desde mail o desde panel cliente',
  `activation_token` varchar(255) NOT NULL,
  `last_activation_request` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deactivation_token` varchar(50) DEFAULT NULL,
  `last_deactivation_request` timestamp NULL DEFAULT NULL,
  `lost_password_request` tinyint NOT NULL DEFAULT '0',
  `lost_password_timestamp` timestamp NULL DEFAULT NULL,
  `active` tinyint NOT NULL DEFAULT '1',
  `title` varchar(150) NOT NULL,
  `sign_up_stamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_sign_in_stamp` timestamp NULL DEFAULT NULL,
  `enabled` tinyint NOT NULL DEFAULT '1' COMMENT 'Specifies if the account is enabled.  Disabled accounts cannot be logged in to, but they retain all of their data and settings.',
  `primary_group_id` tinyint NOT NULL DEFAULT '1' COMMENT 'Specifies the primary group for the user.',
  `locale` varchar(10) NOT NULL DEFAULT 'es_ES' COMMENT 'The language and locale to use for this user.',
  `source` varchar(64) DEFAULT NULL COMMENT 'The source we got this email from',
  `ip` varchar(32) DEFAULT NULL,
  `mobile_token` varchar(255) NOT NULL,
  `fiscalDataType` int DEFAULT NULL COMMENT '1.- Particular 2.- Empresa',
  `fiscalName` varchar(100) DEFAULT NULL,
  `fiscalIdType` varchar(3) DEFAULT NULL,
  `fiscalIdentification` varchar(50) DEFAULT NULL,
  `fiscalAddress` text,
  `fiscalCity` varchar(100) DEFAULT NULL,
  `fiscalCp` varchar(10) DEFAULT NULL,
  `fiscalCountry` varchar(2) DEFAULT NULL,
  `yearFirstBuy` int DEFAULT NULL,
  `monthFirstBuy` int DEFAULT NULL,
  `appleToken` varchar(128) DEFAULT NULL,
  `trustPilotLastMail` timestamp NULL DEFAULT NULL,
  `gender` tinyint(1) DEFAULT NULL COMMENT '1 - hombre 2 - mujer 3 - otro',
  `preferred_language` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_uf_user_email` (`email`),
  KEY `idx_uf_user_activation_token` (`activation_token`),
  KEY `idx_uf_user_mobile_token` (`mobile_token`),
  KEY `idx_uf_user_deactivation_token` (`deactivation_token`)
) ENGINE=InnoDB AUTO_INCREMENT=8344004 DEFAULT CHARSET=utf8mb3 COMMENT='1 - hombre 2 - mujer 3 - otro'
```

### `user_role`

**Usado por:**
- `new-admin`: (`app/Models/AdminUserRole.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| user_id | int | NO | PRI | NULL |  |
| role_id | int | NO | PRI | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | user_id, role_id | Sí |
| fk_user_role_with_role_id | BTREE | role_id | No |

#### DDL

```sql
CREATE TABLE `user_role` (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_user_role_with_role_id` (`role_id`),
  CONSTRAINT `fk_user_role_with_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_role_with_user_id` FOREIGN KEY (`user_id`) REFERENCES `admin_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `users`

**Usado por:**
- `new-admin`: (`app/Models/UserTable.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(100) | YES |  | NULL |  |
| surname | varchar(100) | YES |  | NULL |  |
| country | varchar(3) | YES |  | NULL |  |
| source | varchar(256) | YES |  | NULL |  |
| email | varchar(100) | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| user_type | int | NO |  | NULL |  |
| related_id | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `surname` varchar(100) DEFAULT NULL,
  `country` varchar(3) DEFAULT NULL,
  `source` varchar(256) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `lang` varchar(2) NOT NULL,
  `user_type` int NOT NULL COMMENT 'Relaciona con la tabla user_type.',
  `related_id` int DEFAULT NULL COMMENT 'Relaciona con el ID de la tabla correspondiente.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `users_contests`

**Usado por:**
- `new-admin`: (`app/Models/UserContest.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(100) | YES |  | NULL |  |
| surname | varchar(100) | YES |  | NULL |  |
| country | varchar(3) | YES |  | NULL |  |
| contest_id | int | YES |  | NULL |  |
| email | varchar(100) | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| user_type | int | NO |  | NULL |  |
| how_meet_us | tinyint | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `users_contests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `surname` varchar(100) DEFAULT NULL,
  `country` varchar(3) DEFAULT NULL,
  `contest_id` int DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `lang` varchar(2) NOT NULL,
  `user_type` int NOT NULL COMMENT 'Relaciona con la tabla user_type.',
  `how_meet_us` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3
```

### `users_reviews_useful`

**Usado por:**
- `new-admin`: (`app/Models/UsersReviewsUseful.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| user_id | int | NO | MUL | NULL |  |
| product_id | int | NO | MUL | NULL |  |
| product_type | tinyint(1) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_users_reviews_useful_user_id_uf_user | BTREE | user_id | No |
| idx_users_reviews_useful_product_id | BTREE | product_id | No |

#### DDL

```sql
CREATE TABLE `users_reviews_useful` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `product_type` tinyint(1) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_users_reviews_useful_user_id_uf_user` (`user_id`),
  KEY `idx_users_reviews_useful_product_id` (`product_id`),
  CONSTRAINT `fk_users_reviews_useful_user_id_uf_user` FOREIGN KEY (`user_id`) REFERENCES `uf_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

### `variables_translations_changelog`

**Usado por:**
- `new-admin`: (`app/Models/VariablesTranslationsChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterVariable | int | NO |  | NULL |  |
| label | varchar(256) | YES |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| tipo | varchar(16) | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `variables_translations_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterVariable` int NOT NULL,
  `label` varchar(256) DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `tipo` varchar(16) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb3 COMMENT='Track the changes made in the variables'
```

### `variables_translations_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/VariablesTranslationsChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCambio | int | NO |  | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| idioma | varchar(2) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `variables_translations_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCambio` int NOT NULL,
  `user` varchar(16) NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb3
```

### `versions_providers_conditions`

**Usado por:**
- `new-admin`: (`app/Models/VersionsProvidersConditions.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| type | int | NO |  | NULL |  |
| version_number | varchar(256) | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| notificated | int | YES |  | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `versions_providers_conditions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` int NOT NULL COMMENT '0 Antiguo Civitatis, 1 Nuevo Civitatis',
  `version_number` varchar(256) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `notificated` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3
```

### `wallet`

**Usado por:**
- `new-admin`: (`app/Models/SimpleWallet.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| key | varchar(25) | NO | UNI | NULL |  |
| client_type | int | NO | MUL | NULL |  |
| client_id | int | NO |  | NULL |  |
| amount | decimal(10,2) | NO |  | NULL |  |
| amount_locked | decimal(10,2) | NO |  | 0.00 |  |
| currency | varchar(3) | NO |  | EUR |  |
| alert | tinyint | NO |  | 0 |  |
| alert_amount | decimal(10,2) | YES |  | NULL |  |
| send_alert | tinyint | NO |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| origin | varchar(10) | YES |  | NULL |  |
| alert_email | varchar(100) | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_wallet_key | BTREE | key | Sí |
| wallet_client_type_IDX | BTREE | client_type, client_id | No |

#### DDL

```sql
CREATE TABLE `wallet` (
  `id` int NOT NULL AUTO_INCREMENT,
  `key` varchar(25) NOT NULL,
  `client_type` int NOT NULL COMMENT '1 - agencia, 2 - usuario ,3 - grupo',
  `client_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `amount_locked` decimal(10,2) NOT NULL DEFAULT '0.00',
  `currency` varchar(3) NOT NULL DEFAULT 'EUR',
  `alert` tinyint NOT NULL DEFAULT '0',
  `alert_amount` decimal(10,2) DEFAULT NULL,
  `send_alert` tinyint NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `origin` varchar(10) DEFAULT NULL COMMENT 'allowed values: web, api, admin.',
  `alert_email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_wallet_key` (`key`),
  KEY `wallet_client_type_IDX` (`client_type`,`client_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5023947 DEFAULT CHARSET=utf8mb3
```

### `wallet_codes`

**Usado por:**
- `new-admin`: (`app/Models/WalletCode.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| code | varchar(255) | NO | UNI | NULL |  |
| amount | float | NO |  | NULL |  |
| currency | char(3) | NO |  | NULL |  |
| author_id | int | NO |  | NULL |  |
| type | int | NO | MUL | 0 |  |
| status | int | NO | MUL | 0 |  |
| created_at | datetime | YES |  | NULL |  |
| expires_at | datetime | YES |  | NULL |  |
| used_at | datetime | YES |  | NULL |  |
| wallet_move_key | varchar(255) | YES | MUL | NULL |  |
| description | text | YES |  | NULL |  |
| cost | text | YES |  | NULL |  |
| promo_id | int | YES | MUL | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| code | BTREE | code | Sí |
| fk_wallet_codes_promo_id | BTREE | promo_id | No |
| fk_wallet_codes_statuses | BTREE | status | No |
| fk_wallet_codes_types | BTREE | type | No |
| wallet_codes_wallet_move_key_IDX | BTREE | wallet_move_key | No |

#### DDL

```sql
CREATE TABLE `wallet_codes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `amount` float NOT NULL,
  `currency` char(3) NOT NULL,
  `author_id` int NOT NULL,
  `type` int NOT NULL DEFAULT '0' COMMENT 'FK wallet_codes_types',
  `status` int NOT NULL DEFAULT '0' COMMENT 'FK wallet_codes_statuses',
  `created_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `used_at` datetime DEFAULT NULL,
  `wallet_move_key` varchar(255) DEFAULT NULL COMMENT 'key field at wallet_moves when code is used',
  `description` text,
  `cost` text,
  `promo_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `fk_wallet_codes_statuses` (`status`),
  KEY `fk_wallet_codes_types` (`type`),
  KEY `wallet_codes_wallet_move_key_IDX` (`wallet_move_key`),
  KEY `fk_wallet_codes_promo_id` (`promo_id`),
  CONSTRAINT `fk_wallet_codes_promo_id` FOREIGN KEY (`promo_id`) REFERENCES `wallet_codes_promos` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_wallet_codes_statuses` FOREIGN KEY (`status`) REFERENCES `wallet_codes_statuses` (`id`),
  CONSTRAINT `fk_wallet_codes_types` FOREIGN KEY (`type`) REFERENCES `wallet_codes_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3
```

### `wallet_codes_logs`

**Usado por:**
- `new-admin`: (`app/Models/WalletCodesLogs.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| code_id | int | NO | MUL | NULL |  |
| description | varchar(255) | NO |  | NULL |  |
| created_at | datetime | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_wallet_codes_logs | BTREE | code_id | No |

#### DDL

```sql
CREATE TABLE `wallet_codes_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code_id` int NOT NULL,
  `description` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_wallet_codes_logs` (`code_id`),
  CONSTRAINT `fk_wallet_codes_logs` FOREIGN KEY (`code_id`) REFERENCES `wallet_codes` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3
```

### `wallet_codes_promos`

**Usado por:**
- `new-admin`: (`app/Models/WalletCodePromo.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| promo_name | varchar(255) | NO | MUL | NULL |  |
| number_codes | int | NO |  | NULL |  |
| amount | float | NO |  | NULL |  |
| currency | char(3) | NO |  | NULL |  |
| author_id | int | NO | MUL | NULL |  |
| creation_date | datetime | NO | MUL | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| expiration_date | datetime | YES | MUL | NULL |  |
| withdrawal_date | datetime | YES |  | NULL |  |
| withdrawn | tinyint(1) | NO |  | 0 |  |
| department_code | varchar(3) | NO |  | NULL |  |
| cost | mediumtext | YES |  | NULL |  |
| description | mediumtext | YES |  | NULL |  |
| description_code | varchar(255) | NO | MUL | NULL |  |
| wallet_move_description | varchar(255) | NO |  | NULL |  |
| type | int | NO | MUL | 2 |  |
| trigger_code | varchar(100) | YES | UNI | NULL |  |
| expiration_offset_days | smallint unsigned | YES |  | NULL |  |
| withdrawal_offset_days | smallint unsigned | YES |  | NULL |  |
| min_purchase_amount | decimal(4,2) | YES |  | NULL |  |
| max_uses_per_user | tinyint | NO |  | 1 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_wallet_codes_promos_wallet_codes_types | BTREE | type | No |
| idx_wallet_codes_promos_author_id | BTREE | author_id | No |
| idx_wallet_codes_promos_creation_date | BTREE | creation_date | No |
| idx_wallet_codes_promos_description_code | BTREE | description_code | No |
| idx_wallet_codes_promos_expiration_date | BTREE | expiration_date | No |
| uk_wallet_codes_promos_promo_name | BTREE | promo_name | No |
| uk_wallet_codes_promos_trigger_code | BTREE | trigger_code | Sí |

#### DDL

```sql
CREATE TABLE `wallet_codes_promos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `promo_name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `number_codes` int NOT NULL,
  `amount` float NOT NULL,
  `currency` char(3) COLLATE utf8mb3_unicode_ci NOT NULL,
  `author_id` int NOT NULL COMMENT 'FK to admin_user',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_date` datetime DEFAULT NULL,
  `withdrawal_date` datetime DEFAULT NULL,
  `withdrawn` tinyint(1) NOT NULL DEFAULT '0',
  `department_code` varchar(3) COLLATE utf8mb3_unicode_ci NOT NULL,
  `cost` mediumtext COLLATE utf8mb3_unicode_ci,
  `description` mediumtext COLLATE utf8mb3_unicode_ci,
  `description_code` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `wallet_move_description` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `type` int NOT NULL DEFAULT '2' COMMENT 'FK to wallet_codes_types',
  `trigger_code` varchar(100) COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Codigo maestro publico (ej: IBERIA2025)',
  `expiration_offset_days` smallint unsigned DEFAULT NULL COMMENT 'Dias para canjear el codigo. NULL = usa fecha fija legacy',
  `withdrawal_offset_days` smallint unsigned DEFAULT NULL COMMENT 'Dias de vida del saldo en wallet. NULL = usa fecha fija legacy',
  `min_purchase_amount` decimal(4,2) DEFAULT NULL COMMENT 'Importe minimo de gasto para canjear un codigo de la promocion',
  `max_uses_per_user` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_wallet_codes_promos_trigger_code` (`trigger_code`),
  KEY `fk_wallet_codes_promos_wallet_codes_types` (`type`),
  KEY `uk_wallet_codes_promos_promo_name` (`promo_name`),
  KEY `idx_wallet_codes_promos_author_id` (`author_id`),
  KEY `idx_wallet_codes_promos_creation_date` (`creation_date`),
  KEY `idx_wallet_codes_promos_expiration_date` (`expiration_date`),
  KEY `idx_wallet_codes_promos_description_code` (`description_code`),
  CONSTRAINT `fk_wallet_codes_promos_admin_user` FOREIGN KEY (`author_id`) REFERENCES `admin_user` (`id`),
  CONSTRAINT `fk_wallet_codes_promos_wallet_codes_types` FOREIGN KEY (`type`) REFERENCES `wallet_codes_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Importe minimo de gasto para canjear un codigo de la promocion'
```

### `wallet_codes_statuses`

**Usado por:**
- `new-admin`: (`app/Models/WalletCodesStatuses.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| label | varchar(255) | NO |  | NULL |  |
| description | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `wallet_codes_statuses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3
```

### `wallet_codes_types`

**Usado por:**
- `new-admin`: (`app/Models/WalletCodesTypes.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| label | varchar(255) | NO |  | NULL |  |
| description | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `wallet_codes_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3
```

### `wallet_code_usage`

**Usado por:**
- `new-admin`: (`app/Models/WalletCodeUsage.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int unsigned | NO | PRI | NULL | auto_increment |
| wallet_code_id | int | NO | MUL | NULL |  |
| promo_id | int | YES | MUL | NULL |  |
| client_id | int unsigned | NO | MUL | NULL |  |
| client_type | tinyint unsigned | NO |  | NULL |  |
| used_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| fk_wallet_code_usage_code | BTREE | wallet_code_id | No |
| idx_usage_client_promo | BTREE | client_id, client_type, promo_id | No |
| uq_wallet_code_usage_promo_id_client_id | BTREE | promo_id, client_id, client_type | Sí |

#### DDL

```sql
CREATE TABLE `wallet_code_usage` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `wallet_code_id` int NOT NULL,
  `promo_id` int DEFAULT NULL,
  `client_id` int unsigned NOT NULL,
  `client_type` tinyint unsigned NOT NULL,
  `used_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wallet_code_usage_promo_id_client_id` (`promo_id`,`client_id`,`client_type`),
  KEY `fk_wallet_code_usage_code` (`wallet_code_id`),
  KEY `idx_usage_client_promo` (`client_id`,`client_type`,`promo_id`),
  CONSTRAINT `fk_wallet_code_usage_code` FOREIGN KEY (`wallet_code_id`) REFERENCES `wallet_codes` (`id`),
  CONSTRAINT `fk_wallet_code_usage_promo` FOREIGN KEY (`promo_id`) REFERENCES `wallet_codes_promos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
```

### `wallet_moves`

**Usado por:**
- `new-admin`: (`app/Models/WalletMove.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| wallet_id | int | NO | MUL | NULL |  |
| date | datetime | NO |  | NULL |  |
| type | int | NO |  | NULL |  |
| type_description | text | YES |  | NULL |  |
| type_description_id | int | YES |  | 1 |  |
| amount | decimal(10,2) | NO |  | NULL |  |
| xrt | float | NO |  | NULL |  |
| pay_amount | decimal(10,2) | NO |  | NULL |  |
| currency | varchar(3) | NO |  | EUR |  |
| status | tinyint | NO | MUL | NULL |  |
| wallet_amount | decimal(10,2) | NO |  | NULL |  |
| key | varchar(25) | NO | UNI | NULL |  |
| client_type | int | NO |  | NULL |  |
| client_id | int | NO |  | NULL |  |
| source | tinyint | NO |  | NULL |  |
| created_by | varchar(50) | NO |  | SYSTEM |  |
| approved_by | varchar(50) | YES |  | NULL |  |
| date_approved | datetime | YES |  | NULL |  |
| cancel_by | varchar(50) | YES |  | NULL |  |
| date_cancel | datetime | YES |  | NULL |  |
| related_to | tinytext | YES |  | NULL |  |
| id_booking | int | YES |  | NULL |  |
| notes | text | YES |  | NULL |  |
| locks | decimal(10,2) | NO |  | 0.00 |  |
| unlocks | decimal(10,2) | NO |  | 0.00 |  |
| product_type | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_wallet_moves_key | BTREE | key | Sí |
| wallet_moves_status_IDX | BTREE | status | No |
| wallet_moves_wallet_id_IDX | BTREE | wallet_id | No |

#### DDL

```sql
CREATE TABLE `wallet_moves` (
  `id` int NOT NULL AUTO_INCREMENT,
  `wallet_id` int NOT NULL,
  `date` datetime NOT NULL,
  `type` int NOT NULL COMMENT '0 carga de saldo, 1 compra (descuento de saldo), 2 refund (aumenta saldo)',
  `type_description` text,
  `type_description_id` int DEFAULT '1' COMMENT 'id on wallet_moves_descriptions',
  `amount` decimal(10,2) NOT NULL COMMENT 'negativos posibles',
  `xrt` float NOT NULL,
  `pay_amount` decimal(10,2) NOT NULL,
  `currency` varchar(3) NOT NULL DEFAULT 'EUR',
  `status` tinyint NOT NULL COMMENT '0 pte, 1 aprobado',
  `wallet_amount` decimal(10,2) NOT NULL,
  `key` varchar(25) NOT NULL,
  `client_type` int NOT NULL COMMENT '1 - agencia, 2 - usuario (se trae a esta tabla por las agencias padre)',
  `client_id` int NOT NULL COMMENT '(se trae a esta tabla por las agencias padre)',
  `source` tinyint NOT NULL COMMENT '1 - api, 2 - administración, 3 - panel agencias',
  `created_by` varchar(50) NOT NULL DEFAULT 'SYSTEM',
  `approved_by` varchar(50) DEFAULT NULL,
  `date_approved` datetime DEFAULT NULL,
  `cancel_by` varchar(50) DEFAULT NULL,
  `date_cancel` datetime DEFAULT NULL,
  `related_to` tinytext,
  `id_booking` int DEFAULT NULL,
  `notes` text,
  `locks` decimal(10,2) NOT NULL DEFAULT '0.00',
  `unlocks` decimal(10,2) NOT NULL DEFAULT '0.00',
  `product_type` int DEFAULT NULL COMMENT '1 = Actividad, 2 = Traslado',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_wallet_moves_key` (`key`),
  KEY `wallet_moves_wallet_id_IDX` (`wallet_id`),
  KEY `wallet_moves_status_IDX` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb3 COMMENT='1 = Actividad, 2 = Traslado'
```

### `wallet_moves_charge_requests`

**Usado por:**
- `new-admin`: (`app/Models/WalletMoveChargeRequest.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| status | tinyint | NO |  | 0 |  |
| wallet_move | varchar(25) | NO |  | NULL |  |
| approved_by | int | YES |  | NULL |  |
| wallet_move_reject | varchar(25) | YES |  | NULL |  |
| rejected_by | int | YES |  | NULL |  |
| email_paypal | varchar(256) | YES |  | NULL |  |
| country_bank_id | int | YES |  | NULL |  |
| type_bank_identification | int | YES |  | NULL |  |
| city_bank_name | varchar(128) | YES |  | NULL |  |
| bank_address | varchar(256) | YES |  | NULL |  |
| name_bank | varchar(256) | YES |  | NULL |  |
| name_account | varchar(150) | YES |  | NULL |  |
| bank_account | varchar(100) | YES |  | NULL |  |
| swift_bic | varchar(50) | YES |  | NULL |  |
| extra_label | varchar(256) | YES |  | NULL |  |
| bank_account_type | int | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| updated_at | timestamp | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `wallet_moves_charge_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0- Pendiente  1-Aprobado 2-Rechazado',
  `wallet_move` varchar(25) NOT NULL,
  `approved_by` int DEFAULT NULL COMMENT 'Admin_user ID',
  `wallet_move_reject` varchar(25) DEFAULT NULL,
  `rejected_by` int DEFAULT NULL COMMENT 'Admin_user ID',
  `email_paypal` varchar(256) DEFAULT NULL,
  `country_bank_id` int DEFAULT NULL,
  `type_bank_identification` int DEFAULT NULL COMMENT '1.-ABA 2.-ROUTING NUMBER 3.-SORT CODE 4.-IFSC 5.-CNAP 6.-TRANSIT NUMBER 7.-BSB',
  `city_bank_name` varchar(128) DEFAULT NULL,
  `bank_address` varchar(256) DEFAULT NULL,
  `name_bank` varchar(256) DEFAULT NULL,
  `name_account` varchar(150) DEFAULT NULL,
  `bank_account` varchar(100) DEFAULT NULL,
  `swift_bic` varchar(50) DEFAULT NULL,
  `extra_label` varchar(256) DEFAULT NULL,
  `bank_account_type` int DEFAULT NULL COMMENT '0- Paypal 1. Cuenta corriente 2. Cuenta ahorro',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT=' - Civitatis'
```

### `wp_tags`

**Usado por:**
- `new-admin`: (`app/Models/WpTag.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(256) | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |

#### DDL

```sql
CREATE TABLE `wp_tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb3
```

### `zones_destination`

**Usado por:**
- `new-admin`: (`app/Models/ZoneDestination.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_zone | int | NO | MUL | NULL |  |
| id_destination | int | NO |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_zones_destination-id_master_zone | BTREE | id_master_zone | No |

#### DDL

```sql
CREATE TABLE `zones_destination` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_zone` int NOT NULL,
  `id_destination` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_zones_destination-id_master_zone` (`id_master_zone`)
) ENGINE=InnoDB AUTO_INCREMENT=2677 DEFAULT CHARSET=utf8mb3
```

### `zones_master`

**Usado por:**
- `new-admin`: (`app/Models/Zone.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| name | varchar(512) | NO |  | NULL |  |
| latitude | varchar(32) | YES |  | NULL |  |
| longitude | varchar(32) | YES |  | NULL |  |
| zoom | int | YES |  | NULL |  |
| active | tinyint | NO |  | 1 |  |
| notes | varchar(255) | YES |  | NULL |  |
| country_id | int | YES | MUL | NULL |  |
| is_top | tinyint | NO |  | 0 |  |
| responsible_id | int | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| zones_master_fiscal_data_country_id | BTREE | country_id | No |

#### DDL

```sql
CREATE TABLE `zones_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(512) NOT NULL,
  `latitude` varchar(32) DEFAULT NULL,
  `longitude` varchar(32) DEFAULT NULL,
  `zoom` int DEFAULT NULL,
  `active` tinyint NOT NULL DEFAULT '1',
  `notes` varchar(255) DEFAULT NULL,
  `country_id` int DEFAULT NULL,
  `is_top` tinyint NOT NULL DEFAULT '0' COMMENT '0.no es top 1.es top',
  `responsible_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `zones_master_fiscal_data_country_id` (`country_id`),
  CONSTRAINT `zones_master_fiscal_data_country_id` FOREIGN KEY (`country_id`) REFERENCES `paises` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=407 DEFAULT CHARSET=utf8mb3
```

### `zones_translations`

**Usado por:**
- `new-admin`: (`app/Models/ZoneTranslations.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| id_master_zone | int | NO | MUL | NULL |  |
| name | varchar(512) | NO |  | NULL |  |
| lang | varchar(2) | NO |  | NULL |  |
| url | varchar(56) | NO |  | NULL |  |
| active | tinyint | NO |  | 1 |  |
| breadcrumb_visible | tinyint | NO |  | 1 |  |
| on_zone | varchar(255) | YES |  | NULL |  |
| to_zone | varchar(255) | YES |  | NULL |  |
| of_zone | varchar(256) | YES |  | NULL |  |
| from_zone | varchar(256) | YES |  | NULL |  |
| meta_title | varchar(70) | YES |  | NULL |  |
| meta_description | varchar(160) | YES |  | NULL |  |
| content | text | YES |  | NULL |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_zones_translations-id_master_zone | BTREE | id_master_zone | No |

#### DDL

```sql
CREATE TABLE `zones_translations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_master_zone` int NOT NULL,
  `name` varchar(512) NOT NULL,
  `lang` varchar(2) NOT NULL,
  `url` varchar(56) NOT NULL,
  `active` tinyint NOT NULL DEFAULT '1',
  `breadcrumb_visible` tinyint NOT NULL DEFAULT '1' COMMENT '0. Invisible en migas 1. Visible en migas',
  `on_zone` varchar(255) DEFAULT NULL,
  `to_zone` varchar(255) DEFAULT NULL,
  `of_zone` varchar(256) DEFAULT NULL,
  `from_zone` varchar(256) DEFAULT NULL,
  `meta_title` varchar(70) DEFAULT NULL,
  `meta_description` varchar(160) DEFAULT NULL,
  `content` text,
  PRIMARY KEY (`id`),
  KEY `idx_zones_translations-id_master_zone` (`id_master_zone`)
) ENGINE=InnoDB AUTO_INCREMENT=3008 DEFAULT CHARSET=utf8mb3
```

### `zones_translations_changelog`

**Usado por:**
- `new-admin`: (`app/Models/ZonesTranslationsChangelog.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idMasterZone | int | NO | MUL | NULL |  |
| field | varchar(256) | NO |  | NULL |  |
| old_value | text | YES |  | NULL |  |
| new_value | text | YES |  | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| validated | int | YES | MUL | 0 |  |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_zones_translations_changelog | BTREE | idMasterZone, created_at | No |
| idx_zones_translations_changelog_validated | BTREE | validated | No |

#### DDL

```sql
CREATE TABLE `zones_translations_changelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idMasterZone` int NOT NULL,
  `field` varchar(256) NOT NULL,
  `old_value` text,
  `new_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validated` int DEFAULT '0' COMMENT '1 - Si 0 - No',
  PRIMARY KEY (`id`),
  KEY `idx_zones_translations_changelog` (`idMasterZone`,`created_at`),
  KEY `idx_zones_translations_changelog_validated` (`validated`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COMMENT='Track the changes made in zones'
```

### `zones_translations_changelog_validation`

**Usado por:**
- `new-admin`: (`app/Models/ZonesTranslationsChangelogValidation.php`)

#### Columnas

| Campo | Tipo | Null | Key | Default | Extra |
|-------|------|------|-----|---------|-------|
| id | int | NO | PRI | NULL | auto_increment |
| idCambio | int | NO |  | NULL |  |
| user | varchar(16) | NO |  | NULL |  |
| idioma | varchar(2) | NO | MUL | NULL |  |
| created_at | timestamp | NO |  | CURRENT_TIMESTAMP | DEFAULT_GENERATED |

#### Índices

| Nombre | Tipo | Columnas | Único |
|--------|------|----------|-------|
| PRIMARY | BTREE | id | Sí |
| idx_zones_translations_changelog_validation | BTREE | idioma | No |

#### DDL

```sql
CREATE TABLE `zones_translations_changelog_validation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idCambio` int NOT NULL,
  `user` varchar(16) NOT NULL,
  `idioma` varchar(2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_zones_translations_changelog_validation` (`idioma`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
```

