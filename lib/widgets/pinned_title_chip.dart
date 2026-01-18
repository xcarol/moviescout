import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/pin_button.dart';

class PinnedTitleChip extends StatelessWidget {
  final TmdbTitle title;
  final TmdbListService listService;

  static const double cardWidth = 100.0;
  static const double cardHeight = 165.0;

  const PinnedTitleChip({
    super.key,
    required this.title,
    required this.listService,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Card(
        color: Theme.of(context).extension<CustomColors>()!.chipCardBackground,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TitleDetails(
                  title: title,
                  tmdbListService: listService,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: _poster(title.posterPath)),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: pinButton(context, title),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  title.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _poster(String? posterPath) {
    if (posterPath == null || posterPath.isEmpty) {
      return Container(
        color: Colors.grey[800],
        child: Center(
          child: SvgPicture.asset(
            'assets/movie.svg',
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: posterPath,
      cacheManager: CustomCacheManager.instance,
      fit: BoxFit.cover,
      memCacheHeight: 300,
      memCacheWidth: 200,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      cacheKey: posterPath,
      errorWidget: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[800],
          child: Center(
            child: SvgPicture.asset(
              'assets/movie.svg',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
