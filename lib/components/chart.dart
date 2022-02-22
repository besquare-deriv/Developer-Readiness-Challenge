// ignore_for_file: camel_case_types, no_logic_in_create_state, must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

class chartBuilder extends StatefulWidget {
  chartBuilder({required this.priceTime, Key? key}) : super(key: key);
  List<dynamic> priceTime = [];

  @override
  _chartBuilderState createState() => _chartBuilderState(priceTime);
}

class _chartBuilderState extends State<chartBuilder> {
  _chartBuilderState(this.priceTime);
  List<dynamic> priceTime = [];
  @override
  Widget build(BuildContext context) {
    return Text("Hi");
  }
}
