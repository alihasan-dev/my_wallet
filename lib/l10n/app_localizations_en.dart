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
  String get appearance => 'Appearance';

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
  String get show_archived_friends => 'Show Archived Friends';

  @override
  String get show_archived_friends_msg =>
      'Include archived friends in your friends list';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get forgotPasswordMsg =>
      'Enter the email address associated with your account and we\'ll send you a link to reset your password';

  @override
  String get send => 'Send';

  @override
  String get imageSizeMsg => 'Images size must be less than 2 MB';

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
  String get transactionBreakdown => 'Show Transaction Details';

  @override
  String get transactionBreakdownMsg =>
      'Display additional details for each transaction';

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

  @override
  String get deleted => 'Deleted';

  @override
  String get create_archived_user_label => 'Create as archived user';

  @override
  String get archived_user_hint =>
      'Archived users are hidden from the main list (if the \'Show Archived Users\' option is disabled in settings). Restore them anytime by long-pressing them and tapping \'Unarchive\'.';

  @override
  String get transactionDescription => 'Show Transaction Descriptions';

  @override
  String get transactionDescriptionMsg =>
      'Display descriptions for your transactions';

  @override
  String get transactionStatus => 'Transaction Status';

  @override
  String get importReport => 'Import Report';

  @override
  String get transactionImport => 'Transaction Import';

  @override
  String get optional => 'Optional';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get transactionStatusMsg =>
      'Active transactions count toward your balance. You can change this anytime by editing the transaction.';

  @override
  String get upload => 'Upload';

  @override
  String get review => 'Review';

  @override
  String get clean => 'Clean';

  @override
  String get confirm => 'Confirm';

  @override
  String get drag_drop_msg => 'Drag and drop or ';

  @override
  String get select_files => 'select files';

  @override
  String get upload_file_msg =>
      'Upload your transaction file in CSV (.csv) or Excel (.xlsx/.xls) format.\nThe maximum file size allowed is 2 MB';

  @override
  String get download_sample_template => 'Download sample template';

  @override
  String get done => 'Done';

  @override
  String get import_completed => 'Import completed';

  @override
  String import_complete_msg(Object transaction_count) {
    return '$transaction_count transactions imported successfully';
  }

  @override
  String get try_different_file => 'Try a different file';

  @override
  String get loading => 'Loading';

  @override
  String import_valid_transaction_msg(Object row) {
    return 'Import $row Transactions';
  }

  @override
  String invalid_row_msg(Object invalid_row) {
    return 'All $invalid_row rows in your file had issues and were excluded. Nothing will be imported.';
  }

  @override
  String get import_review_msg =>
      'I have reviewed the data and want to import the validated transactions into MyWallet.';

  @override
  String get no_valid_import => 'No valid transactions to import';

  @override
  String get import_warning_msg =>
      'This action cannot be undone automatically — imported transactions can be edited or deleted individually afterward.';

  @override
  String invalid_row_exclude_msg(Object invalid_row) {
    return '$invalid_row invalid rows excluded';
  }

  @override
  String valid_row_include_msg(Object valid_row) {
    return '$valid_row transactions will be imported';
  }

  @override
  String get import_summary => 'Import summary';

  @override
  String get import_failed_parse => 'Import Failed to Parse';

  @override
  String successful_read_file_msg(
    Object file_name,
    Object total_column,
    Object total_row,
  ) {
    return 'Successfully read $total_row rows and $total_column columns from $file_name';
  }

  @override
  String get reading_file => 'Reading your file';

  @override
  String get checking_formats => 'Checking formats';

  @override
  String get checking_your_data => 'Checking your data';

  @override
  String get transaction_import_msg_second =>
      'Your file must match the sample template format, or it will be rejected.';

  @override
  String get transaction_import_msg_first =>
      'Avoid re-uploading a file you\'ve already imported — only exact matches are caught as duplicates, so edited or partial re-uploads may create repeat entries.';

  @override
  String import_valid_transaction(Object valid_row) {
    return 'Import $valid_row transactions';
  }

  @override
  String get transaction_mode => 'Transactions Mode';

  @override
  String get latest_transaction => 'Latest Transaction';

  @override
  String get latest_transaction_msg =>
      'Show the amount from the most recent transaction';

  @override
  String get total_outstanding => 'Total Outstanding';

  @override
  String get total_outstanding_msg =>
      'Show the current outstanding amount with each friend';

  @override
  String get transaction_mode_info_msg =>
      'Your outstanding amount will update when you add, edit, or change a transaction. Existing transactions will be included after your next transaction update.';
}
