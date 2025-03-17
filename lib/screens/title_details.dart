import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';

class TitleDetails extends StatefulWidget {
  final Map title;
  const TitleDetails({super.key, required this.title});

  @override
  State<TitleDetails> createState() => _TitleDetailsState();
}

class _TitleDetailsState extends State<TitleDetails> {
  @override
  Widget build(BuildContext context) {
    String appTitle = widget.title['name'] ?? widget.title['title'] ?? '';
    
    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: appTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: back,
            tooltip: AppLocalizations.of(context)!.back,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(child: titleDetailsBody()),
    );
  }

  back() async {
    Navigator.pop(context);
  }

  titleDetailsBody() {
    return Column();
  }
}
