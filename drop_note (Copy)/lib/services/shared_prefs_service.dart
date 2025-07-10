import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUserLoggedIn(bool value) async {
    await _prefs.setBool("loggedIn", value);
  }

  static bool isUserLoggedIn() {
    return _prefs.getBool("loggedIn") ?? false;
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }
}