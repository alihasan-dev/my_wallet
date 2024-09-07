import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/app_color.dart';
import '../../../features/transaction/application/bloc/transaction_bloc.dart';
import '../../../features/transaction/application/bloc/transaction_event.dart';
import '../../../features/transaction/application/bloc/transaction_state.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_size.dart';
import '../../../widgets/custom_button.dart';
import '../../../utils/helper.dart';

class AddTransactionDialog extends StatefulWidget {
  final String userName;
  final String friendId;
  const AddTransactionDialog({super.key, required this.userName, required this.friendId});

  @override
  State createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {

  bool errorAmount = false;
  bool errorDate = false;
  bool isFirst = true;
  DateTime? transactionDate;
  String transactionType = AppStrings.transfer;
  var amountTextController = TextEditingController();
  var dateTextController = TextEditingController();
  AppLocalizations? _localizations;

  @override
  Widget build(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
    return BlocProvider<TransactionBloc>(
      create: (_) => TransactionBloc(userName: widget.userName, friendId: widget.friendId),
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(AppSize.s15),
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSize.s15),
        backgroundColor: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s6)),
        content: BlocConsumer<TransactionBloc, TransactionState>(
          builder: (context, state){
            switch (state.runtimeType) {
              case TransactionAmountFieldState:
                state = state as TransactionAmountFieldState;
                errorAmount = state.isAmountEmpty;
                break;
              case TransactionTypeChangeState:
                state = state as TransactionTypeChangeState;
                transactionType = state.type;
                break;
              case TransactionDateChangeState:
                state = state as TransactionDateChangeState;
                errorDate = state.isEmpty;
                break;
              default:
            }
            return SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountTextController,
                    onChanged: (value) => context.read<TransactionBloc>().add(TransactionAmountChangeEvent(amount: value)),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      errorText: errorAmount
                      ? AppStrings.emptyAmount
                      : null,
                      hintText: AppStrings.amount,
                      label: Text('${_localizations!.amount} *'),
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
                  InputDecorator(
                    decoration: InputDecoration(
                      isDense: true,
                      label: Text(_localizations!.transferType),
                      contentPadding: const EdgeInsets.symmetric(vertical: AppSize.s4, horizontal: AppSize.s14),
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
                      items: Helper.listTransactionType.map((String value) {
                        return DropdownMenuItem(value: value, child: Text(value));
                      }).toList(), 
                      dropdownColor: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
                      onChanged: (value) => context.read<TransactionBloc>().add(TransactionTypeChangeEvent(type: value!.toString())),
                      underline: const SizedBox(),
                    ),
                  ),
                  const SizedBox(height: AppSize.s15),
                  TextField(
                    controller: dateTextController,
                    readOnly: true,
                    onTap: () async {
                      var date = await openCalendar(context: context, initialDate: DateTime.now());
                      if(date != null){
                        if(context.mounted){
                          context.read<TransactionBloc>().add(TransactionDateChangeEvent(isError: false));
                        }
                        transactionDate = date;
                        dateTextController.text = date.toString().substring(0,10).split('-').reversed.join('-');
                      }
                    },
                    decoration: InputDecoration(
                      errorText: errorDate
                      ? AppStrings.emptyDate
                      : null,
                      hintText: AppStrings.emptyDate,
                      label: Text('${_localizations!.date} *'),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: AppSize.s05, color: Helper.isDark ? AppColors.grey : AppColors.black))
                    ),
                  ),
                  const SizedBox(height: AppSize.s20),
                  CustomButton(
                    title:  _localizations!.addTransaction, 
                    onTap: () => context.read<TransactionBloc>().add(TransactionAddEvent(
                      userName: widget.userName, 
                      date: transactionDate, 
                      amount: amountTextController.text, 
                      type: transactionType
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            switch (state.runtimeType) {
              case AllTransactionState:
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
      lastDate: initialDate
    );
  }
}