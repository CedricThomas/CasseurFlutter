import 'package:casseurflutter/widgets/fabCreateMemo.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({this.child});

  final Widget child;

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
        title: const Text('Casseur Flutter'),
      ),
      floatingActionButton: FabCreateMemo(),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/createMemo');
      //   },
      // ),
      body: Container(
        child: child,
        constraints: const BoxConstraints(minWidth: double.infinity),
      ),
    );
  }
}
