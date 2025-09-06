part of 'signup_bloc.dart';

sealed class SignupState {}

class SignupInitialState extends SignupState {}

class SignupSuccessState extends SignupState{
  String title;
  String message;
  SignupSuccessState({this.title = '', this.message = ''});
}

class SignupFailedState extends SignupState{
  String message;
  String title;
  bool canShowSnackBar;
  SignupFailedState({required this.message,required this.title, this.canShowSnackBar = true});
}

class SignupLoadingState extends SignupState{}

class SignupNameFieldState extends SignupState{
  String message;
  SignupNameFieldState({required this.message});
}

class SignupEmailFieldState extends SignupState{
  String message;
  SignupEmailFieldState({required this.message});
}

class SignupPasswordFieldState extends SignupState{
  String message;
  SignupPasswordFieldState({required this.message});
}

class SignupPasswordVisibilityState extends SignupState{
  bool isVisible;
  SignupPasswordVisibilityState(this.isVisible);
}