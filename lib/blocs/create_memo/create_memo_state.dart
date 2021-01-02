import 'package:casseurflutter/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CreateMemoState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class CreateMemoInitial extends CreateMemoState {}

class CreateMemoCreating extends CreateMemoState {}

class CreateMemoCreated extends CreateMemoState {
  CreateMemoCreated({@required this.memo});

  final Memo memo;

  @override
  List<Object> get props => <Object>[memo];
}

class CreateMemoFailure extends CreateMemoState {
  CreateMemoFailure({this.message});

  final String message;

  @override
  List<Object> get props => <Object>[message];
}
