import 'package:casseurflutter/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class Memos extends StatefulWidget {
  static const String id = '/memos';

  @override
  _MemosState createState() => _MemosState();
}

class _MemosState extends State<Memos> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const<Widget>[
          Text('Memos'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
