// ignore_for_file: avoid_unnecessary_containers, camel_case_types, prefer_const_constructors
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Welcome to Explorer Page"),
      ),
    );
  }
}
