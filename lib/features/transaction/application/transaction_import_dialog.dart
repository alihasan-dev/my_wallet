import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../transaction/application/transaction_import_bloc/transaction_import_bloc.dart';
import '../../transaction/domain/transaction_import_model.dart';
import '../../../utils/app_extension_method.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_checkbox_widget.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_theme.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_style.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/custom_text.dart';
import '../../../constants/app_size.dart';
import '../../../utils/helper.dart';
import '../../../widgets/custom_text_button.dart';
import '../../../widgets/horizontal_dashline.dart';

class TransactionImportDialog extends StatefulWidget {

  final String friendId;
  final double totalAmount;
  final Widget? closeButton;

  const TransactionImportDialog({
    super.key,
    required this.friendId,
    this.closeButton,
    this.totalAmount = 0.0
  });

  @override
  State createState() => _TransactionImportDialogState();
}

class _TransactionImportDialogState extends State<TransactionImportDialog> with Helper {

  AppLocalizations? _localizations;
  List<ImportStatus> importStatusFlagList = [];
  int currentIndex = 0;
  final reportHeader = {'date','type','status', 'amount'};
  List<TransactionImportModel> importTransactionList = [];
  bool finalCheckValue = false;
  int validRow = 0;
  int invalidRow = 0;
  String fileName = '';
  bool importLoading = false;
  String errorMessage = "";

