import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../components/chart.dart';
import 'package:flutter/services.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key, required this.symbolName, required this.symbol})
      : super(key: key);
  final String symbolName;
  final String symbol;

  @override
  _GraphScreenState createState() =>
      _GraphScreenState(symbolName: symbolName, symbol: symbol);
}

class _GraphScreenState extends State<GraphScreen> {
  _GraphScreenState({required this.symbolName, required this.symbol});
  late ChartSeriesController _chartSeriesController;

// For now initializing this data, should get this variables from Maket page
  String symbolName;
  String symbol;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int counts = 4;
    var _inputAmount = 1000;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xFF1F96B0),
        title: Text(
          symbolName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 400,
            width: double.infinity,
            child: chartBuilder(
              symbol: symbol,
              counts: counts,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Icon(Icons.watch_later_outlined),
              ),
              Text(
                "Time Intervals",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ToggleSwitch(
                fontSize: 11,
                iconSize: 8.0,
                minWidth: 60,
                inactiveBgColor: Colors.grey.shade400,
                activeFgColor: Colors.black,
                activeBgColor: [Colors.grey],
                initialLabelIndex: 4,
                totalSwitches: 4,
                labels: ['1 Hour', '1 Day', '7 Days', '30 Days'],
                onToggle: (index) {
                  counts = index as int;
                },
              )
            ],
          ),
          Container(
            padding: EdgeInsets.all(8),
            width: 200,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(76, 76, 76, 76),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(left: 30, right: 20, bottom: 10),
                        hintText: "Enter your amount",
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      color: Color.fromARGB(76, 76, 76, 76),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(left: 30, right: 20, bottom: 10),
                        hintText: "",
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  onPressed: () {},
                  child: SizedBox(
                    height: 40,
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.black,
                        ),
                        Text(
                          "Rise",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {},
                  child: SizedBox(
                    height: 40,
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.arrow_downward,
                          color: Colors.black,
                        ),
                        Text(
                          "Fall",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
