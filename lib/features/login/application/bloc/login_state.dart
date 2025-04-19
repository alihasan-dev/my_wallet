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
  String message;
  LoginEmailFieldState({required this.message});
}

class LoginPasswordFieldState extends LoginState{
  String message;
  LoginPasswordFieldState({required this.message});
}

class LoginPasswordVisibilityState extends LoginState{
  bool isVisible;
  LoginPasswordVisibilityState(this.isVisible);
}

class LoginRememberMeState extends LoginState {
  bool isRemmeberMe;
  LoginRememberMeState(this.isRemmeberMe);
}