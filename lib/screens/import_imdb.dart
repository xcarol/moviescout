import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_search_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

enum TitleStatus { pending, success, failed }

class ImportIMDB extends StatefulWidget {
  const ImportIMDB({super.key});

  @override
  State<ImportIMDB> createState() => _ImportIMDBState();
}

class _ImportIMDBState extends State<ImportIMDB> {
  late TextEditingController _filenameController;
  late List<dynamic> _csvHeaders = List.empty();
  late List<List<dynamic>> _csvTitles = List.empty();
  late List<TitleStatus> _csvTitlesStatus = List.empty();
  late int _imdbIdColumn = -1;
  late int _imdbTitleColumn = -1;
  late int _imdbRateColumn = -1;
  late int _importId = -1;
  late bool _isRateList = false;
  late bool _operationInProgress = false;
  late String _resetTitlesMessage = '';
  late int _resetTitlesCount = 0;

  @override
  void initState() {
    super.initState();
    _filenameController = TextEditingController();
  }

  @override
  void dispose() {
    _filenameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: AppLocalizations.of(context)!.imdbImport,
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _importPanel(),
            const Divider(),
            _infoLine(),
            const Divider(),
            _importResults(),
          ],
        ),
      ),
    );
  }

  _resetText() {
    _filenameController.clear();
    setState(() {
      _importId = -1;
      _csvTitles = List.empty();
      _csvTitlesStatus = List.empty();
      _filenameController.clear();
    });
  }

  Future<bool> _confirmationDialog(BuildContext context, String message) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.imdbConfirmationTitle),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  _resetWatchlist(BuildContext context) async {
    final confirm = await _confirmationDialog(
      context,
      AppLocalizations.of(context)!.imdbResetWatchlistConfirmation,
    );
    if (context.mounted && confirm) {
      setState(() {
        _operationInProgress = true;
      });
      TmdbWatchlistService watchlistService =
          Provider.of<TmdbWatchlistService>(context, listen: false);
      TmdbUserService userService =
          Provider.of<TmdbUserService>(context, listen: false);

      await watchlistService.retrieveWatchlist(
        userService.accountId,
        userService.sessionId,
        Localizations.localeOf(context),
      );

      while (watchlistService.listIsNotEmpty) {
        if (!context.mounted || _operationInProgress == false) {
          break;
        }

        setState(() {
          _resetTitlesMessage =
              AppLocalizations.of(context)!.resetWatchlistCount;
          _resetTitlesCount = watchlistService.listTitleCount;
        });

        try {
          TmdbTitle? title = watchlistService.getItem(0);

          if (title == null) {
            throw Exception('Failed to retrieve watchlist title');
          }

          await watchlistService.updateWatchlistTitle(
            userService.accountId,
            userService.sessionId,
            title,
            false,
          );
        } catch (error) {
          SnackMessage.showSnackBar(error.toString());
          break;
        }
      }

      setState(() {
        _operationInProgress = false;
        _resetTitlesCount = 0;
      });
    }
  }

  _resetRatings(BuildContext context) async {
    final confirm = await _confirmationDialog(
      context,
      AppLocalizations.of(context)!.imdbResetRateslistConfirmation,
    );
    if (context.mounted && confirm) {
      setState(() {
        _operationInProgress = true;
      });
      TmdbRateslistService rateslistService =
          Provider.of<TmdbRateslistService>(context, listen: false);
      TmdbUserService userService =
          Provider.of<TmdbUserService>(context, listen: false);

      await rateslistService.retrieveRateslist(
        userService.accountId,
        userService.sessionId,
        Localizations.localeOf(context),
      );

      while (rateslistService.listIsNotEmpty) {
        if (!context.mounted || _operationInProgress == false) {
          break;
        }

        setState(() {
          _resetTitlesMessage =
              AppLocalizations.of(context)!.resetRateslistCount;
          _resetTitlesCount = rateslistService.listTitleCount;
        });

        try {
          TmdbTitle? title = rateslistService.getItem(0);

          if (title == null) {
            throw Exception('Failed to retrieve watchlist title');
          }

          await rateslistService.updateTitleRate(
            userService.accountId,
            userService.sessionId,
            title,
            0,
          );
        } catch (error) {
          SnackMessage.showSnackBar(error.toString());
          break;
        }
      }

      setState(() {
        _operationInProgress = false;
        _resetTitlesCount = 0;
      });
    }
  }

  Future<void> _readCsvFromFile(String path) async {
    final rawData = await rootBundle.loadString(path);
    final normalizedData = rawData.replaceAll('\r\n', '\n');
    List<List<dynamic>> csvData =
        const CsvToListConverter(eol: '\n').convert(normalizedData);

    setState(() {
      _csvHeaders =
          csvData.first.map((e) => e.toString().toLowerCase()).toList();
      _imdbIdColumn = _csvHeaders.indexOf('const');
      _imdbTitleColumn = _csvHeaders.indexOf('title');
      _imdbRateColumn = _csvHeaders.indexOf('your rating');
      _csvTitles = csvData
          .where((row) =>
              row.length > _imdbIdColumn &&
              row.length > _imdbTitleColumn &&
              row.length > _imdbRateColumn)
          .toList();
      _csvTitles.removeAt(0);
      _csvTitlesStatus = List.filled(_csvTitles.length, TitleStatus.pending);
      _isRateList = _csvTitles[0][_imdbRateColumn].toString().isNotEmpty;
    });
  }

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      _filenameController.text = file.name;
      _readCsvFromFile(file.path!);
    }
  }

  _importPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                child: Text(AppLocalizations.of(context)!.select),
                onPressed: () => _pickFile(context),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  readOnly: true,
                  controller: _filenameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.imdbImportHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _resetText();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: _filenameController.text.isEmpty ||
                        _isRateList ||
                        _operationInProgress
                    ? null
                    : () => _importWatchlist(context),
                child: Text(AppLocalizations.of(context)!.imdbImportWatchlist),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: _filenameController.text.isNotEmpty &&
                        _isRateList &&
                        _operationInProgress == false
                    ? () => _importRateslist(context)
                    : null,
                child: Text(AppLocalizations.of(context)!.imdbImportRateslist),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: _operationInProgress == true
                    ? () => _operationInProgress = false
                    : null,
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
            ],
          ),
          if (kDebugMode) const SizedBox(height: 10),
          if (kDebugMode)
            Row(
              children: [
                OutlinedButton(
                  onPressed: _operationInProgress == false
                      ? () => _resetWatchlist(context)
                      : null,
                  child: Text(AppLocalizations.of(context)!.imdbResetWatchlist),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: _operationInProgress == false
                      ? () => _resetRatings(context)
                      : null,
                  child: Text(AppLocalizations.of(context)!.imdbResetRateslist),
                ),
                const SizedBox(width: 10),
                if (_resetTitlesCount > 0)
                  Text('$_resetTitlesMessage: $_resetTitlesCount'),
              ],
            ),
        ],
      ),
    );
  }

  _importResultsCell({double? width = 0, Widget child = const SizedBox()}) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: child,
    );
  }

  Widget _infoLine() {
    String totalTitles =
        '${_csvTitles.length} ${AppLocalizations.of(context)!.titles}';
    String importedTitles =
        '${_csvTitlesStatus.where((status) => status == TitleStatus.success).length} ${AppLocalizations.of(context)!.titles}';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(totalTitles),
          Text(importedTitles),
        ],
      ),
    );
  }

  _importResults() {
    return Expanded(
      child: ListView.builder(
        key: const PageStorageKey('ImdbListView'),
        itemCount: _csvTitles.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          IconData status;
          Color statusColor = Colors.grey;

          if (_importId == index) {
            status = Icons.hourglass_empty;
          } else {
            switch (_csvTitlesStatus[index]) {
              case TitleStatus.pending:
                status = Icons.check_box_outline_blank;
              case TitleStatus.success:
                status = Icons.check_box;
                statusColor = Colors.green;
              case TitleStatus.failed:
                status = Icons.cancel_outlined;
                statusColor = Colors.red;
            }
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
                  _importResultsCell(
                      width: 40, child: Icon(status, color: statusColor)),
                  _importResultsCell(
                    width: 150,
                    child: Text(_csvTitles[index][_imdbIdColumn].toString(),
                        style: const TextStyle(fontSize: 12)),
                  ),
                  Expanded(
                    child: _importResultsCell(
                      child: Text(
                        _csvTitles[index][_imdbTitleColumn].toString(),
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (_isRateList)
                    _importResultsCell(
                      width: 40,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _csvTitles[index][_imdbRateColumn].toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  _importWatchlist(BuildContext context) async {
    try {
      setState(() {
        _operationInProgress = true;
      });
      final imdbIds = _csvTitles
          .where((row) => row.length > _imdbIdColumn)
          .map((row) => row[_imdbIdColumn])
          .toList();

      final tmdbBaseService = TmdbBaseService();
      final tmdbSearchService = TmdbSearchService();
      final TmdbUserService tmdbUserService =
          Provider.of<TmdbUserService>(context, listen: false);

      for (int index = 0; index < imdbIds.length; index++) {
        setState(() {
          _importId = index;
        });

        if (!context.mounted || _operationInProgress == false) {
          return;
        }

        final searchResult = await tmdbSearchService.searchImdbTitle(
          imdbIds[index],
          Localizations.localeOf(context),
        );

        if (searchResult.statusCode == 200) {
          if (!context.mounted) {
            return;
          }
          List titlesFromId = TmdbSearchService()
              .fromImdbIdToTitle(tmdbBaseService.body(searchResult));

          if (titlesFromId.isEmpty) {
            _csvTitlesStatus[index] = TitleStatus.failed;
            continue;
          }

          if (Provider.of<TmdbWatchlistService>(context, listen: false)
              .contains(titlesFromId.first)) {
            setState(() {
              _csvTitlesStatus[index] = TitleStatus.success;
            });
            continue;
          }

          TmdbTitle updatedTitle =
              await TmdbTitleService().updateTitleDetails(titlesFromId.first);

          if (!context.mounted) {
            return;
          }

          final watchlistService =
              Provider.of<TmdbWatchlistService>(context, listen: false);

          updatedTitle.listName = watchlistService.listName;
          await watchlistService.updateWatchlistTitle(
            tmdbUserService.accountId,
            tmdbUserService.sessionId,
            updatedTitle,
            true,
          );

          setState(() {
            if (Provider.of<TmdbWatchlistService>(context, listen: false)
                .contains(titlesFromId.first)) {
              _csvTitlesStatus[index] = TitleStatus.success;
            } else {
              _csvTitlesStatus[index] = TitleStatus.failed;
            }
          });
        } else {
          setState(() {
            _csvTitlesStatus[index] = TitleStatus.failed;
          });
        }
      }
    } catch (error) {
      if (context.mounted) {
        SnackMessage.showSnackBar(error.toString());
      }
    } finally {
      setState(() {
        _operationInProgress = false;
      });
    }
  }

  _importRateslist(BuildContext context) async {
    const int idIndex = 0, rateIndex = 1;
    try {
      setState(() {
        _operationInProgress = true;
      });
      final imdbIds = _csvTitles
          .where((row) => row.length > _imdbIdColumn)
          .map((row) => [row[_imdbIdColumn], row[_imdbRateColumn]])
          .toList();

      final tmdbBaseService = TmdbBaseService();
      final tmdbSearchService = TmdbSearchService();
      final tmdbUserService =
          Provider.of<TmdbUserService>(context, listen: false);

      for (int index = 0; index < imdbIds.length; index++) {
        setState(() {
          _importId = index;
        });

        if (!context.mounted || _operationInProgress == false) {
          return;
        }

        final searchResult = await tmdbSearchService.searchImdbTitle(
          imdbIds[index][idIndex],
          Localizations.localeOf(context),
        );

        if (searchResult.statusCode == 200) {
          if (!context.mounted) {
            return;
          }
          List titlesFromId = TmdbSearchService()
              .fromImdbIdToTitle(tmdbBaseService.body(searchResult));

          if (titlesFromId.isEmpty) {
            _csvTitlesStatus[index] = TitleStatus.failed;
            continue;
          }

          // We don't want to re-import a rate (it would change the rating date)... or do we?
          if (Provider.of<TmdbRateslistService>(context, listen: false)
              .contains(titlesFromId.first)) {
            _csvTitlesStatus[index] = TitleStatus.success;
            continue;
          }

          TmdbTitle updatedTitle =
              await TmdbTitleService().updateTitleDetails(titlesFromId.first);

          if (!context.mounted) {
            return;
          }

          final ratelistService =
              Provider.of<TmdbRateslistService>(context, listen: false);

          updatedTitle.listName = ratelistService.listName;
          await ratelistService.updateTitleRate(
            tmdbUserService.accountId,
            tmdbUserService.sessionId,
            updatedTitle,
            imdbIds[index][rateIndex],
          );

          setState(() {
            if (Provider.of<TmdbRateslistService>(context, listen: false)
                .contains(titlesFromId.first)) {
              _csvTitlesStatus[index] = TitleStatus.success;
            } else {
              _csvTitlesStatus[index] = TitleStatus.failed;
            }
          });
        } else {
          setState(() {
            _csvTitlesStatus[index] = TitleStatus.failed;
          });
        }
      }
    } catch (error) {
      if (context.mounted) {
        SnackMessage.showSnackBar(error.toString());
      }
    } finally {
      setState(() {
        _operationInProgress = false;
      });
    }
  }
}
