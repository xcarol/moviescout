import { APP_NAME } from '$lib/constants/app';
import {
	DEFAULT_OG_IMAGE_URL,
	GOOGLE_PLAY_URL,
	SITE_URL,
	TMDB_IMAGE_SIZE,
	tmdbImageUrl
} from '$lib/constants/urls';
import { tw, type SupportedLocale } from '$lib/i18n';
import type {
	CollectionDetails,
	EpisodeDetails,
	PersonDetails,
	SeasonDetails,
	TitleDetails
} from '$lib/types/tmdb';

export function buildLandingSeo(locale: SupportedLocale) {
	const title = `${APP_NAME} — ${tw(locale, 'landingMotto')}`;
	const description = tw(locale, 'landingSubtitle');

	return {
		title,
		description,
		canonicalPath: '/',
		ogImage: DEFAULT_OG_IMAGE_URL,
		jsonLd: {
			'@context': 'https://schema.org',
			'@type': 'SoftwareApplication',
			name: APP_NAME,
			applicationCategory: 'EntertainmentApplication',
			operatingSystem: 'Android',
			url: SITE_URL,
			downloadUrl: GOOGLE_PLAY_URL,
			image: DEFAULT_OG_IMAGE_URL,
			description
		}
	};
}

export function buildTitleSeo(details: TitleDetails) {
	const year = details.releaseDate ? details.releaseDate.slice(0, 4) : '';
	const title = year ? `${details.title} (${year}) — ${APP_NAME}` : `${details.title} — ${APP_NAME}`;
	const description = details.overview || details.tagline || details.title;
	const canonicalPath = `/${details.mediaType}/${details.id}`;
	const ogImage = details.backdropPath
		? tmdbImageUrl(details.backdropPath, TMDB_IMAGE_SIZE.w780)
		: details.posterPath
			? tmdbImageUrl(details.posterPath, TMDB_IMAGE_SIZE.w500)
			: DEFAULT_OG_IMAGE_URL;

	const jsonLd: Record<string, unknown> = {
		'@context': 'https://schema.org',
		'@type': details.mediaType === 'movie' ? 'Movie' : 'TVSeries',
		name: details.title,
		url: `${SITE_URL}${canonicalPath}`,
		description
	};

	if (details.posterPath) {
		jsonLd.image = tmdbImageUrl(details.posterPath, TMDB_IMAGE_SIZE.w500);
	}
	if (details.releaseDate) {
		jsonLd.datePublished = details.releaseDate;
	}
	if (details.genres.length > 0) {
		jsonLd.genre = details.genres.map((g) => g.name);
	}
	if (details.mediaType === 'tv') {
		if (details.numberOfSeasons) jsonLd.numberOfSeasons = details.numberOfSeasons;
		if (details.numberOfEpisodes) jsonLd.numberOfEpisodes = details.numberOfEpisodes;
	}
	if (details.voteCount > 0 && details.voteAverage > 0) {
		jsonLd.aggregateRating = {
			'@type': 'AggregateRating',
			ratingValue: Number(details.voteAverage.toFixed(1)),
			bestRating: 10,
			worstRating: 1,
			ratingCount: details.voteCount
		};
	}

	return {
		title,
		description,
		canonicalPath,
		ogType: details.mediaType === 'movie' ? ('video.movie' as const) : ('video.tv_show' as const),
		ogImage,
		jsonLd
	};
}

export function buildSeasonSeo(season: SeasonDetails) {
	const title = `${season.seriesName} — ${season.name} — ${APP_NAME}`;
	const description = season.overview || `${season.seriesName} · ${season.name}`;
	const canonicalPath = `/tv/${season.tvId}/season/${season.seasonNumber}`;
	const imagePath = season.posterPath ?? season.seriesBackdropPath ?? season.seriesPosterPath;
	const ogImage = imagePath
		? tmdbImageUrl(imagePath, TMDB_IMAGE_SIZE.w780)
		: DEFAULT_OG_IMAGE_URL;

	const jsonLd: Record<string, unknown> = {
		'@context': 'https://schema.org',
		'@type': 'TVSeason',
		name: season.name,
		seasonNumber: season.seasonNumber,
		numberOfEpisodes: season.episodes.length,
		url: `${SITE_URL}${canonicalPath}`,
		description,
		partOfSeries: {
			'@type': 'TVSeries',
			name: season.seriesName,
			url: `${SITE_URL}/tv/${season.tvId}`
		}
	};

	if (season.airDate) jsonLd.datePublished = season.airDate;
	if (season.posterPath) {
		jsonLd.image = tmdbImageUrl(season.posterPath, TMDB_IMAGE_SIZE.w500);
	}

	return { title, description, canonicalPath, ogImage, jsonLd };
}

