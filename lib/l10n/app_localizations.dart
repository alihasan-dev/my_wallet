import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @logoutMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutMsg;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @exitMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get exitMsg;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @profileUpdateMsg.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdateMsg;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addUser;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account'**
  String get dontHaveAccount;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account'**
  String get alreadyHaveAnAccount;

  /// No description provided for @noTransactionFound.
  ///
  /// In en, this message translates to:
  /// **'No transaction found'**
  String get noTransactionFound;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get availableBalance;

  /// No description provided for @receive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receive;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @transferType.
  ///
  /// In en, this message translates to:
  /// **'Transfer Type'**
  String get transferType;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// Delete user message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}'**
  String deleteUserMsg(String name);

  /// No description provided for @selectImg.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImg;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @biometricAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication Failed'**
  String get biometricAuthFailed;

  /// No description provided for @biometricAuthFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'MyWallet protects your data to avoid unauthorized access.'**
  String get biometricAuthFailedMessage;

  /// No description provided for @bioAuthFailedTooManyAttemptMessage.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication failed because the API is locked out due to too many attempts. This occurs after 5 failed attempts'**
  String get bioAuthFailedTooManyAttemptMessage;

  /// No description provided for @reAuthenticate.
  ///
  /// In en, this message translates to:
  /// **'Re-Authenticate'**
  String get reAuthenticate;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @show_archived_friends.
  ///
  /// In en, this message translates to:
  /// **'Show Archived Friends'**
  String get show_archived_friends;

  /// No description provided for @show_archived_friends_msg.
  ///
  /// In en, this message translates to:
  /// **'Include archived friends in your friends list'**
  String get show_archived_friends_msg;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordMsg.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address associated with your account and we\'ll send you a link to reset your password'**
  String get forgotPasswordMsg;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @imageSizeMsg.
  ///
  /// In en, this message translates to:
  /// **'Images size must be less than 2 MB'**
  String get imageSizeMsg;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @aboutMyWallet.
  ///
  /// In en, this message translates to:
  /// **'About MyWallet'**
  String get aboutMyWallet;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @noUserFound.
  ///
  /// In en, this message translates to:
  /// **'No user found'**
  String get noUserFound;

  /// No description provided for @enableBiometric.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometric'**
  String get enableBiometric;

  /// No description provided for @enableBiometricMsg.
  ///
  /// In en, this message translates to:
  /// **'App unlock using biometric'**
  String get enableBiometricMsg;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @amountRange.
  ///
  /// In en, this message translates to:
  /// **'Amount Range'**
  String get amountRange;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @advanceFilter.
  ///
  /// In en, this message translates to:
  /// **'Advance Filter'**
  String get advanceFilter;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @openAppOnBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open app on browser'**
  String get openAppOnBrowser;

  /// No description provided for @deleteTransaction.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get deleteTransaction;

  /// No description provided for @deleteTransactionMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the selected transaction?'**
  String get deleteTransactionMsg;

  /// No description provided for @deleteSubTransaction.
  ///
  /// In en, this message translates to:
  /// **'Delete Sub Transaction'**
  String get deleteSubTransaction;

  /// No description provided for @deleteSubTransactionMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the selected sub transaction?'**
  String get deleteSubTransactionMsg;

  /// No description provided for @clearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear Selection'**
  String get clearSelection;

  /// No description provided for @importantNote.
  ///
  /// In en, this message translates to:
  /// **'Important Note'**
  String get importantNote;

  /// No description provided for @signupWarningMsg.
  ///
  /// In en, this message translates to:
  /// **'If you signed up before using a Google account with the same email address, signing up again with that Google account now will replace your existing account. Please be careful!'**
  String get signupWarningMsg;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @transactionBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Show Transaction Details'**
  String get transactionBreakdown;

  /// No description provided for @transactionBreakdownMsg.
  ///
  /// In en, this message translates to:
  /// **'Display additional details for each transaction'**
  String get transactionBreakdownMsg;

  /// No description provided for @unselect.
  ///
  /// In en, this message translates to:
  /// **'Unselect'**
  String get unselect;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addTransactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction Details'**
  String get addTransactionDetails;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate per piece'**
  String get rate;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @noTransactionDetailsFound.
  ///
  /// In en, this message translates to:
  /// **'No transaction details found'**
  String get noTransactionDetailsFound;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pin;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @create_archived_user_label.
  ///
  /// In en, this message translates to:
  /// **'Create as archived user'**
  String get create_archived_user_label;

  /// No description provided for @archived_user_hint.
  ///
  /// In en, this message translates to:
  /// **'Archived users are hidden from the main list (if the \'Show Archived Users\' option is disabled in settings). Restore them anytime by long-pressing them and tapping \'Unarchive\'.'**
  String get archived_user_hint;

  /// No description provided for @transactionDescription.
  ///
  /// In en, this message translates to:
  /// **'Show Transaction Descriptions'**
  String get transactionDescription;

  /// No description provided for @transactionDescriptionMsg.
  ///
  /// In en, this message translates to:
  /// **'Display descriptions for your transactions'**
  String get transactionDescriptionMsg;

  /// No description provided for @transactionStatus.
  ///
  /// In en, this message translates to:
  /// **'Transaction Status'**
  String get transactionStatus;

  /// No description provided for @importReport.
  ///
  /// In en, this message translates to:
  /// **'Import Report'**
  String get importReport;

  /// No description provided for @transactionImport.
  ///
  /// In en, this message translates to:
  /// **'Transaction Import'**
  String get transactionImport;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @transactionStatusMsg.
  ///
  /// In en, this message translates to:
  /// **'Active transactions count toward your balance. You can change this anytime by editing the transaction.'**
  String get transactionStatusMsg;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @clean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get clean;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @drag_drop_msg.
  ///
  /// In en, this message translates to:
  /// **'Drag and drop or '**
  String get drag_drop_msg;

  /// No description provided for @select_files.
  ///
  /// In en, this message translates to:
  /// **'select files'**
  String get select_files;

  /// No description provided for @upload_file_msg.
  ///
  /// In en, this message translates to:
  /// **'Upload your transaction file in CSV (.csv) or Excel (.xlsx/.xls) format.\nThe maximum file size allowed is 2 MB'**
  String get upload_file_msg;

  /// No description provided for @download_sample_template.
  ///
  /// In en, this message translates to:
  /// **'Download sample template'**
  String get download_sample_template;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @import_completed.
  ///
  /// In en, this message translates to:
  /// **'Import completed'**
  String get import_completed;

  /// No description provided for @import_complete_msg.
  ///
  /// In en, this message translates to:
  /// **'{transaction_count} transactions imported successfully'**
  String import_complete_msg(Object transaction_count);

  /// No description provided for @try_different_file.
  ///
  /// In en, this message translates to:
  /// **'Try a different file'**
  String get try_different_file;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @import_valid_transaction_msg.
  ///
  /// In en, this message translates to:
  /// **'Import {row} Transactions'**
  String import_valid_transaction_msg(Object row);

  /// No description provided for @invalid_row_msg.
  ///
  /// In en, this message translates to:
  /// **'All {invalid_row} rows in your file had issues and were excluded. Nothing will be imported.'**
  String invalid_row_msg(Object invalid_row);

  /// No description provided for @import_review_msg.
  ///
  /// In en, this message translates to:
  /// **'I have reviewed the data and want to import the validated transactions into MyWallet.'**
  String get import_review_msg;

  /// No description provided for @no_valid_import.
  ///
  /// In en, this message translates to:
  /// **'No valid transactions to import'**
  String get no_valid_import;

  /// No description provided for @import_warning_msg.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone automatically — imported transactions can be edited or deleted individually afterward.'**
  String get import_warning_msg;

  /// No description provided for @invalid_row_exclude_msg.
  ///
  /// In en, this message translates to:
  /// **'{invalid_row} invalid rows excluded'**
  String invalid_row_exclude_msg(Object invalid_row);

  /// No description provided for @valid_row_include_msg.
  ///
  /// In en, this message translates to:
  /// **'{valid_row} transactions will be imported'**
  String valid_row_include_msg(Object valid_row);

  /// No description provided for @import_summary.
  ///
  /// In en, this message translates to:
  /// **'Import summary'**
  String get import_summary;

  /// No description provided for @import_failed_parse.
  ///
  /// In en, this message translates to:
  /// **'Import Failed to Parse'**
  String get import_failed_parse;

  /// No description provided for @successful_read_file_msg.
  ///
  /// In en, this message translates to:
  /// **'Successfully read {total_row} rows and {total_column} columns from {file_name}'**
  String successful_read_file_msg(
    Object file_name,
    Object total_column,
    Object total_row,
  );

  /// No description provided for @reading_file.
  ///
  /// In en, this message translates to:
  /// **'Reading your file'**
  String get reading_file;

  /// No description provided for @checking_formats.
  ///
  /// In en, this message translates to:
  /// **'Checking formats'**
  String get checking_formats;

  /// No description provided for @checking_your_data.
  ///
  /// In en, this message translates to:
  /// **'Checking your data'**
  String get checking_your_data;

  /// No description provided for @transaction_import_msg_second.
  ///
  /// In en, this message translates to:
  /// **'Your file must match the sample template format, or it will be rejected.'**
  String get transaction_import_msg_second;

  /// No description provided for @transaction_import_msg_first.
  ///
  /// In en, this message translates to:
  /// **'Avoid re-uploading a file you\'ve already imported — only exact matches are caught as duplicates, so edited or partial re-uploads may create repeat entries.'**
  String get transaction_import_msg_first;

  /// No description provided for @import_valid_transaction.
  ///
  /// In en, this message translates to:
  /// **'Import {valid_row} transactions'**
  String import_valid_transaction(Object valid_row);

  /// No description provided for @transaction_mode.
  ///
  /// In en, this message translates to:
  /// **'Transactions Mode'**
  String get transaction_mode;

  /// No description provided for @latest_transaction.
  ///
  /// In en, this message translates to:
  /// **'Latest Transaction'**
  String get latest_transaction;

  /// No description provided for @latest_transaction_msg.
  ///
  /// In en, this message translates to:
  /// **'Show the amount from the most recent transaction'**
  String get latest_transaction_msg;

  /// No description provided for @total_outstanding.
  ///
  /// In en, this message translates to:
  /// **'Total Outstanding'**
  String get total_outstanding;

  /// No description provided for @total_outstanding_msg.
  ///
  /// In en, this message translates to:
  /// **'Show the current outstanding amount with each friend'**
  String get total_outstanding_msg;

  /// No description provided for @transaction_mode_info_msg.
  ///
  /// In en, this message translates to:
  /// **'Your outstanding amount will update when you add, edit, or change a transaction. Existing transactions will be included after your next transaction update.'**
  String get transaction_mode_info_msg;

  /// No description provided for @transaction_details.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transaction_details;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
