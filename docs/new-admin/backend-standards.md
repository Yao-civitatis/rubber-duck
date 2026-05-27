# Estructura de Backend de New Admin

> Sincronizado desde Confluence — page id `2389508098`, espacio `PANA`.
> Última actualización: 2026-05-27.
> No editar manualmente: `duck-sync-docs new-admin` lo sobrescribe.

# Contexto Arquitectónico

El backend de **New Admin** sigue una **arquitectura hexagonal**, cuyo objetivo es separar responsabilidades para mejorar la **mantenibilidad**, **escalabilidad** y **claridad del código**.

Esta arquitectura divide el sistema en diferentes capas, permitiendo desacoplar la lógica de negocio de la infraestructura y de los mecanismos de entrada/salida.

La estructura general es la siguiente:

```
	   _____________________________________________________________
      |                INFRAESTRUCTURA (Adaptadores)             	|
      |   ┌────────────────────────────────────────────────────────────────┐   |
      |   │              Controladores (Entrada)             	│   |
      |   └─────────────────────────────┬──────────────────────────────────┘   |
      |                            │ (invoca)                    	|
      |    ________________________▼____________________________    |
      |   |                APLICACIÓN (Casos de Uso)         	|   |
      |   |   ┌──────────────────────────────────────────────────────┐   |   |
      |   |   │       Servicios de Aplicación            	│   |   |
      |   |   └───────────────┬───────────────────────┬──────────────┘   |   |
      |   |                │ (usa)             │ (llama)     	|   |
      |   |    ____________▼___________________▼____________  	|   |
      |   |   |               DOMINIO (Núcleo)              |   |   |
      |   |   |   ┌─────────────────────────────────────────────┐   |   |   |
      |   |   |   │  • Entidades                        │   |   |   |
      |   |   |   │  • Servicios de Dominio             │   |   |   |
      |   |   |   │  • Interfaz de Repositorio (Puerto) │   |   |   |
      |   |   |   └─────────────────────────────────────────────┘   |   |   |
      |   |   |_____________________________________________| 	|   |
      |   |_____________________________________________________| 	|
      |                            ▲                             	|
      |   ┌─────────────────────────────┴──────────────────────────────────┐   |
      |   │        Repositorio Implementado (Adaptador)      	│   |
      |   │        (Usa Modelos de Infraestructura / DB)     	│   |
      |   └────────────────────────────────────────────────────────────────┘   |
      |_____________________________________________________________|
```

Con el objetivo de mejorar la **organización y consistencia del backend**, se establecen las siguientes **normas obligatorias**.

---

# Criterios obligatorios

* Las siguientes reglas deben cumplirse en todo nuevo desarrollo:

    * **1 endpoint = 1 Controller = 1 Use Case (Service)**
    * Los **servicios no deben depender de HTTP**.
    * El **acceso a datos solo se realiza a través de Repositories**.
    * Los **errores de dominio deben expresarse mediante excepciones de dominio**.
    * Los **modelos no deben contener lógica de negocio**.
    * **No modificar código legacy**. En su lugar, envolverlo o duplicarlo en un nuevo repositorio para refactorizar.

---

# Normas de Estructura

# Dominio

La **capa de dominio** no debe depender de ninguna otra capa superior.
Esta capa representa el **núcleo del negocio**.

Se encuentra en:

```
app/Domain
```

Contiene:

* Entidades de dominio
* Servicios de dominio
* Interfaces
* Constantes de dominio
* Excepciones de dominio

---

## Entidades

Las **entidades** deben ubicarse dentro de:

```
app/Domain/<Entidad>
```

Reglas:

* Deben representar **conceptos del dominio**.
* No deben depender de infraestructura.
* No deben contener lógica relacionada con la base de datos.

Ejemplo:

```
app/Domain/ActivityChange/ActivityChange.php
```

## Servicios de Dominio

Los **servicios de dominio** encapsulan **lógica de negocio que involucra varias entidades** o reglas complejas.

Reglas:

* Manejan entidades de dominio.
* No deben acceder directamente a la base de datos.
* Para validaciones relacionadas con datos persistidos deben utilizar **interfaces de repositorio**.
* Deben tener el sufijo: `DomainService`

Ejemplo:

```
app/Domain/ActivityChange/UpdateOrCreateActivityChangeDomainService.php
```

## Interfaces de Repositorio

Las **interfaces** de repositorio definen los **puertos de acceso a datos** desde el dominio.

* Deben tener el sufijo: `Repository`

    * Ej: `app/Domain/ActivityChange/ActivityChangeRepository.php`


Ejemplo:

```
namespace App\Domain\ActivityChange;

interface ActivityChangeRepository
{
    public function existsActivityMultimediaOpened(int $activityId, int $type): bool;

    public function getOpenedActivityChangeByActivityId(int $activityId, int $type): ?ActivityChange;
}
```

