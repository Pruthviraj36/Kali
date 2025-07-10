import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static String _key = 'isLoggedIn';

  static Future<void> setLogin(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }

  static Future<bool> isLogin(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> clearLogin() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
