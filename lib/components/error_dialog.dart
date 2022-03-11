// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';

class errorDialog extends StatelessWidget {
  const errorDialog({required this.message, Key? key}) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    ;
  }
}
