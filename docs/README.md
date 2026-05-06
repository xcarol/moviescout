# GitHub Pages Setup & Update Instructions

This folder contains the site for the Movie Scout GitHub Pages.

## How to update the page

If you need to update the website, follow these simple steps:

1. **Modify `docs/index.html`**:
   Make any desired text or design changes directly in `docs/index.html`. 
   The page currently includes:
   - The header image (`imatge-destacada.png`)
   - The app's motto ("Discover. Track. Watch.")
   - A short description based on the main README
   - Links to Google Play and GitHub

2. **Update the Header Image**:
   If you generate a new `imatge-destacada.png` in the `assets/google-play` folder, copy it over to the `docs/` folder:
   ```bash
   cp ./assets/google-play/imatge-destacada.png ./docs/imatge-destacada.png
   ```

3. **Commit and Push**:
   GitHub Pages will automatically rebuild and deploy the new version when you push changes to the main branch.
   ```bash
   git add docs/
   git commit -m "docs: Update GitHub Pages content"
   git push origin main
   ```

## Configuration

The site is served from the `/docs` folder on the `main` branch. You can configure this in your repository's settings:
**Settings > Pages > Build and deployment > Source: "Deploy from a branch" > Branch: "main" > Folder: "/docs"**.
