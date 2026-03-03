<template>
  <div class="auth-container">
    <div class="auth-card">
      <h2 class="auth-title">Únete a la Cocina</h2>
      <p class="auth-subtitle">Crea tu cuenta de chef en Gourmet Recipes</p>
      
      <form @submit.prevent="handleRegister" class="auth-form">
        <div class="input-group">
          <label>Nombre de Usuario</label>
          <input v-model="form.name" type="text" placeholder="Tu nombre artístico" required>
        </div>

        <div class="input-group">
          <label>Correo Electrónico</label>
          <input v-model="form.email" type="email" placeholder="tu-correo@ejemplo.mx" required>
        </div>
        
        <div class="input-group">
          <label>Contraseña</label>
          <input v-model="form.password" type="password" placeholder="Mínimo 8 caracteres" required>
        </div>

        <div class="input-group">
          <label>Confirmar Contraseña</label>
          <input v-model="form.password_confirmation" type="password" placeholder="Repite tu contraseña" required>
        </div>
        
        <button type="submit" class="btn-submit">Crear Cuenta de Chef</button>
      </form>
      
      <div class="auth-footer">
        <p>¿Ya eres parte? <router-link to="/" class="link-accent">Inicia sesión aquí</router-link></p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import api from '../api';
import { useRouter } from 'vue-router';

const router = useRouter();
const form = ref({ name: '', email: '', password: '', password_confirmation: '' });

const handleRegister = async () => {
  try {
    await api.post('/register', form.value);
    alert('¡Registro exitoso! Ahora puedes iniciar sesión');
    router.push('/');
  } catch (e) {
    alert('Error al registrar usuario');
  }
};
</script>