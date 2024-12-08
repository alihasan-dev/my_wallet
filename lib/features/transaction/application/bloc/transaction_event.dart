sealed class TransactionEvent {}

class TransactionInitialEvent extends TransactionEvent {}

class TransactionAddEvent extends TransactionEvent {
  String userName;
  DateTime? date;
  String amount;
  String type;
  TransactionAddEvent({
    required this.userName,
    required this.amount,
    required this.type,
    this.date,
  });
} 

class TransactionAmountChangeEvent extends TransactionEvent {
  String amount;
  TransactionAmountChangeEvent({required this.amount});
}

class TransactionTypeChangeEvent extends TransactionEvent {
  String type;
  TransactionTypeChangeEvent({required this.type});
}

class TransactionDateChangeEvent extends TransactionEvent {
  bool isError;
  TransactionDateChangeEvent({required this.isError});
}

class AllTransactionEvent extends TransactionEvent {
  AllTransactionEvent();
}

class TransactionDateSortEvent extends TransactionEvent {}

class TransactionAmountSortEvent extends TransactionEvent {}

class TransactionTypeSortEvent extends TransactionEvent {}

class TransactionScrollEvent extends TransactionEvent {
  double appbarSize;
  TransactionScrollEvent({required this.appbarSize});
}

class TransactionExportPDFEvent extends TransactionEvent {}

class TransactionProfileUpdateEvent extends TransactionEvent {
  String userName;
  String profileImage;

  TransactionProfileUpdateEvent({this.userName = '', this.profileImage = ''});
}