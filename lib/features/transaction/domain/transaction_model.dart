class TransactionModel {
  String id;
  DateTime date;
  String type;
  double amount;
  bool selected;
  bool isActive;
  String description;

  TransactionModel({
    required this.id,
    required this.date, 
    required this.type, 
    required this.amount,
    this.selected = false,
    this.isActive = true,
    this.description = ''
  });
}