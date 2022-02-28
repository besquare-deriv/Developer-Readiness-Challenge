import 'dart:async';
import 'dart:convert';

import 'package:drc/components/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class chartBuilder extends StatefulWidget {
  chartBuilder(
      {required this.symbol,
      required this.channel2,
      required this.symbolName,
      Key? key})
      : super(key: key);
  String symbol, symbolName;
  WebSocketChannel channel2;

  @override
  _chartBuilderState createState() =>
      _chartBuilderState(symbol, symbolName, channel2);
}

class _chartBuilderState extends State<chartBuilder> {
  _chartBuilderState(this.symbol, this.symbolName, this.channel2);

  List<tickHistory> priceTime = [];

  WebSocketChannel channel2;
  String symbol, symbolName;
  num currentPrice = 0;
  String message = "";
  String extractedTime = "";

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void getTickHistory() {
    String request1 =
        '{"ticks_history": "$symbol" ,"count": 112,"end": "latest"}';
    channel.sink.add(request1);
  }

  void getTickStream() {
    String request2 = '{"ticks": "$symbol","subscribe": 1}';
    channel2.sink.add(request2);
  }

  @override
  void initState() {
    getTickHistory();
    initialTicks();
    getTickStream();
    tickStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (priceTime.isNotEmpty) {
      return Column(
        children: [
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$symbolName :",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "$currentPrice USD",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          SfCartesianChart(
            // margin: EdgeInsets.only(top: 20.0, left: 8.0),
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
          ),
        ],
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void initialTicks() {
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

      timeConverted = DateTime.fromMillisecondsSinceEpoch(
          tickStream['tick']['epoch'] * 1000);
      extractedTime = DateFormat.Hms().format(timeConverted);
      currentPrice = tickStream['tick']['quote'];
      setState(() {
        priceTime.add(
          tickHistory(
            time: extractedTime,
            price: currentPrice,
          ),
        );

        priceTime.removeAt(0);
      });
    });
  }
}

class tickHistory {
  final String time;
  final num price;

  tickHistory({
    required this.time,
    required this.price,
  });

  @override
  String toString() => '[ $time , $price ]';
}
