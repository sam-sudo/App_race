import 'dart:convert';

import 'package:app_races/src/models/Preferences.dart';
import 'package:app_races/src/models/Race.dart';
import 'package:app_races/src/models/RacesViewModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:app_races/src/models/UserCredentials.dart';
import 'package:app_races/src/widgets/RaceDrawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:intl/intl.dart';

class DetailsRaces extends StatefulWidget {
  static final route = '/DetailsRaces';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  State<StatefulWidget> createState() => _DetailsRacesState();
}

class _DetailsRacesState extends State<DetailsRaces> {
  Race race;

  //bool _runnerAdded = Preferences().runnerAdded;
  List<LatLng> points;
  LatLng currentCenter;
  Preferences _preferences = new Preferences();
  MapController mapController = new MapController();
  List<Marker> markers;
  UserCredentials user = new UserCredentials();

  var zoom = 13.0;
  //var _addToRace = false;
  var _dialogText = '¿Quieres apuntarte a esta carrera?';

  Future<bool> _showMyDialog() async {
    print(isUserRunner());
    //print(race.runners[0].toMap());

    if (isUserRunner()) {
      _dialogText = '¿Seguro que quieres dejar la carrera?';
    } else {
      _dialogText = '¿Quieres apuntarte a esta carrera?';
    }

    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ScopedModelDescendant<RaceViewModel>(
          builder: (context, child, model) => AlertDialog(
            title: Text('¡¡ALERTA!!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(_dialogText),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Si'),
                onPressed: () {
                  Navigator.of(context).pop();

                  if (isUserRunner()) {
                    //print(jsonEncode(race));
                    print(race.toJson());
                    print(race.toMap());

                    race.runners.remove(user);

                    model.updateRace(race);
                    print('remove');
                  } else {
                    print('add');
                    race.runners.add(user);
                    print(json.encode(race.runners));

                    model.updateRace(race);
                    //RACES[race.id].runners.add(user);
                    //race.runners.add(user);
                  }
                  //Preferences().setRunnerAdded = !(Preferences().runnerAdded);
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool isUserRunner() {
    print(user.email);
    for (var element in race.runners) {
      if (element.email == user.email) {
        print('user  in');
        return true;
      }
    }

    print('user not in');

    return false;
  }

  void buildMap() {
    points = new List<LatLng>();
    for (var point in race.routePoints) {
      points.add(new LatLng(point[0], point[1]));
    }

    markers = new List<Marker>();
    markers.add(new Marker(
      width: 80.0,
      height: 80.0,
      point: points[0],
      builder: (ctx) => new Icon(
        Icons.pin_drop,
        color: Colors.red,
      ),
    ));
    markers.add(new Marker(
      width: 80.0,
      height: 80.0,
      point: points[points.length - 1],
      builder: (ctx) => new Icon(
        Icons.flag,
        color: Colors.red,
      ),
    ));
  }

//-----------------------------------------------------------------------------
//----------------------------BUILD--------------------------------------------
//-----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      print(jsonEncode(args));
      race = args;
    }
    print(_preferences.emailCurrentUser);
    user.email = _preferences.emailCurrentUser;
    return Scaffold(
      body: buildCustomScrollView(context),
      drawer: RaceDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isUserRunner() ? Colors.green : Colors.red,
        elevation: 10,
        child: Icon(Icons.assistant_photo),
        onPressed: () async {
          await _showMyDialog();
          setState(() {});
        },
      ),
    );
  }

  CustomScrollView buildCustomScrollView(BuildContext context) {
    String dateRace = DateFormat('yyyy-MM-dd').format(race.dateRace);
    String timeRace = DateFormat.Hm().format(race.dateRace);

    setState(() {
      isUserRunner();
      buildMap();
    });

    void _zoomInRefresh() {
      zoom = zoom + 2.0;
      mapController.move(currentCenter, zoom);
    }

    void _zoomOutRefresh() {
      zoom = zoom - 2.0;
      mapController.move(currentCenter, zoom);
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              tooltip: 'Click to Home Screen',
              onPressed: () {
                Navigator.pop(context);
              }),
          pinned: true,
          floating: false,
          title: Text(
            'Map',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          expandedHeight: 400.0,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.zoom_in,
                  size: 40,
                  color: Colors.black,
                ),
                onPressed: _zoomInRefresh),
            IconButton(
                icon: Icon(
                  Icons.zoom_out,
                  size: 40,
                  color: Colors.black,
                ),
                onPressed: _zoomOutRefresh),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: Transform.translate(
              offset: const Offset(0, 10),
              child: RaisedButton(
                shape: StadiumBorder(),
                child: Text("Arrastra para ver el mapa"),
                onPressed: () {},
              ),
            ),
          ),
          flexibleSpace: Stack(
            children: <Widget>[
              Positioned.fill(
                child: buildFlutterMap(),
              )
            ],
          ),
        ),
        SliverFillRemaining(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        tileColor: Colors.green[300],
                                        title: Text(
                                          'NOMBRE DE LA CARRERA',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          race.name,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        tileColor: Colors.green[300],
                                        title: Text(
                                          'Nº PARTICIPANTES',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          race.runners.length.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        tileColor: Colors.green[300],
                                        title: Text(
                                          'FECHA DE LA CARRERA',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          dateRace + ' ---- ' + timeRace,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        tileColor: Colors.green[300],
                                        title: Text(
                                          'DESCRIPCIÓN',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          race.description,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      pauseAutoPlayOnManualNavigate: true,
                      pauseAutoPlayOnTouch: true,
                    ),
                    items: [
                      'assets/img/cartel.jpg',
                      'assets/img/01.jpg',
                      'assets/img/02.jpg',
                      'assets/img/03.jpg',
                      'assets/img/04.jpg',
                      'assets/img/05.png'
                    ].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(i), fit: BoxFit.cover)),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  FlutterMap buildFlutterMap() {
    return FlutterMap(
      mapController: mapController,
      options: new MapOptions(
        onPositionChanged: (position, hasGesture) {
          currentCenter = position.center;
        },
        center: LatLng(race.routePoints[0][0], race.routePoints[0][1]),
        zoom: zoom,
      ),
      layers: [
        new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        new MarkerLayerOptions(markers: markers),
        new PolylineLayerOptions(polylines: [
          new Polyline(points: points, strokeWidth: 4.0, color: Colors.purple)
        ])
      ],
    );
  }
}
