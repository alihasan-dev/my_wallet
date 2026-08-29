import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../constants/app_size.dart';
import '../../constants/app_strings.dart';

class ReportFilterDetails extends pw.StatelessWidget {
  final String transactionType;
  final String transactionStatus;
  final String dateRange;
  final String amountRange;
  final String sorting;
  final String detailsFlag;

  ReportFilterDetails({
    required this.transactionType, 
    required this.transactionStatus, 
    required this.dateRange, 
    required this.amountRange, 
    required this.sorting, 
    required this.detailsFlag
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
         pw.SizedBox(height: AppSize.s10),
        pw.Container(
          width: double.maxFinite,
          padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey200
          ),
          child: pw.Text(
            AppStrings.appliedFilter,
            style: pw.TextStyle(
              color: PdfColors.black,
              fontSize: 10,
            ),
          ),
        ),
        pw.SizedBox(height: AppSize.s5),
        pw.Padding(
          padding: pw.EdgeInsets.symmetric(horizontal: 6),
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.type, value: transactionType)),
                  pw.SizedBox(width: 20),
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.status, value: transactionStatus)),
                ]
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                children: [
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.dateRange, value: dateRange)),
                  pw.SizedBox(width: 20),
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.amountRange, value: amountRange)),
                ]
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                children: [
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.sorting, value: sorting)),
                  pw.SizedBox(width: 20),
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.details, value: detailsFlag)),
                ]
              ),
            ]
          ),
        ),
      ],
    );
  }

  pw.Widget _rowInfoTile({
    required String title,
    required String value,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 1,
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey700,
            ),
          ),
        ),
        // pw.SizedBox(height: 4),
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.black,
            ),
          ),
        ),
      ],
    );
  }
}