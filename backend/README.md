# MovieScout Firebase Custom Auth Backend

This is a serverless function designed to be deployed to Vercel. It bridges TMDB authentication with Firebase Custom Authentication, allowing MovieScout users to seamlessly authenticate with Firebase using their TMDB credentials.

## Why is this needed?
MovieScout relies on TMDB for user authentication. However, TMDB's v4 custom lists have significant latency issues (eventual consistency) making them unsuitable for real-time state synchronization across devices (e.g., for Pinned Titles or Following/Snoozed). 

To solve this, MovieScout uses Firebase Firestore. Since we don't want the user to perform a "Double Login" (TMDB + Google), this function validates the TMDB `session_id` and securely generates a **Firebase Custom Token**. The Flutter app then uses this token to connect to Firebase silently.

---

## 🚀 Deployment Instructions

### 1. Setup Firebase
1. Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. Go to **Build -> Authentication** and click **Get Started**.
3. Go to **Build -> Firestore Database** and create a database (Start in production mode or test mode).
4. Go to **Project Settings** (the gear icon ⚙️ at the top left) -> **Service Accounts**.
5. Click **Generate new private key**. This will download a `.json` file to your computer. Keep it safe.

### 2. Deploy to Vercel
1. Push this `backend` folder to your GitHub repository (or use the Vercel CLI).
2. Go to [Vercel](https://vercel.com/) and click **Add New -> Project**.
3. Import the GitHub repository and select the `backend` folder as the Root Directory.
4. Before clicking "Deploy", expand the **Environment Variables** section. You must add the following two variables:

   * **`TMDB_API_KEY`**
     * **Value:** Your standard TMDB API Key.

   * **`FIREBASE_SERVICE_ACCOUNT`**
     * **Value:** Open the `.json` file you downloaded from Firebase, copy **ALL** the contents, and paste them here as a single string.

5. Click **Deploy**.

### 3. Connect the Flutter App
Once Vercel finishes deploying, it will give you a public URL (e.g., `https://moviescout-backend.vercel.app`).
The API endpoint you need for the Flutter app will be:
`https://moviescout-backend.vercel.app/api/auth`

Update your Flutter environment or configuration to point the Firebase custom auth flow to this new URL.

---

## 🛠️ Testing the Endpoint Manually

You can test if the endpoint is working using `curl`:

```bash
curl -X POST https://your-vercel-url.vercel.app/api/auth \
  -H "Content-Type: application/json" \
  -d '{"account_id": "YOUR_TMDB_ACCOUNT_ID", "session_id": "YOUR_TMDB_SESSION_ID"}'
```

If successful, it will return:
```json
{
  "token": "eyJhbGciOiJSUzI1NiIs..."
}
```
