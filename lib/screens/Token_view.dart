import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class System_user extends StatefulWidget {
  @override
  _System_user createState() => _System_user();
}

class _System_user extends State<System_user> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            return ListView.builder(
              shrinkWrap: true,
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
                final user = docs[index].data() as Map;
                Text(user['token'].toString());
                // DateTime mydateTime = user['last_login'].toDate();
                // String formattedTime =
                //     DateFormat.yMMMd().add_jm().format(mydateTime);
                return InkWell(
                  child: Card(
                    margin: EdgeInsets.only(
                        left: 20, top: 20, right: 20, bottom: 0),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user['token']}",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "lato",
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          // Container(
                          //   alignment: Alignment.centerRight,
                          //   child: Text(
                          //     formattedTime,
                          //     style: TextStyle(
                          //       fontSize: 20.0,
                          //       fontFamily: "lato",
                          //       color: Colors.black87,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
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
