import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User._(this.idToken, this.expDate, this.name, this.email, this.avatar);

  factory User.fromIdToken(String idToken) {
    final List<String> parts = idToken.split(r'.');
    assert(parts.length == 3);

    final Map<String, dynamic> parsedIdToken = jsonDecode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(parts[1]),
        ),
      ),
    ) as Map<String, dynamic>;

    return User._(
        idToken,
        DateTime.fromMillisecondsSinceEpoch(
            (parsedIdToken['exp'] as int) * 1000),
        parsedIdToken['name'] as String,
        parsedIdToken['email'] as String,
        parsedIdToken['picture'] as String);
  }

  final String idToken;
  final DateTime expDate;
  final String name;
  final String email;
  final String avatar;

  bool isTokenExpired() {
    return expDate.isBefore(DateTime.now());
  }

  @override
  List<Object> get props => <Object>[
        idToken,
        expDate,
        name,
        email,
        avatar,
      ];
}
