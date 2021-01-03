import 'package:bloc/bloc.dart';
import 'package:casseurflutter/models/models.dart';
import 'package:casseurflutter/services/services.dart';

import 'update_memo.dart';
import 'update_memo_event.dart';

class UpdateMemoBloc extends Bloc<UpdateMemoEvent, UpdateMemoState> {
  UpdateMemoBloc(APIService apiService)
      : assert(apiService != null),
        _apiService = apiService,
        super(UpdateMemoInitial());

  final APIService _apiService;

  @override
  Stream<UpdateMemoState> mapEventToState(UpdateMemoEvent event) async* {
    if (event is StartUpdateMemo) {
      yield* _mapStartUpdateMemoToState(event);
    }
  }

  Stream<UpdateMemoState> _mapStartUpdateMemoToState(
      StartUpdateMemo event) async* {
    yield UpdateMemoCreating();
    try {
      final Memo memo = await _apiService.updateMemo(event.memo, event.id);
      yield UpdateMemoUpdated(memo: memo);
    } catch (e) {
      yield UpdateMemoFailure(
          message: 'Could not update memo, ' + e.toString());
    }
  }
}
