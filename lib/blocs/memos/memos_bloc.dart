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
      yield* _mapLoginInWithAuth0ToState(event);
    }
  }

  Stream<MemosState> _mapLoginInWithAuth0ToState(FetchMemos event) async* {
    try {
      final List<Memo> memos = await _apiService.listMemos();
      yield MemosLoaded(memos: memos);
    } catch (err) {
      yield MemosFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }
}
