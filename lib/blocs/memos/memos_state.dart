import 'package:casseurflutter/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MemosState extends Equatable {
  const MemosState();

  @override
  List<Object> get props => <Object>[];
}

class MemosInitial extends MemosState {}

class MemosLoading extends MemosState {}

class MemosLoaded extends MemosState {
  const MemosLoaded(this.memos);

  final List<Memo> memos;

  @override
  List<Object> get props => <Object>[memos];
}

class MemoRemoved extends MemosState {
  const MemoRemoved(this.memo);

  final Memo memo;

  @override
  List<Object> get props => <Object>[memo];
}

class MemosFailure extends MemosState {
  const MemosFailure({@required this.error});

  final String error;

  @override
  List<Object> get props => <Object>[error];
}
