class TransactionModel {
  String id;
  DateTime date;
  String type;
  double amount;
  bool selected;

  TransactionModel({
    required this.id,
    required this.date, 
    required this.type, 
    required this.amount,
    this.selected = false
  });
}