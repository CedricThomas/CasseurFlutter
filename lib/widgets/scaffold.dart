import 'package:flutter/material.dart';

import 'drawer.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  AppScaffold({this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: AppDrawer(),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text("Casseur Flutter"),
      ),
      body: Container(child: this.child, constraints: BoxConstraints(minWidth: double.infinity),),
    );
  }
}