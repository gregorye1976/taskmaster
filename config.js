// config.js - Supabase Configuration Loader
// This file loads Supabase credentials from config.json (which is gitignored)

let supabaseConfig = null;

async function loadSupabaseConfig() {
    if (supabaseConfig) {
        return supabaseConfig;
    }

    try {
        // Try to load from config.json first (local development)
        const response = await fetch('./config.json');
        if (response.ok) {
            supabaseConfig = await response.json();
            return supabaseConfig;
        }
    } catch (error) {
        console.error('Error loading config.json:', error);
    }

    // If config.json fails, try environment-based config
    // This would be set up through GitHub Pages environment or similar
    if (window.SUPABASE_CONFIG) {
        supabaseConfig = window.SUPABASE_CONFIG;
        return supabaseConfig;
    }

    // Last resort: prompt user for configuration
    console.error('No configuration found. Please set up config.json');
    return null;
}

// Export for use in other files
window.loadSupabaseConfig = loadSupabaseConfig;
