import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_wallet/constants/app_strings.dart';
import '../../../utils/app_extension_method.dart';
import '../../../utils/preferences.dart';
import '../../../widgets/custom_checkbox_widget.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_size.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/helper.dart';
import '../../../widgets/custom_text.dart';
import '../domain/setting_dashboard_transaction_mode_model.dart';
import '../domain/settings_model.dart';

class TransactionModeDialog extends StatelessWidget {
  final Function(DashboardAmountMode)? onChange;
  final List<SettingDashboardAmountModeModel> dashboardTransactionModeList;
  const TransactionModeDialog({
    super.key, 
    this.dashboardTransactionModeList = const [],
    this.onChange
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
      backgroundColor: Helper.isDark ? AppColors.topDarkColor : AppColors.white,
      insetPadding: const EdgeInsets.all(AppSize.s12),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSize.s18, vertical: AppSize.s16),
      content: Container(
        width: kIsWeb ? MyAppTheme.columnWidth : (MyAppTheme.columnWidth - AppSize.s60),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSize.s10)),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title: localizations.transaction_mode,
                  textStyle: getSemiBoldStyle(),
                ),
              ],
            ),
            SizedBox(height: AppSize.s4),
            ...List.generate(
              dashboardTransactionModeList.length, 
              (index) {
                final item = dashboardTransactionModeList[index]; 
                bool isSelected = DashboardAmountModeExtension.fromValue(Preferences.getString(key: AppStrings.prefDashboardAmountMode)) == item.mode;
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.translate(
                        offset: Offset(0, 2),
                        child: Transform.scale(
                          scale: 0.85,
                          child: CustomCheckBoxWidget(
                            value: isSelected 
                            ? true
                            : false, 
                            onChange: (_) {
                              onChange?.call(item.mode);
                            }
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            CustomText(
                              title: item.title
                            ),
                            CustomText(
                              title: item.subtitle,
                              textSize: 12,
                              textColor: AppColors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
            SizedBox(height: AppSize.s14),
            Row(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.campaign_rounded, size: 20, color: AppColors.grey),
                Expanded(
                  child: Text(
                    localizations.transaction_mode_info_msg,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.s5),
          ],
        ),
      )
    );
  }
}