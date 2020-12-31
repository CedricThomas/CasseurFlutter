import 'dart:convert';

import 'package:casseurflutter/redux/state.dart';

Map<String, dynamic> parseIdToken(String idToken) {
  final List<String> parts = idToken.split(r'.');
  assert(parts.length == 3);

  return jsonDecode(
    utf8.decode(
      base64Url.decode(
        base64Url.normalize(parts[1]),
      ),
    ),
  ) as Map<String, dynamic>;
}

bool isTokenExpired(Map<String, dynamic> parsedIdToken) {
  final DateTime expDate =
      DateTime.fromMillisecondsSinceEpoch((parsedIdToken['exp'] as int) * 1000);
  return expDate.isBefore(DateTime.now());
}

ProfileState extractUserInfo(Map<String, dynamic> parsedIdToken) {
  final ProfileState p = ProfileState();
  p.name = parsedIdToken['name'] as String;
  p.email = parsedIdToken['email'] as String;
  p.avatar = parsedIdToken['picture'] as String;
  return p;
}
