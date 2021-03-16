import 'package:app_races/src/app/RacesApp.dart';
import 'package:app_races/src/models/Preferences.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = Preferences();
  await preferences.initPreferences();

  runApp(MyApp());
}
