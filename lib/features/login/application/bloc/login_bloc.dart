import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../constants/app_strings.dart';
import '../../../../core/analytics/analytics_events.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../utils/check_connectivity.dart';
import '../../../../utils/preferences.dart';
import '../../../settings/domain/settings_model.dart';
part 'login_event.dart';
part 'login_state.dart';

///The business logic layer's responsibilities is to respond to input from the presentation layer with new states.
///This layer can depend on one or more repositories to reterieve data needed to build up the aplication state.
///
///Business logic layer as the bridge between the user interface (presentation layer) and the data layer.
///Business logic layer is notified of events/actions from the presentation layer and then communicates with 
///repository in order to build a new state for the presentation layer to consume.

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  late CheckConnectivity checkConnectivity;
  late FirebaseAuth _authInstance;
  late CollectionReference _collectionReference;
  late DocumentReference firebaseDocumentReference;
  late GoogleSignIn _googleSignIn;
  // bool _isGoogleSignedOut = false;
  // StreamSubscription? _googleSignInSubscription;

  LoginBloc() : super(LoginInitialState()) {
    _googleSignIn = GoogleSignIn(
      clientId: AppStrings.googleSignInClientId,
      scopes: ["email"],
    );
    _authInstance = FirebaseAuth.instance;
    _collectionReference = FirebaseFirestore.instance.collection('users');
    checkConnectivity = CheckConnectivity();
    on<LoginSubmitEvent>(_onLoginSubmit);
    on<LoginEmailChangeEvent>(_onEmailChange);
    on<LoginPasswordChangeEvent>(_onPasswordChange);
    on<LoginShowPasswordEvent>(_onShowHidePassword);
    on<LoginRememberMeEvent>(_onRememberMe);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    // on<LoginWithGoogleStatusEvent>(_onLoginWithGoogleStatus);

    // _googleSignInSubscription = _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
    //   if(!Preferences.getBool(key: AppStrings.prefGoogleSignInFromSignup)) {
    //     add(LoginWithGoogleStatusEvent(account));
    //   }
    // });
  }

  // @override
  // Future<void> close() {
  //   _googleSignInSubscription?.cancel();
  //   return super.close();
  // }

  // Future<void> _onLoginWithGoogleStatus(LoginWithGoogleStatusEvent event, Emitter<LoginState> emit) async {
    // emit(LoginLoadingState());
    // if(event.googleSignInAccount != null) {
    //   final displayName = event.googleSignInAccount!.displayName ?? '';
    //   final photoUrl = event.googleSignInAccount!.photoUrl;
    //   final email = event.googleSignInAccount!.email;
    //   final authentication = await event.googleSignInAccount!.authentication;
    //   final authCredential = GoogleAuthProvider.credential(
    //     idToken: authentication.idToken,
    //     accessToken: authentication.accessToken
    //   );
    //   final firebaseUserCredential = await authInstance.signInWithCredential(authCredential);
    //   final user = firebaseUserCredential.user;
    //   if(firebaseUserCredential.additionalUserInfo != null && user != null) {
    //     if(!firebaseUserCredential.additionalUserInfo!.isNewUser) {
    //       firebaseDocumentReference = FirebaseFirestore.instance.collection('users').doc(user.uid);
    //       Preferences.setString(key: AppStrings.prefUserId, value: user.uid);
    //       Preferences.setString(key: AppStrings.prefEmail, value: email);
    //       await firebaseDocumentReference.get().then((data) {
    //         var mapData = data.data() as Map;
    //         if(mapData.isNotEmpty) {
    //           Preferences.setBool(key: AppStrings.prefEnableBiometric, value: mapData['enableBiometric'] ?? false);
    //           Preferences.setBool(key: AppStrings.prefShowTransactionDetails, value: mapData['showTransactionDetails'] ?? false);
    //           Preferences.setBool(key: AppStrings.prefShowTransactionDescription, value: mapData['transaction_description'] ?? false);
    //           Preferences.setString(
    //             key: AppStrings.prefProfileImg, 
    //             value: (mapData['profile_img'] ?? '').toString().isBlank
    //             ? AppStrings.sampleImg
    //             : mapData['profile_img']
    //           );
    //         }
    //       });
    //       ///capture event
    //       await AnalyticsService.instance.setUserId(user.uid);
    //       await AnalyticsService.instance.logEvent(
    //         name: AnalyticsEvents.login,
    //         parameters: {'method': 'google'},
    //       );
    //       emit(LoginSuccessState(title: AppStrings.success, message: AppStrings.loginSuccessMsg));
    //     } else {
    //       Preferences.setString(key: AppStrings.prefUserId, value: user.uid);
    //       Preferences.setString(key: AppStrings.prefEmail, value: email);
    //       Preferences.setBool(key: AppStrings.prefRememberMe,value: false);
    //       Preferences.setString(key: AppStrings.prefFullName, value: displayName);
    //       ///store user in firebase firestore
    //       await _collectionReference.doc(user.uid).set({
    //         'name': displayName,
    //         'email': email,
    //         'user_id': user.uid,
    //         'profile_img': !(photoUrl ?? '').isBlank 
    //         ? photoUrl ?? ''
    //         : AppStrings.sampleImg,
    //         'showUnverified': true,
    //         'enableBiometric': false
    //       });
    //       Preferences.setString(
    //         key: AppStrings.prefProfileImg, 
    //         value: !(photoUrl ?? '').isBlank 
    //         ? photoUrl ?? ''
    //         : AppStrings.sampleImg,
    //       );
    //       Preferences.setBool(key: AppStrings.prefEnableBiometric, value: false);
    //       ///capture event
    //       await AnalyticsService.instance.setUserId(user.uid);
    //       await AnalyticsService.instance.logEvent(
    //         name: AnalyticsEvents.login,
    //         parameters: {'method': 'google'},
    //       );
    //       emit(LoginSuccessState(title: AppStrings.success, message: AppStrings.loginSuccessNewUserMsg));
    //     }
    //   } else {
    //     _isGoogleSignedOut = true;
    //     emit(LoginFailedState(title: AppStrings.error, message: AppStrings.somethingWentWrong));
    //     // await _googleSignIn.signOut();
    //   }
    // } else {
    //   emit(LoginFailedState(
    //     title: AppStrings.failed, 
    //     message: AppStrings.googleSigninFailedMsg, 
    //     canShowSnackBar: !_isGoogleSignedOut
    //   ));
    //   _isGoogleSignedOut = true;
    // }
  // }

  // Future<void> _onLoginWithGoogle(LoginWithGoogleEvent event, Emitter<LoginState> emit) async {
  //   try {
  //     emit(LoginLoadingState());
  //     final userCredential = await authInstance.signInWithPopup(GoogleAuthProvider());
  //     var user = userCredential.user;
  //     // if (user != null) {
  //     //   firebaseDocumentReference = FirebaseFirestore.instance.collection('users').doc(user.uid);
  //     //   Preferences.setString(key: AppStrings.prefUserId, value: user.uid);
  //     //   Preferences.setString(key: AppStrings.prefEmail, value: user.email);
  //     //   Preferences.setBool(key: AppStrings.prefRememberMe,value: event.isRememberMe);
  //     //   if(event.isRememberMe) {
  //     //     Preferences.setString(key: AppStrings.prefPassword, value: event.password);
  //     //   }
  //     //   await firebaseDocumentReference.get().then((data) {
  //     //     var mapData = data.data() as Map;
  //     //     if(mapData.isNotEmpty) {
  //     //       Preferences.setBool(key: AppStrings.prefEnableBiometric, value: mapData['enableBiometric'] ?? false);
  //     //       Preferences.setBool(key: AppStrings.prefShowTransactionDetails, value: mapData['showTransactionDetails'] ?? false);
  //     //       Preferences.setBool(key: AppStrings.prefShowTransactionDescription, value: mapData['transaction_description'] ?? false);
  //     //       Preferences.setString(
  //     //         key: AppStrings.prefProfileImg, 
  //     //         value: (mapData['profile_img'] ?? '').toString().isBlank
  //     //         ? AppStrings.sampleImg
  //     //         : mapData['profile_img']
  //     //       );
  //     //     }
  //     //   });
  //     //   ///capture log event
  //     //   await AnalyticsService.instance.setUserId(user.uid);
  //     //   await AnalyticsService.instance.logEvent(
  //     //     name: AnalyticsEvents.login,
  //     //     parameters: {'method': 'email'},
  //     //   );
  //     //   emit(LoginSuccessState(title: AppStrings.success, message: AppStrings.loginSuccessMsg));
  //     // } else {
  //     //   emit(LoginFailedState(title: AppStrings.error, message: AppStrings.somethingWentWrong));
  //     // }
  //   } on FirebaseAuthException catch (e) {
  //     emit(LoginFailedState(title: AppStrings.failed, message: e.message!));
  //   }

  //   // try {
  //   //   final data = await _googleSignIn.signIn(); 
  //   //   if (data == null) throw CustomException();
  //   // } on CustomException catch (_) {
  //   //   emit(LoginFailedState(
  //   //     title: AppStrings.failed, 
  //   //     message: AppStrings.googleSigninFailedMsg,
  //   //   ));
  //   // }
  // }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogleEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());
    try {
      // final googleProvider = GoogleAuthProvider();
      // final firebaseUserCredential = 
      // kIsWeb
      // ? await authInstance.signInWithPopup(googleProvider)
      // : await signInWithGoogle();
      final firebaseUserCredential = await signInWithGoogle();
      if (firebaseUserCredential == null) {
        throw FirebaseAuthException(
          code: 'sign-in-cancelled',
          message: 'Google sign-in was cancelled.'
        );
      }
      final user = firebaseUserCredential.user;
      if (user == null) {
        emit(
          LoginFailedState(
            title: AppStrings.error,
            message: AppStrings.somethingWentWrong,
          ),
        );
        return;
      }
      final additionalUserInfo = firebaseUserCredential.additionalUserInfo;
      final isNewUser = additionalUserInfo?.isNewUser ?? false;
      final email = user.email ?? '';
      final displayName = user.displayName ?? '';
      final photoUrl = user.photoURL ?? '';
      final userId = user.uid;
      Preferences.setString(key: AppStrings.prefUserId, value: userId);
      Preferences.setString(key: AppStrings.prefEmail, value: email);
      if (isNewUser) {
        Preferences.setBool(key: AppStrings.prefRememberMe,value: false);
        Preferences.setString(key: AppStrings.prefFullName, value: displayName);
        //store user in firebase firestore
        await _collectionReference.doc(user.uid).set({
          'name': displayName,
          'email': email,
          'user_id': userId,
          'profile_img': !photoUrl.isBlank 
          ? photoUrl
          : AppStrings.sampleImg,
          'showUnverified': true,
          'enableBiometric': false
        });
        Preferences.setString(
          key: AppStrings.prefProfileImg, 
          value: !photoUrl.isBlank 
          ? photoUrl
          : AppStrings.sampleImg,
        );
        Preferences.setBool(key: AppStrings.prefEnableBiometric, value: false);
      } else {
        firebaseDocumentReference = FirebaseFirestore.instance.collection('users').doc(userId);
        await firebaseDocumentReference.get().then((data) {
          var mapData = data.data() as Map;
          if(mapData.isNotEmpty) {
            Preferences.setBool(key: AppStrings.prefEnableBiometric, value: mapData['enableBiometric'] ?? false);
            Preferences.setBool(key: AppStrings.prefShowTransactionDetails, value: mapData['showTransactionDetails'] ?? false);
            Preferences.setBool(key: AppStrings.prefShowTransactionDescription, value: mapData['transaction_description'] ?? false);
            Preferences.setString(key: AppStrings.prefDashboardAmountMode, value: mapData['dashboard_amount_mode'] ?? DashboardAmountMode.latestTransaction.value);
            Preferences.setString(
              key: AppStrings.prefProfileImg, 
              value: (mapData['profile_img'] ?? '').toString().isBlank
              ? AppStrings.sampleImg
              : mapData['profile_img']
            );
          }
        });
      }
      ///capture event
      await AnalyticsService.instance.setUserId(userId);
      await AnalyticsService.instance.logEvent(
        name: isNewUser
        ? AnalyticsEvents.signUp
        : AnalyticsEvents.login,
        parameters: {'method': 'google'},
      );
      emit(
        LoginSuccessState(
          title: AppStrings.success,
          message: isNewUser
          ? AppStrings.loginSuccessNewUserMsg
          : AppStrings.loginSuccessMsg,
        ),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Google Firebase Auth Error: ${e.code} - ${e.message}');
      emit(
        LoginFailedState(
          title: AppStrings.failed,
          message: e.message ?? AppStrings.googleSigninFailedMsg,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Google Login Error: $e');
      debugPrintStack(stackTrace: stackTrace);
      emit(
        LoginFailedState(
          title: AppStrings.error,
          message: AppStrings.googleSigninFailedMsg,
        ),
      );
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      return await _authInstance.signInWithPopup(GoogleAuthProvider());
    }
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // user cancelled the sign-in flow
      return null;
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _onLoginSubmit(LoginSubmitEvent event, Emitter<LoginState> emit) async {
    if(await validation(emit, email: event.email, password: event.password)) {
      emit(LoginLoadingState());
      try {
        var userCredential = await _authInstance.signInWithEmailAndPassword(email: event.email, password: event.password);
        var user = userCredential.user;
        if (user != null) {
          firebaseDocumentReference = FirebaseFirestore.instance.collection('users').doc(user.uid);
          Preferences.setString(key: AppStrings.prefUserId, value: user.uid);
          Preferences.setString(key: AppStrings.prefEmail, value: event.email);
          Preferences.setBool(key: AppStrings.prefRememberMe,value: event.isRememberMe);
          if(event.isRememberMe) {
            Preferences.setString(key: AppStrings.prefPassword, value: event.password);
          }
          await firebaseDocumentReference.get().then((data) {
            var mapData = data.data() as Map;
            if(mapData.isNotEmpty) {
              Preferences.setBool(key: AppStrings.prefEnableBiometric, value: mapData['enableBiometric'] ?? false);
              Preferences.setBool(key: AppStrings.prefShowTransactionDetails, value: mapData['showTransactionDetails'] ?? false);
              Preferences.setBool(key: AppStrings.prefShowTransactionDescription, value: mapData['transaction_description'] ?? false);
              Preferences.setString(key: AppStrings.prefDashboardAmountMode, value: mapData['dashboard_amount_mode'] ?? DashboardAmountMode.latestTransaction.value);
              Preferences.setString(
                key: AppStrings.prefProfileImg, 
                value: (mapData['profile_img'] ?? '').toString().isBlank
                ? AppStrings.sampleImg
                : mapData['profile_img']
              );
            }
          });
          ///capture log event
          await AnalyticsService.instance.setUserId(user.uid);
          await AnalyticsService.instance.logEvent(
            name: AnalyticsEvents.login,
            parameters: {'method': 'email'},
          );
          emit(LoginSuccessState(title: AppStrings.success, message: AppStrings.loginSuccessMsg));
        } else {
          emit(LoginFailedState(title: AppStrings.error, message: AppStrings.somethingWentWrong));
        }
      } on FirebaseAuthException catch (e) {
        emit(LoginFailedState(title: AppStrings.failed, message: e.message!));
      }
    }
  }

  void _onRememberMe(LoginRememberMeEvent event, Emitter emit) => emit(LoginRememberMeState(event.value));

  void _onEmailChange(LoginEmailChangeEvent event, Emitter emit) {
    if(event.email.isBlank) {
      emit(LoginEmailFieldState(message: AppStrings.emptyEmail));
    } else  if(!event.email.toString().isValidEmail) {
      emit(LoginEmailFieldState(message: AppStrings.invalidEmail));
    } else {
      emit(LoginEmailFieldState(message: AppStrings.emptyString));
    }
  }

  void _onPasswordChange(LoginPasswordChangeEvent event, Emitter emit) {
    if(event.password.toString().isBlank) {
      emit(LoginPasswordFieldState(message: AppStrings.emptyPassword));
    } else {
      emit(LoginPasswordFieldState(message: AppStrings.emptyString));
    }
  }

  //method used to show and hide password
  void _onShowHidePassword(LoginShowPasswordEvent event, Emitter emit){
    emit(LoginPasswordVisibilityState(!event.isVisible));
  }

  ///this method is used to validate the email and password field
  Future<bool> validation(Emitter<LoginState> emit, {required String email, required String password}) async {
    if(email.isBlank) {
      emit(LoginEmailFieldState(message: AppStrings.emptyEmail));
      return false;
    } else if(!email.isValidEmail) {
      emit(LoginEmailFieldState(message: AppStrings.invalidEmail));
      return false;
    } else if(password.isBlank) {
      emit(LoginPasswordFieldState(message: AppStrings.emptyPassword));
      return false;
    } else if(!await checkConnectivity.hasConnection) {
      emit(LoginFailedState(
        title: AppStrings.noInternetConnection, 
        message: AppStrings.noInternetConnectionMessage
      ));
      return false;
    } else {
      return true;
    }
  }

}