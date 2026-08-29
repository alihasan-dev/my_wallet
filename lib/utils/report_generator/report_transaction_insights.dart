import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../constants/app_size.dart';
import '../../constants/app_strings.dart';
import '../app_extension_method.dart';

class ReportTransactionInsights extends pw.StatelessWidget {
  final int totalCount;
  final double totalAmount;
  final int activeCount;
  final double transferAmount;
  final int inactiveCount;
  final double receiveAmount;
  final pw.Font font;

  ReportTransactionInsights({
    required this.totalCount, 
    required this.totalAmount, 
    required this.activeCount, 
    required this.transferAmount, 
    required this.inactiveCount, 
    required this.receiveAmount,
    required this.font
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
            AppStrings.transactionInsight,
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
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.totalCount, value: '$totalCount')),
                  pw.SizedBox(width: 20),
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.total, value: _calculateTotalAmount(totalAmount), font: font)),
                ]
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                children: [
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.active, value: '$activeCount')),
                  pw.SizedBox(width: 20),
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.transfer, value: '\u20B9${transferAmount.toString().currencyFormat}', font: font)),
                ]
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                children: [
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.inactive, value: '$inactiveCount')),
                  pw.SizedBox(width: 20),
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.receive, value: '\u20B9${receiveAmount.toString().currencyFormat}', font: font)),
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
    pw.Font? font
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
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.black,
              font: font
            ),
          ),
        ),
      ],
    );
  }

  String _calculateTotalAmount(double amount) {
    try {
      String prefix = amount.isNegative ? '- \u20B9' : '\u20B9';
      return '$prefix${amount.abs().toString().currencyFormat}';
    } catch(_) {
      return totalAmount.toString().currencyFormat;
    }
  }
}