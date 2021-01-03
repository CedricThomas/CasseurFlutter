import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:casseurflutter/blocs/home/home_bloc.dart';
import 'package:casseurflutter/blocs/home/home_event.dart';
import 'package:casseurflutter/blocs/home/home_state.dart';
import 'package:casseurflutter/blocs/notification/notification.dart';
import 'package:casseurflutter/views/Login.dart';
import 'package:casseurflutter/views/Memos.dart';
import 'package:casseurflutter/widgets/scaffold/appbar/title.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    final NotificationBloc notificationBloc =
        BlocProvider.of<NotificationBloc>(context);

    return BlocProvider<HomeBloc>(
      create: (BuildContext context) =>
          HomeBloc(notificationBloc)..add(HomeLoaded()),
      child: MultiBlocListener(
        listeners: <BlocListener<Bloc<Equatable, Equatable>, Equatable>>[
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (BuildContext context, AuthenticationState state) {
              final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
              if (state is AuthenticationAuthenticated) {
                homeBloc
                    .add(const HomeAuthenticationCheckEnd(authenticated: true));
                notificationBloc.add(RegisterNotification());
              } else if (state is AuthenticationNotAuthenticated) {
                homeBloc.add(
                    const HomeAuthenticationCheckEnd(authenticated: false));
              }
            },
          ),
          BlocListener<NotificationBloc, NotificationState>(
              listener: (BuildContext context, NotificationState state) {
            final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
            if (state is NotificationRegistered) {
              homeBloc.add(HomeNotificationCheckEnd());
            } else if (state is NotificationFailure) {
              homeBloc.add(HomeDeclareFailure(message: state.error));
            } else if (state is NotificationRefused) {
              homeBloc.add(HomeNotificationCheckEnd());
            }
          }),
          BlocListener<HomeBloc, HomeState>(
            listener: (BuildContext context, HomeState state) {
              if (state is HomeFirebaseInitialized) {
                authenticationBloc.add(HomeReady());
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
        child: Scaffold(
          appBar: AppBar(
            title: AppBarTitle(),
          ),
          body: Container(
            child: Center(
                child: errorMessage != null
                    ? Text(
                        errorMessage,
                        textDirection: TextDirection.ltr,
                      )
                    : const CircularProgressIndicator()),
            constraints: const BoxConstraints(minWidth: double.infinity),
          ),
        ),
      ),
    );
  }

  void validateHome(BuildContext context) {
    if (isFirebaseInitialized == false ||
        isFirebaseInitialized == null ||
        isLoggedIn == null) {
      return;
    }
    if (isLoggedIn == false) {
      Get.off<Login>(Login());
    } else if (isNotificationRegistered == true) {
      Get.off<Memos>(Memos());
    }
  }
}
