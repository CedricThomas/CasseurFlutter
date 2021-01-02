import 'package:equatable/equatable.dart';

abstract class MemoEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class MemoLoaded extends MemoEvent {}
