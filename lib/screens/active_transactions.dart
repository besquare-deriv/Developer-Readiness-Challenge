import 'dart:convert';

import 'package:drc/components/active_card.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class activeOptions extends StatefulWidget {
  const activeOptions({Key? key}) : super(key: key);

  @override
  _activeOptionsState createState() => _activeOptionsState();
}

class _activeOptionsState extends State<activeOptions> {
  String apiToken = "SZZ9iFcGUaAMqA5";

  List<activeContracts> contractsList = [];
  List<int> idList = [];

  final activeChannel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void sendAuth() {
    activeChannel.sink.add('{"authorize": "$apiToken"}');
    Future.delayed(Duration(seconds: 10), () {
      getActiveContracts();
    });
  }

  void getActiveContracts() {
    activeChannel.sink.add('{"portfolio": 1}');
  }

  void listenActiveContracts() {
    activeChannel.stream.listen((data) {
      var result = jsonDecode(data);

      if (idList.isEmpty) {
        if (result['msg_type'] == 'portfolio') {
          for (int i = 0;
              i <= result['portfolio']['contracts'].length - 1;
              i++) {
            setState(() {
              idList.add(
                result['portfolio']['contracts'][i]['contract_id'],
              );
            });
          }
          activeChannel.sink.close();
        }
      } // if ends
    });
  }

  @override
  void initState() {
    sendAuth();
    listenActiveContracts();
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
          backgroundColor: const Color(0xFF1F96B0),
          title: const Text("Open Contract Positions",
                style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                ),
              ),
              centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(20, 20, 100, 10),
              child: Text(
                "Open Positions",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: idList.length,
                  itemBuilder: (context, index) {
                    if (idList.isNotEmpty) {
                      return activeCard(contract_id: idList[index]);
                    }
                    {
                      return LinearProgressIndicator();
                    }
                  }),
            ),
          ],
        ));
  }
}
