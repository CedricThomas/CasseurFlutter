import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class HomeInitial extends HomeState {}

class HomeFirebaseInitialising extends HomeState {}

class HomeFirebaseInitialized extends HomeState {
  HomeFirebaseInitialized(this.firebaseApp);

  final FirebaseApp firebaseApp;
}

class HomeAuthenticated extends HomeState {}

class HomeNotAuthenticated extends HomeState {}

class HomeNotificationRegistered extends HomeState {}

class HomeFailure extends HomeState {
  HomeFailure({@required this.error});

  final String error;

  @override
  List<Object> get props => <Object>[error];
}
