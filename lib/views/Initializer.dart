import 'package:casseurflutter/views/Home.dart';
import 'package:casseurflutter/views/utils.dart';
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
            () => hardNavigate(context, Home()),
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
