import 'dart:ui';

extension CheckLanguage on Locale {
  ///is the current language is Arablic.
  bool get isArabic => languageCode.toLowerCase() == 'ar';

  ///is the current language is English.
  bool get isEnglish => languageCode.toLowerCase() == 'en';
}
