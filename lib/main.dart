import 'dart:developer';

import 'package:casseurflutter/redux/actions.dart';
import 'package:casseurflutter/redux/actions/setIsAuthenticated.dart';
import 'package:casseurflutter/redux/reducer.dart';
import 'package:casseurflutter/redux/state.dart';
import 'package:casseurflutter/views/Router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final store = new Store<AppState>(reducer, initialState: AppState());
  log(store.toString());
  runApp(MyApp(store: store,));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({Key key, this.store}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    dispatch(store, AppActions.setIsAuthenticated, SetIsAuthenticatedData(isAuthenticated: true));
    return StoreProvider<AppState>(
      store: store,
      child: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                child: Text(
                  "A fatal error occurred",
                  textDirection: TextDirection.ltr,
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return InternalRouter();
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text(
                "Loading",
                textDirection: TextDirection.ltr,
              ),
            );
          }),
    );
  }
}
