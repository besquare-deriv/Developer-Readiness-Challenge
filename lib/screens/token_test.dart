import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:drc/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  AddNote({this.apiToken, this.email});
  String? apiToken;
  String? email;

  @override
  _AddNoteState createState() =>
      _AddNoteState(apiToken: apiToken, email: email);
}

class _AddNoteState extends State<AddNote> {
  _AddNoteState({this.apiToken, this.email});

  String? title;
  String? apiToken;
  String? email;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Add in token",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      content: Center(
          child: Column(children: [
        Text('Enter the BeRad app API token for "$email".',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
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
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter token",
                  filled: true,
                  fillColor: Color(0xFFF4F4F4),
                ),
              ),
            ],
          ),
        ),
      ])),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            AuthHelper().logOut();

            // FirebaseAuth.instance.signOut();
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => LoginScreen(),
            //   ),
            // );
          },
          child: const Text("Cancel", style: TextStyle(fontSize: 17)),
        ),
        TextButton(
          onPressed: () => add(),
          child: const Text("Verify", style: TextStyle(fontSize: 17)),
        ),
      ],
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
          title: new Text('Token Added Successfully'),
          actions: <Widget>[
            TextButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
