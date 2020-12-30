import 'dart:convert';
import 'package:casseurflutter/models/UserInfo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';

import '../constants.dart';

class NotLoggedException implements Exception {
  const NotLoggedException(this.msg);
  final String msg;
  @override
  String toString() => 'NotLoggedException: $msg';
}

class RefreshException implements Exception {
  const RefreshException(this.msg);
  final String msg;
  @override
  String toString() => 'RefreshException: $msg';
}

class APIService {
  factory APIService() {
    return _instance;
  }

  APIService._privateConstructor()
      : appAuth = FlutterAppAuth(),
        secureStorage = const FlutterSecureStorage(),
        _isLoggedIn = false;

  final FlutterAppAuth appAuth;
  final FlutterSecureStorage secureStorage;
  bool _isLoggedIn;

  bool get isLoggedIn => _isLoggedIn;

  static final APIService _instance = APIService._privateConstructor();

  Future<UserInfo> getUserInfo(String _accessToken) async {
    if (!isLoggedIn) {
      throw const NotLoggedException('Not logged in');
    }

    final String url = 'https://$AUTH0_DOMAIN/userinfo';
    final http.Response response = await http.get(
      url,
      headers: <String, String>{'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      return UserInfo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> login() async {
    _isLoggedIn = false;
    final AuthorizationTokenResponse result =
        await appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
      AUTH0_CLIENT_ID,
      AUTH0_REDIRECT_URI,
      issuer: 'https://$AUTH0_DOMAIN',
      scopes: <String>['openid', 'profile', 'offline'],
      additionalParameters: <String, String>{'audience': 'casseur_flutter'},
    ));
    await secureStorage.write(key: 'refresh_token', value: result.refreshToken);
    _isLoggedIn = true;
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'refresh_token');
    _isLoggedIn = false;
  }

  Future<void> refreshToken() async {
    _isLoggedIn = false;
    final String storedRefreshToken = await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) {
      throw const RefreshException('Not refresh token found');
    }
    final TokenResponse response = await appAuth.token(TokenRequest(
      AUTH0_CLIENT_ID,
      AUTH0_REDIRECT_URI,
      issuer: AUTH0_ISSUER,
      refreshToken: storedRefreshToken,
    ));

    secureStorage.write(key: 'refresh_token', value: response.refreshToken);
    _isLoggedIn = true;
  }
}
