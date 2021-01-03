import 'package:casseurflutter/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class MemoEvent extends Equatable {
  const MemoEvent(this.memoId);

  final String memoId;

  @override
  List<Object> get props => <Object>[memoId];
}

class FetchFirstReminder extends MemoEvent {
  const FetchFirstReminder(String memoId) : super(memoId);
}

class AddReminder extends MemoEvent {
  const AddReminder(String id, this.reminderCreationRequest) : super(id);
  final CreateReminderRequest reminderCreationRequest;
}

class DeleteReminder extends MemoEvent {
  const DeleteReminder(String memoId, this.reminderId) : super(memoId);
  final String reminderId;

  @override
  List<Object> get props => <Object>[memoId, reminderId];
}
