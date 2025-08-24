import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants/app_strings.dart';
import '../../../../features/dashboard/domain/user_model.dart';
import '../../../../utils/preferences.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  late DocumentReference _firebaseDocumentRef;
  late StreamSubscription<DocumentSnapshot> _streamSubscription;
  late UserModel _userModel;

  SettingsBloc() : super(SettingsInitialState()) {
    _userModel = UserModel(userId: '', name: '', email: '', phone: '');
    _firebaseDocumentRef = FirebaseFirestore.instance.collection('users').doc(Preferences.getString(key: AppStrings.prefUserId));
    on<SettingsChangeThemeEvent>(_onLanguageChangeEvent);
    on<SettingsUserDetailsEvent>(_onUserDetails);
    on<SettingsOnChangeVerifiedEvent>(_onChangeVerifiedUser);
    on<SettingsOnChangeBiometricEvent>(_onChangeEnableBiometric);
    on<SettingsOnChangeTransactionDetailsEvent>(_onChangeTransactionDetails);

    _streamSubscription = _firebaseDocumentRef.snapshots().listen((event) {
      var userData = event.data() as Map;
      if(userData.isNotEmpty) {
        _userModel.userId = userData['user_id'];
        _userModel.email = userData['email'];
        _userModel.name = userData['name'];
        _userModel.showTransactionDetails = userData['showTransactionDetails'] ?? false;
        _userModel.isUserVerified = userData['showUnverified'] ?? false;
        _userModel.enableBiometric = userData['enableBiometric'] ?? false;
        Preferences.setBool(key: AppStrings.prefEnableBiometric, value: userData['enableBiometric'] ?? false);
        Preferences.setBool(key: AppStrings.prefShowTransactionDetails, value: userData['showTransactionDetails'] ?? false);
      }
      add(SettingsUserDetailsEvent());
    });
  }

  Future<void> _onChangeVerifiedUser(SettingsOnChangeVerifiedEvent event, Emitter emit) async {
    await _firebaseDocumentRef.update({
      'showUnverified': event.isVerified
    });
  }

  Future<void> _onChangeTransactionDetails(SettingsOnChangeTransactionDetailsEvent event, Emitter emit) async {
    await _firebaseDocumentRef.update({
      'showTransactionDetails': event.isEnable
    });
  }

  Future<void> _onChangeEnableBiometric(SettingsOnChangeBiometricEvent event, Emitter emit) async {
    await _firebaseDocumentRef.update({
      'enableBiometric': event.enableBiometric
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