class TmdbRegion {
  static const String isoCodeKey = 'iso_3166_1';
  static const String englishNameKey = 'english_name';
  static const String nativeNameKey = 'native_name';

  final String isoCode;
  final String englishName;
  final String nativeName;

  const TmdbRegion({
    required this.isoCode,
    required this.englishName,
    required this.nativeName,
  });

  factory TmdbRegion.fromJson(Map<String, dynamic> json) {
    return TmdbRegion(
      isoCode: (json[isoCodeKey] ?? '') as String,
      englishName: (json[englishNameKey] ?? '') as String,
      nativeName: (json[nativeNameKey] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
        isoCodeKey: isoCode,
        englishNameKey: englishName,
        nativeNameKey: nativeName,
      };

  String get displayName => nativeName.isNotEmpty ? nativeName : englishName;
}
