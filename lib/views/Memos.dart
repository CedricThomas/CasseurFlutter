import 'package:flutter/material.dart';

class Memos extends StatefulWidget {
  static const String id = "/memos";

  @override
  _MemosState createState() => _MemosState();
}

class _MemosState extends State<Memos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
      ],
    );
  }
}
