import axios from 'axios';

const api = axios.create({
    baseURL: 'http://127.0.0.1:8000/api', // Asegúrate de tener tu Laravel corriendo con 'php artisan serve'
});

// Esto enviará tu correo institucional y el Token automáticamente
api.interceptors.request.use(config => {
    const token = localStorage.getItem('token');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

export default api;