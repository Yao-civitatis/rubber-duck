# 🌈 Estructura de Frontend de New Admin

> Sincronizado desde Confluence — page id `2449342481`, espacio `PANA`.
> Última actualización: 2026-05-27.
> No editar manualmente: `duck-sync-docs new-admin` lo sobrescribe.

## 🏗️ Estructura y jerarquía

### Organización de Directorios

```
dev/vue/
├── views/              # Páginas/vistas principales (enrutables)
├── modules/            # Módulos de funcionalidad (conjuntos de componentes)
├── components/         # Componentes compartidos globales
├── directives/         # Directivas reutilizables
├── filters/            # Filtros personalizados
├── utils/              # Utilidades y helpers
├── services/           # Servicios/lógica de negocio
├── mixins/             # Mixins reutilizables
└── store/              # Gestión de estado (si aplica)
```

### Niveles de componentes

#### 1. **Views** (`dev/vue/views/`)

* Componentes de página completa
* Enmarcados por rutas
* Pueden ser pesados en lógica
* Nombres en CamelCase: `ActivitySchedule.vue`, `ActivityPrices.vue`

#### 2. **Módulos** (`dev/vue/modules/`)

* Conjuntos de componentes relacionados por funcionalidad
* Estructura:

    ```
    moduleName/
    ├── index.js           # Exporta componentes principales
    ├── components/        # Componentes del módulo
    ├── services/          # Lógica de negocio del módulo
    ├── utils/             # Helpers específicos del módulo
    └── types/             # Tipos/interfaces (si aplica)
    ```
* Ejemplos: `activityModalidades/`, `activitySchedule/`, `activityEdit/`

#### 3. **Componentes compartidos** (`dev/vue/components/`)

* Componentes reutilizables globalmente
* Agnósticos de contexto
* Ejemplos: botones customizados, inputs, modales genéricas

#### 4. **Componentes de módulo** (`modules/moduleName/components/`)

* Específicos de un módulo
* Pueden asumir contexto del módulo
* Pueden ser grandes/pesados

---

## 📝 Nomenclatura

### Archivos de Componentes

**Regla:** PascalCase, descriptivo, singular/plural según corresponda

```
// ✅ CORRECTO
ModalitiesManagement.vue
ActivityTicketForm.vue
ModalitySelector.vue
ValidationWarning.vue

// ❌ INCORRECTO
modality-management.vue
activity_ticket_form.vue
modalities.vue
warning.vue
```

### Nombres de componentes en el Código

```
<script>
export default {
  name: 'ModalitiesManagement',
  // ...
}
</script>
```

### Props, Data, Methods

**Props:** camelCase, siempre con type y description

```
props: {
  activityId: {
    type: Number,
    required: true,
    description: 'ID único de la actividad'
  },
  isSecondaryActivity: {
    type: Boolean,
    default: false,
    description: 'Indica si es una actividad secundaria/relacionada'
  },
  modalitiesData: {
    type: Array,
    default: () => [],
    description: 'Array de modalidades'
  }
}
```

**Data:** camelCase

```
data() {
  return {
    isLoading: false,
    errorMessage: '',
    filteredItems: [],
    selectedModalityId: null
  }
}
```

**Methods:** camelCase, verbo + sustantivo cuando sea posible

```
methods: {
  fetchModalities() {},           // ✅
  updateModalityPrice() {},       // ✅
  handleModalityCreation() {},    // ✅
  validateFormData() {},          // ✅
  onModalitySaved() {},           // ✅
  getFilteredList() {},           // ✅

  modality() {},                  // ❌ No es descriptivo
  update() {},                    // ❌ Muy genérico
  test() {},                      // ❌ No tiene sentido
}
```

**Events:** kebab-case (escucha desde template), pero nombrados **descriptivamente**

```
// Emitir
this.$emit('modalidad-created', data)
this.$emit('filter-changed', filterValue)
this.$emit('item-selected', item)

// Escuchar
<Component @modalidad-created="handleCreate" />
<Component @filter-changed="onFilterChange" />
```

**Constantes:** UPPER_SNAKE_CASE

