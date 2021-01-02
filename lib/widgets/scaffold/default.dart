import 'package:casseurflutter/widgets/scaffold/appbar/leading.dart';
import 'package:casseurflutter/widgets/scaffold/appbar/title.dart';
import 'package:casseurflutter/widgets/scaffold/drawer/default.dart';
import 'package:flutter/material.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DefaultDrawer(),
      appBar: AppBar(
        leading: AppBarLeading(),
        title: AppBarTitle(),
      ),
      body: Container(
        child: child,
        constraints: const BoxConstraints(minWidth: double.infinity),
      ),
    );
  }
}
