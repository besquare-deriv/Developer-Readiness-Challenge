import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:web_socket_channel/io.dart';
import 'graph_page.dart';
import 'package:intl/intl.dart';

class MarketScreen extends StatefulWidget {
  MarketScreen(this.apiToken, {Key? key}) : super(key: key);

  String apiToken;
  @override
  _MarketScreenState createState() => _MarketScreenState(apiToken);
}

class _MarketScreenState extends State<MarketScreen> {
  _MarketScreenState(this.apiToken);

  String apiToken;
  String textname = 'Forex';
  bool changeColor = true;
  bool changeColor1 = false;
  bool changeColor2 = false;
  bool changeColor3 = false;
  bool changeColor4 = false;

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void getTickStream() {
    channel.sink.add('{"active_symbols": "full","product_type": "basic"}');
  }

  String query = '';
  @override
  void initState() {
    getTickStream();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var symbol;
    var symbolName;
    var state;
    TextEditingController selectedSymbol = new TextEditingController();

    List<String> MarketNames = [];
    List<SearchFieldListItem> list = [];
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: StreamBuilder(
            stream: channel.stream,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var price = jsonDecode(snapshot.data);
                try {
                  for (int i = 0; i <= 76; i++) {
                    if (price['active_symbols'][i]['exchange_is_open'] == 1) {
                      MarketNames.add(
                          price['active_symbols'][i]['display_name']);
                    }
                  }
                  list =
                      MarketNames.map((e) => SearchFieldListItem(e)).toList();
                } catch (e) {
                  debugPrint(e.toString());
                }
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                      ),
                      height: 160,
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(5, 30, 5, 10),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Row(
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      shape: Border(
                                          bottom: BorderSide(
                                              color: changeColor
                                                  ? Theme.of(context)
                                                      .highlightColor
                                                  : Colors.transparent,
                                              width: 3.0)),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.black, // foreground

                                          // foreground
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            changeColor1 = false;
                                            changeColor2 = false;
                                            changeColor3 = false;
                                            changeColor4 = false;
                                            changeColor = true;
                                            textname = 'Forex';
                                          });
                                        },
                                        child: Text(
                                          'Forex',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      shape: Border(
                                          bottom: BorderSide(
                                              color: changeColor1
                                                  ? Theme.of(context)
                                                      .highlightColor
                                                  : Colors.transparent,
                                              width: 3.0)),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.black, // foreground

                                          // foreground
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            changeColor2 = false;
                                            changeColor = false;
                                            changeColor3 = false;
                                            changeColor4 = false;
                                            changeColor1 = true;
                                            textname = 'Stock Indices';
                                          });
                                        },
                                        child: Text(
                                          'Stock Indices',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      shape: Border(
                                          bottom: BorderSide(
                                              color: changeColor2
                                                  ? Theme.of(context)
                                                      .highlightColor
                                                  : Colors.transparent,
                                              width: 3.0)),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.black, // foreground

                                          // foreground
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            changeColor1 = false;
                                            changeColor = false;
                                            changeColor3 = false;
                                            changeColor4 = false;
                                            changeColor2 = true;
                                            textname = 'Commodities';
                                          });
                                        },
                                        child: Text(
                                          'Commodities',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      shape: Border(
                                          bottom: BorderSide(
                                              color: changeColor3
                                                  ? Theme.of(context)
                                                      .highlightColor
                                                  : Colors.transparent,
                                              width: 3.0)),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.black, // foreground

                                          // foreground
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            changeColor1 = false;
                                            changeColor = false;
                                            changeColor2 = false;
                                            changeColor4 = false;
                                            changeColor3 = true;
                                            textname = 'Synthetic Indices';
                                          });
                                        },
                                        child: Text(
                                          'Synthetic Indices',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      shape: Border(
                                          bottom: BorderSide(
                                              color: changeColor4
                                                  ? Theme.of(context)
                                                      .highlightColor
                                                  : Colors.transparent,
                                              width: 3.0)),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.black, // foreground

                                          // foreground
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            changeColor1 = false;
                                            changeColor = false;
                                            changeColor3 = false;
                                            changeColor2 = false;

                                            changeColor4 = true;
                                            textname = 'Cryptocurrencies';
                                          });
                                        },
                                        child: Text(
                                          'Cryptocurrencies',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          SearchField(
                              marginColor: Colors.black,
                              controller: selectedSymbol,
                              suggestions: list,
                              suggestionState: Suggestion.expand,
                              maxSuggestionsInViewPort: 5,
                              hint: 'Search Currency Pairs',
                              searchStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              searchInputDecoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                hintStyle: TextStyle(color: Colors.black),

                                // icon: Icon(Icons.search),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              onTap: (selectedSymbol) {
                                for (int i = 0; i < list.length; i++) {
                                  if (price['active_symbols'][i]
                                          ['display_name'] ==
                                      selectedSymbol.searchKey) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GraphScreen(
                                          symbolName: price['active_symbols'][i]
                                              ['display_name'],
                                          symbol: price['active_symbols'][i]
                                              ['symbol'],
                                          state: price['active_symbols'][i]
                                              ['exchange_is_open'],
                                          currency_symbol:
                                              price['active_symbols'][i]
                                                  ['quoted_currency_symbol'],
                                          apiToken: apiToken,
                                        ),
                                      ),
                                    );
                                  }
                                  ;
                                }
                                ;
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      elevation: 5,
                      //color: Colors.amberAccent,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(9)),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Name',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  'Last Price',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 78,
                        itemBuilder: (BuildContext context, int index) {
                          if (price['active_symbols'][index]
                                  ['market_display_name'] ==
                              textname) {
                            var formatPrice = NumberFormat.currency(
                                    customPattern: '##,##0.0####',
                                    decimalDigits: 5)
                                .format(price['active_symbols'][index]['spot']);

                            RegExp regex = RegExp(r'([.]*0+)(?!.*\d)');
                            String ongoingPrice =
                                formatPrice.toString().replaceAll(regex, '');

                            return Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GraphScreen(
                                        symbolName: price['active_symbols']
                                            [index]['display_name'],
                                        symbol: price['active_symbols'][index]
                                            ['symbol'],
                                        state: price['active_symbols'][index]
                                            ['exchange_is_open'],
                                        currency_symbol: price['active_symbols']
                                            [index]['quoted_currency_symbol'],
                                        apiToken: apiToken,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFF4F4F4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(50, 0, 60, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            '${price['active_symbols'][index]['display_name']}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                              '${ongoingPrice} ${price['active_symbols'][index]['quoted_currency_symbol']} ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ],
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
