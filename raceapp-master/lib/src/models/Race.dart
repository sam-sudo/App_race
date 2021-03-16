import 'dart:convert';

import 'User.dart';
import 'UserCredentials.dart';

class Race {
  String id;
  String name;
  String description;
  List<List<double>> routePoints;
  List<UserCredentials> runners;
  DateTime dateRace;

  Race({
    this.id,
    this.name,
    this.description,
    this.routePoints,
    this.runners,
    this.dateRace,
  });

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'routePoints': routePoints,
        'runners': runners.map((e) => e.emailToMap()).toList(),
        'dateRace': dateRace.toIso8601String(),
      };

  String get getId => id;

  String get getName => name;

  set setName(String name) => this.name = name;

  String get getDescription => description;

  set setDescription(String description) => this.description = description;

  List get getRoutePoints => routePoints;

  set setRoutePoints(List routePoints) => this.routePoints = routePoints;

  List<User> get getRunners => runners;

  set setRunners(List<User> runners) => this.runners = runners;
  //set setRunner(User runner) => this.runners.add(runner);

  DateTime get getDateRAce => dateRace;

  set setDateRAce(DateTime dateRace) => this.dateRace = dateRace;

  @override
  String toString() {
    return 'Race(id: $id, name: $name, description: $description, routePoints: $routePoints, runners: $runners, dateRace: $dateRace)';
  }

  static Race fromMap(Map<String, dynamic> race) {
    final racee = Race(
        id: race['_id'],
        name: race['name'],
        description: race['description'],
        routePoints: List<List<double>>.from(
            race['routePoints'].map((model) => List<double>.from(model))),
        runners: List<UserCredentials>.from(
            race['runners'].map((model) => UserCredentials.fromJson(model))),
        dateRace: DateTime.parse(race['dateRace']));

    return racee;
  }

  static List<Race> racesFromJson(String jsonData) {
    final data = jsonDecode(jsonData);

    List<Race> data2 = new List<Race>();
    for (var item in data) {
      var race = Race.fromMap(item);
      data2.add(race);
    }

    return data2;
  }
}
