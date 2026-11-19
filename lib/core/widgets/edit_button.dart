import 'package:material_ui/material_ui.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/services/app_service.dart';
import 'package:provider/provider.dart';

class EditButton extends StatelessWidget {
  final String url;
  final String? targetLanguageCode;

  const EditButton({
    super.key,
    required this.url,
    this.targetLanguageCode,
  });

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<AppService>(context).showEditContent) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.edit, size: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(),
      onPressed: () {
        context.toTmdbEditWebView(
          editUrl: url,
          targetLanguageCode: targetLanguageCode,
        );
      },
    );
  }
}
