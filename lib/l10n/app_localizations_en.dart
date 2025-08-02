// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get login => 'Login';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get profile => 'Profile';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get logoutMsg => 'Are you sure you want to logout?';

  @override
  String get exit => 'Exit';

  @override
  String get exitMsg => 'Are you sure you want to exit?';

  @override
  String get userId => 'User ID';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Address';

  @override
  String get update => 'Update';

  @override
  String get profileUpdateMsg => 'Profile updated successfully';

  @override
  String get addUser => 'Add User';

  @override
  String get dontHaveAccount => 'Don\'t have an account';

  @override
  String get signup => 'Signup';

  @override
  String get alreadyHaveAnAccount => 'Already have an account';

  @override
  String get noTransactionFound => 'No transaction found';

  @override
  String get date => 'Date';

  @override
  String get type => 'Type';

  @override
  String get amount => 'Amount';

  @override
  String get availableBalance => 'Available Balance';

  @override
  String get receive => 'Receive';

  @override
  String get transfer => 'Transfer';

  @override
  String get transferType => 'Transfer Type';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get userProfile => 'User Profile';

  @override
  String get deleteUser => 'Delete User';

  @override
  String deleteUserMsg(String name) {
    return 'Are you sure you want to delete $name';
  }

  @override
  String get selectImg => 'Select Image';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get appearance => 'Appearaance';

  @override
  String get theme => 'Theme';

  @override
  String get systemDefault => 'System default';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get biometricAuthFailed => 'Biometric Authentication Failed';

  @override
  String get biometricAuthFailedMessage =>
      'MyWallet protects your data to avoid unauthorized access.';

  @override
  String get bioAuthFailedTooManyAttemptMessage =>
      'Biometric authentication failed because the API is locked out due to too many attempts. This occurs after 5 failed attempts';

  @override
  String get reAuthenticate => 'Re-Authenticate';

  @override
  String get viewProfile => 'View Profile';

  @override
  String get settings => 'Settings';

  @override
  String get showUnverifiedUser => 'Show Archived User';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get forgotPasswordMsg =>
      'Enter the email address associated with your account and we\'ll send you a link to reset your password';

  @override
  String get send => 'Send';

  @override
  String get imageSizeMsg => 'Image size should not be more than 2MB';

  @override
  String get contacts => 'Contacts';

  @override
  String get aboutMyWallet => 'About MyWallet';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get noUserFound => 'No user found';

  @override
  String get enableBiometric => 'Enable Biometric';

  @override
  String get enableBiometricMsg => 'App unlock using biometric';

  @override
  String get apply => 'Apply';

  @override
  String get clear => 'Clear';

  @override
  String get amountRange => 'Amount Range';

  @override
  String get dateRange => 'Date Range';

  @override
  String get advanceFilter => 'Advance Filter';

  @override
  String get search => 'Search';

  @override
  String get exportReport => 'Export Report';

  @override
  String get delete => 'Delete';

  @override
  String get openAppOnBrowser => 'Open app on browser';

  @override
  String get deleteTransaction => 'Delete Transaction';

  @override
  String get deleteTransactionMsg =>
      'Are you sure you want to delete the selected transaction?';

  @override
  String get deleteSubTransaction => 'Delete Sub Transaction';

  @override
  String get deleteSubTransactionMsg =>
      'Are you sure you want to delete the selected sub transaction?';

  @override
  String get clearSelection => 'Clear Selection';

  @override
  String get importantNote => 'Important Note';

  @override
  String get signupWarningMsg =>
      'If you signed up before using a Google account with the same email address, signing up again with that Google account now will replace your existing account. Please be careful!';

  @override
  String get gotIt => 'Got it';

  @override
  String get transactionBreakdown => 'Transaction Details';

  @override
  String get transactionBreakdownMsg => 'Details for Each Transaction';

  @override
  String get unselect => 'Unselect';

  @override
  String get add => 'Add';

  @override
  String get addTransactionDetails => 'Add Transaction Details';

  @override
  String get description => 'Description';

  @override
  String get rate => 'Rate per piece';

  @override
  String get quantity => 'Quantity';

  @override
  String get total => 'Total';

  @override
  String get noTransactionDetailsFound => 'No transaction details found';

  @override
  String get pin => 'Pin';

  @override
  String get archive => 'Archive';
}
