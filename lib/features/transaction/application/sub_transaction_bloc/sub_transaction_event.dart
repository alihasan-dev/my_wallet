part of 'sub_transaction_bloc.dart';

sealed class SubTransactionEvent {}


class SubTransactionSelectDetailsEvent extends SubTransactionEvent {
  int selectedIndex;

  SubTransactionSelectDetailsEvent({this.selectedIndex = -1});
}


class SubTransactionDeleteEvent extends SubTransactionEvent {}

class SubTransactionClearSelectionEvent extends SubTransactionEvent {}

class SubTransactionSubDetailsEvent extends SubTransactionEvent {}

class SubTransactionAddEvent extends SubTransactionEvent {
  
  String transactionId;
  String description;
  double rate;
  int quantity;
  double total;

  SubTransactionAddEvent({
    required this.transactionId,
    required this.description,
    required this.rate,
    required this.quantity,
    required this.total
  });
  
}
