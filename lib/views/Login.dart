import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:casseurflutter/blocs/login/login.dart';
import 'package:casseurflutter/services/services.dart';
import 'package:casseurflutter/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    final APIService apiService = RepositoryProvider.of<APIService>(context);
    final AuthenticationBloc authBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => LoginBloc(authBloc, apiService),
      child: BlocConsumer<LoginBloc, LoginState>(
          listener: (BuildContext context, LoginState state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder<Memos>(
              pageBuilder: (BuildContext context, Animation<double> animation1,
                      Animation<double> animation2) =>
                  Memos(),
              transitionDuration: const Duration(seconds: 0),
            ),
          );
        }
      }, builder: (BuildContext context, LoginState state) {
        final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);

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
                  loginBloc.add(LoginInWithAuth0());
                },
                child: const Text('Login'),
              ),
              Text(errorMessage ?? ''),
            ],
          ),
        );
      }),
    );
  }
}
