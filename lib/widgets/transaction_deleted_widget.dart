import 'package:flutter/material.dart';
import 'package:my_wallet/l10n/app_localizations.dart';
import '../constants/app_size.dart';
import '../widgets/custom_text.dart';
import '../constants/app_color.dart';

class TransactionDeletedWidget extends StatelessWidget {
  final AppLocalizations appLocalization;
  const TransactionDeletedWidget({super.key, required this.appLocalization});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.s2, 
        horizontal: AppSize.s5
      ),
      child: CustomText(
        title: appLocalization.deleted,
        textStyle: TextStyle(
          fontStyle: FontStyle.italic,
          color: AppColors.grey,
          fontSize: 13
        ),
      ),
    );
  }
  
}