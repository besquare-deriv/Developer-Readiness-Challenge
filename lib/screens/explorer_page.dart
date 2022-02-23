// ignore_for_file: avoid_unnecessary_containers, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';

class explorePage extends StatefulWidget {
  const explorePage({Key? key}) : super(key: key);

  @override
  _explorePageState createState() => _explorePageState();
}

class _explorePageState extends State<explorePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Welcome to Explorer Page"),
      ),
    );
  }
}
