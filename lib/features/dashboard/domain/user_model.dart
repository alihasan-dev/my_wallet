// class UserModel {
//   String name;
//   String email;
//   String userId;
//   String phone;
//   String profileImg;
//   String amount;
//   int lastTransactionDate;
//   String type;
//   bool showTransactionDetails;
//   bool isUserVerified;
//   bool enableBiometric;
//   bool isSelected;
//   bool isPinned;

//   UserModel({
//     required this.userId,
//     required this.name, 
//     required this.email,
//     required this.phone,
//     this.profileImg = '',
//     this.amount = '',
//     this.lastTransactionDate = -1,
//     this.type = '',
//     this.showTransactionDetails = false,
//     this.isUserVerified = false,
//     this.enableBiometric = false,
//     this.isPinned = false,
//     this.isSelected = false
//   });
// }



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
    this.isSelected = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserModel) return false;

    return userId == other.userId &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        profileImg == other.profileImg &&
        amount == other.amount &&
        lastTransactionDate == other.lastTransactionDate &&
        type == other.type &&
        showTransactionDetails == other.showTransactionDetails &&
        isUserVerified == other.isUserVerified &&
        enableBiometric == other.enableBiometric &&
        isSelected == other.isSelected &&
        isPinned == other.isPinned;
  }

  @override
  int get hashCode => Object.hash(
        userId,
        name,
        email,
        phone,
        profileImg,
        amount,
        lastTransactionDate,
        type,
        showTransactionDetails,
        isUserVerified,
        enableBiometric,
        isSelected,
        isPinned,
      );
}