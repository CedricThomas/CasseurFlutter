import 'package:equatable/equatable.dart';

abstract class MemoEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class FetchMemo extends MemoEvent {
  FetchMemo(this.memoId);
  final String memoId;

  @override
  List<Object> get props => <Object>[memoId];
}
