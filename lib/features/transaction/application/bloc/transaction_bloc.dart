import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/transaction/domain/transaction_model.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/check_connectivity.dart';
import '../../../../utils/preferences.dart';
import '../../../dashboard/domain/user_model.dart';
part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {

  // late DateFormat dateFormat;
  late CheckConnectivity checkConnectivity;
  late DocumentReference firebaseStoreInstance;
  late StreamSubscription<QuerySnapshot> streamDocumentSnapshot;
  var listTransactionResult = <TransactionModel>[];
  final String userName;
  final String friendId;
  bool amountAscending = true;
  bool typeAscending = true;
  bool dateAscending = false;
  String userId = '';

  TransactionBloc({required this.userName, required this.friendId}) : super(TransactionInitialState()){
    userId = Preferences.getString(key: AppStrings.prefUserId);
    firebaseStoreInstance = FirebaseFirestore.instance.collection('users').doc(userId).collection('friends').doc(friendId);
    checkConnectivity = CheckConnectivity();
    on<TransactionAddEvent>(_addTransaction);
    on<TransactionDateChangeEvent>(_changeDateStatus);
    on<TransactionTypeChangeEvent>(_changeTransactionType);
    on<TransactionAmountChangeEvent>(_onAmountChange);
    on<AllTransactionEvent>(_allTransactionData);
    on<TransactionDateSortEvent>(_onTransactionDateSort);
    on<TransactionAmountSortEvent>(_onTransactionAmountSort);
    on<TransactionTypeSortEvent>(_onTransactionTypeSort);
    on<TransactionScrollEvent>(_onScrollingList);

    streamDocumentSnapshot = firebaseStoreInstance.collection('transactions').snapshots().listen((event) {
      listTransactionResult.clear();
      for(var item in event.docs) {
        var mapData = item.data();
        if(mapData.isNotEmpty){
          listTransactionResult.add(TransactionModel(date: DateTime.fromMillisecondsSinceEpoch(mapData['date'].millisecondsSinceEpoch), type: mapData['type'], amount: double.parse(mapData['amount'])));
        }
      }
      add(AllTransactionEvent());
    });
  }

  void _onScrollingList(TransactionScrollEvent event, Emitter emit) {
    emit(TransactionScrollState(appbarSize: event.appbarSize));
  }

  @override
  Future<void> close() {
    streamDocumentSnapshot.cancel();
    return super.close();
  }

  void _allTransactionData(event, emit){
    if(listTransactionResult.isNotEmpty){
      listTransactionResult.sort((a,b) => a.date.compareTo(b.date));
    }
    emit(AllTransactionState(listTransaction: listTransactionResult));
  }

  void _changeDateStatus(event, emit){
    emit(TransactionDateChangeState(false));
  }

  void _changeTransactionType(TransactionTypeChangeEvent event, Emitter emit){
    emit(TransactionTypeChangeState(event.type));
  }

  void _onAmountChange(TransactionAmountChangeEvent event, Emitter emit){
    if(event.amount.isEmpty){
      emit(TransactionAmountFieldState(isAmountEmpty: true));
    }else{
      emit(TransactionAmountFieldState(isAmountEmpty: false));
    }
  }

  void _onTransactionDateSort(TransactionDateSortEvent event, Emitter emit){
    if(listTransactionResult.isNotEmpty){
      if(dateAscending){
        dateAscending = !dateAscending;
        listTransactionResult.sort((a,b) => a.date.compareTo(b.date));
      } else {
        dateAscending = !dateAscending;
        listTransactionResult.sort((a,b) => b.date.compareTo(a.date));
      }
      emit(AllTransactionState(listTransaction: listTransactionResult));
    }
  }

  void _onTransactionAmountSort(TransactionAmountSortEvent event, Emitter emit){
    if(listTransactionResult.isNotEmpty){
      if(amountAscending){
        amountAscending = !amountAscending;
        listTransactionResult.sort((a,b) => a.amount.compareTo(b.amount));
      } else {
        amountAscending = !amountAscending;
        listTransactionResult.sort((a,b) => b.amount.compareTo(a.amount));
      }
      emit(AllTransactionState(listTransaction: listTransactionResult));
    }
  }

  void _onTransactionTypeSort(TransactionTypeSortEvent event, Emitter emit){
    if(listTransactionResult.isNotEmpty){
      if(typeAscending){
        typeAscending = !typeAscending;
        listTransactionResult.sort((a,b) => a.type.compareTo(b.type));
      } else {
        typeAscending = !typeAscending;
        listTransactionResult.sort((a,b) => b.type.compareTo(a.type));
      }
      emit(AllTransactionState(listTransaction: listTransactionResult));
    }
  }

  Future<void> _addTransaction(TransactionAddEvent event, Emitter<TransactionState> emit) async {
    if(await validation(emit, userName: event.userName, date: event.date, amount: event.amount)){
      firebaseStoreInstance.collection('transactions').add({
        'date': event.date,
        'amount': event.amount,
        'type': event.type
      });
    }
  }

  Future<bool> validation(Emitter emit, {required String userName, DateTime? date, required String amount}) async {
    if(amount.isBlank) {
      emit(TransactionAmountFieldState(isAmountEmpty: true));
      return false;
    } else if (date == null) {
      emit(TransactionDateChangeState(true));
      return false;
    } else if (userName.isBlank) {
      emit(TransactionUserNameFieldState(userNameMessage: AppStrings.emptyName));
      return false;
    } else if (!await checkConnectivity.hasConnection) {
      emit(TransactionFailedState(title: AppStrings.noInternetConnection, message: AppStrings.noInternetConnectionMessage));
      return false;
    }
    return true;
  }

}