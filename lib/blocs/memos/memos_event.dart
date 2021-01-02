import 'package:equatable/equatable.dart';

abstract class MemosEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class FetchMemos extends MemosEvent {}
