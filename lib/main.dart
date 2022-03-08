import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:drc/screens/landing_page.dart';
import 'package:drc/screens/main_nav_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/token_test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? value;
  String? title;

  tokenAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Add in token', textAlign: TextAlign.center, style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold)),
        content: 
        Center(
          child: Column(
            children: [
              Text('Enter the BeRad app API token for "johndoe@gmail.com".', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Card(
                color: Colors.transparent,
                elevation: 0.0,
                child: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (_val) {
                        title = _val;
                      },
                      decoration: 
                      InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter token',
                        filled: true,
                        fillColor: Color(0xFFF4F4F4),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          )
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel', style: TextStyle(fontSize: 17)),
          ),
          TextButton(
            onPressed: () => add(),
            child: const Text('Verify', style: TextStyle(fontSize: 17)),
          ),
        ],
      ),
    );
  }

  void add() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes')
        .add({
      'token': title,
      'created': DateTime.now(),
    });
    // save to db
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Data Added Successfully'),
          actions: <Widget>[
            TextButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    AuthHelper().logOut();
  }

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
                                  if (snapshot.data!.docs.length == 0) {
                                    return AddNote();
                                  } else {
                                    final docs = snapshot.data!.docs;
                                    final v = docs[0].data() as Map;

                                    value = v['token'];
                                    return NavigationPage(value!);
                                  }
                                }
                                return SizedBox.shrink();
                              }
                      );
                    } else {
                      return AddNote();
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
              home: const LandingScreen(title: 'BeRAD'),
            );
            // return LoginPage();
            // return LandingScreen(title: 'MilkyWay');
          }),
    );
  }
}
