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
  bool canShowSnaclBar;
  SignupFailedState({required this.message,required this.title, this.canShowSnaclBar = true});
}

class SignupLoadingState extends SignupState{}

class SignupNameFieldState extends SignupState{
  String nameMessage;
  SignupNameFieldState({required this.nameMessage});
}

class SignupEmailFieldState extends SignupState{
  String emailMessage;
  SignupEmailFieldState({required this.emailMessage});
}

class SignupPasswordFieldState extends SignupState{
  String passwordMessage;
  SignupPasswordFieldState({required this.passwordMessage});
}

class SignupPasswordVisibilityState extends SignupState{
  bool isVisible;
  SignupPasswordVisibilityState(this.isVisible);
}