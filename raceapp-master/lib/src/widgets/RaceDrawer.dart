import 'package:app_races/src/models/RacesViewModel.dart';
import 'package:app_races/src/pages/DetailsRaces.dart';
import 'package:app_races/src/pages/MyCircuitsList.dart';
import 'package:app_races/src/pages/MyRaceList.dart';
import 'package:app_races/src/pages/RaceCalendar.dart';
import 'package:app_races/src/pages/RaceList.dart';
import 'package:app_races/src/pages/RaceLogin.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

class RaceDrawer extends StatelessWidget {
  void Function() onPop;
  RaceDrawer({this.onPop});
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RaceViewModel>(
      builder: (context, child, model) => Drawer(
        child: ListView(
          children: [
            _buildHeader(model),
            ListTile(
              leading: Icon(Icons.home, color: Colors.green[700]),
              title: Text('Inicio', style: TextStyle(color: Colors.green[700])),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context).settings.name ==
                        RaceCalendar.route ||
                    ModalRoute.of(context).settings.name == MyRaceList.route ||
                    ModalRoute.of(context).settings.name ==
                        DetailsRaces.route ||
                    ModalRoute.of(context).settings.name ==
                        MyCircuitList.route) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RaceList.route, (route) => false);
                }
              },
            ),
            Divider(),
            ListTile(
                leading: Icon(Icons.flag, color: Colors.green[700]),
                title: Text('Mis carreras',
                    style: TextStyle(color: Colors.green[700])),
                onTap: () async {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MyRaceList.route, (route) => false);
                }),
            Divider(),
            ListTile(
                leading: Icon(Icons.directions_run, color: Colors.green[700]),
                title: Text('Mis circuitos',
                    style: TextStyle(color: Colors.green[700])),
                onTap: () async {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MyCircuitList.route, (route) => false);
                }),
            Divider(),
            ListTile(
                leading:
                    Icon(Icons.perm_contact_calendar, color: Colors.green[700]),
                title: Text('Calendario',
                    style: TextStyle(color: Colors.green[700])),
                onTap: () async {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RaceCalendar.route, (route) => false);
                }),
            Divider(),
            ListTile(
                leading: Icon(Icons.logout, color: Colors.green[700]),
                title: Text('Cerrar sesión',
                    style: TextStyle(color: Colors.green[700])),
                onTap: () async {
                  Navigator.pop(context);
                  model.logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, RaceLogin.route, (route) => false);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(RaceViewModel model) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: Colors.green),
      accountEmail: Text(model.user.email.toString()),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('assets/img/logo.png'),
      ),
    );
  }
}
