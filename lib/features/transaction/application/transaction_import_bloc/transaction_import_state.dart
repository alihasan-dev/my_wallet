part of 'transaction_import_bloc.dart';

sealed class TransactionImportState {}

class TransactionImportInitialState extends TransactionImportState {}

class TransactionImportStatusUpdateState extends TransactionImportState {
  int currentImportIndex;
  int completeIndex;
  bool isCompleted;
  String message;
  int validCount;
  int invalidCount;
  bool importLoading;
  String fileName;
  bool isReset;
  TransactionImportStatusUpdateState({
    this.currentImportIndex = 0,
    this.completeIndex = 0,
    this.isCompleted = false,
    this.message = '',
    this.validCount = 0,
    this.invalidCount = 0,
    this.importLoading = false,
    this.fileName = '',
    this.isReset = false
  });
}

class TransactionImportDownloadTemplateState extends TransactionImportState {
  bool status;
  String message;
  TransactionImportDownloadTemplateState({
    this.status = false,
    this.message = ''
  });
}

class TransactionImportPickFileState extends TransactionImportState {
  bool status;
  String message;
  TransactionImportPickFileState({
    this.status = false,
    this.message = ''
  });
} 

class TransactionImportInitiateState extends TransactionImportState {
  bool status;
  String message;
  TransactionImportInitiateState({
    this.status = false,
    this.message = ''
  });
}

class TransactionImportCheckedState extends TransactionImportState {
  bool value;
  TransactionImportCheckedState({this.value = false});
}