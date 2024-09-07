import 'package:flutter/material.dart';

sealed class AppearanceEvent {}

class ApperanceChangeThemeEvent extends AppearanceEvent {
  ThemeMode themeMode;

  ApperanceChangeThemeEvent({required this.themeMode});
}