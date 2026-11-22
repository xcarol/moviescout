import type { PersonSummary } from '$lib/types/tmdb';

function splitJobs(role: string): string[] {
	return role
		.split(',')
		.map((job) => job.trim())
		.filter(Boolean);
}

export function getDirectors(crew: PersonSummary[]): PersonSummary[] {
	return crew.filter((member) => splitJobs(member.role).includes('Director'));
}

export function getCreators(crew: PersonSummary[]): PersonSummary[] {
	return crew
		.filter((member) => {
			const jobs = splitJobs(member.role);
			return jobs.includes('Executive Producer') || jobs.includes('Creator');
		})
		.slice(0, 3);
}

export function getWriters(crew: PersonSummary[]): PersonSummary[] {
	return crew.filter((member) => {
		const jobs = splitJobs(member.role);
		return jobs.includes('Writer') || jobs.includes('Screenplay') || jobs.includes('Author');
	});
}

export function getPrimaryHeaderCredit(crew: PersonSummary[]): {
	labelKey: 'director' | 'creator' | 'writer';
	people: PersonSummary[];
} | null {
	const directors = getDirectors(crew);
	if (directors.length > 0) {
		return { labelKey: 'director', people: [directors[0]] };
	}

	const creators = crew.filter((member) => {
		const jobs = splitJobs(member.role);
		return jobs.includes('Executive Producer') || jobs.includes('Creator');
	});
	if (creators.length > 0) {
		return { labelKey: 'creator', people: [creators[0]] };
	}

	const writers = getWriters(crew);
	if (writers.length > 0) {
		return { labelKey: 'writer', people: [writers[0]] };
	}

	return null;
}
