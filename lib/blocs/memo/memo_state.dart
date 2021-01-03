import 'package:casseurflutter/models/memo.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MemoState extends Equatable {
  const MemoState();

  @override
  List<Object> get props => <Object>[];
}

class MemoInitial extends MemoState {}

class MemoLoaded extends MemoState {
  const MemoLoaded(this.memo);

  final Memo memo;

  @override
  List<Object> get props => <Object>[memo];
}

class MemoFailure extends MemoState {
  const MemoFailure({@required this.error});

  final String error;

  @override
  List<Object> get props => <Object>[error];
}
