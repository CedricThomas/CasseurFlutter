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
    if (event is FetchMemo) {
      yield* _mapFetchMemo(event);
    }
  }

  Stream<MemoState> _mapFetchMemo(FetchMemo event) async* {
    try {
      final Memo memo = await _apiService.getMemo(event.memoId);
      yield MemoLoaded(memo);
    } catch (err) {
      yield MemoFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }
}
