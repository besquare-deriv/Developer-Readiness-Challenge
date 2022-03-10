// ignore_for_file: must_be_immutable, camel_case_types, no_logic_in_create_state

import 'package:flutter/material.dart';

class topList extends StatefulWidget {
  topList({required this.name, required this.toplist, Key? key})
      : super(key: key);
  var name = 'assets';
  var toplist = [];
  @override
  _topListState createState() => _topListState(name: name, toplist: toplist);
}

class _topListState extends State<topList> {
  _topListState({required this.name, required this.toplist});

  var name = 'assets';
  var toplist = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          child: Text(
            "TOP $name",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        Container(
          height: 110,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: Column(children: [
              Flexible(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Ticker          ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Price",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Change(%)",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 7,
                child: ListView.builder(
                  itemCount: toplist.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${toplist[index]['name']}',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Text('\$ ${toplist[index]['price']}'),
                          Text(
                            '${toplist[index]['change']}%',
                            style: (toplist[index]['change'] >= 0)
                                ? TextStyle(
                                    color: Colors.green,
                                  )
                                : TextStyle(
                                    color: Colors.red,
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ]),
          ),
        )
      ]),
    );
  }
}
