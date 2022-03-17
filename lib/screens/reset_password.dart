// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../constants.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  TextEditingController email_controller = TextEditingController();

  GlobalKey<FormState> validkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: Color(0xFF1F96B0)),
        child: ListView(
          children: [
            CustomPaint(
              painter: ShapePainter2(),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: <Widget>[
                  const SizedBox(height: 60),
                  Image.asset("assets/images/BeRad.png",
                      width: 280, height: 190),
                ],
              ),
            ),
            Text(
              'Account Recovery',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold, // light
                fontSize: 38,
              ),
            ),
            Text(
              'Recover your BeRAD account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: validkey,
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 10.0,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Email Address:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // light

                          fontSize: 18,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5, top: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        width: 300.0,
                        child: TextFormField(
                            controller: email_controller,
                            decoration: InputDecoration(
                              filled: true,
                              //fillColor: Colors.amber,
                              border: OutlineInputBorder(),
                              hintText: 'Email Address',
                            ),
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Required"),
                              EmailValidator(
                                  errorText:
                                      "Please enter a valid email address"),
                            ])),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      ElevatedButton(
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          try {
                            resetPassword(context);
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text(e.toString()),
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
                          }
                          ;
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF305FAD),
                            fixedSize: const Size(270, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Or',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        child: const Text(
                          'Back to login',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          try {
                            Navigator.of(context).pop();
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text(e.toString()),
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
                          }
                          SizedBox(
                            height: 5,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF305FAD),
                            fixedSize: const Size(270, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 1.0,
                              width: 270.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                        child: Text(
                          "If you don’t see the email within 12 hours, check your spam or junk folder before submitting a new request.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 17, color: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword(BuildContext context) async {
    try {
      if (email_controller.text.length == 0 ||
          !email_controller.text.contains("@")) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Please enter a valid email address"),
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
        return;
      }

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email_controller.text);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "A new password reset link has been sent to your registered email address.",
              style: const TextStyle(
                fontSize: 22.0,
                color: Colors.black,
              ),
            ),
            content: Container(
              child: Text(
                "Please log in again",
                style: const TextStyle(
                  fontSize: 19.0,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            actions: <Widget>[
              Divider(color: Colors.black),
              Center(
                child: TextButton(
                  child: Text("Ok", style: TextStyle(fontSize: 25)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(e.toString()),
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
    }
  }
}

bool chkpass(String currentValue, String checkValue) {
  if (currentValue == checkValue) {
    return true;
  } else {
    return false;
  }
}
