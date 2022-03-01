// ignore_for_file: avoid_unnecessary_containers, camel_case_types, prefer_const_constructors
import 'package:flutter/material.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({Key? key, required this.data, this.info}) : super(key: key);
  final data;
  final info;

  @override
  _ContractPageState createState() => _ContractPageState(this.data, this.info);
}

class _ContractPageState extends State<ContractPage> {
  _ContractPageState(this.data, this.info);
  final data;
  final info;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
              color: Colors.amber,
              child: Text('Welcome'),
              
            ),

            Container(
              color: Colors.amber,
              child: Text('${data.amount}'),
            ),

            Container(
              color: Colors.amber,
              child: Text('${data.action}'),
            ),
            ElevatedButton(onPressed: () {print(info.length);}, child: Text('Click me')),
          ],
        ),
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
  String toString() => '[ $action , $time , $id , $amount, $balance , $contract_id]';
}