```
const MAX_RETRIES = 3
const API_TIMEOUT = 5000
const MODALITY_TYPES = ['standard', 'premium', 'vip']
```

### Nombres de variables

```
// ✅ Claro y descriptivo
const isModalityActive = true
const selectedModalitiesCount = 5
const hasErrorOccurred = false
const modalityPricePerPerson = 50
const ticketTypes = ['Adulto', 'Menor', 'Bebé']

// ❌ Evitar
const isActive = true           // Ambiguo
const count = 5                 // Qué se está contando?
const hasError = false          // Error de qué?
const price = 50                // De qué entidad?
const types = []                // Tipos de qué?
```

---

## 🎯 Componentes Vue

### Estructura base de componente

```
<template>
  <div class="component-name">
    <!-- Contenido -->
  </div>
</template>

<script>
export default {
  name: 'ComponentName',

  components: {
    // Componentes importados
  },

  props: {
    // Definir todos los props
  },

  data() {
    return {
      // Estado local
    }
  },

  computed: {
    // Propiedades computadas
  },

  watch: {
    // Watchers
  },

  methods: {
    // Métodos
  },

  mounted() {
    // Hook de montaje
  },

  beforeDestroy() {
    // Limpieza
  }
}
</script>

<style scoped>
/* Estilos - siempre scoped */
</style>
```

### Orden de secciones

1. `<template>`
2. `<script>` (en el orden especificado arriba)
3. `<style scoped>`

### Tamaño de componentes

| Métrica | Límite | Descripción |
| --- | --- | --- |
| Líneas de template | ~150 | Si excedes, considera dividir en subcomponentes |
| Líneas de script | ~300 | Mucha lógica = considerar composables o services |
| Props | ~10 | Demasiadas props = mala interfaz |
| Data properties | ~15 | Muchas propiedades = considerar agrupar objetos |

Si un componente es muy grande, divide en:

* Componentes hijos específicos
* Un componente contenedor que maneja la lógica
* Componentes de presentación que solo renderizan

### Componentes stateless

Para componentes que **SOLO** renderizan datos:

```
<template>
  <div class="card-modality">
    <h3>{{ modality.name }}</h3>
    <p>{{ modality.description }}</p>
    <button @click="$emit('edit')">Editar</button>
  </div>
</template>

<script>
export default {
  name: 'ModalityCard',
  props: {
    modality: {
      type: Object,
      required: true
    }
  }
}
</script>

<style scoped>
.card-modality {
  padding: 16px;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
}
</style>
```

---

## 🔧 Estandarizaciones

### Indentación y formato

* **Indentación:** 2 espacios
* **Comillas:** Simples en JavaScript, dobles en HTML
* **Punto y coma:** Obligatorio
* **Trailing comma:** No en último elemento

    * **Recomendable el uso de extensiones en IDE para ayudarnos con estos puntos, como Prettier.**

```
<script>
export default {
  name: 'Component',
  props: {
    title: String,
    count: Number  // Sin coma aquí
  }
}
</script>
```

### Clases CSS

**Convención BEM ligera + camelCase:**

```
<template>
  <div class="modality-management">
    <div class="modality-management__header">
      <h2>Gestión de Modalidades</h2>
    </div>
    <div class="modality-management__content">
      <div class="modality-card">
        <div class="modality-card__title">Nombre</div>
        <button class="modality-card__action modality-card__action--edit">
          Editar
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.modality-management {
  padding: 20px;
}

.modality-management__header {
  margin-bottom: 20px;
}

.modality-card {
  border: 1px solid #ddd;
  padding: 16px;
}

.modality-card__title {
  font-weight: bold;
  margin-bottom: 10px;
}

.modality-card__action {
  margin-right: 8px;
}

.modality-card__action--edit {
  background-color: #007bff;
}
</style>
```

### Atributos en HTML

Orden recomendado en templates:

1. Directivas (`v-if`, `v-for`, `v-show`)
2. Bindings de datos (`v-model`, `:prop`)
3. Event listeners (`@click`, `@submit`)
4. Atributos estáticos (`class`, `id`, `aria-*`)
5. Directives custom

