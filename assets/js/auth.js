
// assets/js/auth.js
import { supabase } from './supabaseClient.js';

export async function checkSession() {
    const { data: { session } } = await supabase.auth.getSession();
    return session;
}

export async function signOut() {
    const { error } = await supabase.auth.signOut();
    if (error) console.error('Error signing out:', error);
    window.location.href = 'login.html';
}

export async function getProfile(userId) {
    const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .single();

    if (error) {
        console.error('Error fetching profile:', error);
        return null;
    }
    return data;
}

export async function signIn(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
    });

    if (error) {
        alert('Gagal masuk: ' + error.message);
        return;
    }

    // Check role and redirect
    const { user } = data;
    const role = user.user_metadata.role || 'student';

    if (role === 'teacher') {
        window.location.href = 'teacher-dashboard.html';
    } else {
        window.location.href = 'student-dashboard.html';
    }
}

export async function signUp(email, password, role, fullName) {
    const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
            data: {
                role: role,
                full_name: fullName
            }
        }
    });

    if (error) {
        alert('Gagal mendaftar: ' + error.message);
        return;
    }

    if (data.user) {
        // Profile creation is now handled by the 'on_auth_user_created' database trigger
        // defined in db_schema.sql. We do not need to manually insert here.

        alert('Registrasi berhasil! Silakan periksa email Anda untuk verifikasi (jika diaktifkan) atau masuk.');
        window.location.href = 'login.html';
    }
}
