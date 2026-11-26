export type MediaType = 'movie' | 'tv';

export interface ExternalLinks {
	imdbId?: string;
	wikidataId?: string;
	facebookId?: string;
	instagramId?: string;
	twitterId?: string;
	tiktokId?: string;
	youtubeId?: string;
	homepage?: string;
}

export interface WatchProviderItem {
	providerId: number;
	providerName: string;
	logoPath: string | null;
	displayPriority: number;
}

export interface WatchProviders {
	link?: string;
	flatrate: WatchProviderItem[];
	free: WatchProviderItem[];
	ads: WatchProviderItem[];
	rent: WatchProviderItem[];
	buy: WatchProviderItem[];
}

export interface OmdbRating {
	source: string;
	rawValue: string;
	normalizedValue: string;
	logoAsset: string | null;
}

export interface TmdbVideo {
	key: string;
	site: string;
	name: string;
	iso6391: string | null;
	official: boolean;
	type: string;
}

export interface PersonSummary {
	id: number;
	name: string;
	profilePath: string | null;
	role: string;
	department?: string;
	order?: number;
}

export interface TitleSummary {
	id: number;
	mediaType: MediaType;
	title: string;
	originalTitle: string;
	posterPath: string | null;
	backdropPath: string | null;
	releaseDate: string;
	voteAverage: number;
	voteCount: number;
	overview: string;
	genreIds: number[];
}

export interface SeasonSummary {
	id: number;
	seasonNumber: number;
	name: string;
	overview: string;
	posterPath: string | null;
	airDate: string;
	episodeCount: number;
	voteAverage: number;
}

export interface EpisodeSummary {
	id: number;
	episodeNumber: number;
	seasonNumber: number;
	name: string;
	overview: string;
	stillPath: string | null;
	airDate: string;
	runtime: number | null;
	voteAverage: number;
	voteCount: number;
}

export interface CollectionReference {
	id: number;
	name: string;
	posterPath: string | null;
	backdropPath: string | null;
}

export interface TitleDetails {
	id: number;
	mediaType: MediaType;
	title: string;
	originalTitle: string;
	originalLanguage: string;
	tagline: string;
	overview: string;
	status: string;
	posterPath: string | null;
	backdropPath: string | null;
	images: string[];
	videos: TmdbVideo[];
	releaseDate: string;
	lastAirDate?: string;
	runtime: number | null;
	episodeRunTime: number[];
	numberOfSeasons?: number;
	numberOfEpisodes?: number;
	voteAverage: number;
	voteCount: number;
	genreIds: number[];
	genres: Array<{ id: number; name: string }>;
	originCountry: string[];
	spokenLanguages: string[];
	certification: string | null;
	imdbId: string | null;
	externalLinks: ExternalLinks;
	providers: WatchProviders;
	cast: PersonSummary[];
	crew: PersonSummary[];
	seasons: SeasonSummary[];
	recommendations: TitleSummary[];
	belongsToCollection: CollectionReference | null;
	omdbRatings: OmdbRating[];
}

export interface SeasonDetails {
	id: number;
	tvId: number;
	seriesName: string;
	seriesPosterPath: string | null;
	seriesBackdropPath: string | null;
	totalSeasons: number;
	seasonNumber: number;
	name: string;
	overview: string;
	posterPath: string | null;
	airDate: string;
	voteAverage: number;
	images: string[];
	videos: TmdbVideo[];
	episodes: EpisodeSummary[];
	cast: PersonSummary[];
	crew: PersonSummary[];
}

export interface EpisodeDetails {
	id: number;
	tvId: number;
	seriesName: string;
	seasonName: string;
	seasonNumber: number;
	episodeNumber: number;
	totalEpisodesInSeason: number;
	name: string;
	overview: string;
	stillPath: string | null;
	airDate: string;
	runtime: number | null;
	voteAverage: number;
	voteCount: number;
	images: string[];
	videos: TmdbVideo[];
	cast: PersonSummary[];
	crew: PersonSummary[];
}

export interface PersonCredit extends TitleSummary {
	role: string;
	department?: string;
}

export interface PersonDetails {
	id: number;
	name: string;
	knownForDepartment: string;
	gender: number;
	alsoKnownAs: string[];
	profilePath: string | null;
	biography: string;
	birthday: string;
	deathday: string;
	placeOfBirth: string;
	imdbId: string | null;
	externalLinks: ExternalLinks;
	images: string[];
	taggedImages: string[];
	castCredits: PersonCredit[];
	crewCredits: PersonCredit[];
}

export interface CollectionDetails {
	id: number;
	name: string;
	overview: string;
	posterPath: string | null;
	backdropPath: string | null;
	images: string[];
	parts: TitleSummary[];
}
