import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class NotificationInitial extends NotificationState {}

class NotificationNotRegistered extends NotificationState {}

class NotificationRegistering extends NotificationState {}

class NotificationRegistered extends NotificationState {}

class NotificationRefused extends NotificationState {
  NotificationRefused({@required this.error});

  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class NotificationFailure extends NotificationState {
  NotificationFailure({@required this.error});

  final String error;

  @override
  List<Object> get props => <Object>[error];
}
