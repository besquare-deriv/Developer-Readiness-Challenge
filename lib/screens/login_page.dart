// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:drc/screens/Signup_page.dart';
import 'package:drc/screens/landing_page.dart';
import 'package:drc/screens/main_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../constants.dart';
import 'graph_page.dart';
import 'history_page.dart';
import 'market_list_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _error;
  bool visible_text = true;

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
                _error,
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
                    const SizedBox(height: 100),
                    Image.asset("assets/images/BeRad.png",
                        width: 280, height: 280),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: validkey,
                  child: Card(
                    color: Colors.white,
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
                              controller: _emailController,
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
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          width: 300.0,
                          child: TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                filled: true,
                                //fillColor: Colors.amber,
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
                        Text(
                          "Forgot Password ?",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        ElevatedButton(
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          onPressed: () async {
                            if (validkey.currentState!.validate()) {
                              // validation purpose
                              try {
                                await AuthHelper.signInWithEmail(
                                    // the variable being assign to auth helper variable
                                    email: _emailController.text,
                                    password: _passwordController.text);
                              } catch (e) {
                                setState(() {
                                  // _showDialog(errorMessage);
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
                              //////////////////dDOWN VALIDATION
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("ERROR IN SIGN IN"),
                                // duration: const Duration(seconds: 2),
                              ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent,
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
                                width: 80.0,
                                color: Colors.black,
                              ),
                            ),
                            Text("Or Log In with"),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                height: 1.0,
                                width: 80.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset("assets/icons/google.png",
                                    width: 70, height: 70),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'New user ?',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  SizedBox(width: 5.0),
                  InkWell(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignupScreen(),
                          ));
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
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


/*{
  "proposal": 1,
  "amount": 100,
  "basis": "payout",
  "contract_type": "CALL",
  "currency": "USD",
  "duration": 60,
  "duration_unit": "m",
  "symbol": "R_100"
}*/