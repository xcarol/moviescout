import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/title_comment.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/auth/supabase_auth_service.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/utils/snack_bar.dart';
import 'package:moviescout/widgets/dialogs_and_forms/comment_dialog.dart';
import 'package:provider/provider.dart';

Widget commentButton(
  BuildContext context,
  TmdbTitle title,
) {
  return Consumer<SupabaseAuthService>(
    builder: (context, authService, _) {
      final user = authService.currentUser;
      final localRepo = LocalTitleRepository();

      return StreamBuilder<List<TitleComment>>(
        stream: localRepo.watchCommentsForTitle(title.tmdbId, title.mediaType),
        builder: (context, snapshot) {
          final comments = snapshot.data ?? const [];
          final TitleComment? userComment = user != null
              ? comments.where((c) => c.userId == user.id).firstOrNull
              : null;

          final bool hasComment = userComment != null;
          final loc = AppLocalizations.of(context)!;

          return IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: hasComment ? loc.editComment : loc.addComment,
            icon: Icon(
              hasComment ? Icons.chat_bubble : Icons.chat_bubble_outline,
              size: 20,
              color: hasComment
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).disabledColor,
            ),
            onPressed: () => _handleCommentPressed(
              context,
              title,
              user,
              userComment,
              loc,
            ),
          );
        },
      );
    },
  );
}

void _handleCommentPressed(
  BuildContext context,
  TmdbTitle title,
  dynamic user,
  TitleComment? userComment,
  AppLocalizations loc,
) {
  if (user == null) {
    SnackMessage.showSnackBar(loc.signInToComment);
    return;
  }

  showDialog<void>(
    context: context,
    builder: (dialogContext) => CommentDialog(
      title: title,
      initialComment: userComment,
      onSave: (text) => _saveComment(title, user, userComment, text),
      onDelete: userComment != null
          ? () => _deleteComment(title, user, userComment)
          : null,
    ),
  );
}

Future<void> _saveComment(
  TmdbTitle title,
  dynamic user,
  TitleComment? userComment,
  String text,
) async {
  final localRepo = LocalTitleRepository();
  try {
    final cloudRepo = CloudTitleRepository();
    final saved = await cloudRepo.upsertComment(
      userId: user.id,
      tmdbId: title.tmdbId,
      mediaType: title.mediaType,
      comment: text,
    );
    await localRepo.saveComment(saved);
  } catch (error, stackTrace) {
    ErrorService.log(error, stackTrace: stackTrace);
    final fallback = TitleComment(
      id: userComment?.id.isNotEmpty == true
          ? userComment!.id
          : '${user.id}_${title.tmdbId}_${title.mediaType}',
      userId: user.id,
      username: user.userMetadata?['name'] as String? ?? user.email,
      tmdbId: title.tmdbId,
      mediaType: title.mediaType,
      comment: text,
      createdAt: userComment?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await localRepo.saveComment(fallback);
  }
}

Future<void> _deleteComment(
  TmdbTitle title,
  dynamic user,
  TitleComment userComment,
) async {
  final localRepo = LocalTitleRepository();
  try {
    final cloudRepo = CloudTitleRepository();
    await cloudRepo.deleteComment(
      userId: user.id,
      tmdbId: title.tmdbId,
      mediaType: title.mediaType,
    );
  } catch (error, stackTrace) {
    ErrorService.log(error, stackTrace: stackTrace);
  }
  await localRepo.deleteComment(userComment.id);
}
