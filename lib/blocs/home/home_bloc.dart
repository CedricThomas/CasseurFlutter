import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeLoaded) {
      yield* _mapHomeLoaded(event);
    }
    if (event is HomeAuthenticationCheckEnd) {
      yield* _mapHomeAuthenticationCheckEnd(event);
    }
  }

  Stream<HomeState> _mapHomeLoaded(HomeLoaded event) async* {
    yield HomeFirebaseInitialising();
    final FirebaseApp initialization = await Firebase.initializeApp();
    yield HomeFirebaseInitialized(initialization);
  }

  Stream<HomeState> _mapHomeAuthenticationCheckEnd(
      HomeAuthenticationCheckEnd event) async* {
    if (event.authenticated == true) {
      yield HomeAuthenticated();
    } else {
      yield HomeNotAuthenticated();
    }
  }
}