  @override
  void initState() {
    importTransactionList.clear();
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    importStatusFlagList = [
      ImportStatus(label: _localizations!.upload),
      ImportStatus(label: _localizations!.review),
      ImportStatus(label: _localizations!.clean),
      ImportStatus(label: _localizations!.confirm)
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionImportBloc>(
      create: (context) => TransactionImportBloc(friendId: widget.friendId, totalAmount: widget.totalAmount),
      child: AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSize.s15, 
          horizontal: AppSize.s18
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSize.s15),
        backgroundColor: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
        content: SizedBox(
          width: MyAppTheme.columnWidth + 200,
          child: BlocConsumer<TransactionImportBloc, TransactionImportState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: _localizations!.transactionImport,
                        textStyle: getSemiBoldStyle(),
                      ),
                      Transform.translate(
                        offset: const Offset(10, 0),
                        child: IconButton(
                          tooltip: _localizations!.close,
                          onPressed: () => context.pop(),
                          icon: const Icon(AppIcons.clearIcon),
                          visualDensity: VisualDensity.compact
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.s16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            importStatusFlagList.length, 
                            (index) {
                              final item = importStatusFlagList[index];
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 5,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: item.isCompleted
                                      ? AppColors.green
                                      : currentIndex == index
                                        ? AppColors.primaryColor
                                        : AppColors.grey.withValues(alpha: 0.3),
                                      shape: BoxShape.circle
                                    ),
                                    child: item.isCompleted
                                    ? Icon(
                                        Icons.check,
                                        size: 15,
                                        color: AppColors.white,
                                      )
                                    : Center(
                                      child: Text(
                                        '${index + 1}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: currentIndex == index
                                          ? AppColors.white
                                          : Helper.isDark
                                            ? AppColors.white.withValues(alpha: 0.9)
                                            : AppColors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.label,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: item.isCompleted
                                      ? AppColors.green
                                      : currentIndex == index
                                        ? AppColors.primaryColor
                                        : Helper.isDark
                                          ? AppColors.white.withValues(alpha: 0.9)
                                          : AppColors.black
                                    ),
                                  ),
                                  if (index < importStatusFlagList.length - 1) ...[
                                    SizedBox(
                                      width: 60,
                                      child: HorizontalLine(
                                        color: Colors.grey,
                                        dashWidth: 5,
                                        dashSpace: 5,
                                        strokeWidth: 1.2,
                                      ),
                                    ),
                                    SizedBox(width: 5)
                                  ]
                                ],
                              );
                            }
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.s20),
                  AnimatedSize(
                    duration: Duration(milliseconds: 250),
                    child: currentIndex == 0
                    ? _uploadStep(context)
                    : currentIndex == 1
                      ? _reviewStep(
                          context,
                          fileName: fileName,
                          totalRow: validRow,
                          totalCloumn: invalidRow,
                          errorMessage: errorMessage
                        )
                      : currentIndex == 2
                        ? _cleanStep(context)
                        : importStatusFlagList[currentIndex].isCompleted
                          ? _uploadSuccess(context, transactionCount: validRow)
                          : _confirmStep(
                              context,
                              validRow: validRow,
                              invalidRow: invalidRow,
                              importLoading: importLoading
                            )
                  ),
                  SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: Offset(0, 6),
                              child: Icon(Icons.circle, size: 6, color: AppColors.grey)),
                            Expanded(
                              child: Text(
                               _localizations!.transaction_import_msg_first,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: Offset(0, 6),
                              child: Icon(Icons.circle, size: 6, color: AppColors.grey)),
                            Expanded(
                              child: Text(
                                _localizations!.transaction_import_msg_second,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              );
            },
            listener: (_, state) {
              switch (state) {
                case TransactionImportStatusUpdateState _:
                  errorMessage = state.message;
                  currentIndex = state.currentImportIndex;
                  if (state.isCompleted) {
                    importStatusFlagList[state.completeIndex].isCompleted = true;
                  }
                  validRow = state.validCount;
                  invalidRow = state.invalidCount;
                  importLoading = state.importLoading;
                  fileName = state.fileName;
                  if (state.isReset) {
                    for (var status in importStatusFlagList) {
                      status.isCompleted = false;
                    }
                  }
                  break;
                case TransactionImportDownloadTemplateState _:
                  showSnackBar(
                    context: context, 
                    title: state.message,
                    color: state.status
                    ? AppColors.green
                    : null
                  );
                  break;
                case TransactionImportCheckedState _:
                  finalCheckValue = state.value;
                  break;
                default:
              }
            },
          ),
        ),
      ),
    );
  }
  
  Widget _cleanStep(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 14,
              children: [
                SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                Text(
                  "${_localizations!.checking_your_data}...",
                  style: TextStyle(
                    fontSize: 13
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              _localizations!.checking_formats,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewStep(
    BuildContext context, {
    String errorMessage = '',
    String fileName = '',
    int totalRow = 0,
    int totalCloumn = 0
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Center(
        child: errorMessage.isBlank
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 14,
                children: [
                  SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  Text(
                    "${_localizations!.reading_file}...",
                    style: TextStyle(
                      fontSize: 13
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                _localizations!.successful_read_file_msg(fileName, totalCloumn, totalRow),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey
                ),
              ),
            ],
          )
        : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.clear, 
              color: AppColors.red, 
              size: 35
            ),
            SizedBox(height: 8),
            Text(
              _localizations!.import_failed_parse,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(
                fontSize: 12
              ),
            ),
            SizedBox(height: 12),
            CustomTextButton(
              title: _localizations!.try_different_file,
              horizontalPadding: AppSize.s16,
              borderRadius: AppSize.s24,
              isSelected: true,
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
              onPressed: () => context.read<TransactionImportBloc>().add(TransactionImportResetEvent())
            ),
          ],
        ),
      ),
    );
  }

  Widget _confirmStep(BuildContext context, {
    int validRow = 0,
    int invalidRow = 0,
    bool importLoading = false
  }) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14
      ),
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _localizations!.import_summary,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
          if (validRow > 0) ...[
            SizedBox(height: 8),
            Row(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(0, 6),
                  child: Icon(
                    Icons.circle, 
                    size: 5, 
                    color: AppColors.grey
                  ),
                ),
                Expanded(
                  child: Text(
                    _localizations!.valid_row_include_msg(validRow),
                    style: TextStyle(
                      fontSize: 12
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(0, 6),
                  child: Icon(
                    Icons.circle, 
                    size: 5, 
                    color: AppColors.grey
                  ),
                ),
                Expanded(
                  child: Text(
                    _localizations!.invalid_row_exclude_msg(invalidRow),
                    style: TextStyle(
                      fontSize: 12
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: validRow > 0 ? 18 : 10),
          Row(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(0, 3),
                child: Icon(
                  Icons.warning, 
                  size: 12, 
                  color: validRow > 0
                  ? AppColors.amber
                  : AppColors.red
                ),
              ),
              Expanded(
                child: Text(
                  validRow > 0
                  ? _localizations!.import_warning_msg
                  : _localizations!.no_valid_import,
                  style: TextStyle(
                    fontSize: 12,
                    color: validRow > 0
                    ? AppColors.amber
                    : AppColors.red
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          if (validRow > 0) ...[
            Row(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(0, -1),
                  child: Transform.scale(
                    scale: 0.75,
                    child: CustomCheckBoxWidget(
                      value: finalCheckValue, 
                      onChange: importLoading
                      ? null
                      : (value) => context.read<TransactionImportBloc>().add(
                        TransactionImportCheckedEvent(value: value ?? false)
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    _localizations!.import_review_msg,
                    style: TextStyle(
                      fontSize: 12
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (validRow <=0 )...[
            Text(
              _localizations!.invalid_row_msg(invalidRow),
              style: TextStyle(
                fontSize: 12
              ),
            ),
          ],
          SizedBox(height: 15),
          CustomButton(
            onTap: validRow <= 0
            ? () => context.read<TransactionImportBloc>().add(TransactionImportResetEvent())
            : finalCheckValue && !importLoading
              ? () => context.read<TransactionImportBloc>().add(TransactionImportUploadEvent())
              : null,
            expanded: false,
            verticalPadding: 10,
            horizontalPadding: 15,
            title: importLoading
            ? '${_localizations!.loading}...'
            : validRow <= 0
              ? _localizations!.try_different_file
              : _localizations!.import_valid_transaction(validRow),
            titleSize: 12,
            buttonColor: validRow <= 0
            ? AppColors.red
            : null
          ),
        ],
      ),
    );
  }

  Widget _uploadSuccess(BuildContext context, {int transactionCount = 0}) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14
      ),
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: AppColors.green, size: 40),
          SizedBox(height: 8),
          Text(
            _localizations!.import_completed,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 8),
          Text(
            _localizations!.import_complete_msg(transactionCount),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey
            ),
          ),
          SizedBox(height: 12),
          CustomTextButton(
            title: _localizations!.done,
            horizontalPadding: AppSize.s16,
            borderRadius: AppSize.s24,
            isSelected: true,
            backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
            onPressed: () => context.pop()
          ),
        ],
      ),
    );
  }

  Widget _uploadStep(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: AppColors.grey,
        strokeWidth: 1.2,
        dashPattern: const [10, 3], 
        radius: const Radius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 24
        ),
        decoration: BoxDecoration(
          color: AppColors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Icon(
                Icons.upload,
                size: 28,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'OpenSans'
                  ),
                  children: [
                    TextSpan(
                      text: _localizations!.drag_drop_msg,
                      style: TextStyle(
                        color: Helper.isDark
                        ? AppColors.white.withValues(alpha: 0.9)
                        : AppColors.black
                      ),
                    ),
                    TextSpan(
                      text: _localizations!.select_files,
                      style: TextStyle(
                        color: AppColors.primaryColor
                      ),
                      recognizer: TapGestureRecognizer()
                      ..onTap = () => context.read<TransactionImportBloc>().add(TransactionImportInitiateEvent())
                    ),
                  ]
                ),
              ),
              Text(
                _localizations!.upload_file_msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.grey
                ),
              ),
              GestureDetector(
                onTap: () => context.read<TransactionImportBloc>().add(TransactionImportDownloadTemplateEvent()),
                child: Text(
                  _localizations!.download_sample_template,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class ImportStatus {
  String label;
  bool isCompleted;

  ImportStatus({
    this.label = '',
    this.isCompleted = false
  });
}