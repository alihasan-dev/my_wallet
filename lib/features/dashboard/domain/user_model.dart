class UserModel {
  String name;
  String email;
  String userId;
  String phone;
  String profileImg;
  String amount;
  int lastTransactionDate;
  String type;
  bool showTransactionDetails;
  bool isUserVerified;
  bool enableBiometric;
  bool isSelected;
  bool isPinned;

  UserModel({
    required this.userId,
    required this.name, 
    required this.email,
    required this.phone,
    this.profileImg = '',
    this.amount = '',
    this.lastTransactionDate = -1,
    this.type = '',
    this.showTransactionDetails = false,
    this.isUserVerified = false,
    this.enableBiometric = false,
    this.isPinned = false,
    this.isSelected = false
  });
}