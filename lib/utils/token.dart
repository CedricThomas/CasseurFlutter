import 'dart:convert';

import 'package:casseurflutter/redux/state.dart';

Map<String, dynamic> parseIdToken(String idToken) {
  final parts = idToken.split(r'.');
  assert(parts.length == 3);

  return jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
}

bool isTokenExpired(Map<String, dynamic> parsedIdToken) {
  var expDate =
  DateTime.fromMillisecondsSinceEpoch(parsedIdToken['exp'] * 1000);
  return expDate.isBefore(DateTime.now());
}

ProfileState extractUserInfo(Map<String, dynamic> parsedIdToken) {
  var p = ProfileState();
  p.name = parsedIdToken['name'];
  p.email = parsedIdToken['email'];
  p.avatar = parsedIdToken['picture'];
  return p;
}