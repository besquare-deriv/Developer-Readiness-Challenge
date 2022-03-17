import 'package:flutter/material.dart';

class ContractDetails extends StatefulWidget {
  final data;
  final info;

  const ContractDetails({Key? key, required this.data, this.info})
      : super(key: key);

  @override
  _ContractDetailsState createState() =>
      _ContractDetailsState(this.data, this.info);
}

class _ContractDetailsState extends State<ContractDetails> {
  _ContractDetailsState(this.data, this.info);
  final data;
  final info;

  int? buyID;
  num buyPrice = 0;
  String startTime = "-";
  var sellID;
  num sellPrice = 0;
  String endTime = "-";
  Duration? duration;
  String? printDuration;
  var payoutLimit;
  num accountBalance = 0;
  num profitLoss = 0;
  var currencyType = "-";

  List output = [];
  List timeList = [];

  void comparison() {
    for (int i = 0; i < info.length; i++) {
      if (data.contract_id == info[i].contract_id) {
        output.add(info[i]);
      } 

    if(output.length == 2){
      setInfo();
    }
    else {  
          if(data.action == 'buy'){
            currencyType = data.symbolName;
          }
          else{
          currencyType = data.action;
          }
          buyID =data.id;
          buyPrice = data.amount;
          startTime = data.time;
          currencyType;
          sellID = '-';
          sellPrice = 0;
          endTime = '-';
          payoutLimit = 0;
          accountBalance = data.balance;
          printDuration = '-';
          profitLoss = data.amount;
      }
    }
  }

  void setInfo() {
    if (data.action == 'buy' || data.action == 'sell') {
      for (int i = 0; i <= output.length - 1; i++) {
        if (output[i].action == 'buy') {
          buyID = output[i].id;
          buyPrice = output[i].amount;
          startTime = output[i].time;
        }
        if (output[i].action == 'sell') {
          sellID = output[i].id;
          sellPrice = output[i].amount;
          endTime = output[i].time;
          accountBalance = output[i].balance;
        }
      }
      currencyType = data.symbolName;
      payoutLimit = data.payout;
      calDuration();
      calProfitLoss();
    }
  }

  void calDuration() {
    DateTime dt1 = DateTime.parse(startTime);
    if(endTime == '-'){
      printDuration = '-';
    }
    else{
    DateTime dt2 = DateTime.parse(endTime);
    duration = dt2.difference(dt1);
    //show days, hours, minutes and seconds
    if (duration!.inDays != 0) {
      if (duration!.inDays > 1) {
        if (duration!.inHours != 0 ||
            duration!.inMinutes.remainder(60) != 0 ||
            duration!.inSeconds.remainder(60) > 5) {
          printDuration = ('${duration!.inDays} days ' +
              '${duration!.inHours} hours ' +
              '${duration!.inMinutes.remainder(60)} minutes ' +
              '${duration!.inSeconds.remainder(60)} seconds');
        } else {
          printDuration = ('${duration!.inDays} days');
        }
      } else {
        if (duration!.inHours != 0 ||
            duration!.inMinutes.remainder(60) != 0 ||
            duration!.inSeconds.remainder(60) > 5) {
          printDuration = ('${duration!.inDays} day ' +
              '${duration!.inHours} hour ' +
              '${duration!.inMinutes.remainder(60)} minutes ' +
              '${duration!.inSeconds.remainder(60)} seconds');
        } else {
          printDuration = ('${duration!.inHours} hour');
        }
      }
    } else {
      //show hours, minutes and seconds
      if (duration!.inHours != 0) {
        if (duration!.inHours > 1) {
          if (duration!.inMinutes.remainder(60) != 0 ||
              duration!.inSeconds.remainder(60) > 5) {
            printDuration = ('${duration!.inHours} hours ' +
                '${duration!.inMinutes.remainder(60)} minutes ' +
                '${duration!.inSeconds.remainder(60)} seconds');
          } else {
            printDuration = ('${duration!.inHours} hours');
          }
        } else {
          if (duration!.inMinutes.remainder(60) != 0 ||
              duration!.inSeconds.remainder(60) > 5) {
            printDuration = ('${duration!.inHours} hour ' +
                '${duration!.inMinutes.remainder(60)} minutes ' +
                '${duration!.inSeconds.remainder(60)} seconds');
          } else {
            printDuration = ('${duration!.inHours} hour');
          }
        }
      } else {
        //shows minutes and seconds
        if (duration!.inMinutes != 0) {
          if (duration!.inMinutes > 1) {
            if (duration!.inSeconds.remainder(60) > 5) {
              printDuration = ('${duration!.inMinutes} minutes ' +
                  '${duration!.inSeconds.remainder(60)} seconds');
            } else {
              printDuration = ('${duration!.inMinutes} minutes');
            }
          } else {
            if (duration!.inSeconds.remainder(60) > 5) {
              printDuration = ('${duration!.inMinutes} minute ' +
                  '${duration!.inSeconds.remainder(60)} seconds');
            } else {
              printDuration = ('${duration!.inMinutes} minute');
            }
          }
        } else {
          //shows seconds only
          printDuration = ('${duration!.inSeconds} seconds');
        }
      }
    }
    }
  }

