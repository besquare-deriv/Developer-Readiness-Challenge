import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String? title;
  String? des;
  // appBar: new AppBar(
  //   leading: GestureDetector(
  //     onTap: () {
  //       AuthHelper().logOut();
  //     },
  //     child: Icon(
  //       Icons.menu, // add custom icons also
  //     ),
  //   ),
  //   centerTitle: true,
  //   title: Text("Token"),
  //   backgroundColor: Colors.lightBlue,
  // ),
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          leading: GestureDetector(
            onTap: () {
              AuthHelper().logOut();
            },
            child: Icon(
              Icons.menu, // add custom icons also
            ),
          ),
          centerTitle: true,
          title: Text("Token"),
          backgroundColor: Colors.lightBlue,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 24.0,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blue[700],
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 1,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                    //
                    ElevatedButton(
                      onPressed: add,
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "lato",
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.green,
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Token",
                        ),
                        style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: "lato",
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        onChanged: (_val) {
                          title = _val;
                        },
                      ),
                      //
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
              child: new Text("OK"),
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
}
