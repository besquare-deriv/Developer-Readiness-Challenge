import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            primary: Color(0xFFF2B363F),
            onPrimary: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            minimumSize: const Size(300.0, 50.0)),
        child: Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
        onPressed: onClicked,
      );
}
