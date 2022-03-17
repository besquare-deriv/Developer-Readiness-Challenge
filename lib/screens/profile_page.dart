import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/screens/faq_page.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:web_socket_channel/io.dart';
import '../components/profile_widget.dart';
import '../constants.dart';
import '../utils/user_information.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  final String apiToken;
  const ProfilePage(this.apiToken, {Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState(apiToken);
}

class _ProfilePageState extends State<ProfilePage> {
  String? value;
  String field_Name = 'ABCDEFGHIJKL';
  String apiToken;
  _ProfilePageState(this.apiToken, {Key? key});
  String username = "User";
  String email = "User@gmail.com";
  num balance = 0.0;
  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));
  void sendAuth() {
    channel.sink.add('{"authorize": "$apiToken"}');
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
    const user = UserInformation.myUser;
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

            var hiddenToken = apiToken.replaceRange(0, 11, 'XXXXXXXXXXX');

            return Scaffold(
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
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).appBarTheme.backgroundColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ProfileWidget(
                              imagePath: user.imagePath,
                              onClicked: () async {},
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildName(user),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: buildBalanceAcc(user),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'API Token:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              child: const Text(
                                'Save',
                                style: TextStyle(color: Color(0xFFF3F72AF)),
                              ),
                              //style: TextButton.styleFrom(),
                              onPressed: () {
                                String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                RegExp regExp = new RegExp(pattern);
                                print(field_Name.length);
                                (validator(field_Name.toString()))
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext ctxt) {
                                          return AlertDialog(
                                            title: Text(
                                                "Are you sure you want to change API Token ?"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.of(ctxt).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text("Confirm"),
                                                onPressed: () {
                                                  saveAPI();
                                                  Navigator.of(ctxt).pop();

                                                  // Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext ctxt) {
                                          return AlertDialog(
                                            title: Text(
                                                "API Token must be alphanumeric within 12 to 20 characters and cannot be empty.",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                )),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(ctxt).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                              },
                            ),
                          ],
                        ),
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
                            initialValue: "$hiddenToken",
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
                              primary: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              onPrimary: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                              minimumSize: const Size(200.0, 50.0)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SettingsPage(value: apiToken),
                              ),
                            );
                          }),
                      const SizedBox(height: 25),
                      ElevatedButton(
                          child: Text(
                            'FAQs',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
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
            Text(
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

  void saveAPI() async {
    if (validkey.currentState!.validate()) {
      await ref!.update(
        {
          'token': field_Name,
          'created': DateTime.now(),
          'user_id': FirebaseAuth.instance.currentUser!.uid,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error occurred"),
        ),
      );
    }
  }

  bool validator(String value) {
    if (value.length > 20) {
      return false;
    } else if (value.isNotEmpty && value.length > 11) {
      bool mobileValid = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
      return mobileValid;
    }

    return false;
  }
}