```
<!-- ✅ CORRECTO -->
<input
  v-model="formData.name"
  :class="{ 'is-invalid': hasError }"
  @input="validateName"
  placeholder="Nombre"
  aria-label="Nombre de modalidad"
/>

<!-- ❌ INCORRECTO -->
<input
  placeholder="Nombre"
  aria-label="Nombre de modalidad"
  @input="validateName"
  :class="{ 'is-invalid': hasError }"
  v-model="formData.name"
/>
```

### v-for y Keys

**Siempre usa keys únicas, nunca el índice (a menos que sea lista estática):**

```
<!-- ✅ CORRECTO -->
<div v-for="modality in modalities" :key="modality.id" class="modality-item">
  {{ modality.name }}
</div>

<!-- ❌ INCORRECTO -->
<div v-for="(modality, index) in modalities" :key="index" class="modality-item">
  {{ modality.name }}
</div>
```

### Condicionales

```
<!-- Para elementos simples -->
<div v-if="isLoading">Cargando...</div>

<!-- Para lógica compleja, usa computed -->
<div v-if="hasPermissionToEdit">
  <button @click="editModality">Editar</button>
</div>

<!-- Script -->
computed: {
  hasPermissionToEdit() {
    return this.user.role === 'admin' && this.modality.editable
  }
}
```

---

## ✨ Buenas prácticas

### 1. Comunicación entre componentes

**Props Down, Events Up:**

```
<!-- Padre -->
<ModalityForm
  :modality="selectedModality"
  :errors="formErrors"
  @save="handleSave"
  @cancel="handleCancel"
/>

<!-- Hijo -->
<script>
export default {
  props: {
    modality: Object,
    errors: Array
  },
  methods: {
    submitForm() {
      this.$emit('save', this.formData)
    },
    closeForm() {
      this.$emit('cancel')
    }
  }
}
</script>
```

### 2. Manejo de promesas y async

```
// ✅ Mejor práctica: usar async/await
async methods: {
  async fetchModalities() {
    this.isLoading = true
    try {
      const response = await this.modalityService.getAll()
      this.modalities = response.data
    } catch (error) {
      this.errorMessage = 'Error al cargar modalidades'
      console.error(error)
    } finally {
      this.isLoading = false
    }
  }
}
```

### 3. Validación de props

```
props: {
  activityId: {
    type: Number,
    required: true,
    validator: (value) => value > 0
  },
  status: {
    type: String,
    default: 'active',
    validator: (value) => ['active', 'inactive', 'pending'].includes(value)
  }
}
```

### 4. Watchers — Úsalos CON CUIDADO

### 5. Ciclo de vida

```
export default {
  mounted() {
    // Cargar datos, setup listeners
    this.fetchModalities()
    this.setupEventListeners()
  },

  beforeDestroy() {
    // IMPORTANTE: limpiar resources
    // - Remover event listeners
    // - Cancelar peticiones HTTP pendientes
    // - Limpiar timers/intervals
    this.removeEventListeners()
    this.cancelPendingRequests()
  }
}
```

### 6. Evitar mutation directo de props

```
// ❌ INCORRECTO: modificar prop directamente
methods: {
  changeModalityName() {
    this.modality.name = 'Nuevo nombre'  // NUNCA!
  }
}

// ✅ CORRECTO: emitir evento y dejar que padre actualice
methods: {
  changeModalityName(newName) {
    this.$emit('update-modality', { ...this.modality, name: newName })
  }
}
```

### 7. Slots para flexibilidad

```
<!-- Componente contenedor -->
<template>
  <div class="modal">
    <div class="modal__header">
      <slot name="header">Título por defecto</slot>
    </div>
    <div class="modal__body">
      <slot>Contenido por defecto</slot>
    </div>
    <div class="modal__footer">
      <slot name="footer">
        <button @click="$emit('close')">Cerrar</button>
      </slot>
    </div>
  </div>
</template>

<!-- Uso -->
<Modal>
  <template #header>Mi Modal Customizado</template>
  <p>Contenido personalizado aquí</p>
  <template #footer>
    <button @click="save">Guardar</button>
  </template>
</Modal>
```

