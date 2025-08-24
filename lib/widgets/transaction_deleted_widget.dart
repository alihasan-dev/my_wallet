import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_size.dart';
import '../widgets/custom_text.dart';
import '../constants/app_color.dart';

class TransactionDeletedWidget extends StatelessWidget {
  
  final AppLocalizations appLocalization;
  
  const TransactionDeletedWidget({
    super.key, 
    required this.appLocalization
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      title: appLocalization.deleted,
      textStyle: TextStyle(
        color: AppColors.grey,
        fontSize: AppSize.s14
      ),
    );
  }
  
}