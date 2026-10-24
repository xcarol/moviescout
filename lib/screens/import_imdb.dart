import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/core/tmdb_base_service.dart';
import 'package:moviescout/services/lists/rateslist_service.dart';
import 'package:moviescout/services/tmdb_content/search_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_title_service.dart';
import 'package:moviescout/services/lists/watchlist_service.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
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

  final String searchServiceListName = 'importImdb';

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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.imdbImport),
      ),
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

  void _resetText() {
    _filenameController.clear();
    setState(() {
      _importId = -1;
      _csvTitles = List.empty();
      _csvTitlesStatus = List.empty();
      _filenameController.clear();
    });
  }

  Future<void> _readCsvFromFile(PlatformFile file) async {
    try {
      final bytes = await file.readAsBytes();
      String rawData;
      try {
        rawData = utf8.decode(bytes);
      } catch (_) {
        rawData = latin1.decode(bytes);
      }

      final normalizedData = rawData.replaceAll('\r\n', '\n');
      List<List<dynamic>> csvData = const CsvDecoder().convert(normalizedData);
      if (csvData.isEmpty) return;

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
                (_imdbRateColumn == -1 || row.length > _imdbRateColumn))
            .toList();
        if (_csvTitles.isNotEmpty) {
          _csvTitles.removeAt(0);
        }
        _csvTitlesStatus = List.filled(_csvTitles.length, TitleStatus.pending);
        _isRateList = _imdbRateColumn != -1 &&
            _csvTitles.isNotEmpty &&
            _csvTitles[0][_imdbRateColumn].toString().isNotEmpty;
      });
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error reading CSV file',
      );
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    try {
      final result = await FilePicker.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        _filenameController.text = file.name;
        await _readCsvFromFile(file);
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error picking file',
      );
    }
  }

  Widget _importPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              OutlinedButton(
                onPressed:
                    _operationInProgress ? null : () => _pickFile(context),
                child: Text(AppLocalizations.of(context)!.select),
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
                      onPressed:
                          _operationInProgress ? null : () => _resetText(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              OutlinedButton(
                onPressed: _filenameController.text.isEmpty ||
                        _isRateList ||
                        _operationInProgress
                    ? null
                    : () => _importWatchlist(context),
                child: Text(AppLocalizations.of(context)!.imdbImportWatchlist),
              ),
              OutlinedButton(
                onPressed: _filenameController.text.isNotEmpty &&
                        _isRateList &&
                        !_operationInProgress
                    ? () => _importRateslist(context)
                    : null,
                child: Text(AppLocalizations.of(context)!.imdbImportRateslist),
              ),
              if (_operationInProgress)
                OutlinedButton(
                  onPressed: () => setState(() => _operationInProgress = false),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _importResultsCell(
      {double? width = 0, Widget child = const SizedBox()}) {
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

  Widget _importResults() {
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
                break;
              case TitleStatus.success:
                status = Icons.check_box;
                statusColor = Colors.green;
                break;
              case TitleStatus.failed:
                status = Icons.cancel_outlined;
                statusColor = Colors.red;
                break;
            }
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
                  _importResultsCell(
                      width: 40,
                      child: Icon(
                        status,
                        color: statusColor,
                      )),
                  _importResultsCell(
                    width: 100,
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

  void _importWatchlist(BuildContext context) async {
    try {
      setState(() {
        _operationInProgress = true;
      });
      final imdbIds = _csvTitles
          .where((row) => row.length > _imdbIdColumn)
          .map((row) => row[_imdbIdColumn])
          .toList();

      final watchlistService =
          Provider.of<WatchlistService>(context, listen: false);
      final tmdbBaseService = TmdbBaseService();
      final tmdbSearchService = SearchService(
        searchServiceListName,
        context.read<LocalTitleRepository>(),
      );
      final userLocale = Localizations.localeOf(context);

      for (int index = 0; index < imdbIds.length; index++) {
        if (!mounted || !_operationInProgress) return;

        setState(() {
          _importId = index;
        });

        final searchResult = await tmdbSearchService.searchImdbTitle(
          imdbIds[index],
          userLocale,
        );

        if (searchResult.statusCode == 200) {
          if (!mounted) return;

          List titlesFromId = tmdbSearchService
              .fromImdbIdToTitle(tmdbBaseService.body(searchResult));

          if (titlesFromId.isEmpty) {
            if (mounted) {
              setState(() {
                _csvTitlesStatus[index] = TitleStatus.failed;
              });
            }
            continue;
          }

          if (await watchlistService.contains(titlesFromId.first)) {
            if (mounted) {
              setState(() {
                _csvTitlesStatus[index] = TitleStatus.success;
              });
            }
            continue;
          }

          TmdbTitle updatedTitle =
              await TmdbTitleService().updateTitleDetails(titlesFromId.first);

          if (!mounted) return;

          await watchlistService.updateWatchlistTitle(
            updatedTitle,
            true,
          );

          final isSuccess = await watchlistService.contains(titlesFromId.first);
          if (mounted) {
            setState(() {
              _csvTitlesStatus[index] =
                  isSuccess ? TitleStatus.success : TitleStatus.failed;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _csvTitlesStatus[index] = TitleStatus.failed;
            });
          }
        }
      }
    } catch (error, stackTrace) {
      if (mounted) {
        ErrorService.log(
          error,
          stackTrace: stackTrace,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _operationInProgress = false;
        });
      }
    }
  }

  void _importRateslist(BuildContext context) async {
    const int idIndex = 0, rateIndex = 1;
    try {
      setState(() {
        _operationInProgress = true;
      });
      final imdbIds = _csvTitles
          .where((row) => row.length > _imdbIdColumn)
          .map((row) => [row[_imdbIdColumn], row[_imdbRateColumn]])
          .toList();

      final ratelistService =
          Provider.of<RateslistService>(context, listen: false);
      final tmdbBaseService = TmdbBaseService();
      final tmdbSearchService = SearchService(
        searchServiceListName,
        context.read<LocalTitleRepository>(),
      );
      final userLocale = Localizations.localeOf(context);

      for (int index = 0; index < imdbIds.length; index++) {
        if (!mounted || !_operationInProgress) return;

        setState(() {
          _importId = index;
        });

        final searchResult = await tmdbSearchService.searchImdbTitle(
          imdbIds[index][idIndex],
          userLocale,
        );

        if (searchResult.statusCode == 200) {
          if (!mounted) return;

          List titlesFromId = tmdbSearchService
              .fromImdbIdToTitle(tmdbBaseService.body(searchResult));

          if (titlesFromId.isEmpty) {
            if (mounted) {
              setState(() {
                _csvTitlesStatus[index] = TitleStatus.failed;
              });
            }
            continue;
          }

          if (await ratelistService.contains(titlesFromId.first)) {
            if (mounted) {
              setState(() {
                _csvTitlesStatus[index] = TitleStatus.success;
              });
            }
            continue;
          }

          TmdbTitle updatedTitle =
              await TmdbTitleService().updateTitleDetails(titlesFromId.first);

          if (!mounted) return;

          final rawRating = imdbIds[index][rateIndex];
          final double parsedRating = (rawRating is num)
              ? rawRating.toDouble()
              : double.tryParse(rawRating.toString()) ?? 0.0;

          await ratelistService.updateTitleRate(
            updatedTitle,
            parsedRating,
          );

          final isSuccess = await ratelistService.contains(titlesFromId.first);
          if (mounted) {
            setState(() {
              _csvTitlesStatus[index] =
                  isSuccess ? TitleStatus.success : TitleStatus.failed;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _csvTitlesStatus[index] = TitleStatus.failed;
            });
          }
        }
      }
    } catch (error, stackTrace) {
      if (mounted) {
        ErrorService.log(
          error,
          stackTrace: stackTrace,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _operationInProgress = false;
        });
      }
    }
  }
}
