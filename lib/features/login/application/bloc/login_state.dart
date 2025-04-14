part of 'login_bloc.dart';

sealed class LoginState {}

class LoginInitialState extends LoginState {}

class LoginSuccessState extends LoginState{
  String title;
  String message;
  LoginSuccessState({this.title = '', this.message = ''});
}

class LoginFailedState extends LoginState{
  String message;
  String title;
  bool canShowSnackBar;
  LoginFailedState({required this.message,required this.title, this.canShowSnackBar = true});
}

class LoginLoadingState extends LoginState{}

class LoginEmailFieldState extends LoginState{
  String emailMessage;
  LoginEmailFieldState({required this.emailMessage});
}

class LoginPasswordFieldState extends LoginState{
  String passwordMessage;
  LoginPasswordFieldState({required this.passwordMessage});
}

class LoginPasswordVisibilityState extends LoginState{
  bool isVisible;
  LoginPasswordVisibilityState(this.isVisible);
}

class LoginRememberMeState extends LoginState {
  bool isRemmeberMe;
  LoginRememberMeState(this.isRemmeberMe);
}