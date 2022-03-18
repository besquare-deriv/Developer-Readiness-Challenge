import 'dart:async';
import 'dart:convert';
import 'package:drc/screens/contract_details.dart';
import 'active_transactions.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final String apiToken;

  const HistoryScreen(this.apiToken, {Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState(apiToken);
}

class _HistoryScreenState extends State<HistoryScreen> {
  _HistoryScreenState(this.apiToken);
  String apiToken;
  var channel;

  List<transDetails> listData = [];
  List<transDetails> dataHistory = [];
  List<symbolDetails> activeSymbol = [];
  List<transDetails> detailsContract = [];
  late String symbol_id;
  List<transDetails> sortedList = [];
  List<transDetails> dummyList = [];
  bool _isLoading = false;

  initialConnection() {
    channel = IOWebSocketChannel.connect(
        Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));
  }

  sendMessageAuthorize() {
    channel.sink.add('{"authorize": "$apiToken"}');
  }

  sendMessageStatement() {
    channel.sink.add('{"statement": 1, "description": 1, "limit": 999}');
  }

  getActiveSymbol() {
    channel.sink.add('{"active_symbols": "brief","product_type": "basic"}');
  }

  void getSymbol(data) {
    activeSymbol = [];
    if (data['msg_type'] == 'active_symbols') {
      for (int j = 0; j <= data['active_symbols'].length - 1; j++) {
        symbol_id = data['active_symbols'][j]['symbol'];
        if (mounted) {
          setState(() {
            activeSymbol.add(
              symbolDetails(
                  symbol: symbol_id.toUpperCase(),
                  displayName: data['active_symbols'][j]['display_name']),
            );
          });
        }
      }
    }
  }

  void getAuthorize() {
    channel.stream.listen((event) {
      final data = jsonDecode(event);

      dataHistory = [];
      listData = [];
      List<dynamic> time = [];

      List<String> currency = [];
      List<String> typeCurrency = [];
      List<String> displayName = [];

      if (data['msg_type'] == 'active_symbols') {
        getSymbol(data);
        sendMessageAuthorize();
      }
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

          currency.add(
              data['statement']['transactions'][i]['shortcode'].toString());

          if (currency[i].contains(RegExp(".*?_(R_.*?)_.*?"))) {
            String a = currency[i].split('_')[1];
            String b = currency[i].split('_')[2];
            String output = a + '_' + b;
            typeCurrency.add(output);
          } else if (currency[i].contains(RegExp(".*?_(OTC_.*?)_.*?"))) {
            String a = currency[i].split('_')[1];
            String b = currency[i].split('_')[2];
            String output = a + '_' + b;
            typeCurrency.add(output);
          } else if (currency[i].contains('null')) {
            typeCurrency.add(currency[i]);
          } else {
            String output = currency[i].split('_')[1];
            typeCurrency.add(output);
          }

          for (int j = 0; j <= activeSymbol.length - 1; j++) {
            if (typeCurrency[i] == activeSymbol[j].symbol) {
              displayName.add(activeSymbol[j].displayName);
              break;
            }
            if (typeCurrency[i] == 'null') {
              displayName.add('null');
              break;
            }
          }
          if (mounted) {
            setState(() {
              dataHistory.add(
                transDetails(
                  action: data['statement']['transactions'][i]['action_type'],
                  time: formattedDate,
                  id: data['statement']['transactions'][i]['transaction_id'],
                  amount: data['statement']['transactions'][i]['amount'],
                  balance: data['statement']['transactions'][i]
                      ['balance_after'],
                  contract_id: data['statement']['transactions'][i]
                      ['contract_id'],
                  payout: data['statement']['transactions'][i]['payout'],
                  crypto: typeCurrency[i],
                  symbolName: displayName[i],
                ),
              );
            });
          }
        }
        if (mounted) {
          setState(() {
            listData.addAll(dataHistory);
          });
        }
      }
    });
  }

  void checkData() {
    if (listData.isEmpty) {
      return null;
    }
    if (listData.length > 0) {
      _isLoading = true;
    }
  }

  timer() {
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          checkData();
        });
      }
    });
  }

  getData() async {
    await initialConnection();
    getActiveSymbol();
    getAuthorize();
    timer();
    _isLoading = false;
  }

  @override
  void initState() {
    getData();
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
          //backgroundColor: Color(0xFF1F96B0),
          title: const Text(
            'Transaction History',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              //color: Colors.white,
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
                                        builder: (data) => activeOptions(
                                              apiToken: apiToken,
                                            )));
                              },
                              child: Text(
                                "Open Positions",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh_rounded,
                              color: Theme.of(context).iconTheme.color),
                          iconSize: 40,
                          onPressed: () {
                            getData();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.sort_rounded,
                              color: Theme.of(context).iconTheme.color),
                          iconSize: 40,
                          onPressed: () {
                            setState(() {
                              listData = listData.reversed.toList();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.filter_alt,
                              color: Theme.of(context).iconTheme.color),
                          iconSize: 40,
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
                              return InkWell(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ContractDetails(
                                              data: listData[index],
                                              info: dataHistory)))
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: Card(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer,
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
                                          height: 50,
                                          width: 50,
                                          child: Image.asset(
                                              'assets/icons/transaction.png'),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(listData[index].action,
                                                      style: TextStyle(
                                                          fontSize: 23,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: listData[index]
                                                                      .action ==
                                                                  'buy'
                                                              ? Color.fromRGBO(
                                                                  54, 98, 43, 1)
                                                              : Color.fromRGBO(
                                                                  232,
                                                                  69,
                                                                  69,
                                                                  1))),
                                                  Text(
                                                      '${listData[index].symbolName}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      'Trans.ID: ${listData[index].id}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      '${listData[index].time}',
                                                      style: TextStyle(
                                                          color: Colors.black,
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
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: listData[index].amount < 0
                                                ? Color.fromRGBO(232, 69, 69, 1)
                                                : Color.fromRGBO(54, 98, 43, 1),
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
                : Center(child: CircularProgressIndicator())
        )
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
  final dynamic payout;
  final dynamic crypto;
  final dynamic symbolName;

  transDetails({
    required this.action,
    required this.time,
    this.id,
    this.amount,
    this.balance,
    this.contract_id,
    this.payout,
    this.crypto,
    this.symbolName,
  });

  @override
  String toString() =>
      '[ $action , $time , $id , $amount, $balance , $contract_id, $payout, $crypto , $symbolName]';
}

class symbolDetails {
  final String symbol;
  final String displayName;

  symbolDetails({
    required this.symbol,
    required this.displayName,
  });
  String toString() => '[ $symbol, $displayName]';
}
