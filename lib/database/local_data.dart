import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static late SharedPreferences? _preferences;
  static Future<void> init() async =>
      _preferences = await SharedPreferences.getInstance();

  static void signout() => _preferences!.clear();

  static const String _favKey = 'FAVKEY';
  static const String _verifyKey = 'VERIFYKEY';

  //
  // Setters
  //
  static Future<void> setFavroites(List<String> uid) async =>
      _preferences!.setStringList(_favKey, uid);
  static Future<void> setVerified(List<String> uid) async =>
      _preferences!.setStringList(_verifyKey, uid);

  //
  // Getters
  //
  static List<String> get getFavroites =>
      _preferences!.getStringList(_favKey) ?? <String>[];
  static List<String> get getVerified =>
      _preferences!.getStringList(_verifyKey) ?? <String>[];
}
