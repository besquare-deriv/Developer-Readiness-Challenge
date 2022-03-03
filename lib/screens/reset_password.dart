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
    return Scaffold(
      body: SafeArea(
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
                    const SizedBox(height: 120),
                    Image.asset(
                        "assets/images/robot_forex_terbaik_di_quickpro_apps.png",
                        width: 280,
                        height: 180),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: validkey,
                  child: Card(
                    color: Colors.white,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    elevation: 10.0,
                    child: Column(
                      children: [
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
                                hintText: 'EMAIL',
                              ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "REQUIRED"),
                                EmailValidator(
                                    errorText: "ENTER AN VALID EMAIL ID"),
                              ])),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        ElevatedButton(
                          child: const Text(
                            'SUBMIT',
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
                            ;
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 0, 94, 255),
                              fixedSize: const Size(270, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Back to login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
              title: new Text('Enter a valid email address'),
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
        return;
      }

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email_controller.text);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                new Text('A password reset link has been sent to your email'),
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
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(e.toString()),
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
}

bool chkpass(String currentValue, String checkValue) {
  if (currentValue == checkValue) {
    return true;
  } else {
    return false;
  }
}
