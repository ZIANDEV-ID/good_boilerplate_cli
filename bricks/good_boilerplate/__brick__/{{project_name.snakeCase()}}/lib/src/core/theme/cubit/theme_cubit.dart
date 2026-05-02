import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._preferences)
      : super(
          _preferences.getBool(_themeModeKey) ?? false
              ? ThemeMode.dark
              : ThemeMode.light,
        );

  static const _themeModeKey = 'is_dark_mode';

  final SharedPreferences _preferences;

  bool get isDarkMode => state == ThemeMode.dark;

  Future<void> setDarkMode(bool isDarkMode) async {
    await _preferences.setBool(_themeModeKey, isDarkMode);
    emit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggle() => setDarkMode(!isDarkMode);
}
