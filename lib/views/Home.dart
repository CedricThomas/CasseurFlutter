import 'dart:convert';

import 'package:casseurflutter/redux/actions.dart';
import 'package:casseurflutter/redux/actions/setIsAuthenticated.dart';
import 'package:casseurflutter/redux/actions/setProfile.dart';
import 'package:casseurflutter/redux/reducer.dart';
import 'package:casseurflutter/redux/state.dart';
import 'package:casseurflutter/utils/token.dart';
import 'package:casseurflutter/views/Logout.dart';
import 'package:casseurflutter/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';
import 'Login.dart';
import 'Memos.dart';

class Home extends StatefulWidget {
  static const String id = "/splashscreen";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isBusy = true;
  bool isLoggedIn = false;
  String errorMessage;
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  APIService api = APIService();

  @override
  Widget build(BuildContext context) {
    if (!isBusy) {
      Future.microtask(() => {
            if (!isLoggedIn)
              {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => Login(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                )
              }
            else
              {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => Memos(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                )
              }
          });
    }
    return AppScaffold(child: Center(child: CircularProgressIndicator()));
  }

  void logoutAction() async {
    Future.microtask(() => {
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => Logout(),
        transitionDuration: Duration(seconds: 0),
      ))
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    initAction();
  }

  void initAction() async {
    final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
    final storedIdToken = await secureStorage.read(key: 'id_token');
    if (storedRefreshToken == null || storedIdToken == null) {
      setState(() {
        isBusy = false;
        isLoggedIn = false;
      });
      dispatch(AppActions.setIsAuthenticated,
          SetIsAuthenticatedData(isAuthenticated: false));
      return;
    }

    try {
      Map<String, dynamic> orgParsedIdToken = parseIdToken(storedIdToken);
      if (!isTokenExpired(orgParsedIdToken)) {
        var profile = extractUserInfo(orgParsedIdToken);
        dispatch(AppActions.setIsAuthenticated,
            SetIsAuthenticatedData(isAuthenticated: true));
        dispatch(AppActions.setProfile, SetProfileData(profile: profile));
        setState(() {
          isBusy = false;
          isLoggedIn = true;
        });
        return;
      }

      final response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      final idToken = parseIdToken(response.idToken);
      var profile = extractUserInfo(idToken);

      await secureStorage.write(
          key: 'refresh_token', value: response.refreshToken);
      await secureStorage.write(key: 'id_token', value: response.idToken);
      dispatch(AppActions.setIsAuthenticated,
          SetIsAuthenticatedData(isAuthenticated: true));
      dispatch(AppActions.setProfile, SetProfileData(profile: profile));
      setState(() {
        isBusy = false;
        isLoggedIn = true;
      });
    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      logoutAction();
    }
    super.initState();
  }
}