  void calProfitLoss() {
    profitLoss = sellPrice + buyPrice;
  }

  @override
  void initState() {
    comparison();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: const Color.fromRGBO(234, 230, 230, 1) ,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child:
              Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            padding:const EdgeInsets.only(top: 40),
            height: height*0.3,
            width:double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50), 
                bottomLeft: Radius.circular(50)), 
              color: Theme.of(context).appBarTheme.color ),
            child: Column(
              children: [
                  Padding(
                    padding: EdgeInsets.all(0),
                    child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child:  Container(
                            alignment: Alignment.centerLeft,
                            child: 
                              IconButton(
                                icon:  Icon(Icons.arrow_back,  color: Theme.of(context).appBarTheme.iconTheme?.color, size: 35,),                                   
                                onPressed: (){
                                    Navigator.pop(context);
                                }, 
                              ),
                          ),
                          ),
                          
                          Container(
                            alignment: Alignment.center,
                            child: Text('Contract Details',
                              style: TextStyle(
                              fontSize: 28, 
                              fontWeight: FontWeight.bold, 
                              fontFamily:'DM Sans',
                              ),
                            ),
                          ),
                          Spacer(),
                        ],)
                  ),
                  SizedBox(height:30),
                  Wrap(
                    children: <Widget>[
                      Text("$currencyType", 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //color:Colors.black, 
                            fontSize: 30, 
                            fontWeight: FontWeight.bold, 
                            fontFamily:'IBM Plex Sans'
                          ),
                      ),
                    ],
                  )        
              ]
              ),
            ),

        //Contract statement  
        Container(
          margin: EdgeInsets.only(top: height*0.35),
          padding: EdgeInsets.only(top: height*0.05885),
          width: 374.98,
          height: 467.94,
          decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(20), 
               color: Color(0xFFFFF4F4F4)),
          child: Wrap (
            direction: Axis.horizontal,
            spacing: 2,
            runSpacing: 15,
            children: <Widget> [
             Row(
              children: [
                Expanded(
                  child: Padding(padding:EdgeInsets.only(left: width*0.05093), 
                      child:Text('Buy ID', 
                              style: TextStyle(
                                color: Color.fromRGBO(126, 117, 117, 1),
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                              )
                        )
                    )
                  ),

                Padding(padding: EdgeInsets.only(right: width*0.05093),
                    child: Text('$buyID',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                            )
                      )
                  )
                ],
              ),
             Row(
              children: [
                Expanded(
                  child: Padding(padding:EdgeInsets.only(left: width*0.05093), 
                      child:Text('Buy Price', 
                              style: TextStyle(
                                color: Color.fromRGBO(126, 117, 117, 1),
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                              )
                        )
                    )
                  ),

                Padding(padding: EdgeInsets.only(right: width*0.05093),
                    child: Text('$buyPrice',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                            )
                      )
                  )
                ],
              ),
             Row(
              children: [
                Expanded(
                  child: Padding(padding:EdgeInsets.only(left: width*0.05093), 
                      child:Text('Start Time', 
                              style: TextStyle(
                                color: Color.fromRGBO(126, 117, 117, 1),
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                              )
                        )
                    )
                  ),

                Padding(padding: EdgeInsets.only(right: width*0.05093),
                    child: Text('$startTime GMT',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                            )
                      )
                  )
                ],
              ),
             SizedBox(height: 0.01), 

            const Divider(
              height: 10,
              thickness: 1,
              indent: 10,
              endIndent: 10,
              color: Color.fromRGBO(196, 196, 196, 1),
          ),

             SizedBox(height: 0.01), 

             Row(
              children: [
                Expanded(
                  child: Padding(padding:EdgeInsets.only(left: width*0.05093), 
                      child:Text('Sell ID', 
                              style: TextStyle(
                                color: Color.fromRGBO(126, 117, 117, 1),
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                              )
                        )
                    )
                  ),

                Padding(padding: EdgeInsets.only(right: width*0.05093),
                    child: Text('$sellID',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                            )
                      )
                  )
                ],
              ),
             Row(
              children: [
                Expanded(
                  child: Padding(padding:EdgeInsets.only(left: width*0.05093), 
                      child:Text('Sell Price', 
                              style: TextStyle(
                                color: Color.fromRGBO(126, 117, 117, 1),
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                              )
                        )
                    )
                  ),

                Padding(padding: EdgeInsets.only(right: width*0.05093),
                    child: Text('$sellPrice',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                            )
                      )
                  )
                ],
              ),
             Row(
              children: [
                Expanded(
                  child: Padding(padding:EdgeInsets.only(left: width*0.05093), 
                      child:Text('End Time', 
                              style: TextStyle(
                                color: Color.fromRGBO(126, 117, 117, 1),
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                              )
                        )
                    )
                  ),

                Padding(padding: EdgeInsets.only(right: width*0.05093),
                    child: Text('$endTime GMT',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                            )
                      )
                  )
                ],
              ),
             SizedBox(height: 0.01), 

            const Divider(
              height: 10,
              thickness: 1,
              indent: 10,
              endIndent: 10,
              color: Color.fromRGBO(196, 196, 196, 1),
          ),

             SizedBox(height: 0.01), 

            Row(
              children: [
                Expanded(
                   child:  Padding(padding:EdgeInsets.only(left: width*0.05093), 
                      child:Text('Duration', 
                              style: TextStyle(
                                color: Color.fromRGBO(126, 117, 117, 1),
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                              )
                        )
                    ),
                  ),

                //Wrap(children: [
                  Expanded(
                  flex: 3,
                  child: Padding(padding: EdgeInsets.only(right: width*0.05093),
                    child: Text('$printDuration',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                            )
                      )
                  ),)
                  
                //],)
                
                ],
              ),
            Row(
              children: [
                Expanded(
                  child: Padding(padding:EdgeInsets.only(left: width*0.05093), 
                      child:Text('Payout Limit', 
                              style: TextStyle(
                                color: Color.fromRGBO(126, 117, 117, 1),
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                              )
                        )
                    )
                  ),

                Padding(padding: EdgeInsets.only(right: width*0.05093),
                    child: Text('$payoutLimit',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                            )
                      )
                  )
                ],
              ),
            /* const SizedBox(height: 10), */
            Row(
              children: [
                Expanded(
                  child: Padding(padding:EdgeInsets.only(left: width*0.05093), 
                      child:Text('Account Balance', 
                              style: TextStyle(
                                color: Color.fromRGBO(126, 117, 117, 1),
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                              )
                        )
                    )
                  ),

                Padding(padding: EdgeInsets.only(right: width*0.05093),
                    child: Text('$accountBalance',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'IBM Plex Sans'
                            )
                      )
                  )
                ],
              ),
          ],
          )
        ), 

        // Profit/Loss statement
        Container(
             margin: EdgeInsets.only(top:height*0.2607),
             padding: EdgeInsets.only(top:height*0.02634),
             width: width*0.7384,
             height: height*0.1304,
             decoration: BoxDecoration(
               border: Border.all(color: Colors.black, width: 1.5),
               borderRadius: BorderRadius.circular(20), 
               color: Color(0xFFC4C4C4)
             ),
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
        Container(
          child: Text( profitLoss >= 0 ?"+${profitLoss.toStringAsFixed(2)}" :"${profitLoss.toStringAsFixed(2)}", 
                    style: TextStyle(
                        fontSize: 25, 
                        fontWeight: FontWeight.bold,
                        fontFamily:'DM Sans',
                        color: profitLoss >= 0 ? Color.fromRGBO(54, 98, 43, 1) : Color.fromRGBO(232, 69, 69,1)
                      ),
          ), 
          alignment: Alignment.center,
        ),
  ]
  ),
),
      ],
      ),
      ),
    );
  }
}