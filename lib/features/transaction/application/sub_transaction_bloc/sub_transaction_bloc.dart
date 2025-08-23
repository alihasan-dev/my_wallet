import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/utils/check_connectivity.dart';

import '../../../../constants/app_strings.dart';
import '../../../../utils/preferences.dart';
import '../../domain/transaction_details_model.dart';
part 'sub_transaction_event.dart';
part 'sub_transaction_state.dart';

class SubTransactionBloc extends Bloc<SubTransactionEvent, SubTransactionState>{

  StreamSubscription<QuerySnapshot>? streamSubscriptionTransactionDetails;
  late CheckConnectivity checkConnectivity;
  late DocumentReference firebaseStoreInstance;
  String userId = '';
  final String friendId;
  final String transactionId;
  List<TransactionDetailsModel> transactionDetailsList = [];
  
  SubTransactionBloc({required this.friendId, required this.transactionId}) : super(SubTransactionInitialState()) {
    userId = Preferences.getString(key: AppStrings.prefUserId);
    checkConnectivity = CheckConnectivity();
    firebaseStoreInstance = FirebaseFirestore.instance.collection('users').doc(userId).collection('friends').doc(friendId).collection('transactions').doc(transactionId);

    on<SubTransactionSubDetailsEvent>(_onFetchTransactionSubDetailsEvent);
    on<SubTransactionAddEvent>(_onAddTransactionDetails);
    on<SubTransactionDeleteEvent>(_onDeleteSubTransactionDetails);
    on<SubTransactionSelectDetailsEvent>(_onSelectTransactionDetails);


    streamSubscriptionTransactionDetails =  firebaseStoreInstance.collection('details').snapshots().listen((event) {
      transactionDetailsList.clear();
      for (var item in event.docs) {
        var mapData = item.data();
        if (mapData.isNotEmpty) {
          transactionDetailsList.add(TransactionDetailsModel(
            id: item.id,
            description: mapData['description'],
            quantity: mapData['quantity'],
            rate: mapData['rate'].toDouble(),
            total: mapData['total'].toDouble()
          ));
        }
      }
      add(SubTransactionSubDetailsEvent());
    });
  }

  void _onFetchTransactionSubDetailsEvent(SubTransactionSubDetailsEvent event, Emitter emit) {
    emit(SubTransactionFetchDetailsState(transactionDetailsList: transactionDetailsList));
  }


  Future<void> _onAddTransactionDetails(SubTransactionAddEvent event, Emitter emit) async {
    await firebaseStoreInstance.collection('details').add({
      'description': event.description,
      'quantity': event.quantity,
      'rate': event.rate,
      'total': event.total
    });
  }

  Future<void> _onDeleteSubTransactionDetails(SubTransactionDeleteEvent event, Emitter emit) async {
    if(transactionDetailsList.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();
      for(final transaction in transactionDetailsList) {
        if(transaction.isSelected) {
          final docRef = firebaseStoreInstance.collection('details').doc(transaction.id);
          batch.delete(docRef);
        }
      }
      try {
        await batch.commit();
        log("Documents deleted successfully");
      } catch (e) {
        log("Error deleting documents: $e");
      }
    }
  }

  void _onSelectTransactionDetails(SubTransactionSelectDetailsEvent event, Emitter emit) {
    if (transactionDetailsList.isNotEmpty) {
      transactionDetailsList[event.selectedIndex].isSelected = !transactionDetailsList[event.selectedIndex].isSelected;
      // emit(TransactionFetchDetailsState(transactionDetailsList: transactionDetailsList));
      emit(SubTransactionFetchDetailsState(transactionDetailsList: transactionDetailsList));
    }
  }

  @override
  Future<void> close() {
    streamSubscriptionTransactionDetails?.cancel();
    return super.close();
  }
}