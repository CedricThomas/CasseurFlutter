import 'package:bloc/bloc.dart';
import 'package:casseurflutter/models/models.dart';
import 'package:casseurflutter/services/services.dart';

import 'create_memo.dart';
import 'create_memo_event.dart';

class CreateMemoBloc extends Bloc<CreateMemoEvent, CreateMemoState> {
  CreateMemoBloc(APIService apiService)
      : assert(apiService != null),
        _apiService = apiService,
        super(CreateMemoInitial());

  final APIService _apiService;

  @override
  Stream<CreateMemoState> mapEventToState(CreateMemoEvent event) async* {
    if (event is StartCreateMemo) {
      yield* _mapStartCreateMemoToState(event);
    }
  }

  Stream<CreateMemoState> _mapStartCreateMemoToState(
      StartCreateMemo event) async* {
    yield CreateMemoCreating();
    try {
      final Memo memo = await _apiService.createMemo(event.memo);
      yield CreateMemoCreated(memo: memo);
    } catch (e) {
      yield CreateMemoFailure(message: 'Could not create memo, ' + e.toString());
    }
  }
}
