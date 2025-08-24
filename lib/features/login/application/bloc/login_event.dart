part of 'login_bloc.dart';

sealed class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginSubmitEvent extends LoginEvent {
  String email;
  String password;
  bool isRememberMe;
  LoginSubmitEvent({required this.email, required this.password,required this.isRememberMe});
}

class LoginEmailChangeEvent extends LoginEvent {
  String email;
  LoginEmailChangeEvent({required this.email});
}

class LoginPasswordChangeEvent extends LoginEvent {
  String password;
  LoginPasswordChangeEvent({required this.password});
}

class LoginShowPasswordEvent extends LoginEvent {
  bool isVisible;
  LoginShowPasswordEvent({required this.isVisible});
}

class LoginRememberMeEvent extends LoginEvent {
  bool value;
  LoginRememberMeEvent({required this.value});
}

class LoginWithGoogleEvent extends LoginEvent {}

class LoginWithGoogleStatusEvent extends LoginEvent {
  GoogleSignInAccount? googleSignInAccount;
  LoginWithGoogleStatusEvent(this.googleSignInAccount);
}