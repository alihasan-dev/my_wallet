import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/features/transaction/application/transaction_import_bloc/transaction_import_bloc.dart';
import 'package:my_wallet/features/transaction/domain/transaction_import_model.dart';
import 'package:my_wallet/utils/app_extension_method.dart';
import 'package:my_wallet/widgets/custom_button.dart';
import 'package:my_wallet/widgets/custom_checkbox_widget.dart';
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
  final Widget? closeButton;

  const TransactionImportDialog({
    super.key,
    required this.friendId,
    this.closeButton
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

  @override
  void initState() {
    importStatusFlagList = [
      ImportStatus(label: 'Upload'),
      ImportStatus(label: 'Review'),
      ImportStatus(label: 'Clean'),
      ImportStatus(label: 'Confirm')
    ];
    importTransactionList.clear();
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionImportBloc>(
      create: (context) => TransactionImportBloc(friendId: widget.friendId),
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
                        title: 'Transaction Import',
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
                                          fontWeight: FontWeight.w600,
                                          color: currentIndex == index
                                          ? AppColors.white
                                          : AppColors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.label,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: item.isCompleted
                                      ? AppColors.green
                                      : currentIndex == index
                                        ? AppColors.primaryColor
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
                    // child: currentIndex == 0
                    // ? _uploadStep(context)
                    // : _reviewStep(
                    //   context,
                    //   totalRow: 16,
                    //   totalCloumn: 5,
                    //   fileName: 'Ali_Hasan_Checking_MyWallet_Transaction_Import_Sample.xlsx',
                    //   errorMessage: "This is error message"
                    // ),
                    child: currentIndex == 0
                    ? _uploadStep(context)
                    : currentIndex == 1
                      ? _reviewStep(
                          context,
                          fileName: fileName,
                          totalRow: validRow,
                          totalCloumn: invalidRow
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
                                "Avoid re-uploading a file you've already imported — only exact matches are caught as duplicates, so edited or partial re-uploads may create repeat entries.",
                                style: TextStyle(
                                  fontSize: 11
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
                                "Your file must match the sample template format, or it will be rejected.",
                                style: TextStyle(
                                  fontSize: 11
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
                  "Checking your data...",
                  style: TextStyle(
                    fontSize: 13
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Checking formats & duplicates",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey
              ),
            )
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
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  Text(
                    "Reading your file...",
                    style: TextStyle(
                      fontSize: 13
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Successfully read $totalRow rows and $totalCloumn columns from $fileName",
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
              "Import Failed to Parse",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600
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
              title: 'Try a Different File',
              horizontalPadding: AppSize.s16,
              borderRadius: AppSize.s24,
              isSelected: true,
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
              onPressed: () => context.read<TransactionImportBloc>().add(TransactionResetImportEvent())
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
            "Import summary",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600
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
                    "$validRow transactions will be imported",
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
                    "$invalidRow invalid rows excluded",
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
                  ? "This action cannot be undone automatically — imported transactions can be edited or deleted individually afterward."
                  : "No valid transactions to import",
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
                    "I have reviewed the data and want to import the validated transactions into MyWallet.",
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
              "All $invalidRow rows in your file had issues and were excluded. Nothing will be imported.",
              style: TextStyle(
                fontSize: 12
              ),
            ),
          ],
          SizedBox(height: 15),
          CustomButton(
            onTap: validRow <= 0
            ? () => context.read<TransactionImportBloc>().add(TransactionResetImportEvent())
            : finalCheckValue && !importLoading
              ? () => context.read<TransactionImportBloc>().add(TransactionImportUploadEvent())
              : null,
            expanded: false,
            verticalPadding: 10,
            horizontalPadding: 15,
            title: importLoading
            ? 'Loading...'
            : validRow <= 0
              ? "Upload a different file"
              : 'Import $validRow Transactions',
            titleSize: 12,
            buttonColor: validRow <= 0
            ? AppColors.red
            : null
          ),
        ],
      )
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
            "Import completed",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 8),
          Text(
            "$transactionCount transactions imported successfully",
            style: TextStyle(
              fontSize: 12
            ),
          ),
          SizedBox(height: 12),
          CustomTextButton(
            title: 'Done',
            horizontalPadding: AppSize.s16,
            borderRadius: AppSize.s24,
            isSelected: true,
            backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
            onPressed: () => context.pop()
          )
        ],
      )
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
                      text: 'Drag and drop or '
                    ),
                    TextSpan(
                      text: 'select files',
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
                'Upload your transaction file in CSV or Excel (.xlsx) format.\nThe maximum file size allowed is 2 MB',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11
                ),
              ),
              GestureDetector(
                onTap: () => context.read<TransactionImportBloc>().add(TransactionImportDownloadTemplateEvent()),
                child: Text(
                  'Download sample template',
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