---

## 🎨 Patrones de desarrollo

### Patrón: Componente Contenedor + Presentacional

```
modules/activityModalidades/components/
├── ModalitiesManagement.vue          # Contenedor (lógica)
├── ModalityForm.vue                  # Presentacional (formulario)
├── ModalityList.vue                  # Presentacional (lista)
└── ModalityCard.vue                  # Presentacional (tarjeta)
```

**ModalitiesManagement.vue (Contenedor):**

```
<template>
  <div class="modalities-management">
    <ModalityForm
      v-if="showForm"
      :modality="selectedModality"
      @save="handleSave"
      @cancel="showForm = false"
    />
    <ModalityList
      :modalities="modalities"
      :loading="isLoading"
      @select="handleSelect"
      @delete="handleDelete"
    />
  </div>
</template>

<script>
import ModalityForm from './ModalityForm.vue'
import ModalityList from './ModalityList.vue'

export default {
  name: 'ModalitiesManagement',
  components: { ModalityForm, ModalityList },
  data() {
    return {
      modalities: [],
      selectedModality: null,
      showForm: false,
      isLoading: false
    }
  },
  mounted() {
    this.loadModalities()
  },
  methods: {
    async loadModalities() {
      this.isLoading = true
      try {
        this.modalities = await this.service.fetchAll()
      } finally {
        this.isLoading = false
      }
    },
    handleSave(modality) {
      // Guardar lógica
      this.showForm = false
    },
    handleSelect(modality) {
      this.selectedModality = modality
      this.showForm = true
    }
  }
}
</script>
```

**ModalityForm.vue (Presentacional):**

```
<template>
  <form @submit.prevent="submitForm" class="modality-form">
    <input v-model="form.name" placeholder="Nombre" required />
    <input v-model="form.price" type="number" placeholder="Precio" required />
    <button type="submit">Guardar</button>
    <button type="button" @click="$emit('cancel')">Cancelar</button>
  </form>
</template>

<script>
export default {
  name: 'ModalityForm',
  props: {
    modality: Object
  },
  data() {
    return {
      form: this.modality ? { ...this.modality } : { name: '', price: '' }
    }
  },
  methods: {
    submitForm() {
      this.$emit('save', this.form)
    }
  }
}
</script>
```

### Patrón: Service layer

```
// services/ModalityService.js
export default class ModalityService {
  constructor(apiClient) {
    this.apiClient = apiClient
  }

  async fetchAll(activityId) {
    const response = await this.apiClient.get(`/activities/${activityId}/modalities`)
    return response.data
  }

  async create(activityId, modalityData) {
    const response = await this.apiClient.post(
      `/activities/${activityId}/modalities`,
      modalityData
    )
    return response.data
  }

  async update(activityId, modalityId, modalityData) {
    const response = await this.apiClient.put(
      `/activities/${activityId}/modalities/${modalityId}`,
      modalityData
    )
    return response.data
  }

  async delete(activityId, modalityId) {
    await this.apiClient.delete(
      `/activities/${activityId}/modalities/${modalityId}`
    )
  }
}

// En el componente
import ModalityService from '../services/ModalityService'

export default {
  data() {
    return {
      service: new ModalityService(this.$apiClient)
    }
  },
  methods: {
    async loadModalities() {
      this.modalities = await this.service.fetchAll(this.activityId)
    }
  }
}
```

---

## 🧪 Testing

### Estructura de Tests

```
tests/
├── unit/
│   └── components/
│       └── ModalityForm.spec.js
└── integration/
    └── modalities/
        └── ModalityManagement.spec.js
```

### Ejemplo de test

