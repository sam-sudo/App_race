import 'package:app_races/src/services/AuthApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instance = Preferences._internal();
  SharedPreferences _preferences;
  static final tokenKey = 'race_token';
  static String emailUser = '';

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();

  bool isTokenValid() {
    if (token != null && token != '') {
      return AuthApiService(token: token).isTokenValid();
    }
    return false;
  }

  initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  set token(String token) {
    _preferences.setString(tokenKey, token);
  }

  String get token {
    return _preferences.getString(tokenKey);
  }

  String get emailCurrentUser {
    return _preferences.getString(emailUser);
  }

  set emailCurrentUser(String email) {
    _preferences.setString(emailUser, email);
  }
}
