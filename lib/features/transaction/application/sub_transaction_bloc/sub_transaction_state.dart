part of 'sub_transaction_bloc.dart';

sealed class SubTransactionState {}

class SubTransactionInitialState extends SubTransactionState {}

class SubTransactionDetailsLoadingState extends SubTransactionState {}


class SubTransactionFetchDetailsState extends SubTransactionState {
  List<TransactionDetailsModel> transactionDetailsList;
  SubTransactionFetchDetailsState({this.transactionDetailsList = const []});
}