part of 'transaction_import_bloc.dart';

sealed class TransactionImportState {}

class TransactionImportInitialState extends TransactionImportState {}

class TransactionImportStatusUpdateState extends TransactionImportState {
  int currentImportIndex;
  TransactionImportStatusUpdateState({this.currentImportIndex = 0});
}

class TransactionImportDownloadTemplateState extends TransactionImportState {
  bool status;
  String message;
  TransactionImportDownloadTemplateState({
    this.status = false,
    this.message = ''
  });
}