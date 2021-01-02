import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:casseurflutter/blocs/notification/notification_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this.notificationBloc) : super(HomeInitial());

  final NotificationBloc notificationBloc;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeLoaded) {
      yield* _mapHomeLoadedToState(event);
    }
    if (event is HomeAuthenticationCheckEnd) {
      yield* _mapHomeAuthenticationCheckEndToState(event);
    }
    if (event is HomeNotificationCheckEnd) {
      yield* _mapHomeNotificationCheckEndToState(event);
    }
    if (event is HomeDeclareFailure) {
      yield* _mapHomeDeclareFailureToState(event);
    }
  }

  Stream<HomeState> _mapHomeLoadedToState(HomeLoaded event) async* {
    yield HomeFirebaseInitialising();
    final FirebaseApp initialization = await Firebase.initializeApp();
    final FirebaseMessaging messaging = FirebaseMessaging();
    messaging.configure(onMessage: (Map<String, dynamic> message) async {
      final Map<String, String> notif = Map<String, String>.from(
          message['notification'] as Map<dynamic, dynamic>);
      final String data = jsonEncode(message['data'] as Map<dynamic, dynamic>);
      notificationBloc.showNotification(
          1234, notif['title'], notif['body'], data);
    });
    yield HomeFirebaseInitialized(initialization);
  }

  Stream<HomeState> _mapHomeAuthenticationCheckEndToState(
      HomeAuthenticationCheckEnd event) async* {
    if (event.authenticated == true) {
      yield HomeAuthenticated();
    } else {
      yield HomeNotAuthenticated();
    }
  }

  Stream<HomeState> _mapHomeNotificationCheckEndToState(
      HomeNotificationCheckEnd event) async* {
    yield HomeNotificationRegistered();
  }

  Stream<HomeState> _mapHomeDeclareFailureToState(
      HomeDeclareFailure event) async* {
    yield HomeFailure(error: event.message);
  }
}
