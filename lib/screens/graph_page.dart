// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:drc/components/error_dialog.dart';
import 'package:drc/screens/active_transactions.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../components/chart.dart';
import 'package:flutter/services.dart';

class GraphScreen extends StatefulWidget {
  GraphScreen(
      {Key? key,
      required this.state,
      this.apiToken,
      required this.symbolName,
      required this.currency_symbol,
      required this.symbol})
      : super(key: key);
  final String symbolName;
  final String symbol;
  String? apiToken;
  final String currency_symbol;
  final int state;

  @override
  _GraphScreenState createState() => _GraphScreenState(
      currency_symbol: currency_symbol,
      symbolName: symbolName,
      symbol: symbol,
      apiToken: apiToken,
      state: state);
}

class _GraphScreenState extends State<GraphScreen> {
  _GraphScreenState(
      {required this.symbolName,
      required this.symbol,
      required this.apiToken,
      required this.currency_symbol,
      required this.state});

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  final authChannel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  final checkmarketChannel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

// For now initializing this data, should get this variables from Maket page
  String symbolName;
  String symbol;
  String? apiToken;
  String currency_symbol;
  String? buy_id;
  int state;
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
    authChannel.stream.listen((data) async {
      var result = jsonDecode(data);
      if ((result['msg_type'] == 'proposal' && result['error'] == null) ||
          (result['msg_type'] == 'buy') && result['error'] == null) {
        buy_id = await result['proposal']['id'];

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
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (data) => activeOptions(
                                  apiToken: apiToken,
                                )));
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if ((result['msg_type'] == 'proposal' &&
              result['error'] != null) ||
          (result['msg_type'] == 'buy') && result['error'] != null) {
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
    if (state == 0) {
      return errorDialog(message: "Market is closed");
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).appBarTheme.iconTheme?.color),
              onPressed: () {
                channel.sink.close();
                Navigator.of(context).pop();
              }),
          backgroundColor: Theme.of(context).appBarTheme.color,
          title: Text(
            symbolName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 380,
              width: double.infinity,
              child: chartBuilder(
                symbol: symbol,
                symbolName: symbolName,
                channel2: channel,
                currency_symbol: currency_symbol,
              ),
            ),
            Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Icon(Icons.info_outline),
                        ),
                        Text(
                          "Only Rise/Fall contracts available for now.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                              ),
                              child: TextField(
                                style: TextStyle(color: Colors.black),
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                              ),
                              child: TextField(
                                style: TextStyle(color: Colors.black),
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
                              errorDialog(
                                  message:
                                      "Amount or time field is empty. Please give valid input and press 'Done'.");
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
                              errorDialog(
                                  message:
                                      "Amount or time field is empty. Please give valid input and press 'Done'.");
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
}
