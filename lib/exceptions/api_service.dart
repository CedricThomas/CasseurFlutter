class AuthenticationException implements Exception {
  const AuthenticationException(this.msg);
  final String msg;
  @override
  String toString() => 'AuthenticationException: $msg';
}

class NotLoggedException implements Exception {
  const NotLoggedException(this.msg);
  final String msg;
  @override
  String toString() => 'NotLoggedException: $msg';
}
