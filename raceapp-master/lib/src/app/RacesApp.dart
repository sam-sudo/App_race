import 'package:app_races/src/models/Preferences.dart';
import 'package:app_races/src/models/RacesViewModel.dart';
import 'package:app_races/src/pages/DetailsRaces.dart';
import 'package:app_races/src/pages/MyCircuitsList.dart';
import 'package:app_races/src/pages/MyRaceList.dart';
import 'package:app_races/src/pages/PersonalRace.dart';
import 'package:app_races/src/pages/RaceCalendar.dart';
import 'package:app_races/src/pages/RaceList.dart';
import 'package:app_races/src/pages/RaceLogin.dart';
import 'package:app_races/src/pages/RaceRegister.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MyApp extends StatelessWidget {
  RaceViewModel raceViewModel = RaceViewModel();
  Preferences _preferences = new Preferences();
  var initialRoute = RaceLogin.route;
  RaceApp() {
    raceViewModel = RaceViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: raceViewModel,
      child: ScopedModelDescendant<RaceViewModel>(
        builder: (context, child, model) {
          print(_preferences.isTokenValid());
          if (_preferences.isTokenValid()) {
            initialRoute = model.getActualPage() == null
                ? initialRoute
                : model.getActualPage();
          }
          return MaterialApp(
              key: UniqueKey(),
              title: 'titulo',
              debugShowCheckedModeBanner: false,
              routes: {
                RaceList.route: (context) => RaceList(),
                MyRaceList.route: (context) => MyRaceList(),
                MyCircuitList.route: (context) => MyCircuitList(),
                RaceLogin.route: (context) => RaceLogin(),
                RaceRegister.route: (context) => RaceRegister(),
                RaceCalendar.route: (context) => RaceCalendar(),
                DetailsRaces.route: (context) => DetailsRaces(),
                PersonalRace.route: (context) => PersonalRace(),
              },
              initialRoute: initialRoute);
        },
      ),
    );
  }
}
