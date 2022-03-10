// ignore_for_file: avoid_unnecessary_containers, camel_case_types, prefer_const_constructors
import 'package:drc/components/news.dart';
import 'package:drc/components/top_gainers.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  var gainerList = [
    {"name": "ANGH", "price": 28.88, "change": 161.36},
    {"name": "FTK", "price": 1.35, "change": 70.20},
    {"name": "NVCT", "price": 6.75, "change": 21.18}
  ];
  var loserList = [
    {"name": "AMPL", "price": 17.10, "change": -58.90},
    {"name": "FSLY", "price": 19.20, "change": -33.63},
    {"name": "YMTK", "price": 11.26, "change": -28.81}
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
          ),
        ),
        ListView(
          children: [
            SizedBox(height: 80),
            topList(name: "GAINERS", toplist: gainerList),
            SizedBox(height: 20),
            topList(name: "LOSERS", toplist: loserList),
            SizedBox(height: 20),
            Container(
              height: 300,
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Text(
                      "NEWS",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: newList()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
