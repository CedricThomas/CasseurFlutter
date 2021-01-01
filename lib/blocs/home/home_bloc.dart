import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

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
    messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // TODO(arthur): handle foreground notification
      }
    );
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

  Stream<HomeState> _mapHomeDeclareFailureToState(HomeDeclareFailure event) async* {
    yield HomeFailure(error: event.message);
  }
}
