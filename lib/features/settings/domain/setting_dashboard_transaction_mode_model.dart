import 'package:my_wallet/features/settings/domain/settings_model.dart';

class SettingDashboardAmountModeModel {
  String title;
  String subtitle;
  DashboardAmountMode mode;

  SettingDashboardAmountModeModel({
    this.title = '',
    this.subtitle = '',
    this.mode = DashboardAmountMode.latestTransaction
  });
}