```
// ModalityForm.spec.js
import { mount } from '@vue/test-utils'
import ModalityForm from '@/components/ModalityForm.vue'

describe('ModalityForm', () => {
  it('renders form inputs correctly', () => {
    const wrapper = mount(ModalityForm)
    expect(wrapper.find('input[placeholder="Nombre"]').exists()).toBe(true)
  })

  it('emits save event with form data', async () => {
    const wrapper = mount(ModalityForm)
    await wrapper.find('input[placeholder="Nombre"]').setValue('New Modality')
    await wrapper.find('form').trigger('submit')

    expect(wrapper.emitted('save')).toBeTruthy()
    expect(wrapper.emitted('save')[0][0].name).toBe('New Modality')
  })

  it('emits cancel event when cancel button clicked', async () => {
    const wrapper = mount(ModalityForm)
    await wrapper.find('button[type="button"]').trigger('click')

    expect(wrapper.emitted('cancel')).toBeTruthy()
  })
})
```

---

## ⚡ Performance

### Optimizaciones comunes

#### 1. Lazy loading de componentes

```
// Evitar cargar todos los módulos de una vez
// ❌ INCORRECTO
import ModalitiesManagement from './modules/activityModalidades/components/ModalitiesManagement.vue'

// ✅ CORRECTO
const ModalitiesManagement = () => import('./modules/activityModalidades/components/ModalitiesManagement.vue')
```

#### 2. v-show vs v-if

```
<!-- ✅ v-if: si raramente se muestra -->
<Component v-if="showRarelyUsedPanel" />

<!-- ✅ v-show: si alterna frecuentemente -->
<div v-show="showDetails" class="details">...</div>
```

#### 3. Computed vs Methods

```
// ❌ LENTO: se ejecuta siempre
methods: {
  filteredModalities() {
    return this.modalities.filter(m => m.active)
  }
}

// ✅ RÁPIDO: se cachea hasta que cambie la dependencia
computed: {
  filteredModalities() {
    return this.modalities.filter(m => m.active)
  }
}
```

#### 4. Listas largas — Virtualización

```
<!-- Para listas de 1000+ items, considerar vue-virtual-scroller -->
<virtual-list
  :items="modalities"
  :item-size="50"
  :buffer="10"
>
  <template slot-scope="{ item }">
    <ModalityItem :modality="item" />
  </template>
</virtual-list>
```

#### 5. Debounce para inputs

```
import { debounce } from 'lodash'

export default {
  methods: {
    searchModalities: debounce(function(query) {
      this.fetchResults(query)
    }, 300)
  }
}
```

---

## 📋 Checklist de Revisión de PR

Antes de hacer merge, verificar:

* El nombre del componente es descriptivo y en PascalCase
* Los props tienen type, required/default y description
* No hay mutación directa de props
* Events usan kebab-case y son descriptivos
* Componentes scoped cuando sea posible
* No hay watchers innecesarios (usar computed)
* Se limpian resources en beforeDestroy
* Tamaño del componente es razonable (<300 líneas script)
* Las clases CSS siguen convención BEM
* No hay console.log o debugger en código final
* Existe documentación para componentes complejos
* Se pasaron tests locales

---

## 📚 Recursos Recomendados

* [Vue.js Official Style Guide](https://v2.vuejs.org/v2/style-guide/)
* [Vue Performance Tips](https://v2.vuejs.org/v2/guide/render-function.html#Functional-Components)
* [BEM Naming Convention](http://getbem.com/)
* [JavaScript Naming Conventions](https://www.w3schools.com/js/js_conventions.asp)

---

## 🔄 FAQs

**P: ¿Cuándo crear un nuevo módulo vs un componente compartido?**
A: Crea un módulo si tienes 3+ componentes relacionados por una funcionalidad específica. Si es un componente reutilizable agnóstico, va en `components/`.

**P: ¿Cómo manejo el estado compartido?**
A: Para datos de un módulo, usa props/events. Para estado global complejo, considera un state management (Vuex). Mantén los servicios para lógica de negocio.

**P: ¿Es okay usar directivas custom?**
A: Sí, pero documenta bien. Evita duplicar funcionalidad que Vue ya proporciona (ej: no hagas custom v-if).

**P: ¿Puedo usar mixins?**
A: Sí, pero **con moderación**. Prefiere composables. Los mixins pueden causar conflictos de nombres.
