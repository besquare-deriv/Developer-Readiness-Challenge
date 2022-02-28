import 'package:flutter/material.dart';

class activeOptions extends StatefulWidget {
  const activeOptions({Key? key}) : super(key: key);

  @override
  _activeOptionsState createState() => _activeOptionsState();
}

class _activeOptionsState extends State<activeOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Welcome to Open Positions page"),
    );
  }
}
