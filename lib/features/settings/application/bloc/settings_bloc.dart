import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/core/analytics/analytics_events.dart';
import '../../../../constants/app_strings.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../features/dashboard/domain/user_model.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../utils/preferences.dart';
import '../../domain/settings_model.dart';
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
    on<SettingsOnChangeTransactionDescriptionEvent>(_onChangeTransactionDescription);
    on<SettingsOnDashboardTransactionModeEvent>(_onChangeDashboardTransactionMode);

    _streamSubscription = _firebaseDocumentRef.snapshots().listen((event) {
      var userData = event.data() as Map;
      if(userData.isNotEmpty) {
        _userModel.userId = userData['user_id'];
        _userModel.email = userData['email'];
        _userModel.name = userData['name'];
        _userModel.showTransactionDetails = userData['showTransactionDetails'] ?? false;
        _userModel.isUserVerified = userData['showUnverified'] ?? false;
        _userModel.enableBiometric = userData['enableBiometric'] ?? false;
        _userModel.showTransactionDescription = userData['transaction_description'] ?? false;
        Preferences.setBool(key: AppStrings.prefEnableBiometric, value: userData['enableBiometric'] ?? false);
        Preferences.setBool(key: AppStrings.prefShowTransactionDetails, value: userData['showTransactionDetails'] ?? false);
        Preferences.setBool(key: AppStrings.prefShowTransactionDescription, value: userData['transaction_description'] ?? false);
        Preferences.setString(key: AppStrings.prefDashboardAmountMode, value: userData['dashboard_amount_mode'] ?? DashboardAmountMode.latestTransaction.value);
      }
      add(SettingsUserDetailsEvent());
    });
  }

  Future<void> _onChangeVerifiedUser(SettingsOnChangeVerifiedEvent event, Emitter emit) async {
    await _firebaseDocumentRef.update({
      'showUnverified': event.isVerified
    });
    AnalyticsService.instance.logEvent(
      name: AnalyticsEvents.settingsChanged,
      parameters: {
        'setting_name': 'show_archived_user',
        'value': event.isVerified ? 'true' : 'false',
      },
    );
  }

  Future<void> _onChangeTransactionDetails(SettingsOnChangeTransactionDetailsEvent event, Emitter emit) async {
    await _firebaseDocumentRef.update({
      'showTransactionDetails': event.isEnable
    });
    AnalyticsService.instance.logEvent(
      name: AnalyticsEvents.settingsChanged,
      parameters: {
        'setting_name': 'show_transaction_details',
        'value': event.isEnable ? 'true' : 'false',
      },
    );
  }

  Future<void> _onChangeTransactionDescription(SettingsOnChangeTransactionDescriptionEvent event, Emitter emit) async {
    await _firebaseDocumentRef.update({
      'transaction_description': event.isEnable
    });
    AnalyticsService.instance.logEvent(
      name: AnalyticsEvents.settingsChanged,
      parameters: {
        'setting_name': 'show_transaction_description',
        'value': event.isEnable ? 'true' : 'false',
      },
    );
  }

  Future<void> _onChangeDashboardTransactionMode(SettingsOnDashboardTransactionModeEvent event, Emitter emit) async {
    final modeStringValue = event.mode.value;
    await _firebaseDocumentRef.update({'dashboard_amount_mode': modeStringValue});
    AnalyticsService.instance.logEvent(
      name: AnalyticsEvents.settingsChanged,
      parameters: {
        'setting_name': 'dashboard_amount_mode',
        'value': modeStringValue,
      },
    );
  }

  Future<void> _onChangeEnableBiometric(SettingsOnChangeBiometricEvent event, Emitter emit) async {
    await _firebaseDocumentRef.update({
      'enableBiometric': event.enableBiometric
    });
    AnalyticsService.instance.logEvent(
      name: AnalyticsEvents.settingsChanged,
      parameters: {
        'setting_name': 'enable_biometric',
        'value': event.enableBiometric ? 'true' : 'false',
      },
    );
  }

  void _onUserDetails(SettingsUserDetailsEvent event, Emitter emit) {
    emit(SettingsUserDetailsState(userModel: _userModel));
  }

  void _onLanguageChangeEvent(SettingsChangeThemeEvent event, Emitter emit){
    emit(SettingsThemeChangeState(themeMode: event.themeMode));
    AnalyticsService.instance.logEvent(
      name: AnalyticsEvents.settingsChanged,
      parameters: {'setting_name': 'language'},
    );
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}