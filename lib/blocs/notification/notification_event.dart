import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class RegisterNotification extends NotificationEvent {}
