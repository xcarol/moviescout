import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/core/theme/app_breakpoints.dart';
import 'package:moviescout/features/import/services/imdb_import_service.dart';
import 'package:moviescout/features/watchlist/services/rateslist_service.dart';
import 'package:moviescout/features/watchlist/services/watchlist_service.dart';
import 'package:provider/provider.dart';

class ImportIMDB extends StatefulWidget {
  const ImportIMDB({super.key});

  @override
  State<ImportIMDB> createState() => _ImportIMDBState();
}

class _ImportIMDBState extends State<ImportIMDB> {
  late final TextEditingController _filenameController;
  final ImdbImportService _importService = ImdbImportService();

  ImdbCsvData _csvData = const ImdbCsvData(
    headers: [],
    rows: [],
    imdbIdColumn: -1,
    imdbTitleColumn: -1,
    imdbRateColumn: -1,
    isRateList: false,
  );
  List<ImdbTitleStatus> _csvTitlesStatus = const [];
  int _importId = -1;
  bool _operationInProgress = false;

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
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxContentWidth,
          ),
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
      ),
    );
  }

  void _resetText() {
    _filenameController.clear();
    setState(() {
      _importId = -1;
      _csvData = const ImdbCsvData(
        headers: [],
        rows: [],
        imdbIdColumn: -1,
        imdbTitleColumn: -1,
        imdbRateColumn: -1,
        isRateList: false,
      );
      _csvTitlesStatus = const [];
    });
  }

  Future<void> _readCsvFromFile(PlatformFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final data = ImdbImportService.parseCsvBytes(bytes);
      if (data.isEmpty) return;

      setState(() {
        _csvData = data;
        _csvTitlesStatus = List.filled(data.length, ImdbTitleStatus.pending);
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
                        _csvData.isRateList ||
                        _operationInProgress
                    ? null
                    : () => _importWatchlist(context),
                child: Text(AppLocalizations.of(context)!.imdbImportWatchlist),
              ),
              OutlinedButton(
                onPressed: _filenameController.text.isNotEmpty &&
                        _csvData.isRateList &&
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
    final dividerColor =
        Theme.of(context).extension<CustomColors>()?.dividerColor ??
            Theme.of(context).colorScheme.outlineVariant;
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: dividerColor,
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: child,
    );
  }

  Widget _infoLine() {
    String totalTitles =
        '${_csvData.length} ${AppLocalizations.of(context)!.titles}';
    String importedTitles =
        '${_csvTitlesStatus.where((status) => status == ImdbTitleStatus.success).length} ${AppLocalizations.of(context)!.titles}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: ListView.builder(
        key: const PageStorageKey('ImdbListView'),
        itemCount: _csvData.rows.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          IconData status;
          Color statusColor = colorScheme.onSurfaceVariant;

          if (_importId == index) {
            status = Icons.hourglass_empty;
          } else {
            switch (_csvTitlesStatus[index]) {
              case ImdbTitleStatus.pending:
                status = Icons.check_box_outline_blank;
                break;
              case ImdbTitleStatus.success:
                status = Icons.check_box;
                statusColor = colorScheme.primary;
                break;
              case ImdbTitleStatus.failed:
                status = Icons.cancel_outlined;
                statusColor = colorScheme.error;
                break;
            }
          }

          final row = _csvData.rows[index];
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
                    ),
                  ),
                  _importResultsCell(
                    width: 100,
                    child: Text(
                      row[_csvData.imdbIdColumn].toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: _importResultsCell(
                      child: Text(
                        row[_csvData.imdbTitleColumn].toString(),
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (_csvData.isRateList)
                    _importResultsCell(
                      width: 40,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          row[_csvData.imdbRateColumn].toString(),
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
      setState(() => _operationInProgress = true);

      final watchlistService =
          Provider.of<WatchlistService>(context, listen: false);
      final userLocale = Localizations.localeOf(context);

      for (int index = 0; index < _csvData.rows.length; index++) {
        if (!mounted || !_operationInProgress) return;

        setState(() => _importId = index);

        final imdbId = _csvData.rows[index][_csvData.imdbIdColumn].toString();
        final status = await _importService.importWatchlistEntry(
          imdbId: imdbId,
          locale: userLocale,
          watchlistService: watchlistService,
        );

        if (mounted) {
          setState(() => _csvTitlesStatus[index] = status);
        }
      }
    } catch (error, stackTrace) {
      if (mounted) {
        ErrorService.log(error, stackTrace: stackTrace);
      }
    } finally {
      if (mounted) {
        setState(() => _operationInProgress = false);
      }
    }
  }

  void _importRateslist(BuildContext context) async {
    try {
      setState(() => _operationInProgress = true);

      final rateslistService =
          Provider.of<RateslistService>(context, listen: false);
      final userLocale = Localizations.localeOf(context);

      for (int index = 0; index < _csvData.rows.length; index++) {
        if (!mounted || !_operationInProgress) return;

        setState(() => _importId = index);

        final row = _csvData.rows[index];
        final imdbId = row[_csvData.imdbIdColumn].toString();
        final rawRating = row[_csvData.imdbRateColumn];

        final status = await _importService.importRateslistEntry(
          imdbId: imdbId,
          rawRating: rawRating,
          locale: userLocale,
          rateslistService: rateslistService,
        );

        if (mounted) {
          setState(() => _csvTitlesStatus[index] = status);
        }
      }
    } catch (error, stackTrace) {
      if (mounted) {
        ErrorService.log(error, stackTrace: stackTrace);
      }
    } finally {
      if (mounted) {
        setState(() => _operationInProgress = false);
      }
    }
  }
}
