import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class LoginInWithAuth0 extends LoginEvent {}
