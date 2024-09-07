sealed class SignupEvent {}

class SignupInitialEvent extends SignupEvent {}

class SignupSubmitEvent extends SignupEvent {
  String name;
  String email;
  String password;
  SignupSubmitEvent({required this.name, required this.email, required this.password});
}

class SignupNameChangeEvent extends SignupEvent {
  String name;
  SignupNameChangeEvent({required this.name});
}

class SignupEmailChangeEvent extends SignupEvent {
  String email;
  SignupEmailChangeEvent({required this.email});
}

class SignupPasswordChangeEvent extends SignupEvent {
  String password;
  SignupPasswordChangeEvent({required this.password});
}

class SignupShowPasswordEvent extends SignupEvent {
  bool isVisible;
  SignupShowPasswordEvent({required this.isVisible});
}
