import 'package:casseurflutter/models/memo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CreateMemoEvent extends Equatable {
  const CreateMemoEvent();

  @override
  List<Object> get props => <Object>[];
}

class StartCreateMemo extends CreateMemoEvent {
  const StartCreateMemo({@required this.memo});

  final CreateMemoRequest memo;

  @override
  List<Object> get props => <Object>[memo];
}
