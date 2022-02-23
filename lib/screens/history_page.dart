import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import 'faq_page.dart';
import 'graph_page.dart';
import 'market_list_page.dart';
import 'profile_page.dart';

class HistoryScreen extends StatefulWidget {
  // PostPage({required this.postchannel,Key? key}) : super(key: key);
  // final WebSocketChannel postchannel;

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> { 

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void getTickStream() {
    channel.sink.add('{"active_symbols": "full","product_type": "basic"}');
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
                // child: ListView.builder(

                //   physics: BouncingScrollPhysics(),
                //   scrollDirection: Axis.vertical,
                //   shrinkWrap: true,
                //   itemCount: 10,
                //   itemBuilder: (context, index) {
                //     return ListTile(

                //     ),
                //   },
                // ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
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
                                  Text("Buy",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green)),
                                  Text("BTCAUSD",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  Text("TransactionID: 2665366288128",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  Text("2022-02-15 07:52:03 GMT",
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
                        Text(
                          "-&100",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       IconButton(
      //           icon: const Icon(
      //             Icons.home,
      //           ),
      //           iconSize: 40,
      //           color: Colors.white,
      //           onPressed: () {
      //             Navigator.push(context,
      //                 MaterialPageRoute(builder: (context) => LoginScreen()));
      //           }),
      //       IconButton(
      //           icon: Image.asset('assets/icons/explore.png'),
      //           iconSize: 40,
      //           onPressed: () {
      //             Navigator.push(context,
      //                 MaterialPageRoute(builder: (context) => GraphScreen()));
      //           }),
      //       IconButton(
      //           icon: Image.asset('assets/icons/plus.png'),
      //           iconSize: 70,
      //           onPressed: () {
      //             Navigator.push(context,
      //                 MaterialPageRoute(builder: (context) => MarketScreen()));
      //           }),
      //       IconButton(
      //           icon: Image.asset('assets/icons/history.png'),
      //           iconSize: 40,
      //           onPressed: () {
      //             Navigator.push(context,
      //                 MaterialPageRoute(builder: (context) => HistoryScreen()));
      //           }),
      //       IconButton(
      //           icon: Image.asset('assets/icons/user.png'),
      //           iconSize: 40,
      //           color: Colors.white,
      //           onPressed: () {
      //             Navigator.push(context,
      //                 MaterialPageRoute(builder: (context) => ProfilePage()));
      //           }),
      //     ],
      //   ),
      //   shape: CircularNotchedRectangle(),
      //   color: Colors.black,
      // ),
    );
  }
}
