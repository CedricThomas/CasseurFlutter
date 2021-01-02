import 'package:bloc/bloc.dart';
import 'package:casseurflutter/models/models.dart';
import 'package:casseurflutter/services/services.dart';

import 'memos_event.dart';
import 'memos_state.dart';

class MemosBloc extends Bloc<MemosEvent, MemosState> {
  MemosBloc(APIService apiService)
      : assert(apiService != null),
        _apiService = apiService,
        _memos = List<Memo>.empty(),
        super(MemosInitial());

  final APIService _apiService;
  List<Memo> _memos;

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
      _memos = await _apiService.listMemos();
      yield MemosLoaded(_memos);
    } catch (err) {
      yield MemosFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }

  Stream<MemosState> _mapDeleteMemo(DeleteMemo event) async* {
    try {
      await _apiService.deleteMemo(event.id);
      _memos.removeWhere((Memo element) => element.id == event.id);
    } catch (err) {
      yield MemosFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }
}
