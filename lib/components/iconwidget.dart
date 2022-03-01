import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final IconData icon;

  const IconWidget
({ Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF08D9D6),
      ),
      child: Icon(icon, color: Colors.black, ),
    );
      
  }
}