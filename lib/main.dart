import 'package:casseurflutter/blocs/authentication/authentication_bloc.dart';
import 'package:casseurflutter/blocs/notification/notification.dart';
import 'package:casseurflutter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'views/Home.dart';
import 'views/Login.dart';
import 'views/Memos.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RepositoryProvider<APIService>(
    create: (BuildContext context) {
      return APIService();
    },
    // Injects the Authentication BLoC
    child: BlocProvider<AuthenticationBloc>(
      create: (BuildContext context) {
        final APIService authService =
            RepositoryProvider.of<APIService>(context);
        return AuthenticationBloc(authService);
      },
      child: BlocProvider<NotificationBloc>(
        create: (BuildContext context) {
          final APIService apiService = RepositoryProvider.of<APIService>(context);
          return NotificationBloc(apiService);
        },
        child: MyApp(),
      ),
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        ),
      ),
      initialRoute: Home.id,
      routes: <String, WidgetBuilder>{
        Home.id: (BuildContext context) => Home(),
        Login.id: (BuildContext context) => Login(),
        Memos.id: (BuildContext context) => Memos(),
      },
    );
  }
}
