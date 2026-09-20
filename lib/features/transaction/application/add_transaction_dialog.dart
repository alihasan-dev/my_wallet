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
import '../../../widgets/custom_checkbox_widget.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';
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
  bool isActiveTransaction = true;
  DateTime? transactionDate;
  late DateTime initialDateTime;
  late String transactionType;
  late TextEditingController amountTextController;
  late TextEditingController dateTextController;
  late TextEditingController descriptionTextController;
  AppLocalizations? _localizations;

  @override
  void initState() {
    initialDateTime = DateTime.now();
    transactionType = AppStrings.transfer;
    amountTextController = TextEditingController();
    dateTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    if (widget.transactionModel != null) {
      final transactionModel = widget.transactionModel!;
      amountTextController.text = transactionModel.amount.toStringAsFixed(0);
      dateTextController.text = transactionModel.date.formatDateTime;
      initialDateTime = transactionDate = transactionModel.date;
      transactionType = transactionModel.type;
      descriptionTextController.text = transactionModel.description;
      isActiveTransaction = transactionModel.isActive;
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
              case TransactionStatusChangeState _:
                isActiveTransaction = state.status == AppStrings.active;
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
                  // TextField(
                  //   controller: amountTextController,
                  //   onChanged: (value) => context.read<TransactionBloc>().add(TransactionAmountChangeEvent(amount: value)),
                  //   keyboardType: TextInputType.number,
                  //   textInputAction: TextInputAction.done,
                  //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  //   maxLength: 8,
                  //   decoration: InputDecoration(
                  //     errorText: errorAmount.isBlank
                  //     ? null
                  //     : errorAmount,
                  //     hintText: AppStrings.amount,
                  //     label: Text('${_localizations!.amount} *'),
                  //     hintStyle: const TextStyle(color: AppColors.grey),
                  //     border: const OutlineInputBorder(),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         width: AppSize.s05, 
                  //         color: Helper.isDark 
                  //         ? AppColors.grey 
                  //         : AppColors.black
                  //       ),
                  //     ),
                  //     prefix: Text('₹ ',style: TextStyle(color: AppColors.black)),
                  //     counterText: ''
                  //   ),
                  // ),
                  CustomTextField(
                    title: _localizations!.amount,
                    isPasswordField: false,
                    isMandatory: true,
                    textEditingController: amountTextController,
                    errorText: errorAmount,
                    onChange: (value) => context.read<TransactionBloc>().add(TransactionAmountChangeEvent(amount: value)),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
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
                  const SizedBox(height: AppSize.s18),
                  InputDecorator(
                    decoration: InputDecoration(
                      isDense: true,
                      label: RichText(
                        text: TextSpan(
                          text: _localizations!.transferType,
                          style: TextStyle(
                            color: Helper.isDark 
                            ? AppColors.white.withValues(alpha: 0.8)
                            : AppColors.black.withValues(alpha: 0.7),
                            fontFamily: 'OpenSans'
                          ),
                          children: const [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
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
                      items: Helper.listTransactionType.map((value) {
                        return DropdownMenuItem(
                          value: value, 
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w500,
                              color: Helper.isDark 
                              ? AppColors.white 
                              : AppColors.black
                            ),
                          ),
                        );
                      }).toList(), 
                      dropdownColor: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
                      onChanged: (value) => context.read<TransactionBloc>().add(TransactionTypeChangeEvent(type: value!.toString())),
                      underline: const SizedBox(),
                      icon: Icon(AppIcons.arrowDown),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w500,
                        color: Helper.isDark 
                        ? AppColors.white 
                        : AppColors.black
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.s18),
                  // TextField(
                  //   controller: dateTextController,
                  //   readOnly: true,
                  //   onTap: () async {
                  //     var date = await openCalendar(context: context, initialDate: initialDateTime);
                  //     if(date != null && context.mounted) {
                  //       initialDateTime = date;
                  //       context.read<TransactionBloc>().add(TransactionDateChangeEvent(isError: false));
                  //       final currentTime = DateTime.now();
                  //       transactionDate = DateTime(date.year, date.month, date.day, currentTime.hour, currentTime.minute, currentTime.second);
                  //       dateTextController.text = date.formatDateTime;
                  //     }
                  //   },
                  //   decoration: InputDecoration(
                  //     errorText: errorDate
                  //     ? AppStrings.emptyDate
                  //     : null,
                  //     hintText: AppStrings.emptyDate,
                  //     hintStyle: const TextStyle(color: AppColors.grey),
                  //     label: Text('${_localizations!.date} *'),
                  //     border: const OutlineInputBorder(),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         width: AppSize.s05, 
                  //         color: Helper.isDark 
                  //         ? AppColors.grey 
                  //         : AppColors.black
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  CustomTextField(
                    title: _localizations!.date,
                    isPasswordField: false,
                    isMandatory: true,
                    readOnly: true,
                    textEditingController: dateTextController,
                    textInputAction: TextInputAction.done,
                    animatedError: false,
                    errorText: errorDate
                    ? AppStrings.emptyDate
                    : null,
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
                    // hintStyle: TextStyle(fontSize: AppSize.s14, color: AppColors.grey),
                  ),
                  const SizedBox(height: AppSize.s18),
                  // TextField(
                  //   controller: descriptionTextController,
                  //   maxLines: null,
                  //   maxLength: 100,
                  //   decoration: InputDecoration(
                  //     hintText: '${AppStrings.description} (Optional)',
                  //     hintStyle: const TextStyle(color: AppColors.grey),
                  //     label: Text(AppStrings.description),
                  //     border: const OutlineInputBorder(),
                  //     counterText: '',
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         width: AppSize.s05, 
                  //         color: Helper.isDark 
                  //         ? AppColors.grey 
                  //         : AppColors.black
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  CustomTextField(
                    title: '${_localizations!.description} (${_localizations!.optional})',
                    isPasswordField: false,
                    textEditingController: descriptionTextController,
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    maxLength: 100,
                    animatedError: false,
                    // hintStyle: TextStyle(fontSize: AppSize.s14, color: AppColors.grey),
                  ),
                  const SizedBox(height: AppSize.s16),
                  Row(
                    spacing: AppSize.s8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCheckBoxWidget(
                        value: isActiveTransaction, 
                        onChange: (value) {
                          context.read<TransactionBloc>().add(TransactionStatusChangeEvent(
                            status: value ?? true ? AppStrings.active : AppStrings.inactive
                          ));
                        }
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: AppSize.s2,
                          children: [
                            CustomText(title: '${_localizations!.transactionStatus} (${isActiveTransaction ? _localizations!.active : _localizations!.inactive})'),
                            CustomText(
                              title: _localizations!.transactionStatusMsg,
                              textStyle: getLightStyle(
                                fontSize: 12,
                                color: AppColors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                        : widget.transactionModel!.id,
                        description: descriptionTextController.text,
                        isActive: isActiveTransaction
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