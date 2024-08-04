part of 'appearance_bloc.dart';

sealed class AppearanceEvent {}

class ApperanceChangeThemeEvent extends AppearanceEvent {
  ThemeMode themeMode;

  ApperanceChangeThemeEvent({required this.themeMode});
}