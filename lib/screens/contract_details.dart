import 'package:drc/screens/explorer_page.dart';
import 'package:flutter/material.dart';

import 'graph_page.dart';
import 'history_page.dart';
import 'login_page.dart';
import 'market_list_page.dart';
import 'profile_page.dart';

class ContractDetails extends StatelessWidget {
  ContractDetails({Key? key}) : super(key: key);

  var buyID = "312411681348";
  var buyPrice = -102.37;
  var startTime = '2022-02-15 08:48:17 GMT';
  var sellID = "312411810668";
  var sellPrice = 200;
  var endTime = '2022-02-15 08:49:17 GMT';
  var duration = "1 Minute";
  var payoutLimit = 200;
  var accountBalance = "13311.66 USD";
  var profitLoss = "+56.31";
  var currencyType = "BTC/USD";


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 230, 230, 1) ,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child:
              Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            padding:const EdgeInsets.symmetric(vertical: 40),
            height: height*0.25,
            width:width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50), 
                bottomLeft: Radius.circular(50)), 
              color: Color.fromRGBO(31, 150, 176,1)),
            child: Column(
              children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child:
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 35,),                                   
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HistoryScreen()));
                              }, 
                            ),
                        ),
                        Container(
                          margin:EdgeInsets.symmetric(horizontal: width*0.1),
                          alignment: Alignment.center,
                          child: Text('Contract Details',
                            /* textAlign: TextAlign.center, */
                            style: TextStyle(
                            color:Colors.black, 
                            fontSize: 28, 
                            fontWeight: FontWeight.bold, 
                            fontFamily:'DM Sans',
                            ),
                          ),
                        ),
                      ],)
                  ),

                  Container(
                    child:
                      Text("$currencyType", 
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:Colors.black, 
                          fontSize: 36, 
                          fontWeight: FontWeight.bold, 
                          fontFamily:'IBM Plex Sans'
                                    ),
                                  ),
                  ),
              ]
                    ),),

        //Contract statement  
        Container(
          margin: EdgeInsets.only(top: height*0.3),
          padding: EdgeInsets.symmetric(vertical: height*0.06585),
          width:width*0.9548,
          height: height*0.5663,
          decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(20), 
               color: Colors.white),
          child: Wrap (
            direction: Axis.horizontal,
            spacing: 2,
            children: <Widget> [
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                padding:  EdgeInsets.symmetric(vertical: 0, horizontal: width*0.05093),
                child: const Text('Buy ID', 
                            style: TextStyle(
                              color: Color.fromRGBO(126, 117, 117, 1),
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans'))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child:  Text(buyID,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans')))
            ],),
             SizedBox(height: height*0.01317),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child: const Text('Buy Price', 
                            style: TextStyle(
                              color: Color.fromRGBO(126, 117, 117, 1),
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans'))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child: Text("$buyPrice",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans')))
            ],),
            SizedBox(height: height*0.01317),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child: const Text('Start Time', 
                            style: TextStyle(
                              color: Color.fromRGBO(126, 117, 117, 1),
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans'))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child:  Text(startTime,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans')))
            ],),
            SizedBox(height: height*0.03293),

            const Divider(
              height: 10,
              thickness: 1,
              indent: 10,
              endIndent: 10,
              color: Color.fromRGBO(196, 196, 196, 1),
          ),

            SizedBox(height: height*0.03293),

             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child: const Text('Sell ID', 
                            style: TextStyle(
                              color: Color.fromRGBO(126, 117, 117, 1),
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans'))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child: Text(sellID,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans')))
            ],),
            SizedBox(height: height*0.01317),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child: const Text('Sell Price', 
                            style: TextStyle(
                              color: Color.fromRGBO(126, 117, 117, 1),
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans'))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child:  Text("$sellPrice",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans')))
            ],),
            SizedBox(height: height*0.01317),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child: const Text('End Time', 
                            style: TextStyle(
                              color: Color.fromRGBO(126, 117, 117, 1),
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans'))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child:  Text(endTime,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans')))
            ],),
            SizedBox(height: height*0.03293),

            const Divider(
              height: 10,
              thickness: 1,
              indent: 10,
              endIndent: 10,
              color: Color.fromRGBO(196, 196, 196, 1),
          ),

            SizedBox(height: height*0.03293),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child: const Text('Duration', 
                            style: TextStyle(
                              color: Color.fromRGBO(126, 117, 117, 1),
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans'))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child:  Text(duration,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans')))
            ],),
            SizedBox(height: height*0.01317),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child: const Text('Payout limit', 
                            style: TextStyle(
                              color: Color.fromRGBO(126, 117, 117, 1),
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans'))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child: Text("$payoutLimit",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans')))
            ],),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child: const Text('Account balance', 
                            style: TextStyle(
                              color: Color.fromRGBO(126, 117, 117, 1),
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans'))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.05093),
                child:  Text("$accountBalance",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'IBM Plex Sans')))
            ],),
          ],)
        ), 


        // Profit/Loss statement
        Container(
             margin: EdgeInsets.only(top:height*0.2107),
             padding: EdgeInsets.symmetric(vertical:height*0.02634),
             width: width*0.7384,
             height: height*0.1264,
             decoration: BoxDecoration(
               border: Border.all(color: Colors.black, width: 1.5),
               borderRadius: BorderRadius.circular(20), 
               color: const Color(0xFFC4C4C4),),
                child: Column( children: <Widget>[
                  Container(child: const Text('Total profit/loss',
                                      style: TextStyle(
                                           color:Colors.black, 
                                           fontSize: 20, 
                                           fontFamily:'IBM Plex Sans'
                                           ),
                                          ), 
                  alignment: Alignment.center,
    ),
    Container(child: Text("$profitLoss", style: TextStyle(
                                           color:Color.fromRGBO(54, 98, 43, 1),
                                           fontSize: 25, 
                                           fontWeight: FontWeight.bold,
                                           fontFamily:'DM Sans'
                                           ),
                                          ), 
                  alignment: Alignment.center,),
  ]
  ),
),
      ],
      ),
      ),

      bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: const Icon(Icons.home), 
                          iconSize: 40,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                        ),
              
              IconButton(icon: Image.asset('assets/icons/explore.png'), 
                          iconSize: 40,
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ExplorePage()));
                          }
                        ),
                        
              IconButton(icon: Image.asset('assets/icons/plus.png'), 
                          iconSize: 70,
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MarketScreen()));
                          }
                        ),
        
              IconButton(icon: Image.asset('assets/icons/history.png'), 
                          iconSize: 40,
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HistoryScreen()));
                          }
                        ),

              IconButton(icon: Image.asset('assets/icons/user.png'), 
                          iconSize: 40,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage()));
                          }
                        ),
            ],
          ),
          shape: CircularNotchedRectangle(),
          color: Colors.black,
        ),
           //),
    //);
    );
    }
}
