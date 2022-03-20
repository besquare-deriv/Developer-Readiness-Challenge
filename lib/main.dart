import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:drc/Authorization/verif_email.dart';
import 'package:drc/screens/landing_page.dart';
import 'package:drc/screens/main_nav_screen.dart';
import 'package:drc/screens/token_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: MainScreen(),
          );
        },
      );
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? value;

  String? title;
  String? email;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
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
                    email = user['email'];

                    if (user['role'] == 'user') {
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('notes')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.isEmpty) {
                                return VerifyEmailPage(
                                    apiToken: value, email: email);
                                // return AddNote(apiToken: value, email: email);
                              } else {
                                final docs = snapshot.data!.docs;
                                final v = docs[0].data() as Map;

                                value = v['token'];
                                return NavigationPage(value!);
                              }
                            }
                            return SizedBox.shrink();
                          });
                    } else {
                      return LinearProgressIndicator();
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
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const LandingScreen(title: 'BeRAD'),
            );
            // return LoginPage();
            // return LandingScreen(title: 'MilkyWay');
          }),
    );
  }
}
