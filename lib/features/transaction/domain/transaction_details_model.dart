class TransactionDetailsModel {
  String description;
  int quantity;
  double rate;
  double total;


  TransactionDetailsModel({
    this.description = '',
    this.quantity = 0,
    this.rate = 0.0,
    this.total = 0.0
  });
}