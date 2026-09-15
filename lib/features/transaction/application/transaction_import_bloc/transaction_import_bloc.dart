import 'dart:convert';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:excel_plus/excel_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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
  int currentImportIndex = 0;
  var finalImportTransactionList = <TransactionImportModel>[];
  int validRow = 0;
  int invalidRow = 0;

  TransactionImportBloc({required String friendId}) : super(TransactionImportInitialState()) {
    userId = Preferences.getString(key: AppStrings.prefUserId);
    firebaseStoreInstance = FirebaseFirestore.instance.collection('users').doc(userId).collection('friends').doc(friendId);
    on<TransactionImportStateUpdateEvent>(_onUpdateImportStatus);
    on<TransactionImportUploadEvent>(_onUploadTransactionImport);
    on<TransactionImportDownloadTemplateEvent>(_onDownloadTemplateFile);
    on<TransactionImportInitiateEvent>(_onInitiateTransactionImport);
    on<TransactionImportCheckedEvent>(_onChangeCheckValue);
  }

  void _onUpdateImportStatus(TransactionImportStateUpdateEvent event, Emitter emit) {
    emit(TransactionImportStatusUpdateState(currentImportIndex: event.currentImportIndex));
  }

  void _onChangeCheckValue(TransactionImportCheckedEvent event, Emitter emit) {
    emit(TransactionImportCheckedState(value: event.value));
  }

  Future<void> _onUploadTransactionImport(TransactionImportUploadEvent event, Emitter emit) async {
    try {
      if (finalImportTransactionList.isEmpty) return;
      await Future.delayed(const Duration(milliseconds: 1800));
      const chunkSize = 400;
      for (var i = 0; i < finalImportTransactionList.length; i += chunkSize) {
        final chunk = finalImportTransactionList.skip(i).take(chunkSize);
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
      emit(TransactionImportStatusUpdateState(
        completeIndex: currentImportIndex,
        currentImportIndex: currentImportIndex,
        isCompleted: true,
        invalidCount: invalidRow,
        validCount: validRow
      ));
    } catch (e) {
      developer.log("Failed");
    }
  }

  Future<void> _onDownloadTemplateFile(TransactionImportDownloadTemplateEvent event, Emitter emit) async {
    try {
      await downloadFile(
        networkUrl: 'https://mopbzkfxhlhtebpcgdvw.supabase.co/storage/v1/object/public/my_wallet_storage/cms/MyWallet_Transaction_Import_Sample.csv', 
        downloadName: 'MyWallet_Transaction_Import_Sample.csv').then((_) async {
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

  Future<void> _onInitiateTransactionImport(TransactionImportInitiateEvent event, Emitter emit) async {
    try {
      PlatformFile? file = event.pickedFile;
      file ??= await _onPickedFile(emit);
      if (file == null) return;
      final fileExtension = file.extension;
      final fileBytes = await file.readAsBytes();
      var importTransactionList = <TransactionImportModel>[];
      if (fileExtension == 'csv') {
        final csvString = utf8.decode(fileBytes);
        final csvConverterRowList = csv.decode(csvString);
        var tableList = <List<String>>[];
        for (var row in csvConverterRowList) {
          final tempRow = row.map((item) =>item.toString()).toList();
          tableList.add(tempRow);
        }
        importTransactionList = await _parseFile(tableList, emit);
      }
      if (fileExtension == 'xlsx' || fileExtension == 'xls') {
        final excel = Excel.decodeBytes(fileBytes);
        final table = excel.tables[excel.tables.keys.first];
        if (table != null) {
          var tableList = <List<String>>[];
          for (var row in table.rows) {
            final tempRow = row.map((cell) => cell?.value.toString() ?? '').toList();
            tableList.add(tempRow);
          }
          importTransactionList = await _parseFile(tableList, emit);
        }
      }
      finalImportTransactionList.clear();
      finalImportTransactionList = importTransactionList;
    } catch (e) {
      emit(TransactionImportInitiateState(
        status: false,
        message: 'Failed to import the transaction $e'
      ));
    }
  }

  Future<PlatformFile?> _onPickedFile(Emitter emit) async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls']
      );
      if (file == null) {
        emit(TransactionImportPickFileState(
          status: false, 
          message: 'Unable to upload file'
        ));
        return null;
      }
      final fileLength = await file.length();
      if(fileLength > 2000000) {
        emit(TransactionImportPickFileState(
          status: false, 
          message: AppStrings.fileSizeMsg
        ));
        return null;
      }
      return file;
    } catch (e) {
      emit(TransactionImportPickFileState(
        status: false, 
        message: 'Unable failed : $e'
      ));
      return null;
    }
  }


  Future<List<TransactionImportModel>> _parseFile(List<List<String>> tableList, Emitter emit) async {
    try {
      emit(TransactionImportStatusUpdateState(
        completeIndex: currentImportIndex,
        currentImportIndex: ++currentImportIndex,
        isCompleted: true
      ));
      if (tableList.isEmpty) return [];
      final header = tableList.first.map((item) => item.toString().toLowerCase()).toSet();
      if (tableList.length < 6) {
        debugPrint("Imported file should be min of 5 data points");
        return [];
      }
      if (header.length < 3) {
        debugPrint("Imported file is not proper");
        return [];
      }
      if (!header.contains('date') || !header.contains('type') || !header.contains('amount')) {
        debugPrint('File header is not proper');
        return [];
      }
      await Future.delayed(const Duration(milliseconds: 1500));
      emit(TransactionImportStatusUpdateState(
        completeIndex: currentImportIndex,
        currentImportIndex: ++currentImportIndex,
        isCompleted: true
      ));
      int dateCellIndex = 0;
      int descriptionCellIndex = 0;
      int typeCellIndex = 0;
      int statusCellIndex = 0;
      int amountCellIndex = 0;
      var importTransactionList = <TransactionImportModel>[];
      int invalidRowCount = 0;
      for (var i = 0; i < tableList.length; i++) {
        final row = tableList[i];
        DateTime? date;
        String? type;
        String? amount;
        String? description;
        bool? status;
        for (var j = 0; j < row.length; j++) {
          String columnItem = row[j];
          if (i == 0) {
            columnItem = columnItem.toString().toLowerCase();
            switch (columnItem) {
              case 'date':
                dateCellIndex = j;
                break;
              case 'type':
                typeCellIndex = j;
                break;
              case 'amount':
                amountCellIndex = j;
                break;
              case 'description':
                descriptionCellIndex = j;
                break;
              case 'status':
                statusCellIndex = j;
                break;
            }
          } else {
            if (j == dateCellIndex) {
              date = parseFlexibleDate(columnItem);
            }
            if (j == descriptionCellIndex) {
              description = parseFlexibleDescription(columnItem);
            }
            if (j == typeCellIndex) {
              type = parseFlexibleType(columnItem);
            }
            if (j == statusCellIndex) {
              status = parseFlexibleStatus(columnItem);
            }
            if (j == amountCellIndex) {
              amount = _parseFlexibleAmount(columnItem);
            }
          }
        }
        if (amount == null || type == null || date == null) {
          if (i != 0) invalidRowCount+=1;
          continue;
        }
        final transactionImportModel = TransactionImportModel(
          amount: amount,
          date: date,
          type: type,
          description: description ?? '',
          isActive: status ?? true
        );
        importTransactionList.add(transactionImportModel);
      }
      if (importTransactionList.isNotEmpty) {
        validRow =  (tableList.length - 1)  - invalidRowCount;
        invalidRow = invalidRowCount;
        await Future.delayed(const Duration(milliseconds: 1500));
        emit(TransactionImportStatusUpdateState(
          completeIndex: currentImportIndex,
          currentImportIndex: ++currentImportIndex,
          isCompleted: true,
          invalidCount: invalidRow,
          validCount: validRow
        ));
      }
      return importTransactionList;
    } catch (e) {
      return [];
    }
  }

  String parseFlexibleDescription(String? input) {
    final description = (input ?? '').trim();
    if (description.isEmpty) return '-';
    if (description.length > 100) {
      return description.substring(0, 100);
    }
    return description;
  }

  bool parseFlexibleStatus(String? input) {
    final status = (input ?? '').toLowerCase();
    if ({'active', 'true','false','inactive'}.contains(status)) {
      return status == 'active' || status == 'true'
      ? true
      : false;
    }
    return true;
  }

  String? _parseFlexibleAmount(String? input) {
    if (input == null || input.trim().isEmpty) return null;
    final value = double.tryParse(input.trim());
    if (value == null) return null;
    return value.ceil().toString();
  }

  String? parseFlexibleType(String? input) {
    final type = (input ?? '').toLowerCase();
    if (type == AppStrings.transfer.toLowerCase() || type == AppStrings.receive.toLowerCase()) {
      return type == AppStrings.transfer.toLowerCase() ? AppStrings.transfer : AppStrings.receive;
    }
    return null;
  }

  DateTime? parseFlexibleDate(String? input) {
    if (input == null || input.trim().isEmpty) return null;
    final value = input.trim();
    // Try YYYY-MM-DD first (unambiguous, ISO format)
    final isoMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(value);
    if (isoMatch != null) {
      final year = int.parse(isoMatch.group(1)!);
      final month = int.parse(isoMatch.group(2)!);
      final day = int.parse(isoMatch.group(3)!);
      return _tryBuildDate(year, month, day);
    }
    // Try DD-MM-YYYY
    final dmyMatch = RegExp(r'^(\d{1,2})-(\d{1,2})-(\d{4})$').firstMatch(value);
    if (dmyMatch != null) {
      final day = int.parse(dmyMatch.group(1)!);
      final month = int.parse(dmyMatch.group(2)!);
      final year = int.parse(dmyMatch.group(3)!);
      return _tryBuildDate(year, month, day);
    }
    // Try DD/MM/YYYY (slash variant, mentioned in your earlier spec)
    final dmySlashMatch = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(value);
    if (dmySlashMatch != null) {
      final day = int.parse(dmySlashMatch.group(1)!);
      final month = int.parse(dmySlashMatch.group(2)!);
      final year = int.parse(dmySlashMatch.group(3)!);
      return _tryBuildDate(year, month, day);
    }
    return null; // unrecognized format
  }

  /// Validates the components before constructing DateTime,
  /// since DateTime(2026, 13, 45) would otherwise silently roll over
  /// into an unexpected date instead of failing.
  DateTime? _tryBuildDate(int year, int month, int day) {
    if (month < 1 || month > 12) return null;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    if (day < 1 || day > daysInMonth) return null;
    return DateTime(year, month, day);
  }

}