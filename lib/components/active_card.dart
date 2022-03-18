// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, camel_case_types, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class activeCard extends StatefulWidget {
  activeCard({this.apiToken, required this.contract_id, Key? key})
      : super(key: key);

  String? apiToken;
  int contract_id;

  @override
  _activeCardState createState() =>
      _activeCardState(apiToken: apiToken, contract_id: contract_id);
}

class _activeCardState extends State<activeCard> {
  _activeCardState({
    required this.contract_id,
    this.apiToken,
  });

  String? apiToken;
  int contract_id;
  var result;

  final proposalChannel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void sendAuth2() {
    proposalChannel.sink.add('{"authorize": "$apiToken"}');

    Future.delayed(Duration(seconds: 5), () {
      getContractInfo(contract_id);
    });
  }

  void sellContract(contract_id) {
    proposalChannel.sink.add('{"sell": $contract_id,"price": 0}');
  }

  getContractInfo(contract_id) {
    proposalChannel.sink.add(
        '{"proposal_open_contract": 1,"contract_id": $contract_id, "subscribe":1}');
  }

  format(Duration d) => d.toString().split('.').first;

  void listenContractInfo() {
    proposalChannel.stream.listen((data) {
      setState(() {
        result = jsonDecode(data);
      });
    });
  }

  @override
  void initState() {
    sendAuth2();
    listenContractInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (result['proposal_open_contract'] != null) {
        var expiry_time = DateTime.fromMillisecondsSinceEpoch(
            result['proposal_open_contract']['date_expiry'] * 1000);
        var current_time = DateTime.fromMillisecondsSinceEpoch(
            result['proposal_open_contract']['current_spot_time'] * 1000);

        var time_remaining = format(expiry_time.difference(current_time));

        var validSell = result['proposal_open_contract']['is_valid_to_sell'];

        var profit = result['proposal_open_contract']['profit'];

        return Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40, left: 10, right: 10),
              child: Card(
                color: Color(0xFFFFF4F4F4),
                elevation: 5.0,
                child: Container(
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    "Buy Price :",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    " ${result['proposal_open_contract']['buy_price']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                child: Row(
                              children: [
                                Text(
                                  "Profit :",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  " $profit",
                                  style: (profit < 0)
                                      ? TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        )
                                      : TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    "Payout Limit :",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    " ${result['proposal_open_contract']['payout']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                child: Row(
                              children: [
                                Text(
                                  "Time Left :",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  " $time_remaining",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        alignment: Alignment.center,
                        child: (validSell == 1)
                            ? ElevatedButton(
                                onPressed: () {
                                  sellContract(contract_id);
                                  Navigator.pop(context);
                                },
                                child: Text("Sell", 
                                          style: TextStyle(
                                            color: Colors.white
                                            )
                                        ),
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(48, 95, 173, 1))),
                              )
                            : Text(""),
                      )
                    ],
                  ),
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                constraints: BoxConstraints(minWidth: 50),
                alignment: Alignment.centerLeft,
                height: 50,
                margin: EdgeInsets.fromLTRB(25, 10, 100, 0),
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF08D9D6),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Text(
                  "${result['proposal_open_contract']['display_name']}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    {
      return LinearProgressIndicator();
    }
  }
}

class activeContracts {
  String display_name;
  num profit;
  num buy_price;
  num contract_id;
  String contract_type;
  var dateStart;
  var dateExpiry;

  activeContracts({
    required this.display_name,
    required this.buy_price,
    required this.contract_id,
    required this.contract_type,
    required this.dateExpiry,
    required this.dateStart,
    required this.profit,
  });

  @override
  String toString() =>
      '[$display_name,$buy_price,$contract_id,$contract_type,$dateStart,$dateExpiry,$profit]';
}
