import 'package:casseurflutter/models/user.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => <Object>[];
}

class HomeReady extends AuthenticationEvent {}

// Fired when a user has successfully logged in
class UserLoggedIn extends AuthenticationEvent {
  const UserLoggedIn({@required this.user});

  final User user;

  @override
  List<Object> get props => <Object>[user];
}

// Fired when the user has logged out
class UserLoggedOut extends AuthenticationEvent {}
