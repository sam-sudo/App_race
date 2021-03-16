import 'dart:convert';

import 'package:app_races/src/models/Race.dart';
import 'package:app_races/src/models/User.dart';

main(List<String> args) {
  var user = '{"email":"email2@prueba","password":"1235"}';
  var routePoints = '{"routePoints":[[12.0,-13.0],[14.0,-13.0]]}';
  var race =
      '{"routePoints": [[12.0,-13.0],[14.0,-13.0]],"_id": "603cdfe051b14b55594b8fae", "runners": [{"email": "email@prueba","password": "1235"},{"email": "email2@prueba","password": "1235"}], "name": "Circuito prueba", "description": "description cambiada 3","dateRace": "2021-03-12T00:00:00.000Z","__v": 0 }';
  var race2 =
      '{routePoints: [[12.01, -13.01], [14.01, -13.01]], _id: 603ec84564564c013d735cd4, runners: [{email: email@prueba, password: 1235}, {email: email2@prueba, password: 1235}], name: Circuito prueba, description: description cambiada 3, dateRace: 2021-03-12T00:00:00.000Z, __v: 0}';

  Map userMap = jsonDecode(user);

  Map raceMap = jsonDecode(race);
  print(raceMap);
  //Map routePointsMap = jsonDecode(routePoints);
  //var userDecoded = User.fromJson(userMap);
  print('eey');
  var raceDecoded = Race.fromMap(raceMap);
  //print(routePointsMap);
  //var routePointsDecoded = RoutePoints.fromJson(routePointsMap);

  //print(json);
  print(raceDecoded);
  print(raceDecoded.name);
}
