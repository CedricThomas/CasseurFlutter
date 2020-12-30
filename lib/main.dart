import 'package:casseurflutter/redux/state.dart';
import 'package:casseurflutter/views/Initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'redux/store.dart';
import 'views/Home.dart';
import 'views/Login.dart';
import 'views/Logout.dart';
import 'views/Memos.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
          ),
        ),
        initialRoute: Initializer.id,
        routes: <String, WidgetBuilder>{
          Initializer.id: (BuildContext context) => Initializer(),
          Home.id: (BuildContext context) => Home(),
          Login.id: (BuildContext context) => Login(),
          Logout.id: (BuildContext context) => Logout(),
          Memos.id: (BuildContext context) => Memos(),
        },
      ),
    );
  }
}
