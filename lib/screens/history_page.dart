import 'dart:convert';
import 'package:drc/screens/contract_details.dart';
import 'package:drc/screens/contract_page.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  // PostPage({required this.postchannel,Key? key}) : super(key: key);
  // final WebSocketChannel postchannel;

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> { 

  List<transDetails> dataHistory = [];
  List<symbolDetails> activeSymbol = [];
  List<transDetails> detailsContract = [];
  late String symbol_id;

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089')
    );
  
  void sendMessageAuthorize() {
    channel.sink.add('{"authorize": "5dRHsXj0xsjBEJC"}');
  }

   void sendMessageStatement() {
    channel.sink.add('{"statement": 1, "description": 1, "limit": 100}');
  }

  void getActiveSymbol(){
    channel.sink.add('{"active_symbols": "brief","product_type": "basic"}');
  }

  dynamic getSymbol(data){
    activeSymbol = [];
    if(data['msg_type'] == 'active_symbols'){       
      for(int j = 0; j <= data['active_symbols'].length -1; j ++){
        symbol_id = data['active_symbols'][j]['symbol'];
        setState(() {
            activeSymbol.add(
              symbolDetails(
                symbol: symbol_id.toUpperCase(),
                displayName: data['active_symbols'][j]['display_name']
                ),
              );
            }
         );
        }
    }
  }

  void getAuthorize() {
    channel.stream.listen((event) {
      final data = jsonDecode(event);
      
      dataHistory = [];
      List<dynamic> time = [];
      List<String> currency = [];
      List<String> typeCurrency = [];
      List<String> displayName = [];


      if(data['msg_type'] == 'active_symbols'){
        getSymbol(data);
        sendMessageAuthorize();
      }
      //getSymbol(data);
      //sendMessageStatement();
      
      if (data['msg_type'] == 'authorize') {
         sendMessageStatement();
         //print(data);
       }
            
      if (data['msg_type'] == 'statement') {
         for (int i = 0; i <= data['statement']['transactions'].length -1; i ++) {
          //  print(data['statement']['transactions'][i]['transaction_time']);
          
           time.add(DateTime.fromMillisecondsSinceEpoch(
            data['statement']['transactions'][i]['transaction_time'] * 1000));
          
          String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(time[i]);

          
          currency.add(data['statement']['transactions'][i]['shortcode'].toString());

          /*final regex = RegExp (r'(?<=_)[^R_]+(?=_)');
          String? match = regex.stringMatch(currency[i].toString());
          typeCurrency.add(match!); */

          if (currency[i].contains('R_')){
            String a = currency[i].split('_')[1];
            String b = currency[i].split('_')[2];
            String output = a + '_' + b;
            typeCurrency.add(output);
          } else if (currency[i].contains('null')){
            typeCurrency.add(currency[i]);
          }
          else{
            String output = currency[i].split('_')[1];
            typeCurrency.add(output);
          }
          //print(typeCurrency.length);

           for(int j = 0; j <= activeSymbol.length -1; j ++){
              if(typeCurrency[i] == activeSymbol[j].symbol){
                displayName.add(activeSymbol[j].displayName);
                break;
              }
              if(typeCurrency[i] == 'null'){
                displayName.add('null');
                break;
              }
            }  

          setState(() {
            dataHistory.add(
              transDetails(
                action: data['statement']['transactions'][i]['action_type'],
                time: formattedDate,
                id: data['statement']['transactions'][i]['transaction_id'],
                amount: data['statement']['transactions'][i]['amount'],
                balance: data['statement']['transactions'][i]['balance_after'],
                contract_id: data['statement']['transactions'][i]['contract_id'],
                payout: data['statement']['transactions'][i]['payout'],
                crypto: typeCurrency[i],
                symbolName: displayName[i],
                ),
              );
            }
          );
          
            
         };
         //print(dataHistory);
       }
    });
  }

  // dynamic getDetails(ref_id) {
  //   for (int i=0; i <= dataHistory.length -1; i ++){
  //     if (dataHistory[i].contract_id == ref_id){
  //       setState(() {
  //         detailsContract.add(dataHistory[i]);
  //       });
  //     }
  //   }
  //   return detailsContract;
  // }

  @override
  void initState() {
    getActiveSymbol();
    //sendMessageAuthorize();
    //sendMessageStatement();
    getAuthorize();
    // getDetails(ref_id);
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
        title: const Text(
          'Transaction History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                icon: Image.asset('assets/icons/sort.png'),
                iconSize: 1,
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset('assets/icons/filter.png'),
                iconSize: 1,
                onPressed: () {},
              ),
            ]),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: dataHistory.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContractDetails(data: dataHistory[index], info: dataHistory)))
                        },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Card(
                          color: Colors.white70,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
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
                                child: Image.asset('assets/icons/btc.png'),
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(dataHistory[index].action,
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                
                                                color: dataHistory[index].action == 'buy' ? Color.fromRGBO(54, 98, 43, 1) : Color.fromRGBO(232, 69, 69,1))),
                                        Text('${dataHistory[index].symbolName}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text('TransactionID: ${dataHistory[index].id}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text('${dataHistory[index].time}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text( '${dataHistory[index].amount}',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  color: dataHistory[index].amount >= 0 ?Color.fromRGBO(54, 98, 43, 1) : Color.fromRGBO(232, 69, 69,1),
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
        )),
      ),
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
  String toString() => '[ $action , $time , $id , $amount, $balance , $contract_id, $payout, $crypto , $symbolName]';
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