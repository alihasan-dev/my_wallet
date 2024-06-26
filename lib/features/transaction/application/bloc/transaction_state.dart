part of 'transaction_bloc.dart';

sealed class TransactionState {}

class TransactionInitialState extends TransactionState {}

class DashboardSuccessState extends TransactionState{
  DashboardSuccessState();
}

class DashboardAllUserState extends TransactionState {
  List<UserModel> allUser;
  DashboardAllUserState({required this.allUser});
}

class TransactionFailedState extends TransactionState{
  String message;
  String title;
  TransactionFailedState({required this.message,required this.title});
}

class TransactionLoadingState extends TransactionState{}

class TransactionAmountFieldState extends TransactionState{
  bool isAmountEmpty;
  TransactionAmountFieldState({required this.isAmountEmpty});
}

class TransactionUserNameFieldState extends TransactionState{
  String userNameMessage;
  TransactionUserNameFieldState({required this.userNameMessage});
}

class TransactionTypeChangeState extends TransactionState{
  String type = AppStrings.transfer;
  TransactionTypeChangeState(this.type);
}

class TransactionDateChangeState extends TransactionState{
  bool isEmpty;
  TransactionDateChangeState(this.isEmpty);
}

class AllTransactionState extends TransactionState {
  List<TransactionModel> listTransaction;
  AllTransactionState({required this.listTransaction});
}

class TransactionScrollState extends TransactionState {
  double appbarSize;
  TransactionScrollState({required this.appbarSize});
}