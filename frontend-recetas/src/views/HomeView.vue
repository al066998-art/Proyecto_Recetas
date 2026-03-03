<template>
  <div class="home-container">
    <header class="home-header">
      <div>
        <h1 class="auth-title" style="text-align: left; margin: 0;">Recetas Gourmet</h1>
        <p class="auth-subtitle" style="text-align: left; margin: 0;">Explora y comparte delicias</p>
        <p v-if="isLoggedIn && currentUser.name" class="auth-subtitle" style="text-align: left; color: #10b981; font-weight: bold; margin-top: 5px;">
          Bienvenido, {{ currentUser.name }}
        </p>
      </div>
      <div class="nav-actions">
        <button v-if="isLoggedIn" @click="logout" class="btn-submit btn-logout">Cerrar Sesión</button>
        <button v-else @click="router.push('/')" class="btn-submit btn-login-nav">Identificarse</button>
      </div>
    </header>

    <div style="display: flex; gap: 15px; margin-bottom: 2rem; flex-wrap: wrap;">
      <input 
        v-model="searchQuery" 
        type="text" 
        placeholder="🔍 Buscar una receta por nombre..." 
        style="flex: 2; background: #0f172a; border: 1px solid #334155; border-radius: 0.75rem; color: white; padding: 12px 20px;"
      >
      <select 
        v-model="selectedCategory" 
        style="flex: 1; background: #0f172a; color: white; border: 1px solid #334155; border-radius: 0.75rem; padding: 12px;"
      >
        <option value="">Todas las categorías</option>
        <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
      </select>
      <button v-if="isLoggedIn" @click="showModal = true" class="btn-submit" style="width: auto; white-space: nowrap;">
        + Nueva Receta
      </button>
    </div>

    <div v-if="showModal" class="modal-overlay">
      <div class="modal-card">
        <h2 class="auth-title" style="margin-bottom: 1rem;">Compartir Receta</h2>
        <form @submit.prevent="saveRecipe">
          <div class="input-group">
            <label>Título del Platillo</label>
            <input v-model="newRecipe.title" type="text" placeholder="Ej. Pay de Queso Casero" required>
          </div>
          
          <div class="input-group">
            <label>Categoría</label>
            <select v-model="newRecipe.category_id" style="margin-bottom: 10px;">
              <option :value="null">-- Seleccionar existente --</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
            </select>
            <input 
              v-model="newRecipe.new_category" 
              type="text" 
              placeholder="O escribe una nueva categoría..."
              style="margin-top: 5px;"
            >
          </div>

          <div class="input-group">
            <label>Descripción / Instrucciones</label>
            <textarea v-model="newRecipe.description" rows="4" placeholder="Instrucciones..." required 
              style="width: 100%; background: #0f172a; border: 1px solid #334155; border-radius: 0.75rem; color: white; padding: 14px; resize: none;"></textarea>
          </div>
          <div class="input-group">
            <label>Imagen de la Receta</label>
            <input type="file" @change="handleFileUpload" accept="image/*" style="border: none; padding: 0;">
          </div>
          <div style="display: flex; gap: 10px; margin-top: 1rem;">
            <button type="submit" class="btn-submit">Publicar Delicia</button>
            <button type="button" @click="showModal = false" class="btn-submit" style="background: #475569;">Cancelar</button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="showEditModal" class="modal-overlay">
      <div class="modal-card">
        <h2 class="auth-title" style="margin-bottom: 1rem;">Editar Receta</h2>
        <form @submit.prevent="updateRecipe">
          <div class="input-group">
            <label>Título del Platillo</label>
            <input v-model="editForm.title" type="text" required>
          </div>

          <div class="input-group">
            <label>Categoría</label>
            <select v-model="editForm.category_id" style="margin-bottom: 10px;">
              <option :value="null">-- Seleccionar categoría --</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
            </select>
            <input 
              v-model="editForm.new_category" 
              type="text" 
              placeholder="O cambia a una nueva categoría..."
              style="margin-top: 5px;"
            >
          </div>

          <div class="input-group">
            <label>Instrucciones</label>
            <textarea v-model="editForm.instructions" rows="4" required 
              style="width: 100%; background: #0f172a; border: 1px solid #334155; border-radius: 0.75rem; color: white; padding: 14px; resize: none;"></textarea>
          </div>
          <div class="input-group">
            <label>Cambiar Imagen (opcional)</label>
            <input type="file" @change="(e) => editForm.image = e.target.files[0]" accept="image/*" style="border: none; padding: 0;">
          </div>
          <div style="display: flex; gap: 10px; margin-top: 1rem;">
            <button type="submit" class="btn-submit">Guardar Cambios</button>
            <button type="button" @click="showEditModal = false" class="btn-submit" style="background: #475569;">Cancelar</button>
          </div>
        </form>
      </div>
    </div>

    <main>
      <div v-if="filteredRecipes.length > 0" class="recipe-grid">
        <article v-for="recipe in filteredRecipes" :key="recipe.id" class="recipe-card">
          <div class="recipe-img-box">
            <img 
              :src="recipe.main_image ? `http://127.0.0.1:8000/storage/${recipe.main_image}` : 'https://via.placeholder.com/400x200?text=Sin+Imagen'" 
              alt="Platillo"
            >
          </div>
          <div class="recipe-body">
            <h3>{{ recipe.title }}</h3>
            <span v-if="recipe.categories && recipe.categories.length" style="color: #10b981; font-size: 0.8rem; font-weight: bold;">
              {{ recipe.categories[0].name }}
            </span>
            <p>{{ recipe.instructions ? recipe.instructions.substring(0, 85) : 'Sin descripción' }}...</p>
            <div style="margin-top: 15px; display: flex; flex-wrap: wrap; gap: 5px;">
              <button @click="router.push(`/recipe/${recipe.id}`)" class="btn-submit" style="padding: 8px 12px; font-size: 0.8rem; flex: 1;">
                Ver / Reseñar
              </button>
              <template v-if="isLoggedIn && Number(recipe.user_id) === Number(currentUser.id)">
                <button @click="openEditModal(recipe)" class="btn-submit" style="padding: 8px 12px; font-size: 0.8rem; background: #3b82f6; flex: 1;">Editar</button>
                <button @click="deleteRecipe(recipe.id)" class="btn-submit" style="padding: 8px 12px; font-size: 0.8rem; background: #ef4444; flex: 1;">Borrar</button>
              </template>
            </div>
          </div>
        </article>
      </div>
      <div v-else style="text-align: center; padding: 100px 0;">
        <p class="auth-subtitle">No se encontraron recetas.</p>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import api from '../api';
