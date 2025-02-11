import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:casseurflutter/blocs/login/login.dart';
import 'package:casseurflutter/services/services.dart';
import 'package:casseurflutter/widgets/login/avatar.dart';
import 'package:casseurflutter/widgets/login/button.dart';
import 'package:casseurflutter/widgets/scaffold/appbar/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'Home.dart';

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
            Get.off<Home>(Home());
          }
        },
        builder: (BuildContext context, LoginState state) {
          final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);

          return Scaffold(
            appBar: AppBar(
              title: AppBarTitle(),
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: LoginAvatar(),
                  ),
                  const SizedBox(height: 300),
                  Container(
                    width: MediaQuery.of(context).size.width * 4 / 5,
                    child: LoginButton(
                      onPressed: () {
                        loginBloc.add(LoginInWithAuth0());
                      },
                    ),
                  )
                ],
              ),
              constraints: const BoxConstraints(minWidth: double.infinity),
            ),
          );
        },
      ),
    );
  }
}
