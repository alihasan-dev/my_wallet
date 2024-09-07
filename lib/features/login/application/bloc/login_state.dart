sealed class LoginState {}

class LoginInitialState extends LoginState {}

class LoginSuccessState extends LoginState{
  LoginSuccessState();
}

class LoginFailedState extends LoginState{
  String message;
  String title;
  LoginFailedState({required this.message,required this.title});
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