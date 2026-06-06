import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/widgets/person_card.dart';
import 'package:moviescout/widgets/person_list_control_panel.dart';
import 'package:moviescout/widgets/person_list_info_line.dart';
import 'package:moviescout/widgets/person_list_controller.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_person_list_service.dart';

class PersonList extends StatefulWidget {
  final TmdbPersonListService personListService;
  final String type;
  final TmdbTitleListService titleListService;

  const PersonList({
    super.key,
    required this.personListService,
    required this.type,
    required this.titleListService,
  });

  @override
  State<PersonList> createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  late final PersonListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersonListController(widget.personListService, widget.type);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initializeControlLocalizations(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (!isCurrent && _controller.searchFocusNode.hasFocus) {
      _controller.searchFocusNode.unfocus();
    }
  }

  Widget _personList() {
    return Flexible(
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          _controller.onScrollNotification(scrollInfo, PersonCard.cardHeight);
          return false;
        },
        child: Scrollbar(
          controller: _controller.scrollController,
          child: ListView.builder(
            itemExtent: PersonCard.cardHeight,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: _controller.scrollController,
            itemCount: widget.personListService.loadedItemCount,
            itemBuilder: (context, index) {
              final person = widget.personListService.getItem(index);
              if (person == null) return const SizedBox.shrink();
              return PersonCard(
                person: person,
                tmdbListService: widget.titleListService,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final titleTheme = Theme.of(context).extension<CustomColors>()!;
        return Column(
          children: [
            PersonListInfoLine(controller: _controller),
            Divider(
              height: 1,
              color: titleTheme.dividerColor,
            ),
            if (_controller.showFilters)
              PersonListControlPanel(
                textFilterController: _controller.textFilterController,
                focusNode: _controller.searchFocusNode,
                onTextChanged: (value) => _controller.setTextFilter(value),
              ),
            _personList(),
          ],
        );
      },
    );
  }
}
