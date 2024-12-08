part of 'profile_bloc.dart';

sealed class ProfileState {}

class ProfileInitialState extends ProfileState {}


class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  Map<String, dynamic> profileData;
  ProfileSuccessState({required this.profileData});
}

class ProfileFailedState extends ProfileState {
  String title;
  String message;
  ProfileFailedState({this.title = '', this.message = ''});
}

class ProfileShowIdState extends ProfileState {
  bool isIdVisible = false;
  ProfileShowIdState({required this.isIdVisible});
}

class ProfileErrorIdState extends ProfileState {
  String message;
  ProfileErrorIdState({required this.message});
}

class ProfileErrorEmailState extends ProfileState {
  String message;
  ProfileErrorEmailState({required this.message});
}

class ProfileErrorNameState extends ProfileState {
  String message;
  ProfileErrorNameState({required this.message});
}

class ProfileErrorPhoneState extends ProfileState {
  String message;
  ProfileErrorPhoneState({required this.message});
}

class ProfileErrorAddressState extends ProfileState {
  String message;
  ProfileErrorAddressState({required this.message});
}

class ProfileChooseImageState extends ProfileState {
  String imagePath;
  ProfileChooseImageState({required this.imagePath});
}

class ProfileDeleteUserState extends ProfileState {
  bool isDeleted;

  ProfileDeleteUserState({this.isDeleted = false});
}