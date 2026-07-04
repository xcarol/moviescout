import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/widgets/trailer_dialog.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';

class TrailerButtons extends StatelessWidget {
  final List<Map<String, dynamic>> videos;

  const TrailerButtons({super.key, required this.videos});

  void _playVideo(BuildContext context, String videoId) {
    final topMargin = kToolbarHeight + 16.0;
    showDialog(
      context: context,
      builder: (context) => TrailerDialog(
        videoId: videoId,
        topMargin: topMargin,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ytVideos = videos.where((v) => v['site'] == 'YouTube').toList();

    if (ytVideos.isEmpty) {
      return const SizedBox.shrink();
    }

    final mainVideo = ytVideos.firstWhere(
      (v) => v['type'] == 'Trailer',
      orElse: () => ytVideos.first,
    );

    final String mainVideoId = mainVideo['key'] as String;

    final remainingVideos =
        ytVideos.where((v) => v['key'] != mainVideoId).toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.icon(
          onPressed: () => _playVideo(context, mainVideoId),
          icon: const Icon(Icons.play_arrow, size: 16),
          label: Text(AppLocalizations.of(context)!.trailer),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            minimumSize: const Size(0, 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: const Radius.circular(20),
                right: remainingVideos.isNotEmpty
                    ? Radius.zero
                    : const Radius.circular(20),
              ),
            ),
          ),
        ),
        if (remainingVideos.isNotEmpty) ...[
          const SizedBox(width: 1),
          SizedBox(
            height: 32,
            child: DropdownSelector(
              selectedOption: '',
              options: remainingVideos.map((v) => v['name'] as String).toList(),
              arrowIcon: Icon(
                Icons.more_vert,
                size: 20,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              buttonBackgroundColor: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.zero,
                right: Radius.circular(20),
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
