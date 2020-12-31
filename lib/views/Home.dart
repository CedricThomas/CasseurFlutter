import 'dart:developer';

import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:casseurflutter/blocs/home/home_bloc.dart';
import 'package:casseurflutter/blocs/home/home_event.dart';
import 'package:casseurflutter/blocs/home/home_state.dart';
import 'package:casseurflutter/blocs/notification/notification.dart';
import 'package:casseurflutter/services/services.dart';
import 'package:casseurflutter/views/Login.dart';
import 'package:casseurflutter/views/Memos.dart';
import 'package:casseurflutter/views/utils.dart';
import 'package:casseurflutter/widgets/scaffold.dart';
import 'package:equatable/equatable.dart';
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
  bool isNotificationRegistered;
  String errorMessage;
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final APIService apiService = RepositoryProvider.of<APIService>(context);
    final HomeBloc homeBloc = HomeBloc();
    final NotificationBloc notificationBloc = NotificationBloc(apiService);

    return BlocProvider<HomeBloc>(
        create: (BuildContext context) => homeBloc,
        child: MultiBlocListener(
          listeners: <BlocListener<Bloc<Equatable, Equatable>, Equatable>>[
            BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (BuildContext context, AuthenticationState state) {
                if (state is AuthenticationAuthenticated) {
                  homeBloc.add(
                      const HomeAuthenticationCheckEnd(authenticated: true));
                  notificationBloc.add(RegisterNotification());
                } else if (state is AuthenticationNotAuthenticated) {
                  homeBloc.add(
                      const HomeAuthenticationCheckEnd(authenticated: false));
                }
              },
            ),
            BlocListener<NotificationBloc, NotificationState>(
                listener: (BuildContext context, NotificationState state) {
                  log('notification event received');
                  log(state.toString());
              if (state is NotificationRegistered) {
                homeBloc
                    .add(HomeNotificationCheckEnd());
              } else if (state is NotificationFailure) {
                homeBloc.add(HomeDeclareFailure(message: state.error));
              } else if (state is NotificationRefused) {
                homeBloc
                    .add(HomeNotificationCheckEnd());
              }
            }),
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
                } else if (state is HomeNotificationRegistered) {
                  setState(() {
                    isNotificationRegistered = true;
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
    log('validate home');
    log(isFirebaseInitialized.toString());
    log(isLoggedIn.toString());
    log(isNotificationRegistered.toString());
    if (isFirebaseInitialized == false || isLoggedIn == null) {
      return;
    }
    if (isLoggedIn == false) {
      hardNavigate(context, Login());
    } else if (isNotificationRegistered == true) {
      hardNavigate(context, Memos());
    }
  }
}
