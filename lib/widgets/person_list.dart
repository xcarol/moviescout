import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/widgets/person_card.dart';
import 'package:moviescout/widgets/person_list_control_panel.dart';
import 'package:moviescout/widgets/person_list_info_line.dart';
import 'package:moviescout/widgets/person_list_controller.dart';
import 'package:moviescout/services/tmdb_list_service.dart';

class PersonList extends StatefulWidget {
  final List<TmdbPerson> people;
  final String type;
  final TmdbListService listService;

  const PersonList({
    super.key,
    required this.people,
    required this.type,
    required this.listService,
  });

  @override
  State<PersonList> createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  late final PersonListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersonListController(widget.people, widget.type);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initializeControlLocalizations(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _personList() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
        return Flexible(
          child: Scrollbar(
            controller: _controller.scrollController,
            child: ListView.builder(
              controller: _controller.scrollController,
              itemCount: _controller.itemCount,
              itemBuilder: (context, index) {
                final person = _controller.items[index];
                return Column(
                  children: [
                    PersonCard(
                      person: person,
                      tmdbListService: widget.listService,
                    ),
                    Divider(
                      height: 1,
                      color: titleTheme.listDividerColor,
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
        return Container(
          color: titleTheme.listBackground,
          child: Column(
            children: [
              PersonListInfoLine(controller: _controller),
              Divider(height: 1, color: titleTheme.listDividerColor),
              if (_controller.showFilters)
                PersonListControlPanel(
                  textFilterController: _controller.textFilterController,
                  focusNode: _controller.searchFocusNode,
                  onTextChanged: (value) => _controller.setTextFilter(value),
                ),
              _personList(),
            ],
          ),
        );
      },
    );
  }
}
