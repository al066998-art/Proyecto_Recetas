<template>
  <div class="auth-container">
    <div class="auth-card">
      <h2 class="auth-title">Gourmet Connect</h2>
      <p class="auth-subtitle">Ingresa para publicar tus delicias</p>
      
      <form @submit.prevent="handleLogin">
        <div class="input-group">
          <label>Correo Electrónico</label>
          <input v-model="form.email" type="email" placeholder="tu-correo@ejemplo.mx" required>
        </div>
        <div class="input-group">
          <label>Contraseña</label>
          <input v-model="form.password" type="password" placeholder="••••••••" required>
        </div>
        <button type="submit" class="btn-submit">Entrar al Sistema</button>
      </form>
      
      <div style="margin-top: 1.5rem;">
        <p style="color: #94a3b8;">¿Eres nuevo? <router-link to="/register" class="link-accent">Crea tu cuenta</router-link></p>
        <router-link to="/home" class="link-guest">Entrar como Invitado</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import api from '../api';
import { useRouter } from 'vue-router';

const router = useRouter();
const form = ref({ email: '', password: '' });

const handleLogin = async () => {
  try {
    const res = await api.post('/login', form.value);
    
    localStorage.setItem('token', res.data.token);
    localStorage.setItem('user', JSON.stringify(res.data.user)); 
    
    router.push('/home');
  } catch (e) {
    alert('Error: Credenciales inválidas en proyecto_recetas');
  }
};
</script>