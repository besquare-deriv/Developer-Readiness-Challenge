// ignore_for_file: no_logic_in_create_state

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:intl/intl.dart';

class onGoingPrice extends StatefulWidget {
  onGoingPrice(
      {required this.symbolName,
      required this.currency_symbol,
      required this.symbol,
      Key? key})
      : super(key: key);

  String symbolName, currency_symbol, symbol;

  @override
  State<onGoingPrice> createState() => _onGoingPriceState(
      currency_symbol: currency_symbol, symbol: symbol, symbolName: symbolName);
}

class _onGoingPriceState extends State<onGoingPrice> {
  _onGoingPriceState(
      {required this.symbol,
      required this.symbolName,
      required this.currency_symbol});

  String symbolName, currency_symbol, symbol;
  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  dynamic currentPrice = 0;

  void getTickStream() {
    String request = '{"ticks": "$symbol","subscribe": 1}';
    channel.sink.add(request);
  }

  @override
  initState() {
    getTickStream();
    listenToWebsocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formatPrice =
        NumberFormat.currency(customPattern: '##,##0.0####', decimalDigits: 5)
            .format(currentPrice);
    RegExp regex = RegExp(r"([.]*0+)(?!.*\d)");
    String ongoingPrice = formatPrice.toString().replaceAll(regex, '');

    return Container(
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
                  "${widget.symbolName} :",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ]),
            ),
            Text(
              "$ongoingPrice ${widget.currency_symbol}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }

  void listenToWebsocket() {
    channel.stream.listen((data) {
      var tickStream = jsonDecode(data);
      currentPrice = tickStream['tick']['quote'];

      if (mounted) {
        setState(() {
          currentPrice = tickStream['tick']['quote'];
        });
      }
    });
  }
}
