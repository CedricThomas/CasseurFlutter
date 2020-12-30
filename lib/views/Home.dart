import 'package:casseurflutter/services/api.dart';
import 'package:flutter/material.dart';

import '../widgets/login.dart';
import '../widgets/profile.dart';

class Home extends StatefulWidget {
  static const String id = "/";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String name;
  String picture;

  APIService api = APIService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth0 Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Center(
          child: isBusy
              ? CircularProgressIndicator()
              : api.isLoggedIn
                  ? Profile(api.logout, name, picture)
                  : Login(api.login, errorMessage),
        ),
      ),
    );
  }

  @override
  void initState() {
    try {
      api.refreshToken();
    } on RefreshException catch (e) {
      errorMessage = e.toString();
    }
    super.initState();
  }
}
