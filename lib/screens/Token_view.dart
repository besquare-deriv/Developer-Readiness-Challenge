import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';

class System_user extends StatefulWidget {
  @override
  _System_user createState() => _System_user();
}

class _System_user extends State<System_user> {
  @override
  String? value;
  Widget build(BuildContext context) {
    return Scaffold(
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

      //
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('notes')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final docs = snapshot.data!.docs;
            final v = docs[0].data() as Map;
            value = v['token'];
            print(value);
            return Container();
          } else {
            return Center(
              child: Text("Loading..."),
            );
          }
        },
      ),
    );
  }
}
