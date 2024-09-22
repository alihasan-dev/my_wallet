class UserModel {
  String name;
  String email;
  String userId;
  String phone;
  String profileImg;
  String amount;
  int lastTransactionDate;
  String type;
  bool isUserVerified;

  UserModel({
    required this.userId,
    required this.name, 
    required this.email,
    required this.phone,
    this.profileImg = '',
    this.amount = '',
    this.lastTransactionDate = -1,
    this.type = '',
    this.isUserVerified = false
  });
}