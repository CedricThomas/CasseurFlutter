import 'package:flutter/material.dart';

class CreateMemo extends StatefulWidget {
  static const String id = '/createMemo';

  @override
  _CreateMemo createState() => _CreateMemo();
}

class _CreateMemo extends State<CreateMemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casseur Flutter'),
      ),
      body: const SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
