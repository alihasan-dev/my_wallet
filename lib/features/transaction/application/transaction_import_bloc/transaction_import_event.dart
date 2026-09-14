part of 'transaction_import_bloc.dart';

sealed class TransactionImportEvent {}

class TransactionImportStateUpdateEvent extends TransactionImportEvent {
  int currentImportIndex;
  TransactionImportStateUpdateEvent({this.currentImportIndex = 0});
}

class TransactionImportInitiateEvent extends TransactionImportEvent {
  List<TransactionImportModel> transactionImportList;
  TransactionImportInitiateEvent({this.transactionImportList = const []});
}

class TransactionImportDownloadTemplateEvent extends TransactionImportEvent {}