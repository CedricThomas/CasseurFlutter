import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:casseurflutter/blocs/home/home_bloc.dart';
import 'package:casseurflutter/blocs/home/home_event.dart';
import 'package:casseurflutter/blocs/home/home_state.dart';
import 'package:casseurflutter/views/Login.dart';
import 'package:casseurflutter/views/Memos.dart';
import 'package:casseurflutter/views/utils.dart';
import 'package:casseurflutter/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Home extends StatefulWidget {
  static const String id = '/splashscreen';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isFirebaseInitialized = true;
  bool isLoggedIn;
  String errorMessage;
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = HomeBloc();
    return BlocProvider<HomeBloc>(
        create: (BuildContext context) => homeBloc,
        child: MultiBlocListener(
          // ignore: always_specify_types
          listeners: [
            BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (BuildContext context, AuthenticationState state) {
                if (state is AuthenticationAuthenticated) {
                  homeBloc.add(
                      const HomeAuthenticationCheckEnd(authenticated: true));
                } else if (state is AuthenticationNotAuthenticated) {
                  homeBloc.add(
                      const HomeAuthenticationCheckEnd(authenticated: false));
                }
              },
            ),
            BlocListener<HomeBloc, HomeState>(
              listener: (BuildContext context, HomeState state) {
                if (state is HomeFirebaseInitialized) {
                  setState(() {
                    isFirebaseInitialized = true;
                    validateHome(context);
                  });
                } else if (state is HomeAuthenticated) {
                  setState(() {
                    isLoggedIn = true;
                    validateHome(context);
                  });
                } else if (state is HomeNotAuthenticated) {
                  setState(() {
                    isLoggedIn = false;
                    validateHome(context);
                  });
                } else if (state is HomeFailure) {
                  setState(() {
                    errorMessage = state.error;
                  });
                }
              },
            ),
          ],
          child: AppScaffold(
              child: Center(
                  child: errorMessage != null
                      ? Text(
                          errorMessage,
                          textDirection: TextDirection.ltr,
                        )
                      : const CircularProgressIndicator())),
        ));
  }

  void validateHome(BuildContext context) {
    if (isFirebaseInitialized == false || isLoggedIn == null) {
      return;
    }
    if (isLoggedIn == true) {
      hardNavigate(context, Login());
    } else {
      hardNavigate(context, Memos());
    }
  }
}
