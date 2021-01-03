import 'package:casseurflutter/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class UpdateMemoState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateMemoInitial extends UpdateMemoState {}

class UpdateMemoCreating extends UpdateMemoState {}

class UpdateMemoUpdated extends UpdateMemoState {
  UpdateMemoUpdated({@required this.memo});

  final Memo memo;

  @override
  List<Object> get props => <Object>[memo];
}

class UpdateMemoFailure extends UpdateMemoState {
  UpdateMemoFailure({this.message});

  final String message;

  @override
  List<Object> get props => <Object>[message];
}
