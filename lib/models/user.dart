import 'package:equatable/equatable.dart';

class UserAddress extends Equatable {
  UserAddress.fromJson(dynamic json) : country = json['country'] as String;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'country': country,
      };
  final String country;

  @override
  List<Object> get props => <Object>[country];
}

class User extends Equatable {
  User.fromJson(dynamic json)
      : sub = json['sub'] as String,
        name = json['name'] as String,
        givenName = json['given_name'] as String,
        familyName = json['family_name'] as String,
        middleName = json['middle_name'] as String,
        nickname = json['nickname'] as String,
        preferredUsername = json['preferred_username'] as String,
        profile = json['profile'] as String,
        picture = json['picture'] as String,
        website = json['website'] as String,
        email = json['email'] as String,
        emailVerified = json['email_verified'] as String,
        gender = json['gender'] as String,
        birthdate = json['birthdate'] as String,
        zoneinfo = json['zoneinfo'] as String,
        locale = json['locale'] as String,
        phoneNumber = json['phone_number'] as String,
        phoneNumberVerified = json['phone_number_verified'] as String,
        address = UserAddress.fromJson(json['address']),
        updatedAt = json['updated_at'] as String;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sub': sub,
        'name': name,
        'given_name': givenName,
        'family_name': familyName,
        'middle_name': middleName,
        'nickname': nickname,
        'preferred_username': preferredUsername,
        'profile': profile,
        'picture': picture,
        'website': website,
        'email': email,
        'email_verified': emailVerified,
        'gender': gender,
        'birthdate': birthdate,
        'zoneinfo': zoneinfo,
        'locale': locale,
        'phone_number': phoneNumber,
        'phone_number_verified': phoneNumberVerified,
        'address': address.toJson(),
        'updated_at': updatedAt,
      };

  final String sub;
  final String name;
  final String givenName;
  final String familyName;
  final String middleName;
  final String nickname;
  final String preferredUsername;
  final String profile;
  final String picture;
  final String website;
  final String email;
  final String emailVerified;
  final String gender;
  final String birthdate;
  final String zoneinfo;
  final String locale;
  final String phoneNumber;
  final String phoneNumberVerified;
  final UserAddress address;
  final String updatedAt;

  @override
  List<Object> get props => <Object>[
        sub,
        name,
        givenName,
        familyName,
        middleName,
        nickname,
        preferredUsername,
        profile,
        picture,
        website,
        email,
        emailVerified,
        gender,
        birthdate,
        zoneinfo,
        locale,
        phoneNumber,
        phoneNumberVerified,
        address,
        updatedAt
      ];
}
