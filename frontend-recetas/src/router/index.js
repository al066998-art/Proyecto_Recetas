import { createRouter, createWebHistory } from 'vue-router';
import LoginView from '../views/LoginView.vue';
import RegisterView from '../views/RegisterView.vue';
import HomeView from '../views/HomeView.vue';

const routes = [
  { path: '/', name: 'login', component: LoginView },
  { path: '/register', name: 'register', component: RegisterView },
  { path: '/home', name: 'home', component: HomeView },
  { path: '/recipe/:id', name: 'RecipeDetail', component: () => import('../views/RecipeDetail.vue') }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;