// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, camel_case_types

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class activeCard extends StatefulWidget {
  activeCard({required this.contract_id, Key? key}) : super(key: key);

  int contract_id;

  @override
  _activeCardState createState() => _activeCardState(contract_id: contract_id);
}

class _activeCardState extends State<activeCard> {
  _activeCardState({
    required this.contract_id,
  });

  String apiToken = "SZZ9iFcGUaAMqA5";
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

  getContractInfo(contract_id) {
    print("contract info requested for $contract_id");
    proposalChannel.sink.add(
        '{"proposal_open_contract": 1,"contract_id": $contract_id, "subscribe":1}');
  }

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
        return Card(
            elevation: 5.0,
            child: Column(
              children: [
                ListTile(
                  leading: Text(
                      "${result['proposal_open_contract']['display_name']}"),
                  trailing: Column(
                    children: [
                      Text(
                          "Buy Price : ${result['proposal_open_contract']['buy_price']}"),
                      Text(
                          "Profit/Loss: ${result['proposal_open_contract']['profit']}"),
                    ],
                  ),
                ),
              ],
            ));
      }
    } catch (e) {
      print(e.toString());
    }

    {
      return SizedBox.shrink();
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
