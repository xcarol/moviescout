class YoutubeQueryMapper {
  static const Map<String, String> _languageQueries = {
    'en': 'trailer',
    'es': 'tráiler español',
    'ca': 'tràiler català',
    'fr': 'bande-annonce français',
    'de': 'trailer deutsch',
    'it': 'trailer italiano',
    'pt': 'trailer português',
    'ru': 'трейлер на русском',
    'ja': '予告編',
    'ko': '예고편',
    'zh': '预告片',
    'hi': 'ट्रेलर हिंदी',
    'ar': 'إعلان فيلم',
    'nl': 'trailer nederlands',
    'tr': 'fragman türkçe',
    'pl': 'zwiastun polski',
    'sv': 'trailer svensk',
    'no': 'trailer norsk',
    'fi': 'traileri suomeksi',
    'da': 'trailer dansk',
    'el': 'τρέιλερ ελληνικά',
    'hu': 'előzetes magyar',
    'cs': 'trailer česky',
    'ro': 'trailer română',
    'id': 'trailer indonesia',
    'th': 'ตัวอย่างภาพยนตร์',
    'vi': 'trailer vietsub',
    'uk': 'трейлер українською',
    'he': 'טריילר מתורגם',
    'bg': 'трейлър бг аудио',
    'hr': 'trailer hrvatski',
    'sk': 'trailer slovensky',
    'sr': 'trailer srpski',
    'ms': 'trailer melayu',
    'tl': 'trailer tagalog',
    'ta': 'trailer tamil',
    'te': 'trailer telugu',
    'ml': 'trailer malayalam',
    'ur': 'trailer urdu',
    'fa': 'تریلر دوبله فارسی',
    'bn': 'ট্রেইলার বাংলা',
    'gu': 'ટ્રેલર ગુજરાતી',
    'mr': 'ट्रेलर मराठी',
  };

  static const Map<String, String> _countryQueries = {
    'es': 'tráiler español',
    'mx': 'tráiler latino',
    'ar': 'tráiler latino',
    'co': 'tráiler latino',
    'cl': 'tráiler latino',
    'pe': 'tráiler latino',
    've': 'tráiler latino',
    'br': 'trailer dublado pt-br',
    'ca': 'trailer', // Avoid 'ca' as catalan shortcut
    'us': 'trailer',
    'gb': 'trailer',
    'au': 'trailer',
    'fr': 'bande-annonce vf',
    'de': 'trailer deutsch',
    'it': 'trailer ita',
  };

  static const List<String> forbiddenKeywords = [
    // English
    'review',
    'reaction',
    'gameplay',
    'ost',
    'soundtrack',
    'interview',
    'making of',
    'behind the scenes',
    'deleted scene',
    'theory',
    'ending explained',
    'breakdown',
    'podcast',
    'vlog',
    // Spanish
    'reaccion',
    'reacción',
    'analisis',
    'análisis',
    'reseña',
    'banda sonora',
    'entrevista',
    'detras de camaras',
    'detrás de cámaras',
    'escena eliminada',
    'teoria',
    'teoría',
    'explicado',
    'resumen',
    'critica',
    'crítica',
    // Catalan
    'reacció', 'anàlisi', 'ressenya', 'darrere les càmeres', 'explicat',
    'resum',
    // French
    'critique', 'réaction', 'bande originale', 'entrevue', 'coulisses',
    'scène coupée', 'théorie', 'explication',
    // German
    'kritik', 'reaktion', 'spielverlauf', 'filmmusik', 'hinter den kulissen',
    'gelöschte szene', 'theorie', 'erklärt',
    // Portuguese
    'crítica', 'reação', 'análise', 'trilha sonora', 'por trás das câmeras',
    'cena deletada', 'teoria', 'explicado',
    // Italian
    'recensione', 'reazione', 'colonna sonora', 'dietro le quinte',
    'scena tagliata', 'spiegato', 'spiegazione',
  ];

  static const List<String> positiveKeywords = [
    // English
    'trailer', 'teaser', 'clip', 'official', 'promo', 'sneak peek',
    'first look',
    // Spanish / Catalan
    'avance', 'oficial', 'catala', 'català', 'castellano', 'español', 'latino',
    'tráiler', 'tràiler',
    // French
    'bande-annonce', 'officiel', 'extrait',
    // German
    'offiziell', 'vorschau',
    // Portuguese
    'dublado', 'legendado',
    // Italian
    'ufficiale',
  ];

  static String getQueryForLanguage(String langCode, String title) {
    if (langCode.isEmpty) return 'trailer $title';
    final prefix = _languageQueries[langCode.toLowerCase()] ?? 'trailer';
    return '$prefix $title';
  }

  static String getQueryForCountry(String countryCode, String title) {
    if (countryCode.isEmpty) return 'trailer $title';
    final prefix = _countryQueries[countryCode.toLowerCase()] ?? 'trailer';
    return '$prefix $title';
  }
}
