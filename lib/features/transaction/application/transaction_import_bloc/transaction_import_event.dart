part of 'transaction_import_bloc.dart';

sealed class TransactionImportEvent {}

class TransactionImportStateUpdateEvent extends TransactionImportEvent {
  int currentImportIndex;
  TransactionImportStateUpdateEvent({this.currentImportIndex = 0});
}

class TransactionImportUploadEvent extends TransactionImportEvent {}

class TransactionImportDownloadTemplateEvent extends TransactionImportEvent {}

class TransactionImportInitiateEvent extends TransactionImportEvent {
  final PlatformFile? pickedFile;
  TransactionImportInitiateEvent({this.pickedFile});
}

class TransactionImportCheckedEvent extends TransactionImportEvent {
  bool value;
  TransactionImportCheckedEvent({this.value = false});
}

class TransactionResetImportEvent extends TransactionImportEvent {}