part of 'dashboard_bloc.dart';

sealed class DashboardState {}

class DashboardInitialState extends DashboardState {}

class DashboardSuccessState extends DashboardState{
  DashboardSuccessState();
}

class DashboardAllUserState extends DashboardState {
  List<UserModel> allUser;
  bool isCancelSearch;
  DashboardAllUserState({required this.allUser, this.isCancelSearch = false});
}

class DashboardFailedState extends DashboardState{
  String message;
  String title;
  DashboardFailedState({required this.message,required this.title});
}

class DashboardLoadingState extends DashboardState{}

class DashboardNameFieldState extends DashboardState{
  String nameMessage;
  DashboardNameFieldState({required this.nameMessage});
}

class DashboardEmailFieldState extends DashboardState{
  String emailMessage;
  DashboardEmailFieldState({required this.emailMessage});
}

class DashboardPhoneFieldState extends DashboardState{
  String phoneMessage;
  DashboardPhoneFieldState({required this.phoneMessage});
}

class DashboardPasswordFieldState extends DashboardState{
  String passwordMessage;
  DashboardPasswordFieldState({required this.passwordMessage});
}

class DashboardPasswordVisibilityState extends DashboardState{
  bool isVisible;
  DashboardPasswordVisibilityState(this.isVisible);
}

class DashboardSelectedUserState extends DashboardState {
  String userId;

  DashboardSelectedUserState({this.userId = ''});
}

class DashboardSearchFieldEnableState extends DashboardState {}

class DashboardBiometricAuthState extends DashboardState {
  bool isAuthenticated;

  DashboardBiometricAuthState({this.isAuthenticated = false});
}