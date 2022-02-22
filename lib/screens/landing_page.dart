import 'package:flutter/material.dart';
import '../constants.dart';
import './login_page.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen ({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Container(
          decoration: new BoxDecoration(color: Color(0xFF1F96B0)),
          child: ListView(
            children: [
              CustomPaint(
                painter: ShapePainter1(),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      top: -50.0,
                      child: Image.asset("assets/icons/background.png", width: 420, height: 360),
                    ),
                    const SizedBox(height: 300),
                    Image.asset("assets/images/BeRad.png", width: 280, height: 280),
                    Positioned(
                      top: 240.0,
                      left: 150.0,
                      child: Container(
                        child: Column (
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                text: 'Be',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
                                children: <TextSpan>[
                                  TextSpan(text: 'Ready', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 25))
                                ],
                              ),
                            ),

                            RichText(
                              text: const TextSpan(
                                text: 'Be',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
                                children: <TextSpan>[
                                  TextSpan(text: 'Assertive', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 25))
                                ],
                              ),
                            ),

                            RichText(
                              text: const TextSpan(
                                text: 'Be',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
                                children: <TextSpan>[
                                  TextSpan(text: 'Diverse', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 25))
                                ],
                              ),
                            ),
                          ]
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),

              const Text('Join us in this radical journey to \ntrack your trading portfolio',
                textAlign: TextAlign.center,
                style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 20),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                child: const Text('Login',
                  style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
                ),
                onPressed: () { 
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
                  ScaffoldMessenger.of(context).showSnackBar((const SnackBar(content: Text('Successful sign in. '))));                     
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  fixedSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                child: const Text('Sign Up',
                  style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
                ),
                onPressed: () { 
                  ScaffoldMessenger.of(context).showSnackBar((const SnackBar(content: Text('Please enter your details. '))));                     
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  fixedSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
            ]
          )
        ),
      ),
    );
  }
}