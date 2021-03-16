import 'package:app_races/src/models/Circuit.dart';
import 'package:app_races/src/models/Race.dart';
import 'package:app_races/src/services/ApiService.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/Circuit.dart';

class RaceApiService extends ApiService {
  static final baseUrl = ApiService.baseUrl;

  String token;
  RaceApiService(this.token);

  Future<List<Race>> getRaces() async {
    print('dentrooo-----');
    final response = await http
        .get("${baseUrl}/api_race/races", headers: {"Authorization": "$token"});
    if (response.statusCode == 200) {
      return Race.racesFromJson(response.body);
    }
  }

  Future<List<Race>> getMyRaces(String emailCurrentUser) async {
    print('dentrooo-----');
    print(emailCurrentUser);
    final response = await http.get(
        '${baseUrl}/api_race/my_races/$emailCurrentUser',
        headers: {'Authorization': '$token'});
    if (response.statusCode == 200) {
      return Race.racesFromJson(response.body);
    }
  }

  Future<List<Circuit>> getCircuits(String emailCurrentUser) async {
    print('adri--------------');
    final response = await http.get(
        '${baseUrl}/api_circuit/myCircuits/${emailCurrentUser}',
        headers: {'Authorization': '$token'});
    if (response.statusCode == 200) {
      print(response.body);
      return Circuit.circuitsFromJson(response.body);
    }
  }

  Future<bool> addCircut(Circuit circuit) async {
    print(circuit.toJson());
    try {
      final response = await http.post('${baseUrl}/api_circuit/save_circuit',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '$token'
          },
          body: circuit.toJson());
      print('--------------' + circuit.toJson().toString());

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateRace(Race race) async {
    final response = await http.put(
      '${baseUrl}/api_race/update-race/${race.id}',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: race.toJson(),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateCircuit(Circuit circuit) async {
    try {
      final response = await http.put(
        '${baseUrl}/api_circuit/update_circuit/${circuit.id}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token'
        },
        body: circuit.toJson(),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeRace(Circuit circuit) async {
    try {
      final response = await http.delete(
          "${baseUrl}/api_circuit/delete_circuit/${circuit.id}",
          headers: {"Authorization": "$token"});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
