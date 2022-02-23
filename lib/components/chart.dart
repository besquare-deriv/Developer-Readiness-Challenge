// ignore_for_file: camel_case_types, no_logic_in_create_state, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_label, prefer_typing_uninitialized_variables, unused_import

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

class chartBuilder extends StatefulWidget {
  chartBuilder({required this.symbol, required this.counts, Key? key})
      : super(key: key);
  String symbol;
  int counts;

  @override
  _chartBuilderState createState() => _chartBuilderState(symbol, counts);
}

class _chartBuilderState extends State<chartBuilder> {
  _chartBuilderState(this.symbol, this.counts);

  List<tickHistory> priceTime = [];

  String symbol;
  int counts;
  var countList = [112, 2700, 18900, 81000, 30];

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  final channel2 = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void getTickHistory() {
    String request1 =
        '{"ticks_history": "$symbol" ,"count": ${countList[counts]},"end": "latest"}';
    channel.sink.add(request1);
  }

  void getTickStream() {
    String request2 = '{"ticks": "$symbol","subscribe": 1}';
    channel2.sink.add(request2);
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
  Widget build(BuildContext context) {
    return SfCartesianChart(
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
        AreaSeries<tickHistory, String>(
          opacity: 0.3,
          borderWidth: 4,
          borderGradient: LinearGradient(
            colors: <Color>[
              Color.fromRGBO(230, 0, 180, 1),
              Color.fromRGBO(8, 217, 217, 1)
            ],
          ),
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
    );
  }

  void InitialTicks() {
    channel.stream.listen((data) {
      priceTime = [];
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
    // Sets the interval to call the ticks in seconds

    channel2.stream.listen((data) {
      var tickStream = jsonDecode(data);
      dynamic timeConverted;
      String extractedTime = "";
      timeConverted = DateTime.fromMillisecondsSinceEpoch(
          tickStream['tick']['epoch'] * 1000);
      extractedTime = DateFormat.Hms().format(timeConverted);

      setState(() {
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