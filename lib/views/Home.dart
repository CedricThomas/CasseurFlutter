import 'dart:convert';
import 'dart:developer';
import 'package:casseurflutter/redux/actions.dart';
import 'package:casseurflutter/redux/actions/setIsAuthenticated.dart';
import 'package:casseurflutter/redux/reducer.dart';
import 'package:casseurflutter/redux/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';

import '../constants.dart';
import 'Login.dart';
import 'Memos.dart';

class Home extends StatefulWidget {
  static const String id = "/";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isBusy = true;
  bool isLoggedIn = false;
  String errorMessage;
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    if (!isBusy) {
      Future.microtask(() =>
      {
        if (!isLoggedIn) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => Login(),
              transitionDuration: Duration(seconds: 0),
            ),
          )
        } else
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
    return Center(child: CircularProgressIndicator());
  }

  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  bool isTokenExpired(Map<String, dynamic> parsedIdToken) {
    var expDate = DateTime.fromMillisecondsSinceEpoch(parsedIdToken['exp'] * 1000);
    return expDate.isBefore(DateTime.now());
  }

  ProfileState extractUserInfo(Map<String, dynamic> parsedIdToken) {
    var p = ProfileState();
    p.name = parsedIdToken['name'];
    p.email = parsedIdToken['email'];
    p.avatar = parsedIdToken['picture'];
    return p;
  }

  void logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  @override
  void setState(fn) {
    if(mounted) {
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
        ProfileState profile = extractUserInfo(orgParsedIdToken);
        dispatch(AppActions.setIsAuthenticated,
            SetIsAuthenticatedData(isAuthenticated: true));
        dispatch(AppActions.setProfile, profile);
        setState(() {
          isBusy = false;
          isLoggedIn = true;
        });
        return;
      }
      log("will try to refresh");

      // final response = await appAuth.token(TokenRequest(
      //   AUTH0_CLIENT_ID,
      //   AUTH0_REDIRECT_URI,
      //   issuer: AUTH0_ISSUER,
      //   refreshToken: storedRefreshToken,
      // ));
      log("is refreshed");

      // final idToken = parseIdToken(response.idToken);
      // final profile = await getUserDetails(response.accessToken);

      // secureStorage.write(key: 'refresh_token', value: response.refreshToken);
      dispatch(AppActions.setIsAuthenticated,
          SetIsAuthenticatedData(isAuthenticated: true));

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        // name = idToken['name'];
        // picture = profile['picture'];
      });
    } catch (e, s) {
      log("could not refresh token");
      print('error on refresh token: $e - stack: $s');
      // logoutAction();
    }
  }
}
