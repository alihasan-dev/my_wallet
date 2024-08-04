part of 'my_app_bloc.dart';

sealed class MyAppState {}

class MyAppInitialState extends MyAppState {
  ThemeMode themeMode;
  Locale locale;
  MyAppInitialState({required this.themeMode, required this.locale});
}