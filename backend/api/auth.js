import admin from 'firebase-admin';

// Parse the service account from an environment variable
const serviceAccountParams = process.env.FIREBASE_SERVICE_ACCOUNT;
if (!serviceAccountParams) {
  console.error("Missing FIREBASE_SERVICE_ACCOUNT environment variable");
}

// Initialize Firebase Admin if it hasn't been initialized yet
if (!admin.apps.length && serviceAccountParams) {
  try {
    const serviceAccount = JSON.parse(serviceAccountParams);
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
  } catch (e) {
    console.error("Error parsing FIREBASE_SERVICE_ACCOUNT:", e);
  }
}

async function getTmdbAccount(account_id, session_id) {
  const tmdbToken = process.env.TMDB_API_KEY || process.env.TMDB_API_RAT;
  if (!tmdbToken) throw new Error('500:Missing TMDB API Token environment variable');

  const tmdbUrl = `https://api.themoviedb.org/3/account/${account_id}?session_id=${session_id}`;
  const tmdbResponse = await fetch(tmdbUrl, {
    headers: {
      'Authorization': `Bearer ${tmdbToken}`,
      'Accept': 'application/json'
    }
  });
  
  if (!tmdbResponse.ok) throw new Error('401:Invalid TMDB session or account ID');

  return tmdbResponse.json();
}

export default async function handler(req, res) {
  // CORS configuration for the Flutter app to access this endpoint
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader('Access-Control-Allow-Headers', 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version');

  // Handle OPTIONS request for CORS preflight
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { account_id, session_id } = req.body;

  if (!account_id || !session_id) {
    return res.status(400).json({ error: 'Missing account_id or session_id in request body' });
  }

  try {
    // 1. Validate the session directly with TMDB
    const tmdbData = await getTmdbAccount(account_id, session_id);

    // 2. Generate a Firebase Custom Token
    const uid = `tmdb_${account_id}`;
    
    // Pass the TMDB username as a custom claim so it's visible in Firebase Auth
    const customToken = await admin.auth().createCustomToken(uid, {
      tmdb_username: tmdbData.username
    });

    // 3. Return the token to the Flutter app
    return res.status(200).json({ token: customToken });

  } catch (error) {
    console.error("Auth error:", error);
    if (error.message && error.message.includes(':')) {
      const [status, msg] = error.message.split(':');
      return res.status(parseInt(status, 10)).json({ error: msg });
    }
    return res.status(500).json({ error: 'Internal server error generating token' });
  }
}
