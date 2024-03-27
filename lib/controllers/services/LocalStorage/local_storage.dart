import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static bool isLoginSaved = false;
  static Future<void> saveIsLogin(bool isLoged) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogIn", isLoged);
  }

  static Future<bool> getIsLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogIn") ?? false;
  }
}
