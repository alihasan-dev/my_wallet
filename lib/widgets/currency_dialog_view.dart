import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_wallet/constants/app_color.dart';
import 'package:sample_formatter/sample_formatter.dart';
import '../constants/app_size.dart';
import '../constants/app_theme.dart';
import '../utils/app_extension_method.dart';
import '../utils/helper.dart';

class CurrencyDialogView extends StatelessWidget {
  final Function(CurrencyModel?)? onSelect;
  final CurrencyModel? selectedCurrency;
  const CurrencyDialogView({this.onSelect, this.selectedCurrency, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
      backgroundColor: Helper.isDark ? AppColors.topDarkColor : AppColors.white,
      insetPadding: const EdgeInsets.all(AppSize.s12),
      contentPadding: const EdgeInsets.all(AppSize.s15),
      content: SizedBox(
        width: kIsWeb ? MyAppTheme.columnWidth : (MyAppTheme.columnWidth - AppSize.s40),
        height: context.screenHeight * 0.70,
        child: CurrencyPickerView(
          backgroundColor: AppColors.white,
          selectedCountryModel:  selectedCurrency, //CurrencyModel(currencyCode: "INR"),
          onSelect: onSelect
        ),
      ),
    );
  }
}