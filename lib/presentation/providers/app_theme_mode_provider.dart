import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeModeProvider = NotifierProvider<AppThemeModeNotifier, ThemeMode>((){
  return AppThemeModeNotifier();
});

class AppThemeModeNotifier extends Notifier<ThemeMode>{
  @override
  ThemeMode build() {
    return ThemeMode.dark;
  }

  void toggleThemeMode() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}