
// assets/js/supabaseClient.js

const SUPABASE_URL = 'https://felyhnbsrqhdoukqwmax.supabase.co';
const SUPABASE_KEY = 'sb_publishable_JgJTQFeOwNOakdUJbw5H1w_B5btoCER';

export const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
