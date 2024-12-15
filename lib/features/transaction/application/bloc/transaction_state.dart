import 'package:flutter/material.dart';

import '../../../../constants/app_strings.dart';
import '../../domain/transaction_model.dart';

sealed class TransactionState {}

class TransactionInitialState extends TransactionState {}

class DashboardSuccessState extends TransactionState {
  DashboardSuccessState();
}

class TransactionFailedState extends TransactionState {
  String message;
  String title;
  TransactionFailedState({required this.message, required this.title});
}

class TransactionLoadingState extends TransactionState {}

class TransactionAmountFieldState extends TransactionState {
  bool isAmountEmpty;
  TransactionAmountFieldState({required this.isAmountEmpty});
}

class TransactionUserNameFieldState extends TransactionState {
  String userNameMessage;
  TransactionUserNameFieldState({required this.userNameMessage});
}

class TransactionTypeChangeState extends TransactionState {
  String type = AppStrings.transfer;
  TransactionTypeChangeState(this.type);
}

class TransactionDateChangeState extends TransactionState {
  bool isEmpty;
  TransactionDateChangeState(this.isEmpty);
}

class AllTransactionState extends TransactionState {
  List<TransactionModel> listTransaction;
  double totalBalance;
  bool isFilterEnable;
  AllTransactionState({required this.listTransaction, required this.totalBalance, this.isFilterEnable = false});
}

class TransactionScrollState extends TransactionState {
  double appbarSize;
  TransactionScrollState({required this.appbarSize});
}

class TransactionExportPDFState extends TransactionState {
  String message;
  bool isSuccess;

  TransactionExportPDFState({this.message = '', this.isSuccess = false});
}

class TransactionProfileUpdateState extends TransactionState {
  String userName;
  String profileImage;

  TransactionProfileUpdateState({this.userName = '', this.profileImage = ''});
}

class TransactionFilterState extends TransactionState {}

class TransactionChangeAmountRangeState extends TransactionState {
  RangeValues rangeAmount;

  TransactionChangeAmountRangeState({required this.rangeAmount});
}

// class TransactionFilterDateRangeErrorState extends TransactionState {
//   String errorMsg;

//   TransactionFilterDateRangeErrorState({this.errorMsg = ''});
// }