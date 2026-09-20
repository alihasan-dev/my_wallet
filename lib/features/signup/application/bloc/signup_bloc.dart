import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/analytics/analytics_events.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/check_connectivity.dart';
import '../../../../utils/preferences.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState>{
  
  late CheckConnectivity _checkConnectivity;
  late FirebaseAuth _authInstance;
  late CollectionReference _collectionReference;
  late GoogleSignIn _googleSignIn;
  // bool _isGoogleSignedOut = false;
  // StreamSubscription? _googleSignInSubscription;

  SignupBloc() : super(SignupInitialState()) {
    _googleSignIn = GoogleSignIn(
      clientId: AppStrings.googleSignInClientId,
      scopes: ["email"],
    );
    _authInstance = FirebaseAuth.instance;
    _collectionReference = FirebaseFirestore.instance.collection('users');
    _checkConnectivity = CheckConnectivity();
    on<SignupSubmitEvent>(onSignupSubmit);
    on<SignupEmailChangeEvent>(_onEmailChange);
    on<SignupNameChangeEvent>(_onNameChange);
    on<SignupPasswordChangeEvent>(_onPasswordChange);
    on<SignupShowPasswordEvent>(_onShowHidePassword);
    on<SignupWithGoogleEvent>(_onSignupWithGoogle);
    on<SignupWithGoogleStatusEvent>(_onSignupWithGoogleStatus);

    ///register listener for google signin authentication change
    // _googleSignInSubscription = _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
    //   if(Preferences.getBool(key: AppStrings.prefGoogleSignInFromSignup)) {
    //     add(SignupWithGoogleStatusEvent(account));
    //   }
    // });
  }

  // @override
  // Future<void> close() {
  //   _googleSignInSubscription?.cancel();
  //   return super.close();
  // }

  Future<void> _onSignupWithGoogleStatus(SignupWithGoogleStatusEvent event, Emitter<SignupState> emit) async {
    // if(event.googleSignInAccount != null) {
    //   emit(SignupLoadingState());
    //   final displayName = event.googleSignInAccount!.displayName ?? '';
    //   final photoUrl = event.googleSignInAccount!.photoUrl;
    //   final email = event.googleSignInAccount!.email;
    //   final authentication = await event.googleSignInAccount!.authentication;
    //   final authCredential = GoogleAuthProvider.credential(
    //     idToken: authentication.idToken,
    //     accessToken: authentication.accessToken
    //   );
    //   final firebaseUserCredential = await _authInstance.signInWithCredential(authCredential);
    //   final user = firebaseUserCredential.user;
    //   if(firebaseUserCredential.additionalUserInfo!.isNewUser) {
    //     if (user != null) {
    //       Preferences.setString(key: AppStrings.prefUserId, value: user.uid);
    //       Preferences.setString(key: AppStrings.prefEmail, value: email);
    //       Preferences.setBool(key: AppStrings.prefRememberMe,value: false);
    //       Preferences.setString(key: AppStrings.prefFullName, value: displayName);
    //       ///store user in firebase firestore
    //       await _collectionReference.doc(user.uid).set({
    //         'name': displayName,
    //         'email': email,
    //         'user_id': user.uid,
    //         'profile_img': photoUrl ?? AppStrings.sampleImg,
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
    //       Preferences.setBool(key: AppStrings.prefShowTransactionDetails, value: false);
    //       Preferences.setBool(key: AppStrings.prefShowTransactionDescription, value: false);
    //       ///capture signup event
    //       await AnalyticsService.instance.setUserId(user.uid);
    //       await AnalyticsService.instance.logEvent(
    //         name: AnalyticsEvents.signUp,
    //         parameters: {'method': 'google'},
    //       );
    //       emit(SignupSuccessState(title: AppStrings.success, message: AppStrings.registerMsg));
    //     } else {
    //       emit(SignupFailedState(title: AppStrings.error, message: AppStrings.somethingWentWrong));
    //     }
    //   } else {
    //     _isGoogleSignedOut = true;
    //     emit(SignupFailedState(title: AppStrings.error, message: AppStrings.alreadyHaveAccountMsg));
    //     await _googleSignIn.signOut();
    //   }
    // } else {
    //   emit(SignupFailedState(
    //     title: AppStrings.failed, 
    //     message: AppStrings.googleSigninFailedMsg, 
    //     canShowSnackBar: !_isGoogleSignedOut
    //   ));
    //   _isGoogleSignedOut = false;
    // }
  }

  Future<void> _onSignupWithGoogle(SignupWithGoogleEvent event, Emitter<SignupState> emit) async {
    emit(SignupLoadingState());
    try {
      // final googleProvider = GoogleAuthProvider();
      // final firebaseUserCredential = await _authInstance.signInWithPopup(googleProvider);
      final firebaseUserCredential = await signInWithGoogle();
      if (firebaseUserCredential == null) {
        throw FirebaseAuthException(
          code: 'faiLed',
          message: 'user cancelled the sign-in flow'
        );
      }
      final user = firebaseUserCredential.user;
      if (user == null) {
        emit(
          SignupFailedState(
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
      if (isNewUser) {
        Preferences.setString(key: AppStrings.prefUserId, value: userId);
        Preferences.setString(key: AppStrings.prefEmail, value: email);
        Preferences.setBool(key: AppStrings.prefRememberMe,value: false);
        Preferences.setString(key: AppStrings.prefFullName, value: displayName);
        ///store user in firebase firestore
        await _collectionReference.doc(user.uid).set({
          'name': displayName,
          'email': email,
          'user_id': userId,
          'profile_img': photoUrl.isBlank
          ? AppStrings.sampleImg
          : photoUrl,
          'showUnverified': true,
          'enableBiometric': false
        });
        Preferences.setString(
          key: AppStrings.prefProfileImg, 
          value: photoUrl.isBlank
          ? AppStrings.sampleImg
          : photoUrl,
        );
        Preferences.setBool(key: AppStrings.prefEnableBiometric, value: false);
        Preferences.setBool(key: AppStrings.prefShowTransactionDetails, value: false);
        Preferences.setBool(key: AppStrings.prefShowTransactionDescription, value: false);
        ///capture signup event
        await AnalyticsService.instance.setUserId(userId);
        await AnalyticsService.instance.logEvent(
          name: AnalyticsEvents.signUp,
          parameters: {'method': 'google'},
        );
        emit(SignupSuccessState(title: AppStrings.success, message: AppStrings.registerMsg));
      } else {
        emit(SignupFailedState(title: AppStrings.error, message: AppStrings.alreadyHaveAccountMsg));
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Google Firebase Auth Error: ${e.code} - ${e.message}');
      emit(
        SignupFailedState(
          title: AppStrings.failed,
          message: e.message ?? AppStrings.googleSigninFailedMsg,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Google Login Error: $e');
      debugPrintStack(stackTrace: stackTrace);
      emit(
        SignupFailedState(
          title: AppStrings.error,
          message: AppStrings.googleSigninFailedMsg,
        ),
      );
    }
    // if(event.googleSignInAccount != null) {
    //   emit(SignupLoadingState());
    //   final displayName = event.googleSignInAccount!.displayName ?? '';
    //   final photoUrl = event.googleSignInAccount!.photoUrl;
    //   final email = event.googleSignInAccount!.email;
    //   final authentication = await event.googleSignInAccount!.authentication;
    //   final authCredential = GoogleAuthProvider.credential(
    //     idToken: authentication.idToken,
    //     accessToken: authentication.accessToken
    //   );
    //   final firebaseUserCredential = await _authInstance.signInWithCredential(authCredential);
    //   final user = firebaseUserCredential.user;
    //   if(firebaseUserCredential.additionalUserInfo!.isNewUser) {
    //     if (user != null) {
    //       Preferences.setString(key: AppStrings.prefUserId, value: user.uid);
    //       Preferences.setString(key: AppStrings.prefEmail, value: email);
    //       Preferences.setBool(key: AppStrings.prefRememberMe,value: false);
    //       Preferences.setString(key: AppStrings.prefFullName, value: displayName);
    //       ///store user in firebase firestore
    //       await _collectionReference.doc(user.uid).set({
    //         'name': displayName,
    //         'email': email,
    //         'user_id': user.uid,
    //         'profile_img': photoUrl ?? AppStrings.sampleImg,
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
    //       Preferences.setBool(key: AppStrings.prefShowTransactionDetails, value: false);
    //       Preferences.setBool(key: AppStrings.prefShowTransactionDescription, value: false);
    //       ///capture signup event
    //       await AnalyticsService.instance.setUserId(user.uid);
    //       await AnalyticsService.instance.logEvent(
    //         name: AnalyticsEvents.signUp,
    //         parameters: {'method': 'google'},
    //       );
    //       emit(SignupSuccessState(title: AppStrings.success, message: AppStrings.registerMsg));
    //     } else {
    //       emit(SignupFailedState(title: AppStrings.error, message: AppStrings.somethingWentWrong));
    //     }
    //   } else {
    //     _isGoogleSignedOut = true;
    //     emit(SignupFailedState(title: AppStrings.error, message: AppStrings.alreadyHaveAccountMsg));
    //     await _googleSignIn.signOut();
    //   }
    // } else {
    //   emit(SignupFailedState(
    //     title: AppStrings.failed, 
    //     message: AppStrings.googleSigninFailedMsg, 
    //     canShowSnackBar: !_isGoogleSignedOut
    //   ));
    //   _isGoogleSignedOut = false;
    // }


    // emit(SignupLoadingState());
    // try {
    //   final data = await _googleSignIn.signIn(); 
    //   if (data == null) throw CustomException();
    // } on CustomException catch (_) {
    //   emit(SignupFailedState(
    //     title: AppStrings.failed, 
    //     message: AppStrings.googleSigninFailedMsg,
    //   ));
    // }
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

  Future<void> onSignupSubmit(SignupSubmitEvent event, Emitter emit) async {
    if(await validation(emit, name: event.name, email: event.email, password: event.password)) {
      emit(SignupLoadingState());
      try {
        var userCredential = await _authInstance.createUserWithEmailAndPassword(email: event.email, password: event.password);
        var user = userCredential.user;
        if (user != null) {
          Preferences.setString(key: AppStrings.prefUserId, value: user.uid);
          Preferences.setString(key: AppStrings.prefPassword, value: event.password);
          Preferences.setString(key: AppStrings.prefEmail, value: event.email);
          Preferences.setBool(key: AppStrings.prefRememberMe,value: false);
          Preferences.setString(key: AppStrings.prefFullName, value: event.name);
          ///store user in firebase firestore
          await _collectionReference.doc(user.uid).set({
            'name': event.name,
            'email': event.email,
            'user_id': user.uid,
            'profile_img': AppStrings.sampleImg,
            'showUnverified': true,
            'enableBiometric': false
          });
          Preferences.setString(key: AppStrings.prefProfileImg, value: AppStrings.sampleImg);
          Preferences.setBool(key: AppStrings.prefEnableBiometric, value: false);
          Preferences.setBool(key: AppStrings.prefShowTransactionDetails, value: false);
          Preferences.setBool(key: AppStrings.prefShowTransactionDescription, value: false);
          ///capture signup event
          await AnalyticsService.instance.setUserId(user.uid);
          await AnalyticsService.instance.logEvent(
            name: AnalyticsEvents.signUp,
            parameters: {'method': 'email'},
          );
          emit(SignupSuccessState(title: AppStrings.success, message: AppStrings.registerMsg));
        } else {
          emit(SignupFailedState(title: AppStrings.error, message: AppStrings.somethingWentWrong));
        }
      } on FirebaseAuthException catch (e) {
        emit(SignupFailedState(title: AppStrings.failed, message: e.message!));
      }
    }
  }

  void _onEmailChange(SignupEmailChangeEvent event, Emitter emit) {
    if(event.email.isBlank) {
      emit(SignupEmailFieldState(message: AppStrings.emptyEmail));
    } else  if(!event.email.toString().isValidEmail) {
      emit(SignupEmailFieldState(message: AppStrings.invalidEmail));
    } else {
      emit(SignupEmailFieldState(message: AppStrings.emptyString));
    }
  }

  void _onNameChange(SignupNameChangeEvent event, Emitter emit) {
    if(event.name.isBlank) {
      emit(SignupNameFieldState(message: AppStrings.emptyName));
    } else {
      emit(SignupNameFieldState(message: AppStrings.emptyString));
    }
  }

  void _onPasswordChange(SignupPasswordChangeEvent event, Emitter emit) {
    if(event.password.toString().isBlank) {
      emit(SignupPasswordFieldState(message: AppStrings.emptyPassword));
    } else  if(event.password.toString().length < 8) {
      emit(SignupPasswordFieldState(message: AppStrings.invalidPassword));
    } else {
      emit(SignupPasswordFieldState(message: AppStrings.emptyString));
    }
  }

  void _onShowHidePassword(SignupShowPasswordEvent event, Emitter emit) {
    emit(SignupPasswordVisibilityState(!event.isVisible));
  }

  Future<bool> validation(Emitter emit, {required String name, required String email, required String password}) async {
    if(name.isBlank) {
      emit(SignupNameFieldState(message: AppStrings.emptyName));
      return false;
    } else if(email.isBlank) {
      emit(SignupEmailFieldState(message: AppStrings.emptyEmail));
      return false;
    } else if(!email.isValidEmail) {
      emit(SignupEmailFieldState(message: AppStrings.invalidEmail));
      return false;
    } else if(password.isBlank) {
      emit(SignupPasswordFieldState(message: AppStrings.emptyPassword));
      return false;
    } else if(password.length < 8) {
      emit(SignupPasswordFieldState(message: AppStrings.invalidPassword));
      return false;
    } else if(!await _checkConnectivity.hasConnection) {
      emit(SignupFailedState(title: AppStrings.noInternetConnection, message: AppStrings.noInternetConnectionMessage));
      return false;
    } else {
      return true;
    }
  }
  
}