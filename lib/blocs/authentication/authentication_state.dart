import 'package:casseurflutter/models/user.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => <Object>[];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationNotAuthenticated extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  const AuthenticationAuthenticated({@required this.user});

  final User user;

  @override
  List<Object> get props => <Object>[user];
}

class AuthenticationFailure extends AuthenticationState {
  const AuthenticationFailure({@required this.message});

  final String message;

  @override
  List<Object> get props => <Object>[message];
}
