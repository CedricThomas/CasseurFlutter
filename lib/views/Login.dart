import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';
import 'Memos.dart';

class Login extends StatefulWidget {
  static const String id = "/login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isBusy = false;
  String errorMessage;
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> loginAction() async {
    log("will login");
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse result =
      await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: ['openid', 'profile', 'offline_access', 'email'],
          // promptValues: ['login']
        ),
      );

      log("login received");
      log(result.toString());
      log(result.refreshToken);
      log(result.idToken);

      // final idToken = parseIdToken(result.idToken);
      // final profile = await getUserDetails(result.accessToken);

      await secureStorage.write(
          key: 'id_token', value: result.idToken);
      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
      });
      Navigator.pushNamed(context, Memos.id);
    } catch (e, s) {
      setState(() {
        isBusy = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "You must log yourself in order to use CasseurFlutter",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            decoration: TextDecoration.none,
            fontSize: 16,
            fontFamily: 'Roboto'
          ),
        ),
        Container(
          height: 40,
        ),
        ElevatedButton(
          onPressed: () {
            loginAction();
          },
          child: Text('Login'),
        ),
        Text(errorMessage ?? ''),
      ],
    );
  }
}