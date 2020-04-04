import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtil {

  static String THEME = "theme";

  static Future<SharedPreferences> setTheme(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(THEME, value);
  }

  static Future<String> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(THEME);
  }

}