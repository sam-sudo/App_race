import 'package:app_races/src/models/Circuit.dart';
import 'package:app_races/src/models/Preferences.dart';
import 'package:app_races/src/models/Race.dart';
import 'package:app_races/src/models/UserCredentials.dart';
import 'package:app_races/src/responses/RegisterResponse.dart';
import 'package:app_races/src/services/AuthApiService.dart';
import 'package:app_races/src/services/RaceApiService.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Circuit.dart';

class RaceViewModel extends Model {
  bool logged = false;
  RaceApiService api;
  String route;
  AuthApiService authApi = AuthApiService();
  Preferences _preferences = Preferences();
  UserCredentials user = UserCredentials();

  setActualPage(String route) {
    this.route = route;
  }

  String getActualPage() {
    return route;
  }

  removeRace(Circuit race) async {
    await api.removeRace(race);
    notifyListeners();
  }

  Future<List<Race>> get races async {
    final races = await api.getRaces();
    return races;
  }

  Future<List<Race>> get myraces async {
    final races = await api.getMyRaces(user.email);
    return races;
  }

  Future<List<Circuit>> get circuits async {
    final circuits = await api.getCircuits(user.email);
    return circuits;
  }

  Future<bool> updateCircuit(Circuit circuit) async {
    await api.updateCircuit(circuit);
    notifyListeners();
  }

  Future<bool> updateRace(Race race) async {
    await api.updateRace(race);
    notifyListeners();
  }

  addCicuit(Circuit circuit) async {
    await api.addCircut(circuit);
    notifyListeners();
  }

  bool _setLoginStatus(String token) {
    if (token != null) {
      logged = true;
      _preferences.token = token;
      api = RaceApiService(token);
      return true;
    } else {
      logged = false;
      _preferences.token = null;
      return false;
    }
  }

  Future<bool> login(UserCredentials credentials) async {
    final token = await authApi.login(credentials);
    user.email = credentials.email;
    user.password = credentials.password;
    _preferences.emailCurrentUser = user.email;
    if (token != null) {
      logged = true;
      _preferences.token = token;
      api = RaceApiService(token);
      return true;
    } else {
      logged = false;
      _preferences.token = null;
      return false;
    }
  }

  Future<RegisterResponse> register(UserCredentials user) async {
    final response = await authApi.register(user);
    if (response.status == RegisterResponseStatus.Success) {
      _setLoginStatus(response.token);
    }
    return response;
  }

  logout() {
    logged = false;
    _preferences.token = null;
  }

  Future<void> refresh() async => notifyListeners();
}
