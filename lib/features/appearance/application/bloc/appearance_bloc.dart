import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/constants/app_strings.dart';
import 'package:my_wallet/features/appearance/application/bloc/appearance_event.dart';
import 'package:my_wallet/features/appearance/application/bloc/appearance_state.dart';
import 'package:my_wallet/features/dashboard/domain/user_model.dart';
import 'package:my_wallet/utils/preferences.dart';

class ApperanceBloc extends Bloc<AppearanceEvent, ApperanceState>{

  late DocumentReference _firebaseDocumentRef;
  late StreamSubscription<DocumentSnapshot> _streamSubscription;
  late UserModel _userModel;

  ApperanceBloc() : super(ApperanceInitialState()) {
    _userModel = UserModel(userId: '', name: '', email: '', phone: '');
    _firebaseDocumentRef = FirebaseFirestore.instance.collection('users').doc(Preferences.getString(key: AppStrings.prefUserId));
    on<ApperanceChangeThemeEvent>(_onLanguageChangeEvent);
    on<ApperanceUserDetailsEvent>(_onUserDetails);
    on<ApperanceOnChangeVerifiedEvent>(_onChangeVerifiedUser);

    _streamSubscription = _firebaseDocumentRef.snapshots().listen((event) {
      var userData = event.data() as Map;
      if(userData.isNotEmpty) {
        _userModel.userId = userData['user_id'];
        _userModel.email = userData['email'];
        _userModel.name = userData['name'];
        _userModel.isUserVerified = userData['showUnverified'] ?? false;
      }
      add(ApperanceUserDetailsEvent());
    });
  }

  Future<void> _onChangeVerifiedUser(ApperanceOnChangeVerifiedEvent event, Emitter emit) async {
    await _firebaseDocumentRef.update({
      'showUnverified': event.isVerified
    });
  }

  void _onUserDetails(ApperanceUserDetailsEvent event, Emitter emit) {
    emit(ApperanceUserDetailsState(userModel: _userModel));
  }

  void _onLanguageChangeEvent(ApperanceChangeThemeEvent event, Emitter emit){
    emit(ApperanceThemeChangeState(themeMode: event.themeMode));
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}