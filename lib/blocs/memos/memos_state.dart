import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MemoState extends Equatable {
  const MemoState();

  @override
  List<Object> get props => <Object>[];
}

class MemoInitial extends MemoState {}

class MemoFailure extends MemoState {
  const MemoFailure({@required this.error});

  final String error;

  @override
  List<Object> get props => <Object>[error];
}
