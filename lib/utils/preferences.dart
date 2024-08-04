import '../constants/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static SharedPreferences? _sharedPreferences;

  static Future<SharedPreferences> get _instance async => _sharedPreferences ?? await SharedPreferences.getInstance();

  Future<void> init() async => _sharedPreferences = await _instance;

  ///set string value
  static void setString({required String key, required String value}) => _sharedPreferences!.setString(key, value);
  ///get string value
  static String getString({required String key}) => _sharedPreferences!.getString(key) ?? AppStrings.emptyString;

  ///set bool value
  static void setBool({required String key, required bool value}) => _sharedPreferences!.setBool(key, value);
  ///get bool value
  static bool getBool({required String key}) => _sharedPreferences!.getBool(key) ?? false;
  ///clear data using key
  static Future<bool> clearPreferences({required String key}) async => await _sharedPreferences!.remove(key);
}