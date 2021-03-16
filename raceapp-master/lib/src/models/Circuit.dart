import 'dart:convert';

class Circuit {
  String id;
  String emailUser;
  String name;
  String description;
  List<List<double>> routePoints;
  DateTime dateRace;
  Circuit({
    this.id,
    this.emailUser,
    this.name,
    this.description,
    this.routePoints,
    this.dateRace,
  });

  String toJson() => json.encode(toMap());
  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'routePoints': routePoints,
        'dateRace': dateRace.toIso8601String(),
        'emailUser': emailUser,
      };

  static Circuit fromMap(Map<String, dynamic> circuitJson) {
    final circuit = Circuit(
        id: circuitJson['_id'],
        emailUser: circuitJson['emailUser'],
        name: circuitJson['name'],
        description: circuitJson['description'],
        routePoints: List<List<double>>.from(circuitJson['routePoints']
            .map((model) => List<double>.from(model))),
        dateRace: DateTime.parse(circuitJson['dateRace']));

    return circuit;
  }

  static List<Circuit> circuitsFromJson(String jsonData) {
    final data = jsonDecode(jsonData);

    List<Circuit> data2 = new List<Circuit>();
    for (var item in data) {
      var circuit = Circuit.fromMap(item);
      data2.add(circuit);
    }

    return data2;
  }

  String get getId => this.id;

  set setId(String id) => this.id = id;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getDescription => this.description;

  set setDescription(description) => this.description = description;

  get getRoutePoints => this.routePoints;

  set setRoutePoints(routePoints) => this.routePoints = routePoints;

  get getDateRace => this.dateRace;

  set setDateRace(dateRace) => this.dateRace = dateRace;
}
