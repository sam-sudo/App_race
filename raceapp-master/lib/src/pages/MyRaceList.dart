import 'package:app_races/src/models/Race.dart';
import 'package:app_races/src/models/RacesViewModel.dart';
import 'package:app_races/src/pages/DetailsRaces.dart';
import 'package:app_races/src/pages/RaceCalendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:app_races/src/widgets/RaceDrawer.dart';

class MyRaceList extends StatefulWidget {
  static final route = '/MyraceList';

  @override
  _MyRaceListState createState() => _MyRaceListState();
}

class _MyRaceListState extends State<MyRaceList> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RaceViewModel>(
      builder: (context, child, model) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text('Mis carreras'),
            actions: [
              IconButton(
                icon: Icon(Icons.replay_circle_filled),
                onPressed: () => model.refresh(),
              )
            ],
          ),
          drawer: RaceDrawer(),
          body: Stack(children: [
            ScopedModelDescendant<RaceViewModel>(
                builder: (context, child, model) =>
                    _buildRacesListView(context))
          ])),
    );
  }

  Widget _buildRacesListView(BuildContext context) {
    return ScopedModelDescendant<RaceViewModel>(
        builder: (context, child, model) => FutureBuilder<List<Race>>(
              future: model.myraces,
              builder: (context, snapshot) {
                var childWidgwet;

                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    childWidgwet = Center(child: CircularProgressIndicator());
                    break;

                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      print(snapshot.data.toString() + 'ee');
                      final races = snapshot.data;
                      model.setActualPage(MyRaceList.route);
                      childWidgwet = _buildFutureListView(races);
                    } else {
                      childWidgwet = _raceWarning();
                    }
                }
                return RefreshIndicator(
                    onRefresh: model.refresh, child: childWidgwet);
              },
            ));
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
                'No estas apuntado a ninguna carrera',
                textAlign: TextAlign.center,
              ),
              subtitle: Text('Apuntate a una carrera para verlas aquí',
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFutureListView(List<Race> races) {
    return ScopedModelDescendant<RaceViewModel>(
      builder: (context, child, model) => Scaffold(
        body: Stack(children: [
          buildBackgroundTopCircle(),
          buildBackgroundBottomCircle(),
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
                          color: Colors.blue[200],
                          caption: races[index].runners.length.toString(),
                          icon: Icons.person_add_alt_1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconSlideAction(
                          color: Colors.blue,
                          caption: races[index].dateRace.toString(),
                          icon: Icons.calendar_today,
                          onTap: () async {
                            await Navigator.pushNamed(
                                context, RaceCalendar.route,
                                arguments: races[index]);
                          },
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
                              context, DetailsRaces.route,
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
                    final Race newString = races.removeAt(oldIndex);
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

  Positioned buildBackgroundTopCircle() {
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
                color: Colors.blue,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width,
                )),
          ),
        ),
      ),
    );
  }

  Positioned buildBackgroundBottomCircle() {
    return Positioned(
      top: MediaQuery.of(context).size.height -
          MediaQuery.of(context).size.width,
      right: MediaQuery.of(context).size.width / 2,
      child: Container(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width,
            )),
      ),
    );
  }
}
