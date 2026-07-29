import os
import json
import sqlite3
import hashlib
from datetime import datetime
import ast
import numpy as np
import pandas as pd
from datasets import load_dataset
from sentence_transformers import SentenceTransformer

def calculate_sha256(filepath):
    """Calculates the SHA256 hash of the file to validate the download in the app."""
    sha256_hash = hashlib.sha256()
    with open(filepath, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    return sha256_hash.hexdigest()

def main():
    version_str = datetime.now().strftime("%Y%m%d")  # Ex: 20260729
    db_filename = "movies_embeddings.db"
    json_filename = "movies_metadata.json"

    print("1️⃣ Downloading the Sandeep1525/tmdb-5000-movies dataset from Hugging Face...")
    ds = load_dataset("Sandeep1525/tmdb-5000-movies", split="train")
    df = pd.DataFrame(ds)
    
    print(f"Total movies loaded: {len(df)}")

    print("2️⃣ Cleaning the data and combining features...")
    # In this dataset the key columns are 'id' and 'overview'
    df = df.dropna(subset=['id', 'overview', 'title'])
    df = df[df['overview'].str.strip() != '']
    
    def extract_names(string_data, limit=None):
        try:
            # Parse string representation of list of dicts: "[{'id': 28, 'name': 'Action'}, ...]"
            items = ast.literal_eval(string_data)
            names = [item['name'] for item in items if 'name' in item]
            if limit:
                names = names[:limit]
            return ", ".join(names)
        except Exception:
            return ""

    def extract_directors(string_data):
        try:
            items = ast.literal_eval(string_data)
            names = [item['name'] for item in items if item.get('job') == 'Director' and 'name' in item]
            return ", ".join(names)
        except Exception:
            return ""

    df['genres_text'] = df['genres'].apply(extract_names) if 'genres' in df.columns else ""
    df['keywords_text'] = df['keywords'].apply(extract_names) if 'keywords' in df.columns else ""
    df['cast_text'] = df['cast'].apply(lambda x: extract_names(x, limit=5)) if 'cast' in df.columns else ""
    df['director_text'] = df['crew'].apply(extract_directors) if 'crew' in df.columns else ""
    df['tagline_text'] = df['tagline'].fillna('') if 'tagline' in df.columns else ""
    
    # Combine everything to create a rich document with explicit prefixes
    df['full_text'] = (
        "Title: " + df['title'] + ". " +
        "Tagline: " + df['tagline_text'] + ". " +
        "Director: " + df['director_text'] + ". " +
        "Cast: " + df['cast_text'] + ". " +
        "Genres: " + df['genres_text'] + ". " +
        "Keywords: " + df['keywords_text'] + ". " +
        "Overview: " + df['overview']
    )
    
    df = df.reset_index(drop=True)

    print(f"Valid movies to process: {len(df)}")

    print("3️⃣ Loading 'paraphrase-multilingual-MiniLM-L12-v2' model from Hugging Face...")
    model = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')

    print("4️⃣ Generating embeddings for the 5,000 movies with rich features...")
    documents = df['full_text'].tolist()
    embeddings = model.encode(
        documents, 
        batch_size=64, 
        show_progress_bar=True, 
        convert_to_numpy=True
    )

    print("5️⃣ Creating the local SQLite database...")
    if os.path.exists(db_filename):
        os.remove(db_filename)

    conn = sqlite3.connect(db_filename)
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS movie_embeddings (
            tmdb_id INTEGER PRIMARY KEY,
            embedding BLOB,
            vote_average REAL,
            vote_count INTEGER
        )
    """)

    records = []
    for i, row in df.iterrows():
        tmdb_id = int(row['id'])
        vote_average = float(row.get('vote_average', 0.0))
        vote_count = int(row.get('vote_count', 0))
        # Convert the float vector (384 dimensions) to bytes (float32)
        embedding_bytes = embeddings[i].astype(np.float32).tobytes()
        records.append((tmdb_id, embedding_bytes, vote_average, vote_count))

    cursor.executemany("""
        INSERT OR REPLACE INTO movie_embeddings (tmdb_id, embedding, vote_average, vote_count)
        VALUES (?, ?, ?, ?)
    """, records)

    conn.commit()
    conn.close()

    # Generate metadata for version control
    file_bytes = os.path.getsize(db_filename)
    file_mb = round(file_bytes / (1024 * 1024), 2)
    sha256 = calculate_sha256(db_filename)

    print("6️⃣ Generating metadata.json file...")
    metadata = {
        "version": int(version_str),
        "updated_at": datetime.now().strftime("%Y-%m-%d"),
        "total_movies": len(df),
        "size_bytes": file_bytes,
        "size_mb": file_mb,
        "sha256": sha256,
        "db_filename": db_filename
    }

    with open(json_filename, "w", encoding="utf-8") as f:
        json.dump(metadata, f, indent=2)

    print(f"\n✅ PROCESS COMPLETED SUCCESSFULLY!")
    print(f" -> DB generated: {db_filename} ({file_mb} MB)")
    print(f" -> JSON generated: {json_filename}")

if __name__ == "__main__":
    main()