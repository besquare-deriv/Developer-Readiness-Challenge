import 'dart:convert';
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
      required this.currency_symbol,
      Key? key})
      : super(key: key);
  String symbol, symbolName, currency_symbol;
  WebSocketChannel channel2;

  @override
  _chartBuilderState createState() =>
      _chartBuilderState(symbol, symbolName, currency_symbol, channel2);
}

class _chartBuilderState extends State<chartBuilder> {
  _chartBuilderState(
      this.symbol, this.symbolName, this.currency_symbol, this.channel2);

  List<tickHistory> priceTime = [];

  WebSocketChannel channel2;
  String symbol, symbolName, currency_symbol;

  num currentPrice = 0;
  String message = "";
  String extractedTime = "";
  num firstPrice = 0;
  double interval = 0.1;
  int decimalPlace = 2;

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void getTickHistory() {
    String request1 =
        '{"ticks_history": "$symbol" ,"count": 40,"end": "latest"}';
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
    var formatPrice =
        NumberFormat.currency(customPattern: '##,##0.0####', decimalDigits: 5).format(currentPrice);
        RegExp regex = RegExp(r"([.]*0+)(?!.*\d)");
        String ongoingPrice = formatPrice.toString().replaceAll(regex, '');
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
                  Container(
                    width: 120,
                    child: Wrap(children: [
                      Text(
                        "$symbolName :",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ]),
                  ),
                  Text(
                    "$ongoingPrice $currency_symbol",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          Container(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            width: double.infinity,
            child: SfCartesianChart(
             // onZoomReset:  ,
              // margin: EdgeInsets.only(top: 20.0, left: 8.0),
              borderWidth: 1,
              enableAxisAnimation: true,
              plotAreaBackgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,

              zoomPanBehavior: ZoomPanBehavior(
                selectionRectColor: Colors.red,
                zoomMode: ZoomMode.x,
                enablePanning: true,
                enableDoubleTapZooming: true,
                enablePinching: true,
                maximumZoomLevel: 0.01
              ),
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat.Hms(),
                intervalType: DateTimeIntervalType.seconds,
                interval: 5,
                //visibleMaximum: DateTime(priceTime.last.time.T),
                //rangePadding: ChartRangePadding.auto,
                majorGridLines: MajorGridLines(width: 0),
                tickPosition: TickPosition.outside,
                enableAutoIntervalOnZooming: true,
                labelStyle: TextStyle(color: Colors.white),    
              ),
              /* primaryXAxis: CategoryAxis(
                maximumLabels: 5,
                isVisible: true,
                majorGridLines: MajorGridLines(width: 0),
                labelStyle: TextStyle(color: Colors.white),
                labelPlacement: LabelPlacement.onTicks,
                //labelPosition: ChartDataLabelPosition.inside,
              ), */
              primaryYAxis: NumericAxis(
                maximumLabels: 1,
                interval: interval,
                decimalPlaces: decimalPlace,
                desiredIntervals: 1,
                majorGridLines: MajorGridLines(width: 0),
                // labelPosition: ChartDataLabelPosition.inside,
                labelStyle: TextStyle(color: Colors.white),
                opposedPosition: true,
                enableAutoIntervalOnZooming: true
              ),

              // Chart title
              trackballBehavior: TrackballBehavior(
                enable: true,
               // activationMode: ActivationMode.longPress,
                tooltipSettings: InteractiveTooltip(
                  color: Colors.red,
                  format: 'point.y at point.x' 
                  ),
                lineColor: Colors.red,
                shouldAlwaysShow: true,
                lineWidth: 1,
    lineType: TrackballLineType.horizontal,
    tooltipAlignment: ChartAlignment.near,
    tooltipDisplayMode: TrackballDisplayMode.nearestPoint
                

              ),
              /* tooltipBehavior: TooltipBehavior(
                tooltipPosition: TooltipPosition.auto,
                color: Colors.red,
                elevation: 10,
                enable: true,
                format: 'point.y at point.x',
                shouldAlwaysShow: true,
                canShowMarker: true,
              ), */
              onZoomStart: (ZoomPanArgs args){
                args.currentZoomPosition = 20;
              },
              series: <ChartSeries<tickHistory, DateTime>>[
                AreaSeries<tickHistory, DateTime>(
                  opacity: 0.3,
                  borderWidth: 4,
                  borderColor: Color.fromRGBO(8, 217, 217, 1) ,
                  /* borderGradient: LinearGradient(
                    colors: <Color>[
                      Color.fromRGBO(230, 0, 180, 1),
                      Color.fromRGBO(8, 217, 217, 1)
                    ],
                  ), */
                  animationDuration: 1,
                  onRendererCreated: (ChartSeriesController controller) {
                    _chartSeriesController : controller;
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
        //extractedTime = DateFormat.Hms().format(timeConverted[i]);
        priceTime.add(
          tickHistory(
            time: timeConverted[i],
            price: price['history']['prices'][i],
          ),
        );
      }
      firstPrice = priceTime[0].price;
      calInterval();

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
      //extractedTime = DateFormat.Hms().format(timeConverted);
      currentPrice = tickStream['tick']['quote'];
      setState(() {
        priceTime.add(
          tickHistory(
            time: timeConverted,
            price: currentPrice,
          ),
        );
        priceTime.removeAt(0);
      });
    });
  }

  void calInterval(){

    if(firstPrice <= 2){
      interval = 0.00005;
      decimalPlace = 5;
    }
    else if(firstPrice <= 5){
      interval = 0.001;
      decimalPlace = 4;
    }
    else if(firstPrice <= 25){
      interval = 0.001;
      decimalPlace = 3;
    }
    else if(firstPrice <= 150){
      interval = 0.005;
      decimalPlace = 3;
    } 
    else if(firstPrice <= 1000){
      interval = 0.025;
      decimalPlace = 3;
    }
    else if(firstPrice <= 2000){
      interval = 0.05;
      decimalPlace = 3;
    } 
    else if(firstPrice <= 3000){
      interval = 0.1;
    } 
    else if(firstPrice <= 10000){
      interval = 0.5;
    } 
    else if(symbolName == 'Boom 1000 Index'){
      interval = 1.0;
    }
    else if(symbolName == 'Jump 10 Index'){
      interval = 10;
    }
    else if(symbolName == 'Jump 75 Index' || symbolName == 'Jump 25 Index'){
      interval = 25;
    }
    else if(symbolName == 'Jump 100 Index'|| symbolName == 'Jump 50 Index'){
      interval = 50;
    }
    else if(firstPrice <= 400000){
      interval = 2.5;
    } 
    else if(firstPrice <= 600000){
      interval = 10;
    }
    else{
      interval = 100;
    }
  }
}

class tickHistory {
  final DateTime time;
  final num price;

  tickHistory({
    required this.time,
    required this.price,
  });

  @override
  String toString() => '[ $time , $price ]';
}