## Interfaces de Adaptador

Las **interfaces** de adaptador definen los **puertos de acceso a los adaptadores externos (email, queue, excel, etc)**

* Deben tener el sufijo: `Gateway`

    * Ej: `app/Domain/ActivityChange/ExportEmailGateway.php`


---

# Aplicación

La capa de **aplicación** contiene los **casos de uso del sistema**.

Estos se implementan mediante **Servicios de Aplicación (Caso de uso)**.

---

## Servicios de aplicación (Caso de uso)

Los **servicios** implementan los **casos de uso del sistema**.

Reglas:

* Deben tener **una única responsabilidad**.
* Solo tiene un método publico y debe ser `__invoke()`
* Los archivo debe tener sufijo `Service`
* Cada servicio debe representar **una acción del sistema**.
* No deben contener lógica de infraestructura.

Ejemplo incorrecto:

```
UserService
```

Ejemplo correcto:

```
CreateUserService
UpdateUserService
DeleteUserService
```

## Input y Output de Servicios de aplicación

Se definen clases de **Input** y **Output** para los servicios de aplicación con el objetivo de **estandarizar la entrada y salida de datos**.

Reglas:

* Debe esta en la misma carpeta de **Servicios de aplicación**
* Las clases de Input y Output deben tener el **mismo nombre base que el servicio** correspondiente.

    * Ej:

        ```
        CreateUserService
        CreateUserInput
        CreateUserOutput
        ```

* Los atributos de estas clases deben utilizar **tipos de datos simples**, como:

    * `int`
    * `string`
    * `bool`
    * etc.

    Evitar el uso de objetos complejos innecesarios para mantener las estructuras simples y predecibles.


* Para trabajar con fechas, se recomienda utilizar: `CarbonImmutable`

    Esto garantiza inmutabilidad y evita efectos secundarios no deseados.

---

# Infraestructura

La capa de **infraestructura** contiene las implementaciones técnicas necesarias para el sistema.

Incluye:

* Modelos
* Repositorios
* Controladores
* Acceso a base de datos

## Modelos (Entidad de infraestructura)

* Los **modelos** deben utilizarse únicamente para:

    * Definir **atributos**
    * Definir **relaciones entre entidades**
    * Convertirse a **entidades de dominio**
    * Definir **Observer**


    Reglas:

    * No deben contener lógica de negocio.
    * El acceso a datos debe realizarse mediante **Repositorios**.

    En algunos casos puede ser necesario convertir un Model a una entidad de dominio mediante un método como: `toDomain()`

## Repositorios

Los **repositorios** actuales en:

```
app/Repositories
```

se consideran **legacy**.

A partir de ahora:

* Deben implementarse a partir de una **interfaz definida en dominio**.
* Deben tener el Prefijo: `Eloquent`
* Cada repositorio debe tener **su propia carpeta** dentro de `app/Repositories` con el nombre de interfaz

    * `app/Repositories/{interfazName}/Eloquent{interfazName}.php`

* Dentro de esa carpeta se debe crear el archivo del repositorio correspondiente.

Ejemplo:

```
app/Repositories/ActivityChangeRepository/EloquentActivityChangeRepository.php
```

Reglas:

* Los repositorios **legacy no deben modificarse**.
* Si se requiere mejorar funcionalidad existente, se debe crear un **nuevo método en un nuevo repositorio**, siguiendo las buenas prácticas definidas.

## Controladores

Los nuevos **controladores** deben ubicarse dentro de:

```
app/Controllers/
```

Cada controlador debe tener una carpeta descriptiva según su dominio.

Ejemplo:

```
app/Controllers/ActivityChange/CreateMultimediaActivityChangeController.php
```

Reglas:

* Deben tener el sufijo `Controller`.
* Cada controlador debe implementar **una única funcionalidad**.
* Solo tiene un método publico y debe ser `__invoke()`
* Solo deben actuar como **capa de entrada HTTP**.
* Toda lógica de negocio debe delegarse a **Servicios de aplicación (caso de uso)**.
* **No** tiene acceso a **repositorios o modelos (Entidad de infraestructura)**

## Observadores

Los nuevos **observadores** deben ubicarse dentro de:

```
app/Observers/
```

Cada controlador debe tener una carpeta con mismo nombre de **Modelos** que afecta.

Ejemplo:

```
app/Observers/ActivityChange/ActivityChangeObserver.php
```

Reglas:

* Deben tener el sufijo `Observer`.
* Un Observer debe ser **fino y delegador**.
* Recibe el evento del ORM (el Model que cambió)
* Extrae los datos relevantes del evento
* Delega **toda** la lógica a un Service de Aplicación
* No hace queries, no contiene lógica de negocio
* El **Modelos (Entidad de infraestructura)** solo se utiliza como parámetro de entrada , no se puede usar para hacer las queries

