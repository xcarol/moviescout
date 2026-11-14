import 'package:material_ui/material_ui.dart';

abstract class SearchableListState<T extends StatefulWidget> extends State<T> {
  FocusNode get searchFocusNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (!isCurrent && searchFocusNode.hasFocus) {
      searchFocusNode.unfocus();
    }
  }
}
