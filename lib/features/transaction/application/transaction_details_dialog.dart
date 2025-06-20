import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_size.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_theme.dart';
import '../../../utils/helper.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';
import 'bloc/transaction_bloc.dart';

class TransactionDetailsDialog extends StatefulWidget {

  final Function(String, String, String) onAdd;
  const TransactionDetailsDialog({
    super.key,
    required this.onAdd
  });

  @override
  State<TransactionDetailsDialog> createState() => _TransactionDetailsDialogState();
}

class _TransactionDetailsDialogState extends State<TransactionDetailsDialog> {

  late TextEditingController descriptionText;
  late TextEditingController quantityText;
  late TextEditingController rateText;

  @override
  void initState() {
    descriptionText = TextEditingController();
    quantityText = TextEditingController();
    rateText = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(AppSize.s15),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSize.s15),
      backgroundColor: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
      content: SizedBox(
        width: MyAppTheme.columnWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title: 'Transaction Details',
                  textStyle: getSemiBoldStyle(),
                ),
                Transform.translate(
                  offset: const Offset(10, 0),
                  child: IconButton(
                    // tooltip: _localizations!.close,
                    tooltip: 'Close',
                    onPressed: () => context.pop(),
                    icon: const Icon(AppIcons.clearIcon),
                    visualDensity: VisualDensity.compact
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s10),
            TextField(
              controller: descriptionText,
              onChanged: (value) => context.read<TransactionBloc>().add(TransactionAmountChangeEvent(amount: value)),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                // errorText: errorAmount
                hintText: 'Description',
                label: Text('Description'),
                hintStyle: const TextStyle(color: AppColors.grey),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: AppSize.s05, 
                    color: Helper.isDark 
                    ? AppColors.grey 
                    : AppColors.black
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSize.s15),
            TextField(
              controller: quantityText,
              onChanged: (value) => context.read<TransactionBloc>().add(TransactionAmountChangeEvent(amount: value)),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                // errorText: errorAmount
                hintText: 'Quantity',
                label: Text('Quantity'),
                hintStyle: const TextStyle(color: AppColors.grey),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: AppSize.s05, 
                    color: Helper.isDark 
                    ? AppColors.grey 
                    : AppColors.black
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSize.s15),
            TextField(
              controller: rateText,
              onChanged: (value) => context.read<TransactionBloc>().add(TransactionAmountChangeEvent(amount: value)),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              decoration: InputDecoration(
                // errorText: errorAmount
                hintText: 'Rate per piece',
                label: Text('Rate per piece'),
                hintStyle: const TextStyle(color: AppColors.grey),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: AppSize.s05, 
                    color: Helper.isDark 
                    ? AppColors.grey 
                    : AppColors.black
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSize.s20),
            CustomButton(
              title: 'Add', 
              onTap: () => widget.onAdd(descriptionText.text, rateText.text, quantityText.text),
              //  context.read<TransactionBloc>().add(TransactionAddEvent(
              //     userName: widget.userName, 
              //     date: transactionDate, 
              //     amount: amountTextController.text, 
              //     type: transactionType,
              //     transactionId: widget.transactionModel == null 
              //     ? '' 
              //     : widget.transactionModel!.id
              //   ),
              // ),
              titleSize: AppSize.s15,
            ),
          ],
        ),
      ),
    );
  }
}