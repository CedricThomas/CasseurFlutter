import 'package:bloc/bloc.dart';
import 'package:casseurflutter/models/models.dart';
import 'package:casseurflutter/services/services.dart';

import 'memo_event.dart';
import 'memo_state.dart';

class MemoBloc extends Bloc<MemoEvent, MemoState> {
  MemoBloc(APIService apiService)
      : assert(apiService != null),
        _apiService = apiService,
        super(MemoInitial());

  final APIService _apiService;

  @override
  Stream<MemoState> mapEventToState(MemoEvent event) async* {
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

  Stream<MemoState> _mapFetchFirstReminder(FetchFirstReminder event) async* {
    try {
      final Reminder reminder =
          await _apiService.getFirstReminder(event.memoId);
      yield MemoReminder(
          reminder != null, reminder != null ? reminder.id : null);
    } catch (err) {
      yield MemoFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }

  Stream<MemoState> _mapDeleteReminder(DeleteReminder event) async* {
    try {
      await _apiService.deleteReminder(event.memoId, event.reminderId);
      add(FetchFirstReminder(event.memoId));
    } catch (err) {
      yield MemoFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }

  Stream<MemoState> _mapSetReminder(AddReminder event) async* {
    try {
      await _apiService.createReminder(
          event.memoId, event.reminderCreationRequest);
      add(FetchFirstReminder(event.memoId));
    } catch (err) {
      yield MemoFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }
}
