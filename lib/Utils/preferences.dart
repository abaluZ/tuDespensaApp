import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  late final SharedPreferences _sharedPrefs;

  static final Preferences _instance = Preferences._internal();

  factory Preferences() => _instance;

  Preferences._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get variableName => _sharedPrefs.getString("key") ?? "";
  String get authToken => _sharedPrefs.getString("auth_token") ?? "";

  set variableName(String value) {
    _sharedPrefs.setString("key", value);
  }

  set authToken(String value) {
    _sharedPrefs.setString("auth_token", value);
  }

  void delete() {
    _sharedPrefs.remove("key");
  }
}
