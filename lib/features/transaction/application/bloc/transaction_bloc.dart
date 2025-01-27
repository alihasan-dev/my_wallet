import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../features/transaction/domain/transaction_model.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/check_connectivity.dart';
import '../../../../utils/preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:my_wallet/utils/mobile_download.dart'
  if(dart.library.html) 'package:my_wallet/utils/web_download.dart';
import '../../../dashboard/application/bloc/dashboard_bloc.dart';
part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  // late DateFormat dateFormat;
  late CheckConnectivity checkConnectivity;
  late DocumentReference firebaseStoreInstance;
  late StreamSubscription<QuerySnapshot> streamDocumentSnapshot;
  var listTransactionResult = <TransactionModel>[];
  var originalTransactionResultList = <TransactionModel>[];
  final String userName;
  final DashboardBloc dashboardBloc;
  final String friendId;
  bool isFilterApplied = false;
  bool amountAscending = true;
  bool typeAscending = true;
  bool dateAscending = false;
  late DateFormat dateFormat;
  String userId = '';
  late AudioPlayer audioPlayer;

  TransactionBloc({required this.userName, required this.friendId, required this.dashboardBloc}) : super(TransactionInitialState()) {
    dateFormat = DateFormat.yMMMd();
    userId = Preferences.getString(key: AppStrings.prefUserId);
    firebaseStoreInstance = FirebaseFirestore.instance.collection('users').doc(userId).collection('friends').doc(friendId);
    checkConnectivity = CheckConnectivity();
    initializeAudioPlayer();
    on<TransactionAddEvent>(_addTransaction);
    on<TransactionDateChangeEvent>(_changeDateStatus);
    on<TransactionTypeChangeEvent>(_changeTransactionType);
    on<TransactionAmountChangeEvent>(_onAmountChange);
    on<AllTransactionEvent>(_allTransactionData);
    on<TransactionDateSortEvent>(_onTransactionDateSort);
    on<TransactionAmountSortEvent>(_onTransactionAmountSort);
    on<TransactionTypeSortEvent>(_onTransactionTypeSort);
    on<TransactionScrollEvent>(_onScrollingList);
    on<TransactionExportPDFEvent>(_onExportPDF);
    on<TransactionProfileUpdateEvent>(_onUpdateProfileEvent);
    on<TransactionFilterEvent>(_onEnableFilterEvent);
    on<TransactionChangeAmountRangeEvent>(_onChangeAmountRange);
    on<TransactionApplyFilterEvent>(_onApplyFilterEvent);
    on<TransactionClearFilterEvent>(_onClearFilterEvent);
    on<TransactionSelectListItemEvent>(_onSelectListItemEvent);
    on<TransactionDeleteEvent>(_onDeleteTransaction);

    dashboardBloc.stream.listen((event) {
      if(event is DashboardAllUserState) {
        final userState = event;
        var userEvent = userState.allUser.where((item) => item.userId == friendId).toList();
        if(userEvent.isNotEmpty) {
          add(TransactionProfileUpdateEvent(userName: userEvent.first.name, profileImage: userEvent.first.profileImg));
        }
      }
    });

    streamDocumentSnapshot = firebaseStoreInstance.collection('transactions').snapshots().listen((event) {
      originalTransactionResultList.clear();
      for (var item in event.docs) {
        var mapData = item.data();
        if (mapData.isNotEmpty) {
          originalTransactionResultList.add(TransactionModel(
            id: item.id,
            date: DateTime.fromMillisecondsSinceEpoch(mapData['date'].millisecondsSinceEpoch),
            type: mapData['type'],
            amount: double.parse(mapData['amount'])
          ));
        }
      }
      add(AllTransactionEvent());
    });
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    streamDocumentSnapshot.cancel();
    return super.close();
  }

  Future<void> initializeAudioPlayer() async {
    audioPlayer = AudioPlayer();
    await audioPlayer.setAsset('assets/audio/downloadSound.mp3');
  }

  Future<void> _onDeleteTransaction(TransactionDeleteEvent event, Emitter emit) async {
    if(listTransactionResult.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();
      for(final transaction in listTransactionResult) {
        if(transaction.selected) {
          final docRef = firebaseStoreInstance.collection('transactions').doc(transaction.id);
          batch.delete(docRef);
        }
      }
      try {
        await batch.commit();
        debugPrint("Documents deleted successfully");
      } catch (e) {
        debugPrint("Error deleting documents: $e");
      }
    }
  }

  void _onSelectListItemEvent(TransactionSelectListItemEvent event, Emitter emit) {
    if(listTransactionResult.isNotEmpty) {
      listTransactionResult[event.index].selected = !listTransactionResult[event.index].selected;
      double balance = totalBalance(transactionList: listTransactionResult);
      emit(AllTransactionState(listTransaction: listTransactionResult, totalBalance: balance));
    }
  }

  void _onClearFilterEvent(TransactionClearFilterEvent event, Emitter emit) {
    if(event.clearFilter) {
      isFilterApplied = false;
      listTransactionResult.clear();
      listTransactionResult.addAll(originalTransactionResultList);
      listTransactionResult.sort((a, b) => a.date.compareTo(b.date));
      double balance = totalBalance(transactionList: listTransactionResult);
      emit(AllTransactionState(listTransaction: listTransactionResult, totalBalance: balance));
    }
  }

  void _onChangeAmountRange(TransactionChangeAmountRangeEvent event, Emitter emit) {
    emit(TransactionChangeAmountRangeState(rangeAmount: event.rangeAmount));
  }

  void _onScrollingList(TransactionScrollEvent event, Emitter emit) {
    emit(TransactionScrollState(appbarSize: event.appbarSize));
  }

  void _onUpdateProfileEvent(TransactionProfileUpdateEvent event, Emitter emit) {
    emit(TransactionProfileUpdateState(userName: event.userName, profileImage: event.profileImage));
  }

  void _onEnableFilterEvent(TransactionFilterEvent event, Emitter emit) {
    emit(TransactionFilterState());
  }

  void _onApplyFilterEvent(TransactionApplyFilterEvent event, Emitter emit) {
    isFilterApplied = true;
    listTransactionResult.clear();
    final startDateTime = event.dateTimeRange?.start;
    final endDateTime = event.dateTimeRange?.end;
    for(var item in originalTransactionResultList) {
      if(event.dateTimeRange != null) {
        if(((item.date.isAfter(startDateTime!) || item.date.campareDateOnly(startDateTime)) && (item.date.isBefore(endDateTime!) || item.date.campareDateOnly(endDateTime))) && (item.amount >= event.amountRangeValues!.start  && item.amount <= event.amountRangeValues!.end) && (event.transactionType == AppStrings.all ? true : (item.type == event.transactionType))) {
          listTransactionResult.add(item);
        }
      } else {
        if((item.amount >= event.amountRangeValues!.start  && item.amount <= event.amountRangeValues!.end) && (event.transactionType == AppStrings.all ? true : (item.type == event.transactionType))) {
          listTransactionResult.add(item);
        }
      }
    }
    listTransactionResult.sort((a, b) => a.date.compareTo(b.date));
    double balance = totalBalance(transactionList: listTransactionResult);
    emit(AllTransactionState(listTransaction: listTransactionResult, totalBalance: balance, isFilterEnable: true));
  }

  void _allTransactionData(event, emit) {
    listTransactionResult.clear();
    listTransactionResult.addAll(originalTransactionResultList);
    listTransactionResult.sort((a, b) => a.date.compareTo(b.date));
    double balance = totalBalance(transactionList: listTransactionResult);
    emit(AllTransactionState(listTransaction: listTransactionResult, totalBalance: balance, isTransactionAgainstFilter: isFilterApplied));
  }

  void _changeDateStatus(event, emit) {
    emit(TransactionDateChangeState(false));
  }

  void _changeTransactionType(event, emit) {
    emit(TransactionTypeChangeState(event.type));
  }

  void _onAmountChange(event, emit) {
    if (event.amount.isEmpty) {
      emit(TransactionAmountFieldState(isAmountEmpty: true));
    } else {
      emit(TransactionAmountFieldState(isAmountEmpty: false));
    }
  }

  void _onTransactionDateSort(TransactionDateSortEvent event, Emitter emit) {
    if (listTransactionResult.isNotEmpty) {
      if (dateAscending) {
        dateAscending = !dateAscending;
        listTransactionResult.sort((a, b) => a.date.compareTo(b.date));
      } else {
        dateAscending = !dateAscending;
        listTransactionResult.sort((a, b) => b.date.compareTo(a.date));
      }
      double balance = totalBalance(transactionList: listTransactionResult);
      emit(AllTransactionState(listTransaction: listTransactionResult, totalBalance: balance, isFilterEnable: isFilterApplied));
    }
  }

  void _onTransactionAmountSort(TransactionAmountSortEvent event, Emitter emit) {
    if (listTransactionResult.isNotEmpty) {
      if (amountAscending) {
        amountAscending = !amountAscending;
        listTransactionResult.sort((a, b) => a.amount.compareTo(b.amount));
      } else {
        amountAscending = !amountAscending;
        listTransactionResult.sort((a, b) => b.amount.compareTo(a.amount));
      }
      double balance = totalBalance(transactionList: listTransactionResult);
      emit(AllTransactionState(listTransaction: listTransactionResult, totalBalance: balance, isFilterEnable: isFilterApplied));
    }
  }

  void _onTransactionTypeSort(TransactionTypeSortEvent event, Emitter emit) {
    if (listTransactionResult.isNotEmpty) {
      if (typeAscending) {
        typeAscending = !typeAscending;
        listTransactionResult.sort((a, b) => a.type.compareTo(b.type));
      } else {
        typeAscending = !typeAscending;
        listTransactionResult.sort((a, b) => b.type.compareTo(a.type));
      }
      double balance = totalBalance(transactionList: listTransactionResult);
      emit(AllTransactionState(listTransaction: listTransactionResult, totalBalance: balance, isFilterEnable: isFilterApplied));
    }
  }

  double totalBalance({required List<TransactionModel> transactionList}) {
    double totalBalance = listTransactionResult.fold(0.0, (temp, item) => item.type == AppStrings.transfer ? temp - item.amount : temp + item.amount);
    return totalBalance;
  }

  Future<void> _addTransaction(TransactionAddEvent event, Emitter<TransactionState> emit) async {
    if (await validation(emit, userName: event.userName, date: event.date, amount: event.amount)) {
      firebaseStoreInstance.collection('transactions').add({'date': event.date, 'amount': event.amount, 'type': event.type});
      firebaseStoreInstance.update({
        'lastTransactionTime': event.date,
        'amount': event.amount,
        'type': event.type
      });
    }
  }

  Future<bool> validation(Emitter<TransactionState> emit,{required String userName, DateTime? date, required String amount}) async {
    if (amount.isBlank) {
      emit(TransactionAmountFieldState(isAmountEmpty: true));
      return false;
    } else if (date == null) {
      emit(TransactionDateChangeState(true));
      return false;
    } else if (userName.isBlank) {
      emit(TransactionUserNameFieldState(userNameMessage: AppStrings.emptyName));
      return false;
    } else if (!await checkConnectivity.hasConnection) {
      emit(TransactionFailedState(title: AppStrings.noInternetConnection,message: AppStrings.noInternetConnectionMessage));
      return false;
    }
    return true;
  }

  Future<void> _onExportPDF(TransactionExportPDFEvent event, Emitter emit) async {
    if(listTransactionResult.isNotEmpty) {
      emit(TransactionLoadingState());
      try {
        var labelList = <String>['Date', 'Type', 'Amount'];
        final pdf = pw.Document();
        int pageCount = 0;
        if(listTransactionResult.length % 23 == 0) {
          pageCount = listTransactionResult.length ~/ 23;
        } else {
          pageCount = (listTransactionResult.length ~/ 23 + 1);
        }
        int start = 0;
        int end = 0;
        int totalLength = listTransactionResult.length;
        int count = 1;
        while (pageCount > 0) {
          if (!(totalLength - 23).isNegative) {
            end = end + (24 + 1 - count);
            totalLength -= 23;
          } else {
            if (end == 0) {
              end = end + totalLength + 1;
            } else {
              end += totalLength;
            }
          }
          List<pw.TableRow> tableRowList = [];
          for (var i = start; i < end; i++) {
            tableRowList.add(
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: i == start
                  ? const PdfColor.fromInt(0xFF283593)
                  : PdfColors.white,
                  border: const pw.Border(right: pw.BorderSide(color: PdfColor.fromInt(0xFF000000)))
                ),
                children: List.generate(
                  3,
                  (subIndex) => i == start
                  ? pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        labelList[subIndex],
                        style: pw.TextStyle(color: i == start ? PdfColors.white : PdfColors.black),
                      ),
                    )
                  : pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: subIndex == 0
                    ? pw.Text(dateFormat.format(listTransactionResult[i - 1].date))
                    : subIndex == 1
                      ? pw.Text(listTransactionResult[i - 1].type)
                      : pw.Text(listTransactionResult[i - 1].amount.toString())
                  ),
                ),
              ),
            );
          }
          pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) => pw.Table(border: pw.TableBorder.all(color: const PdfColor.fromInt(0xFF000000)),children: tableRowList),
          ));
          pageCount -= 1;
          start = end - 1;
          count += 1;
        }
        var dateTime = DateTime.now();
        var first = userName.replaceAll(' ', '');
        var last = dateTime.toString().substring(0, 10).replaceAll('-', '');
        first = '${first}_$last.pdf';
        await downloadFile(bytes: await pdf.save(), downloadName: first).then((_) async {
          emit(TransactionExportPDFState(message: 'File downloaded successfully', isSuccess: true));
        });
        audioPlayer.play();
      } catch (e) {
        emit(TransactionExportPDFState(message:'Something went wrong while exporting your transaction report'));
      }
    }
  }
}
