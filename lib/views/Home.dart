import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:casseurflutter/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  void hardNavigation(Widget view) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder<Widget>(
        pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) =>
            view,
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) {
        if (state is AuthenticationAuthenticated) {
          hardNavigation(Memos());
        } else if (state is AuthenticationNotAuthenticated) {
          hardNavigation(Login());
        }
      },
      child:
          const AppScaffold(child: Center(child: CircularProgressIndicator())),
    );
  }
}
