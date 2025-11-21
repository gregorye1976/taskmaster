// config.js - Secure Configuration Loader for Netlify
// Fetches credentials from serverless function (NOT from static file)

let supabaseConfig = null;

async function loadSupabaseConfig() {
    if (supabaseConfig) {
        return supabaseConfig;
    }

    try {
        // Fetch from Netlify serverless function
        // This function runs on Netlify's servers and never exposes credentials in static files
        const response = await fetch('/api/get-config');
        
        if (response.ok) {
            supabaseConfig = await response.json();
            
            // Validate response
            if (!supabaseConfig.supabaseUrl || !supabaseConfig.supabaseAnonKey) {
                console.error('Invalid configuration received from server');
                return null;
            }
            
            console.log('✅ Configuration loaded securely from server');
            return supabaseConfig;
        } else {
            const error = await response.json();
            console.error('Server configuration error:', error);
            return null;
        }
    } catch (error) {
        console.error('Error loading configuration:', error);
        
        // If running locally without Netlify, show helpful error
        if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
            console.error('⚠️ Running locally without Netlify functions.');
            console.error('To test locally with functions, run: netlify dev');
        }
        
        return null;
    }
}

// Export for use in other files
window.loadSupabaseConfig = loadSupabaseConfig;
