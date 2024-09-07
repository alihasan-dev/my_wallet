import 'package:flutter/material.dart';

sealed class ApperanceState {}

class ApperanceInitialState extends ApperanceState {}

class ApperanceThemeChangeState extends ApperanceState {
  ThemeMode themeMode;

  ApperanceThemeChangeState({required this.themeMode});
}
