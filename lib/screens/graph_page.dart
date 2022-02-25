// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
  late ChartSeriesController _chartSeriesController;

// For now initializing this data, should get this variables from Maket page
  String symbolName;
  String symbol;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int counts = 4;
    int _inputAmount = 100;

    int contractTime = 10;

    final channel2 = IOWebSocketChannel.connect(
        Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              channel2.sink.close();
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
              channel2: channel2,
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
                Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 10, top: 8, bottom: 8),
                  width: double.infinity,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                          // padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFC1C1C1),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              _inputAmount = int.parse(value);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 20, bottom: 10),
                              hintText: "$_inputAmount USD",
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
                          alignment: Alignment.center,
                          // padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFC1C1C1),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              contractTime = int.parse(value);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 20, bottom: 10),
                              hintText: "$contractTime mins",
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
                          print('$contractTime $_inputAmount');
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
                        onPressed: () {},
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
