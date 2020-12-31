import 'package:casseurflutter/views/Home.dart';
import 'package:casseurflutter/widgets/scaffold.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Initializer extends StatelessWidget {
  static const String id = '/init';
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'A fatal error occurred',
              textDirection: TextDirection.ltr,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Future<void>.microtask(
            () => Navigator.pushReplacement(
              context,
              PageRouteBuilder<Home>(
                pageBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2) => Home(),
                transitionDuration: const Duration(seconds: 0),
              ),
            ),
          );
        }
        return const AppScaffold(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