Ejemplo ideal:

```php
class AdminUserObserver
{
    private AdminUserLifecycleService $lifecycleService;

    public function __construct(AdminUserLifecycleService $lifecycleService)
    {
        $this->lifecycleService = $lifecycleService;
    }

    public function created(AdminUser $adminUser): void
    {
        $this->lifecycleService->handleAdminUserCreated($adminUser->id);
    }

    public function updating(AdminUser $adminUser): void
    {
        $this->lifecycleService->handleAdminUserUpdating($adminUser->id, $adminUser->getDirty(), $adminUser->getOriginal());
    }

    public function updated(AdminUser $adminUser): void
    {
        $this->lifecycleService->handleAdminUserUpdated($adminUser->id, $adminUser->getDirty(), $adminUser->getOriginal());
    }
}
```

## Adaptadores

Los **adaptadores** deben ubicarse dentro de:

```
app/Infrastructure/
```

* Deben implementarse a partir de una **interfaz Gateway definida en dominio**.
* Deben tener el sufijo: `Adapter`
* Cada repositorio debe tener **su propia carpeta** dentro de `app/Infrastructure/` con el nombre de interfaz

    * `app/Infrastructure/{interfazFolderName}/{interfazName}Adapter.php`
    * Ej

        * Interfaz: `app/Domain/ActivitiesCanonical/CanonicalRecalculationGateway.php`
        * Adapter: `app/Infrastructure/ActivitiesCanonical/CanonicalRecalculationAdapter.php`

* Dentro de esa carpeta se debe crear el archivo del adaptador correspondiente.

---

# Casos compartidos

En una arquitectura hexagonal, las capas superiores pueden depender de las inferiores.

Las constantes y excepciones deben ubicarse **lo más cerca posible del contexto donde se utilizan**, evitando dependencias innecesarias.

## Constantes

Actualmente existe el archivo:

```
app/Services/ConstService.php
```

Este archivo introduce **acoplamiento innecesario**, por lo que debe evitarse su uso en nuevo código.

Debido a que el proyecto utiliza **PHP 7.4** (sin soporte para `Enum`), las constantes deben definirse mediante **clases estáticas**.

Reglas:

* Las constantes deben ubicarse **lo más cerca posible del contexto donde se utilizan**.

## Excepciones

Las **excepciones** deben utilizarse para manejar errores de dominio y errores de aplicación de forma clara.

Reglas:

* Debe evitar usar excepción genérico (`\Exception`).
* Tiene sufijo `Exception`.
* Deben tener nombres descriptivos.
* Las excepciones deben ubicarse **lo más cerca posible del contexto donde se utilizan**.

Ejemplo:

```php
<?php

namespace App\Domain\ActivityChange;

class ActivityChangeException extends \Exception
{
    public function __construct(string $states)
    {
        parent::__construct($states);
    }

    public static function existsActivityMultimediaOpened(): self
    {
        return new self(ActivityChangeExceptionStates::EXISTS_ACTIVITY_MULTIMEDIA_OPENED);
    }
}
```

---

# Rutas

La ruta principal se encuentra en:

```
app/route.php
```

Las rutas deben separarse por dominio dentro de:

```
app/Routes
```

Ejemplo:

```
app/Routes/UserRoutes.php
app/Routes/ActivityRoutes.php
```

Reglas:

* En `app/route.php` **solo deben declararse rutas de primer nivel**.
* Las rutas específicas deben delegarse a archivos dentro de `app/Routes`.
* Si es necesario modificar una ruta que **no sea de primer nivel** en `app/route.php`, se debe:

    1. Crear un nuevo archivo de rutas dentro de `app/Routes`.
    2. Migrar todas las subrutas relacionadas a ese archivo.
    3. Mantener `app/route.php` **simple y limpio**.

---

# Autowiring

Las **interfaces** se instancian únicamente a través de su **implementación concreta**.
Los nombres de la interfaz y de su implementación deben seguir las siguientes normas:

### Repository → Eloquent autowiring

```php
/**
 * Pattern to match Domain repository interfaces.
 */
private const DOMAIN_INTERFACE_PATTERN = '/^App\\\\Domain\\\\(.+)\\\\(\w+Repository)$/';

/**
 * Template for building implementation class names.
 */
private const IMPLEMENTATION_TEMPLATE = 'App\\Repositories\\%sRepository\\Eloquent%s';
```

### Gateway → Adapter autowiring

```php
/**
 * Pattern to match Domain gateway interfaces.
 */
private const DOMAIN_INTERFACE_PATTERN = '/^App\\\\Domain\\\\(.+)\\\\(\w+)Gateway$/';

/**
 * Template for building adapter implementation class names.
 */
private const IMPLEMENTATION_TEMPLATE = 'App\\Infrastructure\\%s\\%sAdapter';
```
