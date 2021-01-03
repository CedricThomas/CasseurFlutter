import 'package:bloc/bloc.dart';
import 'package:casseurflutter/models/models.dart';
import 'package:casseurflutter/services/services.dart';

import 'reminder_event.dart';
import 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc(APIService apiService)
      : assert(apiService != null),
        _apiService = apiService,
        super(ReminderInitial());

  final APIService _apiService;

  @override
  Stream<ReminderState> mapEventToState(ReminderEvent event) async* {
    if (event is FetchFirstReminder) {
      yield* _mapFetchFirstReminder(event);
    }
    if (event is DeleteReminder) {
      yield* _mapDeleteReminder(event);
    }
    if (event is AddReminder) {
      yield* _mapSetReminder(event);
    }
  }

  Stream<ReminderState> _mapFetchFirstReminder(
      FetchFirstReminder event) async* {
    try {
      final Reminder reminder =
          await _apiService.getFirstReminder(event.memoId);
      yield MemoReminder(
          reminder != null, reminder != null ? reminder.id : null);
    } catch (err) {
      yield ReminderFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }

  Stream<ReminderState> _mapDeleteReminder(DeleteReminder event) async* {
    try {
      await _apiService.deleteReminder(event.memoId, event.reminderId);
      add(FetchFirstReminder(event.memoId));
    } catch (err) {
      yield ReminderFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }

  Stream<ReminderState> _mapSetReminder(AddReminder event) async* {
    try {
      await _apiService.createReminder(
          event.memoId, event.reminderCreationRequest);
      add(FetchFirstReminder(event.memoId));
    } catch (err) {
      yield ReminderFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }
}
