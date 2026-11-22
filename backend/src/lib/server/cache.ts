interface CacheEntry<V> {
	value: V;
	expiresAt: number;
}

export class TtlLruCache<V> {
	private readonly store = new Map<string, CacheEntry<V>>();
	private readonly pending = new Map<string, Promise<V>>();
	private readonly maxEntries: number;
	private readonly defaultTtlMs: number;

	constructor(options: { maxEntries?: number; defaultTtlMs: number }) {
		this.maxEntries = options.maxEntries ?? 500;
		this.defaultTtlMs = options.defaultTtlMs;
	}

	get(key: string): V | undefined {
		const entry = this.store.get(key);
		if (!entry) return undefined;

		if (Date.now() > entry.expiresAt) {
			this.store.delete(key);
			return undefined;
		}

		// Refresh insertion order for LRU eviction.
		this.store.delete(key);
		this.store.set(key, entry);
		return entry.value;
	}

	set(key: string, value: V, ttlMs = this.defaultTtlMs): void {
		if (this.store.has(key)) {
			this.store.delete(key);
		} else if (this.store.size >= this.maxEntries) {
			const oldestKey = this.store.keys().next().value;
			if (oldestKey !== undefined) {
				this.store.delete(oldestKey);
			}
		}

		this.store.set(key, {
			value,
			expiresAt: Date.now() + ttlMs
		});
	}

	async getOrFetch(
		key: string,
		fetcher: () => Promise<V>,
		options?: { ttlMs?: number; shouldCache?: (value: V) => boolean }
	): Promise<V> {
		const cached = this.get(key);
		if (cached !== undefined) return cached;

		const inflight = this.pending.get(key);
		if (inflight) return inflight;

		const promise = fetcher()
			.then((value) => {
				const shouldCache = options?.shouldCache ? options.shouldCache(value) : value !== null;
				if (shouldCache) {
					this.set(key, value, options?.ttlMs);
				}
				return value;
			})
			.finally(() => {
				this.pending.delete(key);
			});

		this.pending.set(key, promise);
		return promise;
	}
}
