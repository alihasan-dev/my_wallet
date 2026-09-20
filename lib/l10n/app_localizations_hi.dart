// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get rememberMe => 'मुझे याद रखो';

  @override
  String get login => 'लॉग इन करें';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get language => 'भाषा';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get close => 'बंद करे';

  @override
  String get back => 'वापस जाएं';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get logoutMsg => 'क्या आप लॉग आउट करना चाहते हैं?';

  @override
  String get exit => 'निकास';

  @override
  String get exitMsg => 'क्या आप निश्चित हैं आपकी बाहर निकलने की इच्छा है?';

  @override
  String get userId => 'उपयोगकर्ता पहचान';

  @override
  String get name => 'नाम';

  @override
  String get phone => 'फ़ोन';

  @override
  String get address => 'पता';

  @override
  String get update => 'सुधार';

  @override
  String get profileUpdateMsg => 'प्रोफाइल को सफलतापूर्वक अपडेट किया गया';

  @override
  String get addUser => 'यूजर जोड़ें';

  @override
  String get dontHaveAccount => 'कोई खाता नहीं है';

  @override
  String get signup => 'साइन अप करें';

  @override
  String get alreadyHaveAnAccount => 'क्या आपके पास पहले से खाता मौजूद है';

  @override
  String get noTransactionFound => 'कोई ट्रांजेक्शन नहीं मिला';

  @override
  String get date => 'तारीख';

  @override
  String get type => 'प्रकार';

  @override
  String get amount => 'धनराशि';

  @override
  String get availableBalance => 'उपलब्ध शेष राशि';

  @override
  String get receive => 'प्राप्त';

  @override
  String get transfer => 'ट्रान्सफर';

  @override
  String get transferType => 'ट्रान्सफर प्रकार';

  @override
  String get addTransaction => 'लेन-देन जोड़ें';

  @override
  String get editTransaction => 'लेन-देन सुधारें';

  @override
  String get userProfile => 'उपभोक्ता प्रोफ़ाइल';

  @override
  String get deleteUser => 'उपभोक्ता मिटायें';

  @override
  String deleteUserMsg(String name) {
    return 'क्या आप वाकई मे $name को हटाना चाहते हैं?';
  }

  @override
  String get selectImg => 'चित्र चुनें';

  @override
  String get gallery => 'गैलरी';

  @override
  String get camera => 'कैमरा';

  @override
  String get appearance => 'उपस्थिति';

  @override
  String get theme => 'विषय';

  @override
  String get systemDefault => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get light => 'रोशनी';

  @override
  String get dark => 'अँधेरा';

  @override
  String get biometricAuthFailed => 'बायोमेट्रिक प्रमाणीकरण विफल';

  @override
  String get biometricAuthFailedMessage =>
      'MyWallet अनधिकृत पहुंच से बचने के लिए आपके डेटा की सुरक्षा करता है।';

  @override
  String get bioAuthFailedTooManyAttemptMessage =>
      'बायोमेट्रिक प्रमाणीकरण विफल रहा क्योंकि बहुत अधिक प्रयासों के कारण एपीआई लॉक हो गया है। ऐसा 5 असफल प्रयासों के बाद होता है';

  @override
  String get reAuthenticate => 'पुन: प्रमाणीकृत';

  @override
  String get viewProfile => 'व्यू प्रोफाइल';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get show_archived_friends => 'संग्रहीत मित्र दिखाएं';

  @override
  String get show_archived_friends_msg =>
      'अपनी मित्र सूची में संग्रहीत मित्रों को शामिल करें';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए';

  @override
  String get forgotPasswordMsg =>
      'अपने खाते से संबद्ध ईमेल पता दर्ज करें और हम आपको आपका पासवर्ड रीसेट करने के लिए एक लिंक भेजेंगे';

  @override
  String get send => 'भेजें';

  @override
  String get imageSizeMsg => 'फोटो का आकार 2 MB से कम होना चाहिए।';

  @override
  String get contacts => 'संपर्क';

  @override
  String get aboutMyWallet => 'मायवॉलेट के बारे में';

  @override
  String get backToLogin => 'लॉगिन पर वापस जाएं';

  @override
  String get noUserFound => 'कोई यूजर नहीं मिला';

  @override
  String get enableBiometric => 'बायोमेट्रिक सक्षम करें';

  @override
  String get enableBiometricMsg => 'बायोमेट्रिक का उपयोग करके ऐप अनलॉक करें';

  @override
  String get apply => 'लागु करें';

  @override
  String get clear => 'हटाएँ';

  @override
  String get amountRange => 'राशि सीमा';

  @override
  String get dateRange => 'दिनांक सीमा';

  @override
  String get advanceFilter => 'एडवांस फ़िल्टर';

  @override
  String get search => 'खोजें';

  @override
  String get exportReport => 'निर्यात रिपोर्ट';

  @override
  String get delete => 'मिटाए';

  @override
  String get openAppOnBrowser => 'ब्राउज़र पर ऐप खोलें';

  @override
  String get deleteTransaction => 'लेन-देन मिटाए';

  @override
  String get deleteTransactionMsg =>
      'क्या आप वाकई में चयनित लेनदेन को मिटाना चाहते हैं?';

  @override
  String get deleteSubTransaction => 'उप लेन-देन मिटाए';

  @override
  String get deleteSubTransactionMsg =>
      'क्या आप वाकई में चयनित उप लेनदेन को मिटाना चाहते हैं?';

  @override
  String get clearSelection => 'चयनित हटाएँ';

  @override
  String get importantNote => 'महत्वपूर्ण सूचना';

  @override
  String get signupWarningMsg =>
      'यदि आपने पहले उसी ईमेल पते से Google खाता इस्तेमाल करके साइन अप किया था, तो अब उसी Google खाते से फिर से साइन अप करने पर आपका मौजूदा खाता बदल जाएगा। कृपया सावधान रहें!';

  @override
  String get gotIt => 'समझ गया';

  @override
  String get transactionBreakdown => 'लेन-देन का ब्यौरा दिखाएं';

  @override
  String get transactionBreakdownMsg =>
      'प्रत्येक लेन-देन के लिए अतिरिक्त जानकारी प्रदर्शित करें';

  @override
  String get unselect => 'अचयनित';

  @override
  String get add => 'जोड़ें';

  @override
  String get addTransactionDetails => 'लेन-देन विवरण जोड़ें';

  @override
  String get description => 'विवरण';

  @override
  String get rate => 'दर प्रति पीस';

  @override
  String get quantity => 'मात्रा';

  @override
  String get total => 'कुल';

  @override
  String get noTransactionDetailsFound => 'कोई लेनदेन विवरण नहीं मिला';

  @override
  String get pin => 'पिन';

  @override
  String get archive => 'आर्काइव';

  @override
  String get deleted => 'मिटा दिया गया';

  @override
  String get create_archived_user_label =>
      'संग्रहीत (आर्काइव) उपयोगकर्ता के रूप में बनाएं';

  @override
  String get archived_user_hint =>
      'संग्रहीत (आर्काइव) उपयोगकर्ता मुख्य सूची से छिपे रहते हैं (यदि सेटिंग्स में \'संग्रहीत उपयोगकर्ता दिखाएं\' विकल्प बंद है)। उन्हें कभी भी वापस लाने के लिए उन पर लॉन्ग-प्रेस करें और \'अनआर्काइव\' पर टैप करें।';

  @override
  String get transactionDescription => 'लेन-देन विवरण दिखाएं';

  @override
  String get transactionDescriptionMsg =>
      'अपने लेन-देन के लिए विवरण प्रदर्शित करें';

  @override
  String get transactionStatus => 'लेन-देन स्थिति';

  @override
  String get importReport => 'आयात रिपोर्ट';

  @override
  String get transactionImport => 'लेन-देन आयात';

  @override
  String get optional => 'वैकल्पिक';

  @override
  String get active => 'सक्रिय';

  @override
  String get inactive => 'निष्क्रिय';

  @override
  String get transactionStatusMsg =>
      'सक्रिय लेन-देन आपके बैलेंस में गिने जाते हैं। आप इसे कभी भी लेन-देन संपादित करके बदल सकते हैं।';

  @override
  String get upload => 'अपलोड';

  @override
  String get review => 'समीक्षा';

  @override
  String get clean => 'सफ़ाई';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get drag_drop_msg => 'खींचें और छोड़ें या ';

  @override
  String get select_files => 'फ़ाइलें चुनें';

  @override
  String get upload_file_msg =>
      'अपनी लेन-देन फ़ाइल CSV (.csv) या Excel (.xlsx/.xls) प्रारूप में अपलोड करें।\nअधिकतम फ़ाइल आकार 2 MB है';

  @override
  String get download_sample_template => 'नमूना टेम्पलेट डाउनलोड करें';

  @override
  String get done => 'पूर्ण';

  @override
  String get import_completed => 'आयात पूर्ण हुआ';

  @override
  String import_complete_msg(Object transaction_count) {
    return '$transaction_count लेन-देन सफलतापूर्वक आयात किए गए';
  }

  @override
  String get try_different_file => 'दूसरी फ़ाइल आज़माएं';

  @override
  String get loading => 'लोड हो रहा है';

  @override
  String import_valid_transaction_msg(Object row) {
    return '$row लेन-देन आयात करें';
  }

  @override
  String invalid_row_msg(Object invalid_row) {
    return 'आपकी फ़ाइल की सभी $invalid_row पंक्तियों में समस्याएं थीं और उन्हें बाहर रखा गया। कुछ भी आयात नहीं किया जाएगा।';
  }

  @override
  String get import_review_msg =>
      'मैंने डेटा की समीक्षा कर ली है और सत्यापित लेन-देन को MyWallet में आयात करने के लिए सहमत हूं।';

  @override
  String get no_valid_import => 'आयात करने के लिए कोई मान्य लेन-देन नहीं';

  @override
  String get import_warning_msg =>
      'इस क्रिया को स्वचालित रूप से पूर्ववत नहीं किया जा सकता — आयातित लेन-देन को बाद में अलग-अलग संपादित या हटाया जा सकता है।';

  @override
  String invalid_row_exclude_msg(Object invalid_row) {
    return '$invalid_row अमान्य पंक्तियाँ बाहर रखी गईं';
  }

  @override
  String valid_row_include_msg(Object valid_row) {
    return '$valid_row लेन-देन आयात किए जाएंगे';
  }

  @override
  String get import_summary => 'आयात सारांश';

  @override
  String get import_failed_parse => 'आयात पार्स करने में विफल';

  @override
  String successful_read_file_msg(
    Object file_name,
    Object total_column,
    Object total_row,
  ) {
    return '$file_name से $total_row पंक्तियाँ और $total_column कॉलम सफलतापूर्वक पढ़े गए';
  }

  @override
  String get reading_file => 'आपकी फ़ाइल पढ़ी जा रही है';

  @override
  String get checking_formats => 'प्रारूप जांचे जा रहे हैं';

  @override
  String get checking_your_data => 'आपका डेटा जांचा जा रहा है';

  @override
  String get transaction_import_msg_second =>
      'आपकी फ़ाइल नमूना टेम्पलेट प्रारूप से मेल खानी चाहिए, अन्यथा इसे अस्वीकार कर दिया जाएगा।';

  @override
  String get transaction_import_msg_first =>
      'पहले से आयात की गई फ़ाइल को दोबारा अपलोड करने से बचें — केवल पूर्ण रूप से मेल खाने वाली प्रविष्टियाँ ही डुप्लिकेट के रूप में पकड़ी जाती हैं, इसलिए संपादित या आंशिक रूप से दोबारा अपलोड की गई फ़ाइलें दोहराई गई प्रविष्टियाँ बना सकती हैं।';

  @override
  String import_valid_transaction(Object valid_row) {
    return '$valid_row लेन-देन आयात करें';
  }

  @override
  String get transaction_mode => 'लेन-देन मोड';

  @override
  String get latest_transaction => 'नवीनतम लेन-देन';

  @override
  String get latest_transaction_msg => 'सबसे हाल के लेन-देन की राशि दिखाएं';

  @override
  String get total_outstanding => 'कुल बकाया';

  @override
  String get total_outstanding_msg =>
      'प्रत्येक मित्र के साथ वर्तमान बकाया राशि दिखाएं';

  @override
  String get transaction_mode_info_msg =>
      'जब आप कोई लेन-देन जोड़ेंगे, संपादित करेंगे, या बदलेंगे, तो आपकी बकाया राशि अपडेट हो जाएगी। मौजूदा लेन-देन आपके अगले लेन-देन अपडेट के बाद शामिल किए जाएंगे। (वर्तमान में लेन-देन अपडेट के लिए समर्थित नहीं है)';
}