import { useRouter } from 'vue-router';

const router = useRouter();
const recipes = ref([]);
const categories = ref([]);
const searchQuery = ref('');
const selectedCategory = ref('');

const isLoggedIn = computed(() => !!localStorage.getItem('token'));
const currentUser = computed(() => {
  const userData = localStorage.getItem('user');
  try { return userData ? JSON.parse(userData) : { id: null, name: '' }; } 
  catch (e) { return { id: null, name: '' }; }
});

const showModal = ref(false);
const showEditModal = ref(false);
const editingRecipe = ref(null);
const newRecipe = ref({ title: '', description: '', image: null, category_id: null, new_category: '' });
const editForm = ref({ title: '', instructions: '', image: null, category_id: null, new_category: '' });

// FILTRADO POR NOMBRE Y CATEGORÍA
const filteredRecipes = computed(() => {
  return recipes.value.filter(r => {
    const matchesSearch = r.title.toLowerCase().includes(searchQuery.value.toLowerCase());
    const matchesCategory = !selectedCategory.value || 
      (r.categories && r.categories.some(c => Number(c.id) === Number(selectedCategory.value)));
    return matchesSearch && matchesCategory;
  });
});

const handleFileUpload = (event) => { newRecipe.value.image = event.target.files[0]; };

const openEditModal = (recipe) => {
  editingRecipe.value = recipe;
  const currentCatId = (recipe.categories && recipe.categories.length > 0) ? recipe.categories[0].id : null;
  editForm.value = { 
    title: recipe.title, 
    instructions: recipe.instructions, 
    image: null,
    category_id: currentCatId,
    new_category: ''
  };
  showEditModal.value = true;
};

const loadCategories = async () => {
  try {
    const res = await api.get('/categories');
    categories.value = res.data;
  } catch (e) { console.error("Error cargando categorías"); }
};

const loadRecipes = async () => {
  try {
    const res = await api.get('/recipes');
    recipes.value = res.data.data || res.data;
  } catch (e) { console.error("Error cargando recetas"); }
};

const saveRecipe = async () => {
  try {
    const formData = new FormData();
    formData.append('title', newRecipe.value.title);
    formData.append('instructions', newRecipe.value.description);
    formData.append('status', 'Publicada');
    
    if (newRecipe.value.new_category) {
      formData.append('new_category', newRecipe.value.new_category);
    } else if (newRecipe.value.category_id) {
      formData.append('category_id', newRecipe.value.category_id);
    }

    if (newRecipe.value.image) formData.append('images', newRecipe.value.image);
    
    await api.post('/recipes', formData, { headers: { 'Content-Type': 'multipart/form-data' } });
    showModal.value = false;
    newRecipe.value = { title: '', description: '', image: null, category_id: null, new_category: '' };
    loadRecipes();
    loadCategories();
  } catch (e) { alert("Error al publicar"); }
};

const updateRecipe = async () => {
  try {
    const formData = new FormData();
    formData.append('_method', 'PUT');
    formData.append('title', editForm.value.title);
    formData.append('instructions', editForm.value.instructions);
    
    if (editForm.value.new_category) {
      formData.append('new_category', editForm.value.new_category);
    } else if (editForm.value.category_id) {
      formData.append('category_id', editForm.value.category_id);
    }

    if (editForm.value.image) formData.append('images', editForm.value.image);
    await api.post(`/recipes/${editingRecipe.value.id}`, formData, { headers: { 'Content-Type': 'multipart/form-data' } });
    showEditModal.value = false;
    loadRecipes();
    loadCategories();
  } catch (e) { alert("Error al actualizar"); }
};

const deleteRecipe = async (id) => {
  if (confirm('¿Deseas eliminar esta receta permanentemente?')) {
    try {
      await api.delete(`/recipes/${id}`);
      loadRecipes();
    } catch (e) { alert("No se pudo eliminar"); }
  }
};

const logout = async () => {
  try { await api.post('/logout'); } finally {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    router.push('/');
  }
};

onMounted(() => {
  loadRecipes();
  loadCategories();
});
</script>