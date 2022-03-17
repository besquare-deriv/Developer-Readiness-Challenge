// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:drc/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

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
  double _strength = 0;

  @override
  void initState() {
    super.initState();
    email_Input = TextEditingController(text: "");
    password_Input = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
  }

  String _displayText = 'Please enter a password';
  RegExp capital = RegExp(r"[A-Z]");
  RegExp Lowercase = RegExp(r"[a-z]");
  RegExp spcharacter = RegExp(r"[!@#\$&*~]");

  // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{10,}$',

  void _checkPassword(String value) {
    if (password_Input!.text.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = 'Please enter you password';
      });
    } else if (!capital.hasMatch(password_Input!.text)) {
      setState(() {
        _strength = 1 / 5;
        _displayText = 'Your password should consist capital letter';
      });
    } else if (!Lowercase.hasMatch(password_Input!.text)) {
      setState(() {
        _strength = 2 / 5;
        _displayText = 'Your password should consist lowercase letter';
      });
    } else if (!spcharacter.hasMatch(password_Input!.text)) {
      setState(() {
        _strength = 3 / 5;
        _displayText = 'Your password should consist special character';
      });
    } else if (password_Input!.text.length < 10) {
      setState(() {
        _strength = 4 / 5;
        _displayText = 'Your password should atleast be 10 character';
      });
    } else if (password_Input!.text.length < 10 ||
        password_Input!.text.length < 50) {
      setState(() {
        _strength = 1;
        _displayText = 'Your password is great';
      });
    }
  }

  GlobalKey<FormState> validkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                            controller: email_Input,
                            decoration: InputDecoration(
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
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        width: 300.0,
                        child: TextFormField(
                            onChanged: (value) => _checkPassword(value),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
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
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black87,
                                  size: 24.0,
                                ),
                              ),
                            ),
                            obscureText: visible_text,
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Required"),

                              PatternValidator(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#\$&*~]).{10,}$',
                                  errorText: "Required:"),

                              MaxLengthValidator(50,
                                  errorText:
                                      "Password should not be greater than 50 characters")
                            ])),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: LinearProgressIndicator(
                          value: _strength,
                          backgroundColor: Colors.grey[300],
                          color: _strength <= 1 / 5
                              ? Colors.red
                              : _strength == 2 / 5
                                  ? Colors.yellow
                                  : _strength == 3 / 5
                                      ? Colors.blue
                                      : _strength == 4 / 5
                                          ? Color.fromARGB(255, 76, 147, 175)
                                          : _strength == 1
                                              ? Colors.green
                                              : Colors.green,
                          minHeight: 5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                        child: Text(
                          _displayText,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5, top: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        width: 300.0,
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
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
                                    ? Icons.visibility_off
                                    : Icons.visibility,
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
                          RegExp regex = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#\$&*~]).{10,}$');
                          if (!regex.hasMatch(password_Input!.text)) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text(
                                      "Please fill in the email and password field."),
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
                          } else if (validkey.currentState!.validate()) {
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
                                          child: new Text("Ok"),
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Error occurred"),
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF305FAD),
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
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "Or",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 1.0,
                              width: 80.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SignInButton(
                            Buttons.Google,
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
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Already have an account ?',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5.0),
                  InkWell(
                    onTap: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(),
                          ));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
