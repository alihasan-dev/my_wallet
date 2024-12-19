part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordState {}

class ForgotPasswordInitialState extends ForgotPasswordState {}

class ForgotPasswordEmailFieldState extends ForgotPasswordState {
  String message;

  ForgotPasswordEmailFieldState({this.message = ''});
}

class ForgotPasswordSuccessState extends ForgotPasswordState {
  String message;

  ForgotPasswordSuccessState({this.message = ''});
}

class ForgotPasswordFailedState extends ForgotPasswordState {
  String title;
  String message;

  ForgotPasswordFailedState({this.title = '', this.message = ''});
}

class ForgotPasswordLoadingState extends ForgotPasswordState {
  ForgotPasswordLoadingState();
}