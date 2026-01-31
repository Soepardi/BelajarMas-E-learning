
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
        // Create profile record (Trigger usually handles this, but good to be safe or explicit if no trigger)
        const { error: profileError } = await supabase.from('profiles').insert([{
            id: data.user.id,
            email: email,
            full_name: fullName,
            role: role
        }]);

        if (profileError) {
            console.error('Error creating profile:', profileError);
        }

        alert('Registrasi berhasil! Silakan periksa email Anda untuk verifikasi (jika diaktifkan) atau masuk.');
        window.location.href = 'login.html';
    }
}
