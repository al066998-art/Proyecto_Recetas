<template>
  <div v-if="recipe" class="home-container">
    <button @click="router.back()" class="btn-submit" style="width: auto; background: #475569; margin-bottom: 2rem;">
      ← Volver al Menú
    </button>

    <div class="recipe-detail-card" style="background: #1e293b; padding: 2rem; border-radius: 1rem; border: 1px solid #334155;">
      <h1 class="auth-title" style="margin-bottom: 1rem;">{{ recipe.title }}</h1>
      
      <img 
        :src="recipe.main_image ? `http://127.0.0.1:8000/storage/${recipe.main_image}` : 'https://via.placeholder.com/800x400'" 
        style="width: 100%; max-height: 400px; object-fit: cover; border-radius: 0.75rem; margin-bottom: 2rem;"
      >

      <h3 style="color: #10b981; margin-bottom: 1rem;">Instrucciones de Preparación:</h3>
      <p style="color: white; white-space: pre-wrap; line-height: 1.6; font-size: 1.1rem;">
        {{ recipe.instructions }}
      </p>
    </div>

    <div style="margin-top: 3rem;">
      <h2 class="auth-title">Reseñas de la Comunidad</h2>
      
      <div style="margin-top: 1rem; margin-bottom: 2rem; background: #1e293b; padding: 1.5rem; border-radius: 1rem;">
        <h4 style="color: white; margin-bottom: 1rem;">Deja tu opinión</h4>
        
        <div class="rating-selector" style="margin-bottom: 1rem; display: flex; gap: 10px; align-items: center;">
          <label style="color: #94a3b8;">Calificación:</label>
          <select v-model="rating" style="background: #0f172a; color: white; border: 1px solid #334155; padding: 8px; border-radius: 0.5rem; cursor: pointer;">
            <option v-for="n in 5" :key="n" :value="n">{{ n }} ⭐</option>
          </select>
        </div>

        <textarea v-model="comment" placeholder="¿Qué te pareció esta receta?" rows="3" 
          style="width: 100%; background: #0f172a; border: 1px solid #334155; border-radius: 0.75rem; color: white; padding: 1rem; resize: none;"></textarea>
        
        <button @click="enviarReseña" class="btn-submit" style="margin-top: 10px; width: auto;">Publicar Reseña</button>
      </div>

      <div v-if="recipe.reviews && recipe.reviews.length" class="reviews-list">
        <div v-for="review in recipe.reviews" :key="review.id" 
          style="background: #0f172a; padding: 1.2rem; border-radius: 0.5rem; margin-bottom: 1rem; border-left: 4px solid #10b981;">
          
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
            <p style="color: #94a3b8; font-size: 0.9rem; font-weight: bold;">{{ review.user?.name || 'Invitado' }}</p>
            <p style="color: #fbbf24; font-size: 0.9rem;">
              {{ '⭐'.repeat(review.rating) }}
            </p>
          </div>
          
          <p style="color: white; line-height: 1.4;">{{ review.comment }}</p>
        </div>
      </div>
      <p v-else class="auth-subtitle" style="text-align: center; margin-top: 2rem;">Aún no hay reseñas. ¡Sé el primero en opinar!</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import api from '../api';

const route = useRoute();
const router = useRouter();
const recipe = ref(null);
const comment = ref('');
const rating = ref(5);
const isLoggedIn = computed(() => !!localStorage.getItem('token'));

const loadRecipe = async () => {
  try {
    const res = await api.get(`/recipes/${route.params.id}`);
    recipe.value = res.data;
  } catch (e) {
    console.error("No se pudo cargar la receta");
    router.push('/home');
  }
};

const enviarReseña = async () => {
  if (!comment.value.trim()) {
    alert('Por favor, escribe un comentario.');
    return;
  }
  
  try {
    await api.post(`/recipes/${recipe.value.id}/reviews`, { 
      comment: comment.value,
      rating: rating.value 
    });
    
    comment.value = '';
    rating.value = 5;
    await loadRecipe(); 
    alert('¡Gracias por tu reseña!');
  } catch (e) {
    const errorMsg = e.response?.data?.message || 'No se pudo guardar la reseña.';
    alert(errorMsg);
  }
};

onMounted(loadRecipe);
</script>