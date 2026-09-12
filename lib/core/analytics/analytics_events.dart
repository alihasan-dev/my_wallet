class AnalyticsEvents {
  AnalyticsEvents._();

  static const login = 'login';

  static const logout = 'logout';
  
  static const signUp = 'sign_up';

  static const forgotPassword = 'forgot_password';

  static const transactionCreated = 'transaction_created';

  static const transactionUpdated = 'transaction_updated';

  static const transactionDeleted = 'transaction_deleted';

  static const transactionActivated = 'transaction_activated';

  static const transactionDeactivated = 'transaction_deactivated';

  static const transactionFilterApplied = 'transaction_filter_applied';

  static const reportGenerated = 'report_generated';

  static const transactionImport = 'transaction_import';

  static const settingsChanged = 'settings_changed';

  static const friendAdded = 'friend_added';

  static const friendDeleted = 'friend_deleted';

  static const friendUpdated = 'friend_updated';
}