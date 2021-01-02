import 'package:bloc/bloc.dart';
import 'package:casseurflutter/services/services.dart';

import 'memos_event.dart';
import 'memos_state.dart';

class MemoBloc extends Bloc<MemoEvent, MemoState> {
  MemoBloc(APIService apiService)
      : assert(apiService != null),
        _apiService = apiService,
        super(MemoInitial());

  final APIService _apiService;

  @override
  Stream<MemoState> mapEventToState(MemoEvent event) async* {
    if (event is MemoLoaded) {
      _apiService.listMemos();
    }
  }
}
