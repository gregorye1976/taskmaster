// Netlify Serverless Function - Securely provides Supabase credentials
// Credentials are stored in Netlify environment variables, NOT in code

exports.handler = async (event, context) => {
  // Only allow GET requests
  if (event.httpMethod !== 'GET') {
    return {
      statusCode: 405,
      body: JSON.stringify({ error: 'Method not allowed' })
    };
  }

  // Get credentials from environment variables (set in Netlify dashboard)
  const config = {
    supabaseUrl: process.env.SUPABASE_URL,
    supabaseAnonKey: process.env.SUPABASE_ANON_KEY
  };

  // Verify credentials are configured
  if (!config.supabaseUrl || !config.supabaseAnonKey) {
    return {
      statusCode: 500,
      body: JSON.stringify({ 
        error: 'Server configuration error',
        message: 'Environment variables not set. Please configure SUPABASE_URL and SUPABASE_ANON_KEY in Netlify dashboard.'
      })
    };
  }

  // Return credentials
  return {
    statusCode: 200,
    headers: {
      'Access-Control-Allow-Origin': '*', // In production, set to your domain
      'Access-Control-Allow-Headers': 'Content-Type',
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Content-Type': 'application/json',
      'Cache-Control': 'no-cache, no-store, must-revalidate', // Don't cache credentials
    },
    body: JSON.stringify(config)
  };
};
