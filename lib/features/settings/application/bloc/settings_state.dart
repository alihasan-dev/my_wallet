part of 'settings_bloc.dart';

sealed class SettingsState {}

class SettingsInitialState extends SettingsState {}

class SettingsThemeChangeState extends SettingsState {
  ThemeMode themeMode;

  SettingsThemeChangeState({required this.themeMode});
}


class SettingsUserDetailsState extends SettingsState {
  UserModel userModel;

  SettingsUserDetailsState({required this.userModel});
}