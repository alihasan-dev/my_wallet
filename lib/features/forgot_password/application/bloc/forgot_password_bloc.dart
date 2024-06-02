import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/check_connectivity.dart';
part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState>{

  late CheckConnectivity checkConnectivity;
  
  ForgotPasswordBloc() : super(ForgotPasswordInitialState()){
    checkConnectivity = CheckConnectivity();
    on<ForgotPasswordEmailChangeEvent>(_onEmailChange);
    on<ForgotPasswordSubmitEvent>(_onForgotPassword);
  }

  Future<void> _onForgotPassword(ForgotPasswordSubmitEvent event, Emitter emit) async {
    if(await validation(event.email, emit)){}
  }

  Future<bool> validation(String email, Emitter emit) async {
    if(email.isEmpty){
      emit(ForgotPasswordEmailFieldState(message: AppStrings.emptyEmail));
      return false;
    } else  if(!email.isValidEmail){
      emit(ForgotPasswordEmailFieldState(message: AppStrings.invalidEmail));
      return false;
    } else if(!await checkConnectivity.hasConnection){
      emit(ForgotPasswordFailedState(title: AppStrings.noInternetConnection, message: AppStrings.noInternetConnectionMessage));
      return false;
    } else {
      emit(ForgotPasswordEmailFieldState(message: AppStrings.emptyString));
      return true;
    }
  }

  void _onEmailChange(ForgotPasswordEmailChangeEvent event, Emitter emit){
    if(event.value.isEmpty){
      emit(ForgotPasswordEmailFieldState(message: AppStrings.emptyEmail));
    } else  if(!event.value.toString().isValidEmail){
      emit(ForgotPasswordEmailFieldState(message: AppStrings.invalidEmail));
    } else {
      emit(ForgotPasswordEmailFieldState(message: AppStrings.emptyString));
    }
  }
}