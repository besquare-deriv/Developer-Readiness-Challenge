// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/Authorization/auth_helper.dart';

import 'package:drc/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../constants.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenScreenState createState() => _SignupScreenScreenState();
}

class _SignupScreenScreenState extends State<SignupScreen> {
  String? _error;
  String? title;
  bool visible_text = true;
  TextEditingController? email_Input;
  TextEditingController? password_Input;
  TextEditingController? _confirmPasswordController;

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.red,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _error!,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  @override
  void initState() {
    super.initState();
    email_Input = TextEditingController(text: "");
    password_Input = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
  }

  //TextEditing controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void onDispose() {
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }

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
                              controller: email_Input,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(),
                                hintText: 'Email Address',
                              ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "REQUIRED"),
                                EmailValidator(
                                    errorText: "ENTER AN VALID EMAIL ID"),
                              ])),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          width: 300.0,
                          child: TextFormField(
                              controller: password_Input,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(),
                                hintText: 'Password',
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      visible_text = !visible_text;
                                    });
                                  },
                                  child: Icon(
                                    visible_text
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black87,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                              obscureText: visible_text,
                              validator: MultiValidator([
                                RequiredValidator(errorText: "REQUIRED"),
                              ])),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5, top: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          width: 300.0,
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(),
                              hintText: 'Confirm Password',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    visible_text = !visible_text;
                                  });
                                },
                                child: Icon(
                                  visible_text
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black87,
                                  size: 24.0,
                                ),
                              ),
                            ),
                            obscureText: visible_text,
                            validator: (confirmation) {
                              return confirmation!.isEmpty
                                  ? 'Confirm password cant be empty'
                                  : chkpass(confirmation, password_Input!.text)
                                      ? null
                                      : 'Confirm password and password does not match';
                            },
                          ),
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
                          onPressed: () async {
                            if (validkey.currentState!.validate()) {
                              try {
                                await AuthHelper.signupWithEmail(
                                    email: email_Input!.text,
                                    password: password_Input!.text);

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "Account have been created succesfully"),
                                  duration: const Duration(seconds: 2),
                                ));

                                Navigator.of(context).pop();

                                return;
                              } catch (e) {
                                setState(() {
                                  print(e);

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
                                });
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Error occurred"),
                              ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFFF305FAD),
                              fixedSize: const Size(270, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                height: 1.0,
                                width: 110.0,
                                color: Color(0xFFF909090),
                              ),
                            ),
                            Text(
                              "Or",
                              style: TextStyle(
                                color: Color(0xFFF909090),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                height: 1.0,
                                width: 110.0,
                                color: Color(0xFFF909090),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SignInButton(
                              Buttons.Google,
                              text: "Sign Up with Google",
                              onPressed: () async {
                                try {
                                  await AuthHelper.signInWithGoogle();
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
                              },
                              // child: ClipRRect(
                              //   borderRadius: BorderRadius.circular(20.0),
                              //   // child: Image.asset("assets/icons/google.png",
                              //   //     width: 70, height: 70),
                              // ),
                            ),
                            InkWell(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(width: 5.0),
                  InkWell(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(),
                          ));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Color(0xFFF305FAD),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool chkpass(String currentValue, String checkValue) {
  if (currentValue == checkValue) {
    return true;
  } else {
    return false;
  }
}