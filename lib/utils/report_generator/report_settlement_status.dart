import 'package:my_wallet/constants/app_strings.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../constants/app_size.dart';
import '../app_extension_method.dart';

class ReportSettlementStatus extends pw.StatelessWidget {
  final double totalBalance;
  final String friendName;
  final pw.Font font;

  ReportSettlementStatus({
    required this.totalBalance,
    required this.friendName,
    required this.font
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: AppSize.s10),
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Container(
                width: double.maxFinite,
                padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: pw.BoxDecoration(
                  color: PdfColors.indigo
                ),
                child: pw.Text(
                  AppStrings.settlementStatus,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            pw.Expanded(
              flex: 4,
              child: pw.Container(
                width: double.maxFinite,
                padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: pw.BoxDecoration(
                  color: _backgroundColor
                ),
                child: pw.Text(
                  _settlementLabel,
                  style: pw.TextStyle(
                    color: _textColor,
                    fontSize: 10,
                    font: font,
                  ),
                ),
              ),
            ),
          ]
        ),
        pw.SizedBox(height: AppSize.s5),
      ],
    );
  }

  PdfColor get _backgroundColor {
    if (totalBalance == 0.0) {
      return PdfColors.blue50;
    } else if (totalBalance < 0.0) {
      return PdfColors.red50;
    } else {
      return PdfColors.green50;
    }
  }

  PdfColor get _textColor {
    if (totalBalance == 0.0) {
      return PdfColors.blue;
    } else if (totalBalance < 0.0) {
      return PdfColors.red;
    } else {
      return PdfColors.green;
    }
  }

  String get _settlementLabel {
    if (totalBalance == 0.0) {
      return AppStrings.transactionSettled;
    } else if (totalBalance < 0.0) {
      return '$friendName owes you \u20B9${totalBalance.abs().toString().currencyFormat}';
    } else {
      return 'You owe $friendName \u20B9${totalBalance.abs().toString().currencyFormat}';
    }
  }
  
}