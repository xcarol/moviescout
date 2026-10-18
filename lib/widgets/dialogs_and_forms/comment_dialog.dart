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
  late bool _hasText;

  bool get _isEditing => widget.initialComment != null;

  @override
  void initState() {
    super.initState();
    final initialText = widget.initialComment?.comment ?? '';
    _controller = TextEditingController(text: initialText);
    _canSave = initialText.trim().isNotEmpty;
    _hasText = initialText.isNotEmpty;
    _controller.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    final canSave = _controller.text.trim().isNotEmpty;
    final hasText = _controller.text.isNotEmpty;
    if (canSave != _canSave || hasText != _hasText) {
      setState(() {
        _canSave = canSave;
        _hasText = hasText;
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
    final confirm = await _showDeleteConfirmation(context, loc);

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

  Future<bool?> _showDeleteConfirmation(
    BuildContext context,
    AppLocalizations loc,
  ) {
    return showDialog<bool>(
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
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: _dialogTitle(loc),
      content: _dialogContent(loc),
      actions: _dialogActions(loc),
    );
  }

  Widget _dialogTitle(AppLocalizations loc) {
    return Text(_isEditing ? loc.editComment : loc.addComment);
  }

  Widget _dialogContent(AppLocalizations loc) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dialogContentHeader(loc),
          const SizedBox(height: 12),
          _commentInputField(loc),
        ],
      ),
    );
  }

  Widget _dialogContentHeader(AppLocalizations loc) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.title.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        if (_hasText && !_isLoading) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.clear, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
            onPressed: () => _controller.clear(),
          ),
        ],
      ],
    );
  }

  Widget _commentInputField(AppLocalizations loc) {
    return TextField(
      controller: _controller,
      autofocus: true,
      enabled: !_isLoading,
      maxLines: 6,
      minLines: 3,
      maxLength: 1000,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: loc.writeComment,
        border: const OutlineInputBorder(),
      ),
    );
  }

  List<Widget> _dialogActions(AppLocalizations loc) {
    return [
      if (_isEditing && widget.onDelete != null) _deleteButton(loc),
      _cancelButton(loc),
      _saveButton(loc),
    ];
  }

  Widget _deleteButton(AppLocalizations loc) {
    return IconButton(
      icon: Icon(
        Icons.delete_outline,
        color: Theme.of(context).colorScheme.error,
      ),
      tooltip: loc.deleteComment,
      onPressed: _isLoading ? null : _confirmDelete,
    );
  }

  Widget _cancelButton(AppLocalizations loc) {
    return TextButton(
      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
      child: Text(loc.cancel),
    );
  }

  Widget _saveButton(AppLocalizations loc) {
    return FilledButton(
      onPressed: (_canSave && !_isLoading) ? _submit : null,
      child: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(loc.save),
    );
  }
}
