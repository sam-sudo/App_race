import 'package:app_races/src/models/Circuit.dart';
import 'package:app_races/src/models/Race.dart';
import 'package:app_races/src/models/RacesViewModel.dart';
import 'package:app_races/src/pages/DetailsRaces.dart';
import 'package:app_races/src/pages/PersonalRace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:app_races/src/widgets/RaceDrawer.dart';

class MyCircuitList extends StatefulWidget {
  static final route = '/myCircuitList';

  @override
  _MyCircuitListState createState() => _MyCircuitListState();
}

class _MyCircuitListState extends State<MyCircuitList> {
  // var race;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RaceViewModel>(
      builder: (context, child, model) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Text('Mis Circuitos'),
            actions: [
              IconButton(
                icon: Icon(Icons.replay_circle_filled),
                onPressed: () => model.refresh(),
              )
            ],
          ),
          drawer: RaceDrawer(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange,
            elevation: 10,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, PersonalRace.route);
            },
          ),
          body: Stack(children: [
            ScopedModelDescendant<RaceViewModel>(
                builder: (context, child, model) => _buildRacesListView())
          ])),
    );
  }

  Widget _buildRacesListView() {
    return ScopedModelDescendant<RaceViewModel>(
      builder: (context, child, model) => FutureBuilder<List<Circuit>>(
        future: model.circuits,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            final circuits = snapshot.data;
            model.setActualPage(MyCircuitList.route);
            return _buildFutureListView(circuits);
          } else {
            return _raceWarning();
          }
        },
      ),
    );
  }

  Widget _raceWarning() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Card(
            color: Colors.grey[300],
            child: ListTile(
              leading: Icon(Icons.warning),
              title: Text(
                'No tienes ningún circuito registrado',
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                  'Empieza a hacer tus propios recorridos para verlos aquí',
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ],
    );
  }

  void _deleteCircuit(BuildContext context, Circuit circuit) {
    showDialog(
      context: context,
      builder: (contextDialog) => AlertDialog(
        title: Text('Eliminar circuito'),
        content:
            Text('¿Seguro que quieres eliminar el circuito ${circuit.name}?'),
        actions: [
          FlatButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ScopedModelDescendant<RaceViewModel>(
            builder: (contextDialog, child, model) => FlatButton(
                onPressed: () async {
                  var deleted = await model.removeRace(circuit);
                  var msg;
                  if (true) {
                    msg = 'Circuito eliminada correctamente';
                  } else {
                    msg = 'El circuito no se ha podido eliminar';
                  }
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(msg),
                    duration: Duration(seconds: 5),
                  ));

                  Navigator.pop(contextDialog, true);
                },
                child: Text('Eliminar')),
          )
        ],
      ),
    );
  }

  Widget _buildFutureListView(List<Circuit> races) {
    return ScopedModelDescendant<RaceViewModel>(
      builder: (context, child, model) => Scaffold(
        body: Stack(children: [
          buildBackgroundTopCircle(context),
          buildBackgroundBottomCircle(context),
          Center(
            child: ReorderableListView(
              children: List.generate(races.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  key: UniqueKey(),
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    secondaryActions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconSlideAction(
                          onTap: () => _deleteCircuit(context, races[index]),
                          color: Colors.red,
                          icon: Icons.delete,
                        ),
                      ),
                    ],
                    child: Card(
                      elevation: 10,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          races[index].name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(races[index].description),
                        onTap: () async {
                          var changed = await Navigator.pushNamed(
                              context, PersonalRace.route,
                              arguments: races[index]);

                          if (changed ??= false) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                );
              }),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                    final Circuit newString = races.removeAt(oldIndex);
                    races.insert(newIndex, newString);
                  }
                });
              },
            ),
          )
        ]),
      ),
    );
  }
}

Positioned buildBackgroundTopCircle(BuildContext context) {
  return Positioned(
    top: 0,
    child: Transform.translate(
      offset: Offset(0.0, -MediaQuery.of(context).size.width / 1.3),
      child: Transform.scale(
        scale: 1.35,
        child: Container(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width,
              )),
        ),
      ),
    ),
  );
}

Positioned buildBackgroundBottomCircle(BuildContext context) {
  return Positioned(
    top: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width,
    right: MediaQuery.of(context).size.width / 2,
    child: Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.orange[200],
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width,
          )),
    ),
  );
}
