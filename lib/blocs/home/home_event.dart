import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => <Object>[];
}

class HomeLoaded extends HomeEvent {}

class HomeAuthenticationCheckEnd extends HomeEvent {
  const HomeAuthenticationCheckEnd({@required this.authenticated});

  final bool authenticated;

  @override
  List<Object> get props => <Object>[authenticated];
}

class HomeNotificationCheckEnd extends HomeEvent {}

class HomeDeclareFailure extends HomeEvent {
  const HomeDeclareFailure({@required this.message});

  final String message;

  @override
  List<Object> get props => <Object>[message];
}
