import 'dart:async';

import 'package:app_races/src/models/Circuit.dart';
import 'package:app_races/src/models/RacesViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:latlong/latlong.dart';

class PersonalRace extends StatefulWidget {
  static final route = '/PersonalRaces';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  _PersonalRaceState createState() => _PersonalRaceState();
}

class _PersonalRaceState extends State<PersonalRace> {
  StreamSubscription<LocationData> locationService;
  Circuit circuit = new Circuit();
  Circuit updateCircuit = new Circuit();
  bool isEdited = false;

  List<LatLng> points = [];
  LatLng currentCenter;
  MapController mapController = new MapController();
  List<Marker> markers;
  //User user = User(id: 3, email: 'sam4@gmail.com');
  var zoom = 13.0;
  LatLng _initialPosition;
  Timer time;
  CircularProgressIndicator waiting = CircularProgressIndicator(
    value: 1,
    backgroundColor: Colors.red,
    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
  );

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      updateCircuit = args;
      isEdited = true;
      for (var item in updateCircuit.routePoints) {
        points.add(LatLng(item[0], item[1]));
      }
      print(mapController);
      setState(() {
        //buildMap();
      });
    }

    if (isEdited) {}
    return ScopedModelDescendant<RaceViewModel>(
      builder: (context, child, model) => WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          locationService?.cancel();
        },
        child: Scaffold(
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'btn23',
                elevation: 10,
                child: Icon(Icons.save),
                onPressed: () {
                  _onSave(model);
                },
              ),
            ],
          ),
          body: _buildPersonalRace(),
        ),
      ),
    );
  }

  void _onSave(RaceViewModel model) {
    if (widget._formKey.currentState.validate()) {
      widget._formKey.currentState.save();
      print('onsave');
      if (isEdited) {
        circuit.dateRace = updateCircuit.dateRace;
        circuit.id = updateCircuit.id;
        circuit.emailUser = updateCircuit.emailUser;
        circuit.routePoints = updateCircuit.routePoints;
        print('on true');
        ScopedModel.of<RaceViewModel>(context, rebuildOnChange: true)
            .updateCircuit(circuit);
      } else {
        circuit.emailUser = model.user.email;
        circuit.dateRace = DateTime.now();
        circuit.routePoints = new List<List<double>>();
        for (var item in points) {
          print(item);
          circuit.routePoints.add([item.latitude, item.longitude]);
        }

        ScopedModel.of<RaceViewModel>(context, rebuildOnChange: false)
            .addCicuit(circuit);
      }

      circuit = Circuit();
    }
  }

  void buildMap() {
    print(points.toString() + 'oo');

    mapController.onReady.then((result) {
      mapController.move(points[0], 13.0);
    });

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

  _getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    points.add(LatLng(_locationData.latitude, _locationData.longitude));
    locationService =
        location.onLocationChanged.listen((LocationData currentLocation) {
      print(currentLocation);
      points.add(LatLng(currentLocation.latitude, currentLocation.longitude));
    });
  }

  Widget _buildPersonalRace() {
    void _zoomInRefresh() {
      zoom = zoom + 2.0;
      mapController.move(currentCenter, zoom);
    }

    void _zoomOutRefresh() {
      zoom = zoom - 2.0;
      mapController.move(currentCenter, zoom);
    }

    return Form(
      key: widget._formKey,
      child: CustomScrollView(
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
            expandedHeight: 300.0,
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
                  children: [
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            tileColor: Colors.green[300],
                            title: Text(
                              'NOMBRE',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListTile(
                            title: TextFormField(
                              validator: (value) {
                                if (value == null) {
                                  return 'Nombre vacia';
                                }
                              },
                              onSaved: (newValue) => circuit.name = newValue,
                              initialValue: updateCircuit?.name,
                              maxLines: 1,
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                            title: TextFormField(
                              validator: (value) {
                                if (value == null) {
                                  return 'Descripción vacia';
                                }
                              },
                              onSaved: (newValue) =>
                                  circuit.description = newValue,
                              initialValue: updateCircuit?.description,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isEdited == false) _buildStartButton()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FlutterMap buildFlutterMap() {
    print('dentro');
    print('positio n ' + _initialPosition.toString());

    return FlutterMap(
      mapController: mapController,
      options: new MapOptions(
        onPositionChanged: (position, hasGesture) {
          currentCenter = position.center;
        },
        center: points?.isEmpty ? null : points[0],
        zoom: zoom,
      ),
      layers: [
        new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        new MarkerLayerOptions(markers: markers ?? new List<Marker>()),
        new PolylineLayerOptions(polylines: [
          new Polyline(points: points, strokeWidth: 4.0, color: Colors.purple)
        ])
      ],
    );
  }

  Widget _buildStartButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 1.4 * (MediaQuery.of(context).size.height / 20),
              width: 5 * (MediaQuery.of(context).size.width / 8),
              margin: EdgeInsets.only(bottom: 20),
              child: RaisedButton(
                elevation: 5.0,
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  if (isEdited == false) {
                    Fluttertoast.showToast(
                        msg: "Grabando recorrido...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity
                            .BOTTOM // also possible "TOP" and "CENTER"
                        );
                    setState(() {
                      waiting = CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.green),
                      );
                      _getLocation();
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "No se puede editar el recorrido",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity
                            .BOTTOM // also possible "TOP" and "CENTER"
                        );
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Comenzar",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: MediaQuery.of(context).size.height / 40,
                        ),
                      ),
                      waiting
                    ]),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 1.4 * (MediaQuery.of(context).size.height / 20),
              width: 5 * (MediaQuery.of(context).size.width / 8),
              margin: EdgeInsets.only(bottom: 20),
              child: RaisedButton(
                elevation: 5.0,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    locationService.cancel();
                    waiting = CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.green),
                      value: 1,
                      backgroundColor: Colors.green,
                    );
                    buildMap();

                    print(points);
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  "Detener",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: MediaQuery.of(context).size.height / 40,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
