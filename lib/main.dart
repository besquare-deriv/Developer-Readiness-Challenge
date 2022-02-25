import 'package:drc/screens/contract_details.dart';
import 'package:drc/screens/history_page.dart';
import 'package:drc/screens/landing_page.dart';
import 'package:drc/screens/login_page.dart';
import 'package:drc/screens/profile_page.dart';
import 'package:drc/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

