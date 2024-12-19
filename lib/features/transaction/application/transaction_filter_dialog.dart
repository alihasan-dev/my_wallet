import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_style.dart';
import '../../../features/transaction/application/bloc/transaction_bloc.dart';
import '../../../utils/app_extension_method.dart';
import '../../../widgets/custom_text.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_size.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_theme.dart';
import '../../../utils/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionFilterDialog extends StatefulWidget {
  final RangeValues? amountChangeValue;
  final RangeValues finalAmountRange;
  final TransactionBloc transactionBloc;
  final DateTimeRange? initialDateTimeRage;
  final String transactionType;

  const TransactionFilterDialog({
    required this.transactionType,
    this.initialDateTimeRage,
    this.amountChangeValue,
    required this.finalAmountRange,
    required this.transactionBloc,
    super.key
  });

  @override
  State createState() => _TransactionFilterDialogState();
}

class _TransactionFilterDialogState extends State<TransactionFilterDialog> {

  DateTimeRange? initialDateTimeRage;
  late RangeValues amountChangeValue;
  String transactionType = AppStrings.all;
  late AppLocalizations localizations;
  late TextEditingController dateTimeRangeTextController;
  // bool isDialogOpenFirst = true;

  @override
  void didChangeDependencies() {
    transactionType = widget.transactionType;
    initialDateTimeRage = widget.initialDateTimeRage;
    dateTimeRangeTextController = TextEditingController();
    if(initialDateTimeRage != null) {
      var start = initialDateTimeRage!.start;
      var end = initialDateTimeRage!.end;
      dateTimeRangeTextController.text = '${start.formatDateTime} - ${end.formatDateTime}';
    }
    if(widget.amountChangeValue == null) {
      amountChangeValue = RangeValues(widget.finalAmountRange.start, widget.finalAmountRange.end);
    } else {
      amountChangeValue = RangeValues(widget.amountChangeValue!.start, widget.amountChangeValue!.end);
    }
    localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionBloc>.value(
      value: widget.transactionBloc,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(AppSize.s10),
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSize.s15),
        backgroundColor: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s6)),
        content: BlocConsumer<TransactionBloc, TransactionState>(
          builder: (context, state){
            return Container(
              width: MyAppTheme.columnWidth,
              padding: const EdgeInsets.symmetric(horizontal: AppSize.s8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: "Advance Filter",
                        textStyle: getSemiBoldStyle(),
                      ),
                      Transform.translate(
                        offset: const Offset(10, 0),
                        child: IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.clear),
                          visualDensity: VisualDensity.compact
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: AppSize.s10),
                  TextField(
                    controller: dateTimeRangeTextController,
                    onTap: () => chooseDateRange(context),
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "DD-MM-YYYY to DD-MM-YYY",
                      label: const Text('Date Range'),
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
                  InputDecorator(
                    decoration: InputDecoration(
                      isDense: true,
                      label: Text(localizations.transferType),
                      contentPadding: const EdgeInsets.symmetric(vertical: AppSize.s0, horizontal: AppSize.s14),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: AppSize.s05,
                          color: Helper.isDark
                          ? AppColors.grey
                          : AppColors.black
                        ),
                      ),
                    ),
                    child: DropdownButton(
                      value: transactionType,
                      isExpanded: true,
                      items: Helper.filterTransactionTypeList.map((String value) {
                        return DropdownMenuItem(value: value, child: Text(value));
                      }).toList(),
                      dropdownColor: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
                      onChanged: (value) => widget.transactionBloc.add(TransactionTypeChangeEvent(type: value!.toString())),
                      underline: const SizedBox(),
                    ),
                  ),
                  const SizedBox(height: AppSize.s15),
                  CustomText(title: "Amount Range", textStyle: getMediumStyle()),
                  SizedBox(
                    width: double.maxFinite,
                    child: SliderTheme(
                      data: const SliderThemeData(
                        showValueIndicator: ShowValueIndicator.always,
                        inactiveTrackColor: Colors.grey
                      ),
                      child: RangeSlider(
                        values: amountChangeValue,
                        min: 0.0,
                        max: widget.finalAmountRange.end + 10000.0,
                        activeColor: AppColors.primaryColor,
                        labels: RangeLabels(amountChangeValue.start.toStringAsFixed(0), amountChangeValue.end.toStringAsFixed(0)),
                        onChanged: (value) => widget.transactionBloc.add(TransactionChangeAmountRangeEvent(rangeAmount: value)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: '   ₹${amountChangeValue.start.toStringAsFixed(0)}',
                        textStyle: getMediumStyle(),
                      ),
                      CustomText(
                        title: '₹${amountChangeValue.end.toStringAsFixed(0)}   ',
                        textStyle: getMediumStyle(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.s10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => context.pop(('clear')),
                        child: CustomText(
                          title: 'Clear',
                          textStyle: getSemiBoldStyle(color: AppColors.red)
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.pop((initialDateTimeRage, transactionType, amountChangeValue)),
                        child: CustomText(
                          title: "Apply",
                          textStyle: getSemiBoldStyle(color: AppColors.primaryColor)
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.s5),
                ],
              ),
            );
          },
          listener: (context, state) {
            switch (state) {
              case TransactionChangeAmountRangeState _:
                amountChangeValue = state.rangeAmount;
                break;
              case TransactionTypeChangeState _:
                transactionType = state.type;
                break;
              default:
            }
          },
        ),
      ),
    );
  }

  Future<void> chooseDateRange(BuildContext context) async {
    final dateTimeRange = await showDateRangePicker(
      initialDateRange: initialDateTimeRage,
      context: context, 
      firstDate: DateTime.parse('2022-01-01'), 
      lastDate: DateTime.now().add(const Duration(days: 30))
    );
    if(dateTimeRange != null) {
      initialDateTimeRage = dateTimeRange;
      var start = dateTimeRange.start;
      var end = dateTimeRange.end;
      dateTimeRangeTextController.text = '${start.formatDateTime} - ${end.formatDateTime}';
    }
  }
}
