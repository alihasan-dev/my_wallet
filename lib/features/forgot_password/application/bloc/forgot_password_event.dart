part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent {}

class ForgotPasswordEmailChangeEvent extends ForgotPasswordEvent {
  String value;

  ForgotPasswordEmailChangeEvent({required this.value});
}

class ForgotPasswordSubmitEvent  extends ForgotPasswordEvent {
  String email;

  ForgotPasswordSubmitEvent({required this.email});
}