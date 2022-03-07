import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/screens/faq_page.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:web_socket_channel/io.dart';
import '../components/button_widget.dart';
import '../components/profile_widget.dart';
import '../constants.dart';
import '../utils/user_information.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  final String value1;

  const ProfilePage(this.value1, {Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState(value1);
}

class _ProfilePageState extends State<ProfilePage> {
  String? value;
  String? field_Name;
  String value1;
  _ProfilePageState(this.value1, {Key? key});
  String username = "User";
  String email = "User@gmail.com";

  num balance = 0.0;

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void sendAuth() {
    channel.sink.add('{"authorize": "$value1"}');
  }

  void getStatement() {
    String walletInfo =
        '{"statement": 1,"description": 1,"limit": 999,"offset": 25}';
    channel.sink.add(walletInfo);
  }

  @override
  void initState() {
    sendAuth();
    getProfileInfo();
    super.initState();
  }

  DocumentReference? ref;
  GlobalKey<FormState> validkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String token;

    const user = UserInformation.myUser;
    print(value1);

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('notes')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final docs = snapshot.data!.docs;
            final v = docs[0].data() as Map;
            field_Name = v['token'];
            ref = snapshot.data!.docs[0].reference;

            return Scaffold(
              backgroundColor: Colors.white,

              //appBar: buildAppBar(context),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: validkey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(color: Color(0xFF1F96B0)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 24,
                            ),
                            ProfileWidget(
                              imagePath: user.imagePath,
                              onClicked: () async {},
                            ),
                            const SizedBox(width: 50),
                            Column(
                              children: [
                                const SizedBox(height: 80),
                                Center(child: buildName(user)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // SizesWidget(),
                      const SizedBox(height: 30),
                      Center(
                        child: buildBalanceAcc(user),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          const SizedBox(width: 50),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'API Token:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(),
                          const SizedBox(width: 120),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: TextButton(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Save',
                                    style: TextStyle(color: Color(0xFFF3F72AF)),
                                  ),
                                ],
                              ),
                              //style: TextButton.styleFrom(),
                              onPressed: save,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.black,
                        ),
                        child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: "lato",
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            initialValue: "${v['token']}",
                            onChanged: (_val) {
                              field_Name = _val;
                            },
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Workfield Column is Required"),
                            ])),
                      ),

                      const SizedBox(height: 25),
                      ElevatedButton(
                          child: Text(
                            'Settings',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFFC4C4C4),
                              onPrimary: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                              minimumSize: const Size(200.0, 50.0)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingPage()));
                          }),

                      const SizedBox(height: 25),
                      ElevatedButton(
                          child: Text(
                            'FAQs',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFFC4C4C4),
                              onPrimary: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                              minimumSize: const Size(200.0, 50.0)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyFAQsPage(),
                              ),
                            );
                          }),

                      const SizedBox(height: 25),
                      ElevatedButton(
                          child: Text(
                            'Log out',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFF305FAD),
                              onPrimary: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                              minimumSize: const Size(200.0, 50.0)),
                          onPressed: () {
                            AuthHelper().logOut();
                          }),
                    ],
                  ),
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }

  Widget buildName(Users users) => Column(
        children: <Widget>[
          Text(
            "Hi, $username",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            "$email",
            style: const TextStyle(color: Colors.white),
          )
        ],
      );

  Widget buildBalanceAcc(Users users) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Account Balance:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Text(
                "$balance USD",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );

  void save() async {
    if (validkey.currentState!.validate()) {
      await ref!.update(
        {
          'token': field_Name,
          'created': DateTime.now(),
          'user_id': FirebaseAuth.instance.currentUser!.uid,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error occurred"),
      ));
    }
  }

  void getProfileInfo() {
    channel.stream.listen((data) {
      var response = jsonDecode(data);

      if (response['msg_type'] == 'authorize') {
        getStatement();
        setState(() {
          balance = response['authorize']['balance'];

          username = response['authorize']['email']
              .substring(0, response['authorize']['email'].indexOf('@'));

          email = response['authorize']['email'];
        });
      }
    });
  }
}
