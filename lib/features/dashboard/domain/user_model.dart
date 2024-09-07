class UserModel {
  String name;
  String email;
  String userId;
  String phone;
  String profileImg;
  String amount;
  String lastTransactionDate;

  UserModel({
    required this.userId,
    required this.name, 
    required this.email,
    required this.phone,
    this.profileImg = '',
    this.amount = '',
    this.lastTransactionDate = ''
  });
}