export function buildEpisodeSeo(episode: EpisodeDetails) {
	const code = `S${String(episode.seasonNumber).padStart(2, '0')}E${String(episode.episodeNumber).padStart(2, '0')}`;
	const title = `${episode.seriesName} ${code}: ${episode.name} — ${APP_NAME}`;
	const description = episode.overview || `${episode.seriesName} ${code} — ${episode.name}`;
	const canonicalPath = `/tv/${episode.tvId}/season/${episode.seasonNumber}/episode/${episode.episodeNumber}`;
	const ogImage = episode.stillPath
		? tmdbImageUrl(episode.stillPath, TMDB_IMAGE_SIZE.w780)
		: DEFAULT_OG_IMAGE_URL;

	const jsonLd: Record<string, unknown> = {
		'@context': 'https://schema.org',
		'@type': 'TVEpisode',
		name: episode.name,
		episodeNumber: episode.episodeNumber,
		url: `${SITE_URL}${canonicalPath}`,
		description,
		partOfSeason: {
			'@type': 'TVSeason',
			seasonNumber: episode.seasonNumber,
			url: `${SITE_URL}/tv/${episode.tvId}/season/${episode.seasonNumber}`
		},
		partOfSeries: {
			'@type': 'TVSeries',
			name: episode.seriesName,
			url: `${SITE_URL}/tv/${episode.tvId}`
		}
	};

	if (episode.airDate) jsonLd.datePublished = episode.airDate;
	if (episode.stillPath) {
		jsonLd.image = tmdbImageUrl(episode.stillPath, TMDB_IMAGE_SIZE.w780);
	}
	if (episode.voteCount > 0 && episode.voteAverage > 0) {
		jsonLd.aggregateRating = {
			'@type': 'AggregateRating',
			ratingValue: Number(episode.voteAverage.toFixed(1)),
			bestRating: 10,
			worstRating: 1,
			ratingCount: episode.voteCount
		};
	}

	return { title, description, canonicalPath, ogImage, jsonLd };
}

export function buildPersonSeo(person: PersonDetails) {
	const title = `${person.name} — ${APP_NAME}`;
	const description = person.biography || person.name;
	const canonicalPath = `/person/${person.id}`;
	const ogImage = person.profilePath
		? tmdbImageUrl(person.profilePath, TMDB_IMAGE_SIZE.w500)
		: DEFAULT_OG_IMAGE_URL;

	const jsonLd: Record<string, unknown> = {
		'@context': 'https://schema.org',
		'@type': 'Person',
		name: person.name,
		url: `${SITE_URL}${canonicalPath}`,
		description
	};

	if (person.profilePath) {
		jsonLd.image = tmdbImageUrl(person.profilePath, TMDB_IMAGE_SIZE.w500);
	}
	if (person.birthday) jsonLd.birthDate = person.birthday;
	if (person.deathday) jsonLd.deathDate = person.deathday;
	if (person.knownForDepartment) jsonLd.jobTitle = person.knownForDepartment;

	return { title, description, canonicalPath, ogImage, jsonLd };
}

export function buildCollectionSeo(collection: CollectionDetails) {
	const title = `${collection.name} — ${APP_NAME}`;
	const description = collection.overview || collection.name;
	const canonicalPath = `/collection/${collection.id}`;
	const imagePath = collection.backdropPath ?? collection.posterPath;
	const ogImage = imagePath
		? tmdbImageUrl(imagePath, TMDB_IMAGE_SIZE.w780)
		: DEFAULT_OG_IMAGE_URL;

	const jsonLd: Record<string, unknown> = {
		'@context': 'https://schema.org',
		'@type': 'CollectionPage',
		name: collection.name,
		url: `${SITE_URL}${canonicalPath}`,
		description,
		mainEntity: {
			'@type': 'ItemList',
			numberOfItems: collection.parts.length,
			itemListElement: collection.parts.map((part, index) => ({
				'@type': 'ListItem',
				position: index + 1,
				item: {
					'@type': 'Movie',
					name: part.title,
					url: `${SITE_URL}/movie/${part.id}`
				}
			}))
		}
	};

	return { title, description, canonicalPath, ogImage, jsonLd };
}
