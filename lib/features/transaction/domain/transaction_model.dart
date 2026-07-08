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

  /// Empty/default instance
  factory TransactionModel.empty() {
    return TransactionModel(
      id: '',
      date: DateTime.now(),
      type: '',
      amount: 0.0
    );
  }

  /// Returns a copy with optional overrides
  factory TransactionModel.copyWith(
    TransactionModel source, {
    String? id,
    DateTime? date,
    String? type,
    double? amount,
    bool? selected,
    bool? isActive,
    String? description,
  }) {
    return TransactionModel(
      id: id ?? source.id,
      date: date ?? source.date,
      type: type ?? source.type,
      amount: amount ?? source.amount,
      selected: selected ?? source.selected,
      isActive: isActive ?? source.isActive,
      description: description ?? source.description,
    );
  }
}