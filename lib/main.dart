import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:drc/screens/Token_test.dart';
import 'package:drc/screens/Token_view.dart';
import 'package:drc/screens/home_page.dart';
import 'package:drc/screens/landing_page.dart';
import 'package:drc/screens/login_page.dart';
import 'package:drc/screens/market_list_page.dart';
import 'package:drc/screens/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:drc/screens/history_page.dart';
import 'package:drc/screens/landing_page.dart';
import 'package:drc/screens/main_nav_screen.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance
            .authStateChanges(), // if user logged in or not chang the set
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            UserHelper.saveUser(snapshot.data);
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(snapshot.data!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData && snapshot.data!.data() != null) {
                  CircularProgressIndicator();

                  final userDoc = snapshot.data;
                  final user = userDoc!.data() as Map;

                  if (user['role'] == 'user') {
                    return HomePage();
                  } else {
                    return HomePage();
                  }
                } else {
                  return Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          }
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const LandingScreen(title: 'Flutter Demo Home Page'),
          );
          // return LoginPage();
          // return LandingScreen(title: 'MilkyWay');
        });
  }
}
