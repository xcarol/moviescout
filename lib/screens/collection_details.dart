import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_collection.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_content/tmdb_collection_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/widgets/chips/title_chip.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/widgets/media/media_carousel.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class CollectionDetails extends StatefulWidget {
  final TmdbCollection collection;
  final TmdbTitleListService tmdbListService;

  const CollectionDetails(
      {super.key, required this.collection, required this.tmdbListService});

  @override
  State<CollectionDetails> createState() => _CollectionDetailsState();
}

class _CollectionDetailsState extends State<CollectionDetails> {
  late Future<Map<String, dynamic>> _collectionFuture;
  final TmdbCollectionService _collectionService = TmdbCollectionService();

  @override
  void initState() {
    super.initState();
    _loadCollection();
  }

  void _loadCollection() {
    final locale =
        '${_collectionService.getLanguageCode()}-${_collectionService.getCountryCode()}';
    _collectionFuture = _collectionService
        .getCollectionDetails(widget.collection.tmdbId, locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collection.name),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _collectionFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final partsRaw = data['parts'] as List<dynamic>? ?? [];
          final parts = partsRaw.map((p) {
            p[TmdbTitleFields.mediaType] = ApiConstants.movie;
            return TmdbTitle.fromMap(title: p);
          }).toList();

          parts.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));

          final String overview =
              data['overview'] ?? widget.collection.overview;
          final String posterPath =
              data['poster_path'] ?? widget.collection.posterPathSuffix ?? '';
          final String backdropPath = data['backdrop_path'] ??
              widget.collection.backdropPathSuffix ??
              '';
          final List<String> images = (data[TmdbTitleFields.images] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediaCarousel(
                  images: images,
                  backdropPath: backdropPath.isNotEmpty
                      ? 'https://image.tmdb.org/t/p/original$backdropPath'
                      : '',
                  posterPath: posterPath.isNotEmpty
                      ? 'https://image.tmdb.org/t/p/original$posterPath'
                      : '',
                  mediaType: ApiConstants.movie,
                  isLoading: false,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (overview.isNotEmpty) ...[
                        Text(
                          overview,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                      ],
                      if (parts.isNotEmpty) ...[
                        Text(
                          AppLocalizations.of(context)!.movies,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.start,
                          children: parts
                              .map((title) => TitleChip(
                                  title: title,
                                  tmdbListService: widget.tmdbListService))
                              .toList(),
                        ),
                      ]
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
