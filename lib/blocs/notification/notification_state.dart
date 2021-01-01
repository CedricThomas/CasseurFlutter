import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => <Object>[];
}

class NotificationInitial extends NotificationState {}

class NotificationNotRegistered extends NotificationState {}

class NotificationRegistering extends NotificationState {}

class NotificationRegistered extends NotificationState {}

class NotificationRefused extends NotificationState {
  const NotificationRefused({@required this.error});

  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class NotificationFailure extends NotificationState {
  const NotificationFailure({@required this.error});

  final String error;

  @override
  List<Object> get props => <Object>[error];
}
