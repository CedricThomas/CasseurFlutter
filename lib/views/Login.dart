import 'package:casseurflutter/redux/actions.dart';
import 'package:casseurflutter/redux/actions/setIsAuthenticated.dart';
import 'package:casseurflutter/redux/actions/setProfile.dart';
import 'package:casseurflutter/redux/reducer.dart';
import 'package:casseurflutter/redux/state.dart';
import 'package:casseurflutter/utils/token.dart';
import 'package:casseurflutter/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';
import 'Memos.dart';

class Login extends StatefulWidget {
  static const String id = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isBusy = false;
  String errorMessage;
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return AppScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You must log yourself in order to use CasseurFlutter',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontSize: 16,
                fontFamily: 'Roboto'),
          ),
          Container(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {
              loginAction();
            },
            child: const Text('Login'),
          ),
          Text(errorMessage ?? ''),
        ],
      ),
    );
  }
}
