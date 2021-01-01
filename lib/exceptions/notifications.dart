class NotificationsRefusedException implements Exception {
  const NotificationsRefusedException(this.msg);
  final String msg;
  @override
  String toString() => 'NotificationsRefusedException: $msg';
}

class NotificationsRegisterException implements Exception {
  const NotificationsRegisterException(this.msg);
  final String msg;
  @override
  String toString() => 'NotificationsRegisterException: $msg';
}