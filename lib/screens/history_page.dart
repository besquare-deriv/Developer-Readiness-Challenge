import 'dart:async';
import 'dart:convert';

import 'package:drc/screens/active_transactions.dart';
import 'package:drc/screens/contract_page.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<transDetails> listData = [];
  List<transDetails> dataHistory = [];
  List<transDetails> sortedList = [];
  List<transDetails> dummyList = [];
  bool _isLoading = false;

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void sendMessageAuthorize() {
    channel.sink.add('{"authorize": "SZZ9iFcGUaAMqA5"}');
  }

  void sendMessageStatement() {
    channel.sink.add('{"statement": 1, "description": 1, "limit": 100}');
  }

  void getAuthorize() {
    channel.stream.listen((event) {
      final data = jsonDecode(event);

      dataHistory = [];
      listData = [];
      List<dynamic> time = [];
      // List<String> currency = [];
      // List<String> typeCurrency = [];

      if (data['msg_type'] == 'authorize') {
        sendMessageStatement();
      }

      if (data['msg_type'] == 'statement') {
        for (int i = 0;
            i <= data['statement']['transactions'].length - 1;
            i++) {
          time.add(DateTime.fromMillisecondsSinceEpoch(
              data['statement']['transactions'][i]['transaction_time'] * 1000));

          String formattedDate =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(time[i]);

          // currency.add(data['statement']['transactions'][i]['shortcode']);

          // if (currency[i].contains('R_')){
          //   String a = currency[i].split('_')[1];
          //   String b = currency[i].split('_')[2];
          //   String output = a + '_' + b;
          //   typeCurrency.add(output);
          // } else{
          //   String output = currency[i].split('_')[1];
          //   typeCurrency.add(output);
          // }

          setState(() {
            dataHistory.add(
              transDetails(
                action: data['statement']['transactions'][i]['action_type'],
                time: formattedDate,
                id: data['statement']['transactions'][i]['transaction_id'],
                amount: data['statement']['transactions'][i]['amount'],
                balance: data['statement']['transactions'][i]['balance_after'],
                contract_id: data['statement']['transactions'][i]
                    ['contract_id'],
                //crypto: typeCurrency[i],
              ),
            );
          });
        }
        ;
        setState(() {
          listData.addAll(dataHistory);
        });
      }
    });
  }

  void checkData() {
    if (listData.isEmpty) {
      return null;
    }
    if (listData.length > 0) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  timer() {
    Timer(Duration(seconds: 5), () {
      setState(() {
        checkData();
      });
    });
  }

  @override
  void initState() {
    sendMessageAuthorize();
    sendMessageStatement();
    getAuthorize();
    timer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void filterSearchResults(String query) {
    dummyList = [];
    sortedList = [];

    if (query.isNotEmpty) {
      for (int i = 0; i < dataHistory.length; i++) {
        if (dataHistory[i].action == query) {
          setState(() {
            sortedList.add(dataHistory[i]);
          });
        }
      }
      ;
      setState(() {
        listData.clear();
        listData.addAll(sortedList);
      });
      return;
    } else {
      setState(() {
        listData.clear();
        listData.addAll(dataHistory);
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    sortedList = [];

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        backgroundColor: Color(0xFF1F96B0),
        title: const Text(
          'Transaction History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [],
      ),
      body: SafeArea(
          child: (_isLoading)
              ? Center(
                  child: Column(
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (data) => activeOptions()));
                            },
                            child: Text(
                              "Active Contracts",
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Image.asset('assets/icons/sort.png'),
                        iconSize: 1,
                        onPressed: () {
                          setState(() {
                            listData = listData.reversed.toList();
                          });
                        },
                      ),
                      IconButton(
                        icon: Image.asset('assets/icons/filter.png'),
                        iconSize: 1,
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  scrollable: true,
                                  title: Text('Filter by:'),
                                  insetPadding: EdgeInsets.zero,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        filterSearchResults('buy');
                                      },
                                      child: Text('Buy'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        filterSearchResults('sell');
                                      },
                                      child: Text('Sell'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        filterSearchResults('');
                                      },
                                      child: Text('Clear Filter'),
                                    ),
                                  ]);
                            }),
                      ),
                    ]),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: listData.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ContractPage(
                                            data: listData[index],
                                            info: listData)))
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Card(
                                  color: Colors.white70,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 20.0,
                                    ),
                                    child: Row(children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child:
                                            Image.asset('assets/icons/btc.png'),
                                      ),
                                      const SizedBox(width: 7),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(listData[index].action,
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: listData[index]
                                                                    .action ==
                                                                'buy'
                                                            ? Colors.green
                                                            : Colors.red)),
                                                Text('BTCAUSD',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    'TransactionID: ${listData[index].id}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text('${listData[index].time}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${listData[index].amount}',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ))
              : Center(child: CircularProgressIndicator())),
    );
  }
}

class transDetails {
  final String action;
  final String time;
  final dynamic id;
  final dynamic amount;
  final dynamic balance;
  final dynamic contract_id;
  // final dynamic crypto;

  transDetails({
    required this.action,
    required this.time,
    this.id,
    this.amount,
    this.balance,
    this.contract_id,
    // this.crypto,
  });

  @override
  String toString() =>
      '[ $action , $time , $id , $amount, $balance , $contract_id]';
}
