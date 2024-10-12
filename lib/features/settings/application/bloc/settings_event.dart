part of 'settings_bloc.dart';


sealed class SettingsEvent {}

class SettingsChangeThemeEvent extends SettingsEvent {
  ThemeMode themeMode;

  SettingsChangeThemeEvent({required this.themeMode});
}

class SettingsUserDetailsEvent extends SettingsEvent {}

class SettingsOnChangeVerifiedEvent extends SettingsEvent {
  bool isVerified;

  SettingsOnChangeVerifiedEvent({this.isVerified = false});
}