class UserInfoAddress {
  final String country;

  UserInfoAddress.fromJson(Map<String, dynamic> json)
      : country = json['country'];

  Map<String, dynamic> toJson() => {
        'country': country,
      };
}

class UserInfo {
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
  final UserInfoAddress address;
  final String updatedAt;

  UserInfo.fromJson(Map<String, dynamic> json)
      : sub = json['sub'],
        name = json['name'],
        givenName = json['given_name'],
        familyName = json['family_name'],
        middleName = json['middle_name'],
        nickname = json['nickname'],
        preferredUsername = json['preferred_username'],
        profile = json['profile'],
        picture = json['picture'],
        website = json['website'],
        email = json['email'],
        emailVerified = json['email_verified'],
        gender = json['gender'],
        birthdate = json['birthdate'],
        zoneinfo = json['zoneinfo'],
        locale = json['locale'],
        phoneNumber = json['phone_number'],
        phoneNumberVerified = json['phone_number_verified'],
        address = UserInfoAddress.fromJson(json['address']),
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() => {
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
}
