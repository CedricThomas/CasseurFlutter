import 'package:casseurflutter/redux/actions.dart';
import 'package:casseurflutter/redux/actions/setIsAuthenticated.dart';
import 'package:casseurflutter/redux/actions/setProfile.dart';
import 'package:casseurflutter/redux/reducer.dart';
import 'package:casseurflutter/redux/state.dart';
import 'package:casseurflutter/utils/token.dart';
import 'package:casseurflutter/views/Logout.dart';
import 'package:casseurflutter/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';
import 'Login.dart';
import 'Memos.dart';

class Home extends StatefulWidget {
  static const String id = '/splashscreen';

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
      Future<void>.microtask(() => <void>{
            if (!isLoggedIn)
              <void>{
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder<Login>(
                    pageBuilder: (BuildContext context,
                            Animation<double> animation1,
                            Animation<double> animation2) =>
                        Login(),
                    transitionDuration: const Duration(seconds: 0),
                  ),
                )
              }
            else
              <void>{
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder<Memos>(
                    pageBuilder: (BuildContext context,
                            Animation<double> animation1,
                            Animation<double> animation2) =>
                        Memos(),
                    transitionDuration: const Duration(seconds: 0),
                  ),
                )
              }
          });
    }
    return const AppScaffold(child: Center(child: CircularProgressIndicator()));
  }

  Future<void> logoutAction() async {
    Future<void>.microtask(() => <void>{
          Navigator.pushReplacement(
              context,
              PageRouteBuilder<Logout>(
                pageBuilder: (BuildContext context,
                        Animation<double> animation1,
                        Animation<double> animation2) =>
                    Logout(),
                transitionDuration: const Duration(seconds: 0),
              ))
        });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    initAction();
  }

  Future<void> initAction() async {
    final String storedRefreshToken =
        await secureStorage.read(key: 'refresh_token');
    final String storedIdToken = await secureStorage.read(key: 'id_token');
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
      final Map<String, dynamic> orgParsedIdToken = parseIdToken(storedIdToken);
      if (!isTokenExpired(orgParsedIdToken)) {
        final ProfileState profile = extractUserInfo(orgParsedIdToken);
        dispatch(AppActions.setIsAuthenticated,
            SetIsAuthenticatedData(isAuthenticated: true));
        dispatch(AppActions.setProfile, SetProfileData(profile: profile));
        setState(() {
          isBusy = false;
          isLoggedIn = true;
        });
        return;
      }

      final TokenResponse response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      final Map<String, dynamic> idToken = parseIdToken(response.idToken);
      final ProfileState profile = extractUserInfo(idToken);

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
