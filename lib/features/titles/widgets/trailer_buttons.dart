import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/l10n/app_localizations.dart';

import 'package:moviescout/core/widgets/drop_down_selector.dart';
import 'package:moviescout/core/services/video_player_service.dart';

class TrailerButtons extends StatelessWidget {
  final List<Map<String, dynamic>> videos;

  const TrailerButtons({super.key, required this.videos});

  void _playVideo(BuildContext context, String videoId) {
    VideoPlayerService().playVideo(videoId);
  }

  Map<String, dynamic> _findMainVideo(List<Map<String, dynamic>> ytVideos) {
    return ytVideos.firstWhere(
      (v) {
        final name = (v['name'] as String?)?.toLowerCase() ?? '';
        final isSearchResult = v['is_search_result'] == true;
        final lang = v['iso_639_1'] as String?;
        return isSearchResult &&
            lang != 'en' &&
            name.contains('official trailer');
      },
      orElse: () => ytVideos.firstWhere(
        (v) {
          final name = (v['name'] as String?)?.toLowerCase() ?? '';
          final isSearchResult = v['is_search_result'] == true;
          final lang = v['iso_639_1'] as String?;
          return isSearchResult && lang != 'en' && name.contains('trailer');
        },
        orElse: () => ytVideos.firstWhere(
          (v) =>
              (v['name'] as String?)
                  ?.toLowerCase()
                  .contains('official trailer') ??
              false,
          orElse: () => ytVideos.firstWhere(
            (v) => v['type'] == 'Trailer',
            orElse: () => ytVideos.firstWhere(
              (v) =>
                  (v['name'] as String?)?.toLowerCase().contains('trailer') ??
                  false,
              orElse: () => ytVideos.first,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ytVideos = videos.where((v) => v['site'] == 'YouTube').toList();
    final mainVideo = ytVideos.isNotEmpty ? _findMainVideo(ytVideos) : null;
    final mainVideoId = mainVideo?['key'] as String?;
    final remainingVideos = mainVideoId != null
        ? ytVideos.where((v) => v['key'] != mainVideoId).toList()
        : const <Map<String, dynamic>>[];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.icon(
          onPressed: mainVideoId != null
              ? () => _playVideo(context, mainVideoId)
              : null,
          icon: const Icon(Icons.play_arrow, size: AppSizes.iconSm),
          label: Text(AppLocalizations.of(context)!.trailer),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 0,
            ),
            minimumSize: const Size(0, AppSizes.trailerButtonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: const Radius.circular(AppRadius.full),
                right: remainingVideos.isNotEmpty
                    ? Radius.zero
                    : const Radius.circular(AppRadius.full),
              ),
            ),
          ),
        ),
        if (remainingVideos.isNotEmpty) ...[
          const SizedBox(width: AppSizes.borderWidthRegular),
          SizedBox(
            height: AppSizes.trailerButtonHeight,
            child: DropdownSelector(
              selectedOption: '',
              options: remainingVideos.map((v) => v['name'] as String).toList(),
              arrowIcon: Icon(
                Icons.more_vert,
                size: AppSizes.iconMd,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              buttonBackgroundColor: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.zero,
                right: Radius.circular(AppRadius.full),
              ),
              onSelected: (selectedName) {
                final video = remainingVideos
                    .firstWhere((v) => v['name'] == selectedName);
                _playVideo(context, video['key'] as String);
              },
            ),
          ),
        ],
      ],
    );
  }
}
