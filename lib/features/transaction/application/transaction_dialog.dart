import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_theme.dart';
import '../../../features/dashboard/application/bloc/dashboard_bloc.dart';
import '../../../utils/app_extension_method.dart';
import '../../../constants/app_color.dart';
import '../../../features/transaction/application/bloc/transaction_bloc.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_size.dart';
import '../../../widgets/custom_button.dart';
import '../../../utils/helper.dart';
import '../../../widgets/custom_text.dart';
import '../domain/transaction_model.dart';

class AddTransactionDialog extends StatefulWidget {
  final String userName;
  final String friendId;
  final TransactionModel? transactionModel;

  const AddTransactionDialog({
    super.key, 
    required this.userName, 
    required this.friendId,
    this.transactionModel
  });

  @override
  State createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {

  String errorAmount = '';
  String errorMsg = '';
  bool errorDate = false;
  bool isFirst = true;
  DateTime? transactionDate;
  late DateTime initialDateTime;
  late String transactionType;
  late TextEditingController amountTextController;
  late TextEditingController dateTextController;
  AppLocalizations? _localizations;

  @override
  void initState() {
    initialDateTime = DateTime.now();
    transactionType = AppStrings.transfer;
    amountTextController = TextEditingController();
    dateTextController = TextEditingController();
    if (widget.transactionModel != null) {
      final transactionModel = widget.transactionModel!;
      amountTextController.text = transactionModel.amount.toStringAsFixed(0);
      dateTextController.text = transactionModel.date.formatDateTime;
      initialDateTime = transactionDate = transactionModel.date;
      transactionType = transactionModel.type;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
    return BlocProvider<TransactionBloc>(
      create: (_) => TransactionBloc(userName: widget.userName, friendId: widget.friendId, dashboardBloc: context.read<DashboardBloc>()),
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(AppSize.s15),
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSize.s15),
        backgroundColor: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
        content: BlocConsumer<TransactionBloc, TransactionState>(
          builder: (context, state){
            switch (state) {
              case TransactionAmountFieldState _:
                errorAmount = state.errorAmountMsg;
                break;
              case TransactionTypeChangeState _:
                transactionType = state.type;
                break;
              case TransactionDateChangeState _:
                errorDate = state.isEmpty;
                break;
              case TransactionFailedState _:
                errorMsg = state.message;
                break;
              default:
            }
            return SizedBox(
              width: MyAppTheme.columnWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: widget.transactionModel != null
                        ? _localizations!.editTransaction
                        : _localizations!.addTransaction,
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
                  TextField(
                    controller: amountTextController,
                    onChanged: (value) => context.read<TransactionBloc>().add(TransactionAmountChangeEvent(amount: value)),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 8,
                    decoration: InputDecoration(
                      errorText: errorAmount.isBlank
                      ? null
                      : errorAmount,
                      hintText: AppStrings.amount,
                      label: Text('${_localizations!.amount} *'),
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
                      counterText: ''
                    ),
                  ),
                  const SizedBox(height: AppSize.s15),
                  InputDecorator(
                    decoration: InputDecoration(
                      isDense: true,
                      label: Text(_localizations!.transferType),
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSize.s14),
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
                      items: Helper.listTransactionType.map((String value) => DropdownMenuItem(value: value, child: Text(value))).toList(), 
                      dropdownColor: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
                      onChanged: (value) => context.read<TransactionBloc>().add(TransactionTypeChangeEvent(type: value!.toString())),
                      underline: const SizedBox(),
                      icon: Icon(AppIcons.arrowDown),
                    ),
                  ),
                  const SizedBox(height: AppSize.s15),
                  TextField(
                    controller: dateTextController,
                    readOnly: true,
                    onTap: () async {
                      var date = await openCalendar(context: context, initialDate: initialDateTime);
                      if(date != null && context.mounted) {
                        initialDateTime = date;
                        context.read<TransactionBloc>().add(TransactionDateChangeEvent(isError: false));
                        final currentTime = DateTime.now();
                        transactionDate = DateTime(date.year, date.month, date.day, currentTime.hour, currentTime.minute, currentTime.second);
                        dateTextController.text = date.formatDateTime;
                      }
                    },
                    decoration: InputDecoration(
                      errorText: errorDate
                      ? AppStrings.emptyDate
                      : null,
                      hintText: AppStrings.emptyDate,
                      hintStyle: const TextStyle(color: AppColors.grey),
                      label: Text('${_localizations!.date} *'),
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
                  const SizedBox(height: AppSize.s16),
                  AnimatedSwitcher(
                    duration: MyAppTheme.animationDuration,
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, -0.4), // from top
                        end: Offset.zero,
                      ).animate(animation);
                      return ClipRect(
                        child: SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: errorMsg.isBlank
                    ? const SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSize.s8,
                          horizontal: AppSize.s12
                        ),
                        margin: const EdgeInsets.only(bottom: AppSize.s10),
                        decoration: BoxDecoration(
                          color: AppColors.pink.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: Row(
                          spacing: AppSize.s6,
                          children: [
                            Icon(AppIcons.warningIcon, size: AppSize.s18, color: AppColors.pink),
                            Expanded(
                              child: CustomText(
                                title: AppStrings.noInternetConnection,
                                textStyle: getRegularStyle(color: AppColors.pink)
                              )
                            ),
                          ],
                        ),
                      ),
                  ),
                  CustomButton(
                    title: widget.transactionModel != null  
                    ? _localizations!.update
                    : _localizations!.add, 
                    onTap: () => context.read<TransactionBloc>().add(TransactionAddEvent(
                        userName: widget.userName, 
                        date: transactionDate, 
                        amount: amountTextController.text, 
                        type: transactionType,
                        transactionId: widget.transactionModel == null 
                        ? '' 
                        : widget.transactionModel!.id
                      ),
                    ),
                    titleSize: AppSize.s15,
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            switch (state) {
              case AllTransactionState _:
                if(!isFirst) {
                  Navigator.pop(context);
                } else {
                  isFirst = false;
                }
                break;
              default:
            }
          },
        ),
      ),
    );
  }

  Future<DateTime?> openCalendar({required BuildContext context, required DateTime initialDate}) async {
    return await showDatePicker(
      context: context, 
      initialDate: initialDate, 
      firstDate: DateTime.parse('2022-01-01'), 
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly
    );
  }
}