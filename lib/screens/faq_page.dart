import 'package:flutter/material.dart';

class MyFAQsPage extends StatefulWidget {
  const MyFAQsPage({Key? key}) : super(key: key);

  @override
  _MyFAQsPage createState() => _MyFAQsPage();
}

class _MyFAQsPage extends State<MyFAQsPage> {
  //controller for TextField
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //backgroundColor: Color(0xFF1F96B0),
        title: const Text("FAQs", 
              style: TextStyle(/* color: Colors.white, */ fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Card(
            color: Theme.of(context).secondaryHeaderColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),

                ExpansionTile(
                  title: Text("What is Forex?",
                        style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                        )
                  ),
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  backgroundColor: Theme.of(context).selectedRowColor,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(25.0),
                      child: Text("Forex is the global decentralised market for the buying and selling of currencies.",
                            style: TextStyle(fontSize: 18.0, color: Colors.black),
                            textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),

                ExpansionTile(
                  title: Text("What is Cryptocurrency?",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)
                  ),
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  backgroundColor: Theme.of(context).selectedRowColor,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(25.0),
                      child: Text("A cryptocurrency is a digital or virtual currency that is secured by cryptography, which makes it nearly impossible to counterfeit or double-spend.",
                            style: TextStyle(fontSize: 18.0, color: Colors.black),
                            textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),

                 ExpansionTile(
                  title: Text("What markets can I trade on BeRAD?",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)
                  ),
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  backgroundColor: Theme.of(context).selectedRowColor,
                children: <Widget>[
                    Padding(padding: EdgeInsets.all(25.0),
                      child: Text("You can trade CFDs on forex and cryptocurrencies on BeRAD.",
                            style: TextStyle(fontSize: 18.0, color: Colors.black),
                            textAlign: TextAlign.left,
                      ),
                    ),
                  ], 
                ),

                ExpansionTile(
                  title: Text("How long does it take to process deposits and withdrawals?",
                          style: TextStyle(
                              //color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)
                  ),
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  backgroundColor: Theme.of(context).selectedRowColor,
                children: <Widget>[
                    Padding(padding: EdgeInsets.all(25.0),
                      child: Text("Your deposits and withdrawals will be processed within one business day (Monday to Friday, 9:00 am to 5:00 pm GMT+8) unless stated otherwise. Please note that your bank or money transfer service may require additional time to process your request.",
                            style: TextStyle(fontSize: 18.0, color: Colors.black),
                            textAlign: TextAlign.left,
                      ),
                    ),
                  ], 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}