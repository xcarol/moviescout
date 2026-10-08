import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_region.dart';
import 'package:moviescout/services/settings/region_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_provider_service.dart';
import 'package:moviescout/widgets/inputs_and_filters/text_filter_widget.dart';
import 'package:provider/provider.dart';

class RegionForm extends StatefulWidget {
  const RegionForm({super.key, required this.currentRegion});

  final String? currentRegion;

  @override
  State<RegionForm> createState() => _RegionFormState();
}

class _RegionFormState extends State<RegionForm> {
  late String? _selectedRegion;
  bool _isLoading = true;
  List<TmdbRegion> _allRegions = [];
  List<TmdbRegion> _filteredRegions = [];

  final TextEditingController _filterController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _normalize(String s) => removeDiacritics(s.toLowerCase());

  @override
  void initState() {
    super.initState();
    _selectedRegion = widget.currentRegion;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRegions();
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadRegions() async {
    final providerService =
        Provider.of<TmdbProviderService>(context, listen: false);
    final regions = await providerService.getAvailableRegions();
    if (!mounted) return;
    setState(() {
      _allRegions = regions;
      _isLoading = false;
      _applyFilter();
    });
  }

  void _applyFilter([String? text]) {
    final query = _normalize(text ?? _filterController.text).trim();
    if (query.isEmpty) {
      _filteredRegions = _allRegions;
    } else {
      _filteredRegions = _allRegions.where((region) {
        return _normalize(region.displayName).contains(query) ||
            _normalize(region.englishName).contains(query) ||
            region.isoCode.toLowerCase().contains(query);
      }).toList();
    }
  }

  Widget _buildRadioTile({required String? value, required String title}) {
    final isSelected = _selectedRegion == value;
    return RadioListTile<String?>(
      value: value,
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      selected: isSelected,
    );
  }

  String? _findRegionName(String? isoCode) {
    if (isoCode == null) return null;
    final found = _allRegions.cast<TmdbRegion?>().firstWhere(
      (r) => r?.isoCode.toUpperCase() == isoCode.toUpperCase(),
      orElse: () => null,
    );
    return found?.displayName;
  }

  @override
  Widget build(BuildContext context) {
    final query = _normalize(_filterController.text).trim();
    final autoText = AppLocalizations.of(context)!.regionAuto;
    final regionService = RegionService();
    final detected = regionService.detectedRegion;
    String autoLabel = autoText;
    if (detected != null && detected.isNotEmpty) {
      final name =
          _findRegionName(detected) ?? regionService.getRegionName(detected);
      if (name.isNotEmpty) {
        autoLabel = '$autoText ($name)';
      } else {
        autoLabel = '$autoText ($detected)';
      }
    }
    final showAuto = query.isEmpty || _normalize(autoLabel).contains(query);
    final itemCount = (showAuto ? 1 : 0) + _filteredRegions.length;

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.selectRegion,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height * 0.65,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextFilterWidget(
                    controller: _filterController,
                    focusNode: _focusNode,
                    hintText: AppLocalizations.of(context)!.searchRegion,
                    height: 36,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    onChanged: (value) {
                      setState(() {
                        _applyFilter(value);
                      });
                    },
                    onCleared: () {
                      setState(() {
                        _applyFilter('');
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: itemCount == 0
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)!.emptyList,
                            ),
                          )
                        : RadioGroup<String?>(
                            groupValue: _selectedRegion,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedRegion = newValue;
                              });
                            },
                            child: ListView.separated(
                              itemCount: itemCount,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 6),
                              itemBuilder: (context, index) {
                                if (showAuto && index == 0) {
                                  return _buildRadioTile(
                                    value: null,
                                    title: autoLabel,
                                  );
                                }
                                final regionIndex =
                                    showAuto ? index - 1 : index;
                                final region = _filteredRegions[regionIndex];
                                return _buildRadioTile(
                                  value: region.isoCode,
                                  title: region.displayName,
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedRegion);
          },
          child: Text(AppLocalizations.of(context)!.select),
        ),
      ],
    );
  }
}
