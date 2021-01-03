import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object> get props => <Object>[];
}

class ReminderInitial extends ReminderState {}

class MemoReminder extends ReminderState {
  const MemoReminder(this.hasReminder, this.reminderId);

  final bool hasReminder;
  final String reminderId;

  @override
  List<Object> get props => <Object>[hasReminder, reminderId];
}

class ReminderFailure extends ReminderState {
  const ReminderFailure({@required this.error});

  final String error;

  @override
  List<Object> get props => <Object>[error];
}
