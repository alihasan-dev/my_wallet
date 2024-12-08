part of 'dashboard_bloc.dart';

sealed class DashboardEvent {}

class DashboardInitialEvent extends DashboardEvent {}


class DashboardAllUserEvent extends DashboardEvent {}

class DashboardNameChangeEvent extends DashboardEvent {
  String name;
  DashboardNameChangeEvent({required this.name});
}

class DashboardEmailChangeEvent extends DashboardEvent {
  String email;
  DashboardEmailChangeEvent({required this.email});
}

class DashboardAddUserEvent extends DashboardEvent {
  String name;
  String email;
  DashboardAddUserEvent({required this.name, required this.email});
}

class DashboardDeleteUserEvent extends DashboardEvent {
  String docId;
  DashboardDeleteUserEvent({required this.docId});
}

class DashboardUserDetailsEvent extends DashboardEvent {
  UserModel userModel;

  DashboardUserDetailsEvent(this.userModel);
}

class DashboardCancelSearchEvent extends DashboardEvent {}

class DashboardSearchEvent extends DashboardEvent {
  String text;

  DashboardSearchEvent({required this.text});
}

class DashboardSelectedUserEvent extends DashboardEvent {
  String userId;

  DashboardSelectedUserEvent({this.userId = ''});
}