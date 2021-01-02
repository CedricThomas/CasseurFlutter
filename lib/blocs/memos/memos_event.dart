import 'package:equatable/equatable.dart';

abstract class MemosEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class FetchMemos extends MemosEvent {}

class DeleteMemo extends MemosEvent {
  DeleteMemo(this.id);

  final String id;

  @override
  List<Object> get props => <Object>[id];
}
