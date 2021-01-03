import 'package:casseurflutter/models/memo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class UpdateMemoEvent extends Equatable {
  const UpdateMemoEvent();

  @override
  List<Object> get props => <Object>[];
}

class StartUpdateMemo extends UpdateMemoEvent {
  const StartUpdateMemo({@required this.memo, @required this.id});

  final UpdateMemoRequest memo;
  final String id;

  @override
  List<Object> get props => <Object>[memo];
}
