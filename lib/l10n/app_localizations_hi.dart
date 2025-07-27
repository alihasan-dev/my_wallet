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
  String get appearance => 'दिखावट';

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
  String get showUnverifiedUser => 'शो आर्चीवड यूजर';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए';

  @override
  String get forgotPasswordMsg =>
      'अपने खाते से संबद्ध ईमेल पता दर्ज करें और हम आपको आपका पासवर्ड रीसेट करने के लिए एक लिंक भेजेंगे';

  @override
  String get send => 'भेजें';

  @override
  String get imageSizeMsg => 'फोटो का आकार 2MB से अधिक नहीं होना चाहिए';

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
  String get importantNote => 'महत्वपूर्ण नोट';

  @override
  String get signupWarningMsg =>
      'यदि आपने पहले उसी ईमेल पते से Google खाता इस्तेमाल करके साइन अप किया था, तो अब उसी Google खाते से फिर से साइन अप करने पर आपका मौजूदा खाता बदल जाएगा। कृपया सावधान रहें!';

  @override
  String get gotIt => 'समझ गया';

  @override
  String get transactionBreakdown => 'लेन-देन विवरण';

  @override
  String get transactionBreakdownMsg => 'प्रत्येक लेनदेन का विवरण';

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
}
