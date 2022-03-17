// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final String? value1;

  const HomePage(this.value1, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(value1);
}

class _HomePageState extends State<HomePage> {
  String? value1;
  _HomePageState(this.value1, {Key? key});

  String username = "User";

  num balance = 0.0;
  int winsCount = 0;
  int lossCount = 0;
  num profit = 0;
  num loss = 0;
  var assetList = ['BTC/USD', 'EUR/USD', 'ETH/USD', 'Gold'];

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void sendAuth() {
    channel.sink.add('{"authorize": "$value1"}');
  }

  void getStatement() {
    String walletInfo =
        '{"statement": 1,"description": 1,"limit": 999,"offset": 25}';
    channel.sink.add(walletInfo);
  }

  @override
  void initState() {
    sendAuth();
    getProfileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: Stack(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset("assets/images/BeRad.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(Icons.settings,
                                  color: Theme.of(context).iconTheme.color),
                              iconSize: 40,
                              onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(value: value1),),);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                        left: 10,
                      ),
                      child: Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Hi, $username",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Dashboard",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.subtitle1?.color,
                          ),
                        ),
                      ),
                      trailing: Image.asset('assets/images/bear.png'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 220.0),
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFC1C1C1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 100,
                    width: 370,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 10,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: assetList.length,
                        itemBuilder: ((context, index) {
                          return SizedBox(
                            height: 80,
                            width: 80,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                        'assets/images/ethereum.png'),
                                  ),
                                  Text(
                                    assetList[index],
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                ]),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          crossAxisCount: 2,
          children: <Widget>[
            // Displays Balance for the user account
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF930077),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Account",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Balance",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "$balance USD",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Displays wins and losses
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFBD39),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: ListTile(
                          leading: Text(
                            "Wins    ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            "$winsCount",
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF73B8C8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: ListTile(
                          leading: Text(
                            "Losses",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          subtitle: Text(
                            "$lossCount",
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Displays Total Profit
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF36622B),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total Profit",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "+${profit.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFE84545),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total Loss",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    loss.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ))
      ],
    );
  }

  void getProfileInfo() {
    int tempWins = 0;
    int tempLoss = 0;
    num tempProfit = 0;
    num tempLosses = 0;

    channel.stream.listen((data) {
      var response = jsonDecode(data);
      // debugPrint(response.toString());
      if (response['msg_type'] == 'authorize' && response['error'] == null) {
        getStatement();
        setState(() {
          balance = response['authorize']['balance'];

          username = response['authorize']['email']
              .substring(0, response['authorize']['email'].indexOf('@'));
        });
      } else if (response['msg_type'] == 'authorize' &&
          response['error']['code'] == 'InvalidToken') {
        showDialog(
          context: context,
          builder: (BuildContext ctxt) {
            return AlertDialog(
              title: Text(
                  "${response['error']['message']} Please go to Profile Page and change the API Token."),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(ctxt).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      if (response['msg_type'] == 'statement') {
        // initialize the length of contracts
        int loopCount = response['statement']['count'];

        // Starts the first for loop

        for (int i = 0; i < loopCount; i++) {
          // checks for buy contract type
          if (response['statement']['transactions'][i]['action_type'] ==
              'buy') {
            //initialize contractID and balanceBefore for calculations
            var contractID =
                response['statement']['transactions'][i]['contract_id'];
            var balanceBefore =
                response['statement']['transactions'][i]['amount'];

// starts the second for loop
            for (int j = 0; j < loopCount; j++) {
              var secondID =
                  response['statement']['transactions'][j]['contract_id'];

              if (response['statement']['transactions'][j]['action_type'] ==
                  'sell') {
                if (contractID == secondID) {
                  var nett = balanceBefore +
                      response['statement']['transactions'][j]['amount'];

                  if (nett > 0) {
                    tempWins = tempWins + 1;
                    tempProfit = tempProfit + nett;
                  } else if (nett < 0) {
                    tempLoss = tempLoss + 1;
                    tempLosses = tempLosses + nett;
                  }
                }
              }
            }
          }
        }
        setState(() {
          winsCount = tempWins;
          lossCount = tempLoss;
          profit = tempProfit;
          loss = tempLosses;
        });
      }
    });
  }
}
