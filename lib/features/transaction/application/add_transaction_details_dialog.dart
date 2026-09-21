import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/custom_text_field.dart';
import '../../transaction/application/sub_transaction_bloc/sub_transaction_bloc.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/app_extension_method.dart';
import '../../../utils/check_connectivity.dart';
import '../../../l10n/app_localizations.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_size.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_theme.dart';
import '../../../utils/helper.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';
class AddTransactionDetailsDialog extends StatefulWidget {

  final SubTransactionBloc transactionBloc;
  final String transactionId;

  const AddTransactionDetailsDialog({
    super.key,
    required this.transactionId,
    required this.transactionBloc,
  });

  @override
  State<AddTransactionDetailsDialog> createState() => _AddTransactionDetailsDialogState();
}

class _AddTransactionDetailsDialogState extends State<AddTransactionDetailsDialog> with Helper {

  late TextEditingController descriptionText;
  late TextEditingController quantityText;
  late TextEditingController rateText;
  late CheckConnectivity _checkConnectivity;
  AppLocalizations? _localizations;

  late ValueNotifier<String?> errorDescription;
  late ValueNotifier<String?> errorQuantity;
  late ValueNotifier<String?> errorRate;

  @override
  void initState() {
    _checkConnectivity = CheckConnectivity();
    errorDescription = ValueNotifier<String?>(null);
    errorQuantity = ValueNotifier<String?>(null);
    errorRate = ValueNotifier<String?>(null);
    descriptionText = TextEditingController();
    quantityText = TextEditingController();
    rateText = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
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
        child: BlocProvider.value(
          value: widget.transactionBloc,
          child: AnimatedBuilder(
            animation: Listenable.merge([errorDescription, errorQuantity, errorRate]),
            builder: (_, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: _localizations!.transactionBreakdown,
                        textStyle: getSemiBoldStyle(),
                      ),
                      Transform.translate(
                        offset: const Offset(10, 0),
                        child: IconButton(
                          tooltip: _localizations!.close,
                          onPressed: () => context.pop(),
                          icon: const Icon(AppIcons.clearIcon),
                          visualDensity: VisualDensity.compact
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.s10),
                  CustomTextField(
                    title: _localizations!.description,
                    isPasswordField: false,
                    isMandatory: true,
                    textEditingController: descriptionText,
                    errorText: errorDescription.value,
                    onChange: _onDescriptionTextChange,
                    textInputAction: TextInputAction.next,
                    maxLength: 50,
                    animatedError: false,
                    hintStyle: TextStyle(fontSize: AppSize.s14, color: AppColors.grey),
                  ),
                  const SizedBox(height: AppSize.s15),
                  CustomTextField(
                    title: _localizations!.quantity,
                    isPasswordField: false,
                    isMandatory: true,
                    textEditingController: quantityText,
                    errorText: errorQuantity.value,
                    onChange: _onQuantityTextChange,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    animatedError: false,
                    textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    hintStyle: TextStyle(fontSize: AppSize.s14, color: AppColors.grey),
                  ),
                  const SizedBox(height: AppSize.s15),
                  CustomTextField(
                    title: _localizations!.rate,
                    isPasswordField: false,
                    isMandatory: true,
                    textEditingController: rateText,
                    errorText: errorRate.value,
                    onChange: _onRateTextChange,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    animatedError: false,
                    prefix: Text(
                      '₹ ',
                      style: TextStyle(
                        color: Helper.isDark 
                        ? AppColors.white 
                        : AppColors.black,
                        fontSize: AppSize.s14
                      ),
                    ),
                    textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    hintStyle: TextStyle(fontSize: AppSize.s14, color: AppColors.grey),
                  ),
                  const SizedBox(height: AppSize.s20),
                  CustomButton(
                    title: _localizations!.add, 
                    onTap: () async {
                      if (await _fieldValidation() && context.mounted) {
                        widget.transactionBloc.add(SubTransactionAddEvent(
                          transactionId: widget.transactionId,
                          description: descriptionText.text.trim(),
                          rate: double.parse(rateText.text),
                          quantity: int.parse(quantityText.text),
                          total: double.parse(rateText.text) * int.parse(quantityText.text)
                        ));
                        context.pop();
                      }
                    },
                    titleSize: AppSize.s15,
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  void _onDescriptionTextChange(String text) {
    if (text.isBlank) {
      errorDescription.value = AppStrings.descriptionMsg;
    } else {
      errorDescription.value = null;
    }
  }

  void _onQuantityTextChange(String text) {
    if (text.isBlank) {
      errorQuantity.value = AppStrings.quantityMsg;
    } else if (int.parse(text) <= 0) {
      errorQuantity.value = AppStrings.invalidQuantityMsg;
    } else {
      errorQuantity.value = null;
    }
  }

  void _onRateTextChange(String text) {
    if (text.isBlank) {
      errorRate.value = AppStrings.rateMsg;
    } else if (int.parse(text) <= 0) {
      errorRate.value = AppStrings.invalidRateMsg;
    } else {
      errorRate.value = null;
    }
  }

  Future<bool> _fieldValidation() async {
    var result = true;
    if (descriptionText.text.isBlank) {
      result = false;
      errorDescription.value = AppStrings.descriptionMsg;
    }
    if (quantityText.text.isBlank) {
      result = false;
      errorQuantity.value = AppStrings.quantityMsg;
    } else if (int.parse(quantityText.text) <= 0) {
      result = false;
      errorQuantity.value = AppStrings.invalidQuantityMsg;
    }
    if (rateText.text.isBlank) {
      result = false;
      errorRate.value = AppStrings.rateMsg;
    } else if (int.parse(rateText.text) <= 0) {
      result = false;
      errorRate.value = AppStrings.invalidRateMsg;
    }
    if (result && !(await _checkConnectivity.hasConnection)) {
      result = false;
      showSnackBar(
        context: context, 
        title: AppStrings.noInternetConnection, 
        message: AppStrings.noInternetConnectionMessage
      );
    } 
    return result;
  }
}