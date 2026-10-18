import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/title_comment.dart';
import 'package:moviescout/models/tmdb_title.dart';

class CommentDialog extends StatefulWidget {
  final TmdbTitle title;
  final TitleComment? initialComment;
  final Future<void> Function(String comment) onSave;
  final Future<void> Function()? onDelete;

  const CommentDialog({
    super.key,
    required this.title,
    this.initialComment,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  late final TextEditingController _controller;
  bool _isLoading = false;
  late bool _canSave;

  bool get _isEditing => widget.initialComment != null;

  @override
  void initState() {
    super.initState();
    final initialText = widget.initialComment?.comment ?? '';
    _controller = TextEditingController(text: initialText);
    _canSave = initialText.trim().isNotEmpty;
    _controller.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    final canSave = _controller.text.trim().isNotEmpty;
    if (canSave != _canSave) {
      setState(() {
        _canSave = canSave;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() => _isLoading = true);
    try {
      await widget.onSave(text);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _confirmDelete() async {
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

    if (confirm == true && mounted && widget.onDelete != null) {
      setState(() => _isLoading = true);
      try {
        await widget.onDelete!();
        if (mounted) {
          Navigator.of(context).pop();
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(_isEditing ? loc.editComment : loc.addComment),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              autofocus: true,
              enabled: !_isLoading,
              maxLines: 6,
              minLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: loc.writeComment,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (_isEditing && widget.onDelete != null)
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            tooltip: loc.deleteComment,
            onPressed: _isLoading ? null : _confirmDelete,
          ),
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(loc.cancel),
        ),
        FilledButton(
          onPressed: (_canSave && !_isLoading) ? _submit : null,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(loc.save),
        ),
      ],
    );
  }
}
