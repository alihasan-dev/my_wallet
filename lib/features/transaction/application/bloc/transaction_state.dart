import '../../../../features/dashboard/domain/user_model.dart';
import '../../../../constants/app_strings.dart';
import '../../domain/transaction_model.dart';

sealed class TransactionState {}

class TransactionInitialState extends TransactionState {}

class DashboardSuccessState extends TransactionState {
  DashboardSuccessState();
}

class DashboardAllUserState extends TransactionState {
  List<UserModel> allUser;
  DashboardAllUserState({required this.allUser});
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
  AllTransactionState({required this.listTransaction, required this.totalBalance});
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
