
// assets/js/app.js
import { checkSession } from './auth.js';

document.addEventListener('DOMContentLoaded', async () => {
    const session = await checkSession();

    const path = window.location.pathname;

    if (!session && !path.includes('login.html') && !path.includes('register.html') && !path.includes('index.html') && path !== '/' && !path.endsWith('/')) {
        // Redirect to login if not authenticated and trying to access a protected page
        console.log('Redirecting to login from protected route');
        window.location.href = 'login.html';
    } else if (session && (path.includes('login.html') || path.includes('register.html'))) {
        // Redirect to dashboard if already authenticated
        // Fetch profile to determine role (mocking for now or needs profile check)
        window.location.href = 'student-dashboard.html'; // Default to student for now, needs logic
    }
});
