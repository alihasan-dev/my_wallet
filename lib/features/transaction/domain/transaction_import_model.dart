// class TransactionImportModel {
//   DateTime? date;
//   String? type;
//   double? amount;
//   bool? isActive;
//   String? description;

//   TransactionImportModel({
//     this.date, 
//     this.type, 
//     this.amount,
//     this.isActive,
//     this.description
//   });
// }
class TransactionImportModel {
  DateTime? date;
  String? type;
  String? amount;
  bool? isActive;
  String? description;

  TransactionImportModel({
    this.date,
    this.type,
    this.amount,
    this.isActive,
    this.description,
  });

  /// Empty/default instance
  factory TransactionImportModel.empty() {
    return TransactionImportModel(
      date: null,
      type: null,
      amount: null,
      isActive: null,
      description: null,
    );
  }

  /// Returns a copy with optional overrides
  TransactionImportModel copyWith({
    DateTime? date,
    String? type,
    String? amount,
    bool? isActive,
    String? description,
  }) {
    return TransactionImportModel(
      date: date ?? this.date,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'TransactionImportModel('
        'date: $date, '
        'type: $type, '
        'amount: $amount, '
        'isActive: $isActive, '
        'description: $description'
        ')';
  }
}