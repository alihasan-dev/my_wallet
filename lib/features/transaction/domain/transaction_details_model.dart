class TransactionDetailsModel {
  String id;
  String description;
  int quantity;
  double rate;
  double total;
  bool isSelected;


  TransactionDetailsModel({
    required this.id,
    this.description = '',
    this.quantity = 0,
    this.rate = 0.0,
    this.total = 0.0,
    this.isSelected = false
  });
}