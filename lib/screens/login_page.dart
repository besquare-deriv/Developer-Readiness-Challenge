// ignore_for_file: prefer_const_constructors
import 'package:drc/Authorization/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../constants.dart';
import 'reset_password.dart';
import 'signup_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _error;
  bool visible_text = true;

  //TextEditing controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _textString = 'Hello world';

  void onDispose() {
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }

  GlobalKey<FormState> validkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Image.asset("assets/images/BeRad.png", width: 280, height: 280),
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          controller: _emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
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
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        controller: _passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
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
                          MaxLengthValidator(50,
                              errorText:
                                  "Password should not be greater than 50 characters")
                        ]),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ResetScreen(),
                                ));
                          },
                          child: Text(
                            "Forgot Password ?",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        SizedBox(width: 30.0),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    ElevatedButton(
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Error in Sign In"),
                            // duration: const Duration(seconds: 2),
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
                        Text("Or",
                            style: TextStyle(
                              color: Colors.grey,
                            )),
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10, width: 5.0),
          Container(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: Text(
                    "Don't have an account ?   ",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignupScreen(),
                          ));
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
