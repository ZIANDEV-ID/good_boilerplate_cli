import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.nativeName,
    required this.flag,
  });

  final String code;
  final String nativeName;
  final String flag;

  Locale get locale => Locale(code);

  static const values = [
    AppLanguage(code: 'en', nativeName: 'English', flag: '🇺🇸'),
    AppLanguage(code: 'id', nativeName: 'Bahasa Indonesia', flag: '🇮🇩'),
    AppLanguage(code: 'es', nativeName: 'Español', flag: '🇪🇸'),
    AppLanguage(code: 'fr', nativeName: 'Français', flag: '🇫🇷'),
    AppLanguage(code: 'de', nativeName: 'Deutsch', flag: '🇩🇪'),
    AppLanguage(code: 'it', nativeName: 'Italiano', flag: '🇮🇹'),
    AppLanguage(code: 'pt', nativeName: 'Português', flag: '🇵🇹'),
    AppLanguage(code: 'nl', nativeName: 'Nederlands', flag: '🇳🇱'),
    AppLanguage(code: 'ru', nativeName: 'Русский', flag: '🇷🇺'),
    AppLanguage(code: 'ar', nativeName: 'العربية', flag: '🇸🇦'),
    AppLanguage(code: 'hi', nativeName: 'हिन्दी', flag: '🇮🇳'),
    AppLanguage(code: 'zh', nativeName: '中文', flag: '🇨🇳'),
    AppLanguage(code: 'ja', nativeName: '日本語', flag: '🇯🇵'),
    AppLanguage(code: 'ko', nativeName: '한국어', flag: '🇰🇷'),
    AppLanguage(code: 'tr', nativeName: 'Türkçe', flag: '🇹🇷'),
    AppLanguage(code: 'vi', nativeName: 'Tiếng Việt', flag: '🇻🇳'),
    AppLanguage(code: 'th', nativeName: 'ไทย', flag: '🇹🇭'),
    AppLanguage(code: 'ms', nativeName: 'Bahasa Melayu', flag: '🇲🇾'),
    AppLanguage(code: 'fil', nativeName: 'Filipino', flag: '🇵🇭'),
    AppLanguage(code: 'sw', nativeName: 'Kiswahili', flag: '🇹🇿'),
  ];

  static List<Locale> get supportedLocales {
    return values.map((language) => language.locale).toList();
  }

  static AppLanguage fromCode(String code) {
    return values.firstWhere(
      (language) => language.code == code,
      orElse: () => values.first,
    );
  }
}

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit(this._preferences)
    : super(
        AppLanguage.fromCode(
          _preferences.getString(_languageKey) ?? 'en',
        ).locale,
      );

  static const _languageKey = 'language_code';

  final SharedPreferences _preferences;

  AppLanguage get currentLanguage => AppLanguage.fromCode(state.languageCode);

  Future<void> setLanguage(AppLanguage language) async {
    await _preferences.setString(_languageKey, language.code);
    emit(language.locale);
  }
}
