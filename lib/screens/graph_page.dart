// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:web_socket_channel/io.dart';
import '../components/chart.dart';
import 'package:flutter/services.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key, required this.symbolName, required this.symbol})
      : super(key: key);
  final String symbolName;
  final String symbol;

  @override
  _GraphScreenState createState() =>
      _GraphScreenState(symbolName: symbolName, symbol: symbol);
}

class _GraphScreenState extends State<GraphScreen> {
  _GraphScreenState({required this.symbolName, required this.symbol});

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  final authChannel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

// For now initializing this data, should get this variables from Maket page
  String symbolName;
  String symbol;
  String apiToken = "SZZ9iFcGUaAMqA5";
  String? buy_id;
  int counts = 4;
  int? _inputAmount;
  int? contractTime;
  String? contractType;

  void getPriceProposal() {
    String request =
        '{"proposal": 1,"amount": $_inputAmount,"basis": "payout", "contract_type": "$contractType","currency": "USD","duration": $contractTime,"duration_unit": "m", "symbol": "$symbol"}';
    authChannel.sink.add(request);
  }

  void sendAuth() {
    authChannel.sink.add('{"authorize": "$apiToken"}');
  }

  void listenWS() {
    authChannel.stream.listen((data) {
      var result = jsonDecode(data);

      print(result.toString());

      if (result['msg_type'] == 'proposal' && result['proposal'] != null) {
        buy_id = result['proposal']['id'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  "Are you sure you want to buy $contractType contract with $_inputAmount USD for $contractTime minutes ?"),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    buyContract();
                  },
                ),
              ],
            );
          },
        );
      }

      if (result['msg_type'] == 'proposal' && result['error'] != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                result['error']['message'],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  void buyContract() {
    authChannel.sink.add('{"buy": "$buy_id","price": $_inputAmount}');
  }

  @override
  void initState() {
    sendAuth();
    listenWS();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              channel.sink.close();
              Navigator.of(context).pop();
            }),
        backgroundColor: Color(0xFF1F96B0),
        title: Text(
          symbolName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 400,
            width: double.infinity,
            child: chartBuilder(
              symbol: symbol,
              counts: counts,
              channel2: channel,
            ),
          ),
          Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Icon(Icons.watch_later_outlined),
                    ),
                    Text(
                      "Time Intervals",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ToggleSwitch(
                      fontSize: 11,
                      iconSize: 8.0,
                      minWidth: 60,
                      inactiveBgColor: Colors.grey.shade400,
                      activeFgColor: Colors.black,
                      activeBgColor: [Colors.grey],
                      initialLabelIndex: 4,
                      totalSwitches: 4,
                      labels: ['1 Hour', '1 Day', '7 Days', '30 Days'],
                      onToggle: (index) {
                        counts = index as int;
                      },
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            // padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFC1C1C1),
                            ),
                            child: TextField(
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  _inputAmount = int.parse(value);
                                } else {
                                  _inputAmount = null;
                                }
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 20, bottom: 10),
                                labelText: "Amount (USD)",
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            // padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFC1C1C1),
                            ),
                            child: TextField(
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  contractTime = int.parse(value);
                                } else {
                                  contractTime = null;
                                }
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 20, bottom: 10),
                                labelText: "Time (Mins)",
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        onPressed: () {
                          if (_inputAmount != null || contractTime != null) {
                            contractType = "CALL";
                            getPriceProposal();
                          }
                          if (_inputAmount == null || contractTime == null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      "Amount or time field is empty. Please give valid input and press 'Done'."),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("OK"),
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
                        child: SizedBox(
                          height: 40,
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: Colors.black,
                              ),
                              Text(
                                "Rise",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        onPressed: () {
                          if (_inputAmount != null || contractTime != null) {
                            contractType = "PUT";
                            getPriceProposal();
                          }
                          if (_inputAmount == null || contractTime == null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      "Amount or time field is empty. Please give valid input and press 'Done'."),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("OK"),
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
                        child: SizedBox(
                          height: 40,
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                color: Colors.black,
                              ),
                              Text(
                                "Fall",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
