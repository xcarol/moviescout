import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/title_comment.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/auth/supabase_auth_service.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/utils/snack_bar.dart';
import 'package:moviescout/widgets/dialogs_and_forms/comment_dialog.dart';
import 'package:moviescout/widgets/text_and_info/expandable_text.dart';
import 'package:provider/provider.dart';

class TitleCommentsSection extends StatefulWidget {
  final TmdbTitle title;

  const TitleCommentsSection({
    super.key,
    required this.title,
  });

  @override
  State<TitleCommentsSection> createState() => _TitleCommentsSectionState();
}

class _TitleCommentsSectionState extends State<TitleCommentsSection> {
  @override
  void initState() {
    super.initState();
    _fetchAndSyncComments();
  }

  @override
  void didUpdateWidget(covariant TitleCommentsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title.tmdbId != widget.title.tmdbId ||
        oldWidget.title.mediaType != widget.title.mediaType) {
      _fetchAndSyncComments();
    }
  }

  Future<void> _fetchAndSyncComments() async {
    try {
      final cloudRepo = CloudTitleRepository();
      final comments = await cloudRepo.fetchTitleComments(
        tmdbId: widget.title.tmdbId,
        mediaType: widget.title.mediaType,
      );
      final localRepo = LocalTitleRepository();
      await localRepo.saveComments(comments);
    } catch (e, s) {
      ErrorService.log(e, stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final localRepo = LocalTitleRepository();
    final authService = Provider.of<SupabaseAuthService>(context);
    final currentUser = authService.currentUser;

    return StreamBuilder<List<TitleComment>>(
      stream: localRepo.watchCommentsForTitle(
        widget.title.tmdbId,
        widget.title.mediaType,
      ),
      builder: (context, snapshot) {
        final comments = snapshot.data ?? const [];
        final TitleComment? userComment = currentUser != null
            ? comments.where((c) => c.userId == currentUser.id).firstOrNull
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _commentsHeader(loc, comments.length, userComment),
            const SizedBox(height: 10),
            if (comments.isEmpty)
              _emptyCommentsPlaceholder(loc)
            else
              _commentsList(comments, currentUser),
          ],
        );
      },
    );
  }

  Widget _commentsHeader(
    AppLocalizations loc,
    int commentCount,
    TitleComment? userComment,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${loc.comments} ($commentCount)',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (userComment == null)
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: loc.addComment,
            onPressed: _openAddCommentDialog,
          ),
      ],
    );
  }

  Widget _emptyCommentsPlaceholder(AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        loc.noCommentsYet,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _commentsList(
    List<TitleComment> comments,
    dynamic currentUser,
  ) {
    final loc = AppLocalizations.of(context)!;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final comment = comments[index];
        final isAuthor =
            currentUser != null && comment.userId == currentUser.id;
        return _commentCard(comment, isAuthor, loc);
      },
    );
  }

  Widget _commentCard(
    TitleComment comment,
    bool isAuthor,
    AppLocalizations loc,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _commentCardDecoration(isAuthor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _commentCardHeader(comment, isAuthor, loc),
          const SizedBox(height: 8),
          _commentCardBody(comment),
        ],
      ),
    );
  }

  BoxDecoration _commentCardDecoration(bool isAuthor) {
    return BoxDecoration(
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: isAuthor
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
            : Theme.of(context)
                .colorScheme
                .outlineVariant
                .withValues(alpha: 0.3),
        width: isAuthor ? 1.5 : 1,
      ),
    );
  }

  Widget _commentCardHeader(
    TitleComment comment,
    bool isAuthor,
    AppLocalizations loc,
  ) {
    final authorName = isAuthor
        ? loc.you
        : (comment.username != null && comment.username!.isNotEmpty
            ? comment.username!
            : 'User');

    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final dateStr =
        DateFormat.yMMMMd(localeTag).add_Hm().format(comment.updatedAt);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _commentAuthorBadge(authorName, isAuthor),
        _commentMetaAndActions(comment, dateStr, isAuthor, loc),
      ],
    );
  }

  Widget _commentAuthorBadge(String authorName, bool isAuthor) {
    return Row(
      children: [
        Icon(
          Icons.account_circle,
          size: 20,
          color: isAuthor
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Text(
          authorName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isAuthor
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _commentMetaAndActions(
    TitleComment comment,
    String dateStr,
    bool isAuthor,
    AppLocalizations loc,
  ) {
    return Row(
      children: [
        Text(
          dateStr,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (isAuthor) ...[
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: loc.editComment,
            onPressed: () => _openEditCommentDialog(comment),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 18,
              color: Theme.of(context).colorScheme.error,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: loc.deleteComment,
            onPressed: () => _confirmAndDeleteComment(comment),
          ),
        ],
      ],
    );
  }

  Widget _commentCardBody(TitleComment comment) {
    return ExpandableText(
      text: comment.comment,
      initialMaxLines: 3,
      style: const TextStyle(fontSize: 14),
    );
  }

  void _openAddCommentDialog() {
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    if (!authService.isLoggedIn) {
      SnackMessage.showSnackBar(AppLocalizations.of(context)!.signInToComment);
      return;
    }

    showDialog<void>(
      context: context,
      builder: (ctx) => CommentDialog(
        title: widget.title,
        onSave: (text) => _saveComment(text),
      ),
    );
  }

  void _openEditCommentDialog(TitleComment comment) {
    showDialog<void>(
      context: context,
      builder: (ctx) => CommentDialog(
        title: widget.title,
        initialComment: comment,
        onSave: (text) => _saveComment(text, existingComment: comment),
        onDelete: () => _deleteComment(comment),
      ),
    );
  }

  Future<void> _saveComment(
    String text, {
    TitleComment? existingComment,
  }) async {
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    final currentUser = authService.currentUser;
    if (currentUser == null) return;

    final localRepo = LocalTitleRepository();
    try {
      final cloudRepo = CloudTitleRepository();
      final saved = await cloudRepo.upsertComment(
        userId: currentUser.id,
        tmdbId: widget.title.tmdbId,
        mediaType: widget.title.mediaType,
        comment: text,
      );
      await localRepo.saveComment(saved);
    } catch (error, stackTrace) {
      ErrorService.log(error, stackTrace: stackTrace);
      final fallback = TitleComment(
        id: existingComment?.id.isNotEmpty == true
            ? existingComment!.id
            : '${currentUser.id}_${widget.title.tmdbId}_${widget.title.mediaType}',
        userId: currentUser.id,
        username:
            currentUser.userMetadata?['name'] as String? ?? currentUser.email,
        tmdbId: widget.title.tmdbId,
        mediaType: widget.title.mediaType,
        comment: text,
        createdAt: existingComment?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await localRepo.saveComment(fallback);
    }
  }

  Future<void> _deleteComment(TitleComment comment) async {
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    final currentUser = authService.currentUser;
    if (currentUser == null) return;

    final localRepo = LocalTitleRepository();
    try {
      final cloudRepo = CloudTitleRepository();
      await cloudRepo.deleteComment(
        userId: currentUser.id,
        tmdbId: widget.title.tmdbId,
        mediaType: widget.title.mediaType,
      );
    } catch (error, stackTrace) {
      ErrorService.log(error, stackTrace: stackTrace);
    }
    await localRepo.deleteComment(comment.id);
  }

  Future<void> _confirmAndDeleteComment(TitleComment comment) async {
    final loc = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.deleteComment),
        content: Text(loc.deleteCommentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.delete),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _deleteComment(comment);
    }
  }
}
