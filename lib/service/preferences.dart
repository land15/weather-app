import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String _cityKey = '';

  static Future<void> saveCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cityKey, cityName);
  }

  static Future<String?> getCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cityKey);
  }

  static Future<bool> hasCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_cityKey);
  }
}