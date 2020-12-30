import 'package:casseurflutter/redux/actions.dart';
import 'package:casseurflutter/redux/actions/setIsAuthenticated.dart';
import 'package:casseurflutter/redux/reducer.dart';
import 'package:casseurflutter/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Home.dart';

class Logout extends StatefulWidget {
  static const String id = '/logout';
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  bool isBusy = true;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    logoutAction();
  }

  Future<void> logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    await secureStorage.delete(key: 'id_token');
    dispatch(AppActions.setIsAuthenticated,
        SetIsAuthenticatedData(isAuthenticated: false));
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isBusy) {
      Future<void>.microtask(() => Navigator.pushReplacement(context, PageRouteBuilder<Home>(
        pageBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2) => Home(),
        transitionDuration: const Duration(seconds: 0),
      )));
    }
    return const AppScaffold(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
