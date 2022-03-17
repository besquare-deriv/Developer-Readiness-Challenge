// ignore_for_file: avoid_unnecessary_containers, camel_case_types, prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/news.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  var toplist = [];
  var loserList = [];

  void coinList() async {
    var data =
        await http.get(Uri.parse('https://berad-api.herokuapp.com/stats'));
    var result = json.decode(data.body);

    setState(() {
      for (int i = 0; i <= result.length - 1; i++) {
        toplist.add(result[i]);
      }
      loserList = toplist.reversed.toList();
    });
  }

  @override
  void initState() {
    coinList();
    super.initState();
  }

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
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: Text(
                    "TOP GAINERS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                    child: Column(children: [
                      Flexible(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Ticker          ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Price",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Change(%)",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 7,
                        child: ListView.builder(
                          itemCount: toplist.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${toplist[index]['symbol']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      )),
                                  Text('\$ ${toplist[index]['price']}',
                                      style: TextStyle(color: Colors.black)),
                                  Text(
                                    '${toplist[index]['change_percent']}%',
                                    style: TextStyle(
                                      color: Colors.green[900],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ]),
                  ),
                )
              ]),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: Text(
                    "TOP LOSERS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                    child: Column(children: [
                      Flexible(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Ticker          ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Price",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Change(%)",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 7,
                        child: ListView.builder(
                          itemCount: loserList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${loserList[index]['symbol']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      )),
                                  Text('\$ ${loserList[index]['price']}',
                                      style: TextStyle(color: Colors.black)),
                                  Text(
                                    '${loserList[index]['change_percent']}%',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ]),
                  ),
                )
              ]),
            ),
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
