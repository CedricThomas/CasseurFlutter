import 'package:casseurflutter/views/Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Initializer extends StatelessWidget {
  static const String id = "/init";
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // final Future<FirebaseApp> _initialization = Future.delayed(
  //     Duration(seconds: 10), () => Firebase.initializeApp());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "A fatal error occurred",
              textDirection: TextDirection.ltr,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Future.microtask(
            () => Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Home(),
                transitionDuration: Duration(seconds: 0),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
