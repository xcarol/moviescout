from datasets import load_dataset
import pandas as pd
ds = load_dataset("Sandeep1525/tmdb-5000-movies", split="train")
df = pd.DataFrame(ds)
print(df.columns.tolist())
