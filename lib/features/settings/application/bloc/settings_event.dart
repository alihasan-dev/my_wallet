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

class SettingsOnChangeTransactionDetailsEvent extends SettingsEvent {
  bool isEnable;

  SettingsOnChangeTransactionDetailsEvent({this.isEnable = false});
}

class SettingsOnChangeBiometricEvent extends SettingsEvent {
  bool enableBiometric;

  SettingsOnChangeBiometricEvent({this.enableBiometric = false});
}
class SettingsOnChangeTransactionDescriptionEvent extends SettingsEvent {
  bool isEnable;

  SettingsOnChangeTransactionDescriptionEvent({this.isEnable = false});
}

class SettingsOnDashboardTransactionModeEvent extends SettingsEvent {
  DashboardAmountMode mode;

  SettingsOnDashboardTransactionModeEvent({required this.mode});
}