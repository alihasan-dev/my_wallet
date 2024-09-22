import 'package:flutter/material.dart';

sealed class AppearanceEvent {}

class ApperanceChangeThemeEvent extends AppearanceEvent {
  ThemeMode themeMode;

  ApperanceChangeThemeEvent({required this.themeMode});
}

class ApperanceUserDetailsEvent extends AppearanceEvent {}

class ApperanceOnChangeVerifiedEvent extends AppearanceEvent {
  bool isVerified;

  ApperanceOnChangeVerifiedEvent({this.isVerified = false});
}