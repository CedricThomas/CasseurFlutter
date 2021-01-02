import 'package:bloc/bloc.dart';
import 'package:casseurflutter/models/models.dart';
import 'package:casseurflutter/services/services.dart';

import 'memos_event.dart';
import 'memos_state.dart';

class MemosBloc extends Bloc<MemosEvent, MemosState> {
  MemosBloc(APIService apiService)
      : assert(apiService != null),
        _apiService = apiService,
        super(MemosInitial());

  final APIService _apiService;

  @override
  Stream<MemosState> mapEventToState(MemosEvent event) async* {
    if (event is FetchMemos) {
      yield* _mapFetchMemos(event);
    }
    if (event is DeleteMemo) {
      yield* _mapDeleteMemo(event);
    }
  }

  Stream<MemosState> _mapFetchMemos(FetchMemos event) async* {
    try {
      yield MemosLoading();
      final List<Memo> memos = await _apiService.listMemos();
      yield MemosLoaded(memos);
    } catch (err) {
      yield MemosFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }

  Stream<MemosState> _mapDeleteMemo(DeleteMemo event) async* {
    try {
      await _apiService.deleteMemo(event.id);
    } catch (err) {
      yield MemosFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }
}
