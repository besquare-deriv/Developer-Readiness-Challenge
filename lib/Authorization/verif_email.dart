import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:drc/screens/landing_page.dart';
import 'package:drc/screens/login_page.dart';
import 'package:drc/screens/signup_page.dart';
import 'package:drc/screens/token_test.dart';
import 'package:drc/screens/token_view.dart';
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
        Duration(seconds: 30),
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
      await Future.delayed(Duration(seconds: 30));
      setState(() => canResendEmail = true);
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) => isEmailVerified
      ? AddNote(apiToken: apiToken, email: email1)
      : Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            title: Text("Verify Email"),
            backgroundColor: Colors.lightBlue,
          ),
          body: Center(
            child: Column(
              children: [
                ElevatedButton(
                    child: const Text(
                      'Resend',
                      style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    onPressed: canResendEmail ? sendverificationEmail : null),
                ElevatedButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    AuthHelper().logOut();
                  },
                )
              ],
            ),
          ),
        );
}
