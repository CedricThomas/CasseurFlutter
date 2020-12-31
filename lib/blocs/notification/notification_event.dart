import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

// Fired just after the app is launched
class AppLoadedNotification extends NotificationEvent {}

class RegisterNotification extends NotificationEvent {}
