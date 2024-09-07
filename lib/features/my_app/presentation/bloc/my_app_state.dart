import 'package:flutter/material.dart';

sealed class MyAppState {}

class MyAppInitialState extends MyAppState {
  ThemeMode themeMode;
  Locale locale;
  MyAppInitialState({required this.themeMode, required this.locale});
}