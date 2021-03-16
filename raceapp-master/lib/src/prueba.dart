import 'dart:convert';

import 'package:app_races/src/models/Race.dart';

import 'models/User.dart';

main(List<String> args) {
  var user = '{"email":"email2@prueba","password":"1235"}';
  var routePoints = '{"routePoints":[[12.0,-13.0],[14.0,-13.0]]}';
  var race =
      '{"routePoints": [[12.0,-13.0],[14.0,-13.0]],"_id": "603cdfe051b14b55594b8fae", "runners": [{"email": "email@prueba","password": "1235"},{"email": "email2@prueba","password": "1235"}], "name": "Circuito prueba", "description": "description cambiada 3","dateRace": "2021-03-12T00:00:00.000Z","__v": 0 }';

  Map userMap = jsonDecode(user);
  Map raceMap = jsonDecode(race);
  Map routePointsMap = jsonDecode(routePoints);
  //var userDecoded = User.fromJson(userMap);
  //var raceDecoded = Race.fromJson(raceMap);
  print(routePointsMap);
  //var routePointsDecoded = RoutePoints.fromJson(routePointsMap);

  //print(json);
  //print(raceDecoded.toJson());
  // print(raceDecoded.routePoints[1]);
}
