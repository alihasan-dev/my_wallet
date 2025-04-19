part of 'transaction_screen.dart';

class TransactionDisableDialog extends StatelessWidget {
  const TransactionDisableDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
      backgroundColor: Helper.isDark ? AppColors.topDarkColor : AppColors.white,
      insetPadding: const EdgeInsets.all(AppSize.s12),
      contentPadding: const EdgeInsets.all(AppSize.s15),
      content: Container(
        width: kIsWeb ? MyAppTheme.columnWidth : (MyAppTheme.columnWidth - AppSize.s40),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSize.s10)),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Row(
              children: [
                Icon(
                  AppIcons.infoIcon, 
                  size: AppSize.s28,
                  color: AppColors.primaryColor
                ),
                const SizedBox(width: AppSize.s5),
                CustomText(
                  title: 'Transaction details disable',
                  textStyle: getSemiBoldStyle(),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s5),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 5),
              child: CustomText(
                title: 'To visualize your transaction details, Please enable this feature from Settings.',
                // title: localizations.signupWarningMsg,
                textSize: AppSize.s14,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.pop(), 
                  child: CustomText(
                    title: localizations.gotIt, 
                    textStyle: getSemiBoldStyle(color: AppColors.primaryColor)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}