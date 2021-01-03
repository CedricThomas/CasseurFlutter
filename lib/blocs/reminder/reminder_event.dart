import 'package:casseurflutter/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class ReminderEvent extends Equatable {
  const ReminderEvent(this.memoId);

  final String memoId;

  @override
  List<Object> get props => <Object>[memoId];
}

class FetchFirstReminder extends ReminderEvent {
  const FetchFirstReminder(String memoId) : super(memoId);
}

class AddReminder extends ReminderEvent {
  const AddReminder(String id, this.reminderCreationRequest) : super(id);
  final CreateReminderRequest reminderCreationRequest;
}

class DeleteReminder extends ReminderEvent {
  const DeleteReminder(String memoId, this.reminderId) : super(memoId);
  final String reminderId;

  @override
  List<Object> get props => <Object>[memoId, reminderId];
}
