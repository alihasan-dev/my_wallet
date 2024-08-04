part of 'my_app_bloc.dart';

sealed class MyAppEvent {}

class MyAppChangeThemeEvent extends MyAppEvent {
  ThemeMode themeMode;
  MyAppChangeThemeEvent({required this.themeMode});
}

class MyAppChangeLanguageEvent extends MyAppEvent {
  Locale locale;
  MyAppChangeLanguageEvent({required this.locale});
}