import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/constants/app_strings.dart';
import 'package:my_wallet/features/dashboard/domain/user_model.dart';
import 'package:my_wallet/utils/preferences.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState>{

  late DocumentReference _firebaseDocumentRef;
  late StreamSubscription<DocumentSnapshot> _streamSubscription;
  late UserModel _userModel;

  SettingsBloc() : super(SettingsInitialState()) {
    _userModel = UserModel(userId: '', name: '', email: '', phone: '');
    _firebaseDocumentRef = FirebaseFirestore.instance.collection('users').doc(Preferences.getString(key: AppStrings.prefUserId));
    on<SettingsChangeThemeEvent>(_onLanguageChangeEvent);
    on<SettingsUserDetailsEvent>(_onUserDetails);
    on<SettingsOnChangeVerifiedEvent>(_onChangeVerifiedUser);

    _streamSubscription = _firebaseDocumentRef.snapshots().listen((event) {
      var userData = event.data() as Map;
      if(userData.isNotEmpty) {
        _userModel.userId = userData['user_id'];
        _userModel.email = userData['email'];
        _userModel.name = userData['name'];
        _userModel.isUserVerified = userData['showUnverified'] ?? false;
      }
      add(SettingsUserDetailsEvent());
    });
  }

  Future<void> _onChangeVerifiedUser(SettingsOnChangeVerifiedEvent event, Emitter emit) async {
    await _firebaseDocumentRef.update({
      'showUnverified': event.isVerified
    });
  }

  void _onUserDetails(SettingsUserDetailsEvent event, Emitter emit) {
    emit(SettingsUserDetailsState(userModel: _userModel));
  }

  void _onLanguageChangeEvent(SettingsChangeThemeEvent event, Emitter emit){
    emit(SettingsThemeChangeState(themeMode: event.themeMode));
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}