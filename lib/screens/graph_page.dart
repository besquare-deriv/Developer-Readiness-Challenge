// ignore_for_file: avoid_print, unused_import, non_constant_identifier_names, camel_case_types, prefer_const_constructors, empty_constructor_bodies, no_logic_in_create_state, prefer_const_literals_to_create_immutables, unused_label, unused_field

import 'dart:async';
import 'dart:developer';

import 'package:drc/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '/components/chart.dart';
import 'history_page.dart';
import 'login_page.dart';
import 'market_list_page.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<GraphScreen> {
  late ChartSeriesController _chartSeriesController;
  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));
  final channel2 = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  String symbolName = "Volatility 50 Index";
  String symbol = "R_50";
  List<tickHistory> priceTime = [];

  void getTickHistory() {
    String request1 =
        '{"ticks_history": "$symbol" ,"count": 50,"end": "latest"}';
    channel.sink.add(request1);
    print("first request sent");
  }

  void getTickStream() {
    String request2 = '{"ticks": "R_50","subscribe": 1}';
    channel2.sink.add(request2);
    print("second request sent");
  }

  @override
  void initState() {
    getTickHistory();
    InitialTicks();
    getTickStream();

    tickStream();
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Color(0xFF1F96B0),
          title: Text(symbolName,
              style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,  
            ),
          ),
          centerTitle: true,
        ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: SfCartesianChart(
                margin: EdgeInsets.only(top: 20.0, left: 8.0),
                enableAxisAnimation: true,
                plotAreaBackgroundColor: Colors.black,

                zoomPanBehavior: ZoomPanBehavior(
                  selectionRectColor: Colors.red,
                  zoomMode: ZoomMode.x,
                  enablePanning: true,
                  enableDoubleTapZooming: true,
                  enablePinching: true,
                ),
                primaryXAxis: CategoryAxis(
                  maximumLabels: 5,
                  isVisible: true,
                  majorGridLines: MajorGridLines(width: 0),
                  labelStyle: TextStyle(color: Colors.white),
                  labelPlacement: LabelPlacement.onTicks,
                  labelPosition: ChartDataLabelPosition.inside,
                ),
                primaryYAxis: NumericAxis(
                  maximumLabels: 5,
                  interval: 0.1,
                  majorGridLines: MajorGridLines(width: 0),
                  labelPosition: ChartDataLabelPosition.inside,
                  labelStyle: TextStyle(color: Colors.white),
                  opposedPosition: true,
                ),

                // Chart title

                tooltipBehavior: TooltipBehavior(
                  tooltipPosition: TooltipPosition.auto,
                  color: Colors.red,
                  elevation: 10,
                  enable: true,
                  format: 'point.y at point.x',
                  shouldAlwaysShow: true,
                  canShowMarker: true,
                ),
                series: <ChartSeries<tickHistory, String>>[
                  LineSeries<tickHistory, String>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController:
                      controller;
                    },
                    color: Colors.grey,
                    enableTooltip: true,
                    dataSource: priceTime,
                    xValueMapper: (tickHistory ticks, _) => ticks.time,
                    yValueMapper: (tickHistory ticks, _) => ticks.price,
                    name: 'Ticks',
                    // Enable data label
                  ),
                ],
              ),
            ),
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
                  initialLabelIndex: 0,
                  totalSwitches: 4,
                  labels: ['1 Day', '7 Day', '30 Days', '1 Year'],
                  onToggle: (index) {},
                )
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () {},
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
                      backgroundColor: MaterialStateProperty.all(Colors.red),
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
      
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home), 
                        iconSize: 40,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()));
                        }
                      ),
            
            IconButton(icon: Image.asset('assets/icons/explore.png'), 
                        iconSize: 40,
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GraphScreen()));
                        }
                      ),
                      
            IconButton(icon: Image.asset('assets/icons/plus.png'), 
                        iconSize: 70,
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MarketScreen()));
                        }
                      ),
      
            IconButton(icon: Image.asset('assets/icons/history.png'), 
                        iconSize: 40,
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoryScreen()));
                        }
                      ),

            IconButton(icon: Image.asset('assets/icons/user.png'), 
                        iconSize: 40,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()));
                        }
                      ),
          ],
        ),
        shape: CircularNotchedRectangle(),
        color: Colors.black,
      ),
    );
  }

  void InitialTicks() {
    channel.stream.listen((data) {
      // Decodes the response to JSON format
      var price = jsonDecode(data);
      // initialize
      List<dynamic> timeConverted = [];

      for (int i = 0; i <= price['history']['times'].length - 1; i++) {
        // Converts epoch to DateTimestamp format
        timeConverted.add(DateTime.fromMillisecondsSinceEpoch(
            price['history']['times'][i] * 1000));

        // extract time only
        String extractedTime = DateFormat.Hms().format(timeConverted[i]);
        priceTime.add(
          tickHistory(
            time: extractedTime,
            price: price['history']['prices'][i],
          ),
        );
      }

      channel.sink.close();
    });
  }

  void tickStream() {
    channel2.stream.listen((data) {
      var tickStream = jsonDecode(data);
      DateTime timeConverted = DateTime.now();

      setState(() {
        timeConverted = DateTime.fromMillisecondsSinceEpoch(
            tickStream['tick']['epoch'] * 1000);

        String extractedTime = DateFormat.Hms().format(timeConverted);

        priceTime.add(
          tickHistory(
            time: extractedTime,
            price: tickStream['tick']['quote'],
          ),
        );
        priceTime.removeAt(0);
      });
    });
  }
}

class tickHistory {
  final String time;
  final double price;

  tickHistory({
    required this.time,
    required this.price,
  });

  @override
  String toString() => '[ $time , $price ]';
}
