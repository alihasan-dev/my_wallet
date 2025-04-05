import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/utils/app_extension_method.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/preferences.dart';
import '../../../../utils/check_connectivity.dart';
part 'profile_state.dart';
part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  bool idVisible = false;
  late DocumentReference firebaseDocReference;
  late StreamSubscription<DocumentSnapshot> streamSubscription;
  late Reference firebaseStorage;
  var profileData = <String, dynamic>{};
  late CheckConnectivity checkConnectivity;
  String selectedImagePath = '';
  String friendId;

  ProfileBloc({this.friendId = ''}) : super(ProfileInitialState()) {
    checkConnectivity = CheckConnectivity();
    var userCollectionRef = FirebaseFirestore.instance.collection('users').doc(Preferences.getString(key: AppStrings.prefUserId));
    firebaseDocReference = friendId.isEmpty ? userCollectionRef : userCollectionRef.collection('friends').doc(friendId);
    firebaseStorage = FirebaseStorage.instance.ref();

    ///Register Event Here
    on<ProfileUpdateEvent>(_onProfileUpdate);
    on<ProfileShowIdEvent>(_onProfileShowId);
    on<ProfileDataEvent>(_getProfileData);
    on<ProfileNameChangeEvent>(_onNameChange);
    on<ProfilePhoneChangeEvent>(_onPhoneChange);
    on<ProfileEmailChangeEvent>(_onEmailChange);
    on<ProfileChooseImageEvent>(_onChooseImage);
    on<ProfileDeleteUserEvent>(_onDeleteUser);

    streamSubscription = firebaseDocReference.snapshots().listen((event) { 
      profileData = event.data() as Map<String, dynamic>;
      if(profileData['user_id'] == null) {
        profileData['user_id'] = friendId;
      }
      add(ProfileDataEvent());
    });
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }

  void _onNameChange(ProfileNameChangeEvent event, Emitter emit) {
    if(event.text.isEmpty){
      emit(ProfileErrorNameState(message: AppStrings.emptyName));
    } else {
      emit(ProfileErrorNameState(message: AppStrings.emptyString));
    }
  }

  void _onEmailChange(ProfileEmailChangeEvent event, Emitter emit) {
    if(event.email.isEmpty) {
      emit(ProfileErrorEmailState(message: AppStrings.emptyEmail));
    } else if(!event.email.isValidEmail) {
      emit(ProfileErrorEmailState(message: AppStrings.invalidEmail));
    } else {
      emit(ProfileErrorEmailState(message: AppStrings.emptyString));
    }
  }

  void _onPhoneChange(ProfilePhoneChangeEvent event, Emitter emit) {
    if(event.text.length < 10) {
      emit(ProfileErrorPhoneState(message: AppStrings.invalidPhone));
    } else {
      emit(ProfileErrorPhoneState(message: AppStrings.emptyString));
    }
  }

  void _onChooseImage(ProfileChooseImageEvent event, Emitter emit) {
    selectedImagePath = event.imagePath;
    emit(ProfileChooseImageState(imagePath: selectedImagePath));
  }

  Future<void> _onProfileUpdate(ProfileUpdateEvent event, Emitter emit) async {
    if(await fieldValidation(event, emit)) {
      var updatedImageUrl = '';
      if(selectedImagePath.isNotEmpty) {
        emit(ProfileLoadingState());
        try {
          final mountainImagesRef = friendId.isEmpty 
          ? firebaseStorage.child("${Preferences.getString(key: AppStrings.prefUserId)}/profile_img.jpg")
          : firebaseStorage.child("${Preferences.getString(key: AppStrings.prefUserId)}/friends/$friendId.jpg");
          await mountainImagesRef.putData(base64Decode(selectedImagePath), SettableMetadata(contentType: 'image/jpeg')).then((value) async {
            await mountainImagesRef.getDownloadURL().then((value) {
              updatedImageUrl = value;
            });
          });
        } catch (e) {
          debugPrint(AppStrings.somethingWentWrong);
        }
      }
      await firebaseDocReference.update({
        'email': event.profileData['email'],
        'name': event.profileData['name'],
        'user_id': event.profileData['user_id'],
        'phone': event.profileData['phone'],
        'address': event.profileData['address'],
        'profile_img': updatedImageUrl.isEmpty ? event.profileData['profile_img'] : updatedImageUrl
      });
    } 
  }

  Future<void> _onDeleteUser(ProfileDeleteUserEvent event, Emitter emit) async {
    if(event.isConfirmed) {
      emit(ProfileLoadingState());
      await firebaseDocReference.delete();
      emit(ProfileDeleteUserState(isDeleted: true));
    } else {
      emit(ProfileDeleteUserState());
    }
  }

  void _getProfileData(ProfileDataEvent event, Emitter emit) {
    emit(ProfileSuccessState(profileData: profileData));
  }

  void _onProfileShowId(ProfileShowIdEvent event, Emitter emit) {
    idVisible = !idVisible;
    emit(ProfileShowIdState(isIdVisible: idVisible));
  }

  Future<bool> fieldValidation(ProfileUpdateEvent event, Emitter emit) async {
    if(event.profileData['user_id'].isEmpty) {
      emit(ProfileErrorIdState(message: AppStrings.emptyEmail));
      return false;
    } else if(event.profileData['email'].isEmpty) {
      emit(ProfileErrorEmailState(message: AppStrings.emptyEmail));
      return false;
    } else if(event.profileData['name'].isEmpty) {
      emit(ProfileErrorNameState(message: AppStrings.emptyEmail));
      return false;
    } else if(event.profileData['phone'].isNotEmpty) {
      var data = event.profileData['phone'];
      if(data.length < 10) return false;
      return true;
    } else if (!await checkConnectivity.hasConnection) {
      emit(ProfileFailedState(title: AppStrings.noInternetConnection, message: AppStrings.noInternetConnectionMessage));
      return false;
    } else {
      return true;
    }
  }
  
}