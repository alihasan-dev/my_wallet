import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/features/transaction/domain/transaction_import_model.dart';
import 'package:my_wallet/utils/preferences.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/mobile_download.dart'
  if(dart.library.html) '../../../../utils/web_download.dart';
part 'transaction_import_event.dart';
part 'transaction_import_state.dart';


class TransactionImportBloc extends Bloc<TransactionImportEvent, TransactionImportState> {
  
  late String userId;
  late DocumentReference firebaseStoreInstance;

  TransactionImportBloc({required String friendId}) : super(TransactionImportInitialState()) {
    userId = Preferences.getString(key: AppStrings.prefUserId);
    firebaseStoreInstance = FirebaseFirestore.instance.collection('users').doc(userId).collection('friends').doc(friendId);
    on<TransactionImportStateUpdateEvent>(_onUpdateImportStatus);
    on<TransactionImportInitiateEvent>(_onInitiateTransactionImport);
    on<TransactionImportDownloadTemplateEvent>(_onDownloadTemplateFile);
  }

  void _onUpdateImportStatus(TransactionImportStateUpdateEvent event, Emitter emit) {
    emit(TransactionImportStatusUpdateState(currentImportIndex: event.currentImportIndex));
  }

  Future<void> _onInitiateTransactionImport(TransactionImportInitiateEvent event, Emitter emit) async {
    try {
      if (event.transactionImportList.isEmpty) return;
      final transactionList = event.transactionImportList;
      const chunkSize = 400;
      for (var i = 0; i < transactionList.length; i += chunkSize) {
        final chunk = transactionList.skip(i).take(chunkSize);
        final batch = FirebaseFirestore.instance.batch();
        for (final row in chunk) {
          final ref = firebaseStoreInstance.collection('transactions').doc();
          batch.set(ref, {
            'date': row.date,
            'amount': row.amount,
            'type': row.type,
            'isActive': row.isActive,
            'description': row.description,
          });
        }
        await batch.commit();
      }
    } catch (e) {
      developer.log("Failed");
    }
  }

  Future<void> _onDownloadTemplateFile(TransactionImportDownloadTemplateEvent event, Emitter emit) async {
    try {
      final dio = Dio();
      final response = await dio.get<List<int>>(
        'https://mopbzkfxhlhtebpcgdvw.supabase.co/storage/v1/object/public/my_wallet_storage/cms/MyWallet_Transaction_Import_Sample.csv',
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      await downloadFile(bytes: bytes!, downloadName: 'MyWallet_Transaction_Import_Sample.csv').then((_) async {
        emit(TransactionImportDownloadTemplateState(
          message: 'File downloaded successfully', 
          status: true
        ));
      });
    } catch (e) {
      emit(TransactionImportDownloadTemplateState(
        message: 'Download failed : $e',
      ));
    }
  }

}