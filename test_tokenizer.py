from sentence_transformers import SentenceTransformer

model = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')
tokenizer = model.tokenizer
print(tokenizer.encode('alien in space'))
