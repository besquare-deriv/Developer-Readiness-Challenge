import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:drc/constants.dart';
import 'package:drc/screens/landing_page.dart';
import 'package:drc/screens/login_page.dart';
import 'package:drc/screens/signup_page.dart';
import 'package:drc/screens/token_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  VerifyEmailPage({this.apiToken, this.email});
  String? apiToken;
  String? email;

  @override
  _VerifyEmailPageState createState() =>
      _VerifyEmailPageState(apiToken: apiToken, email1: email);
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  _VerifyEmailPageState({this.apiToken, this.email1});

  bool isEmailVerified = false;
  bool canResendEmail = false;
  String? apiToken;
  String? email1;

  Timer? timer;
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendverificationEmail();
      Timer.periodic(
        Duration(seconds: 20),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendverificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 20));
      setState(() => canResendEmail = true);
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) => isEmailVerified
      ? AddNote(apiToken: apiToken, email: email1)
      : Scaffold(
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(color: Color(0xFF1F96B0)),
              child: ListView(
                children: [
                  SizedBox(height: 40),
                  CustomPaint(
                    painter: ShapePainter2(),
                    child: Container(
                      width: 100,
                      height: 200,
                      child: Image.asset(
                        "assets/images/mail-removebg-preview.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Center(
                      child: Text('Email Confimation',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Card(
                        elevation: 20,
                        child: Container(
                          height: 300,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "We have sent an email to:",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    (email1 != null)
                                        ? "$email1"
                                        : "No email provided",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Wrap(
                                    children: [
                                      Text(
                                        "Check your email and click on the confirmation link to continue.",
                                        style: TextStyle(fontSize: 24),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(0xFF305FAD),
                                            fixedSize: Size.fromHeight(50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Resend Link',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20),
                                          ),
                                          onPressed: canResendEmail
                                              ? sendverificationEmail
                                              : null),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.grey,
                                          fixedSize: Size.fromHeight(50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        ),
                                        onPressed: () {
                                          AuthHelper().logOut();
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        );
}
