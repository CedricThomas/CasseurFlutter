import 'dart:convert';
import 'package:casseurflutter/models/UserInfo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';

import '../constants.dart';

class NotLoggedException implements Exception {
  final String msg;
  const NotLoggedException(this.msg);
  String toString() => 'NotLoggedException: $msg';
}

class RefreshException implements Exception {
  final String msg;
  const RefreshException(this.msg);
  String toString() => 'RefreshException: $msg';
}

class APIService {
  final FlutterAppAuth appAuth;
  final FlutterSecureStorage secureStorage;
  bool _isLoggedIn;
  String _accessToken;

  bool get isLoggedIn => _isLoggedIn;

  APIService._privateConstructor()
      : appAuth = FlutterAppAuth(),
        secureStorage = const FlutterSecureStorage(),
        _isLoggedIn = false,
        _accessToken = null;

  static final APIService _instance = APIService._privateConstructor();

  factory APIService() {
    return _instance;
  }

  Future<UserInfo> getUserInfo(String _accessToken) async {
    if (!isLoggedIn) {
      throw NotLoggedException('Not logged in');
    }

    final url = 'https://$AUTH0_DOMAIN/userinfo';
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      return UserInfo.fromJson(jsonDecode(response.body));
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
      scopes: ['openid', 'profile', 'offline'],
      additionalParameters: {'audience': 'casseur_flutter'},
    ));
    await secureStorage.write(key: 'refresh_token', value: result.refreshToken);
    _isLoggedIn = true;
  }

  void logout() async {
    await secureStorage.delete(key: 'refresh_token');
    _isLoggedIn = false;
  }

  void refreshToken() async {
    _isLoggedIn = false;
    final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) {
      throw RefreshException('Not refresh token found');
    }
    final response = await appAuth.token(TokenRequest(
      AUTH0_CLIENT_ID,
      AUTH0_REDIRECT_URI,
      issuer: AUTH0_ISSUER,
      refreshToken: storedRefreshToken,
    ));

    secureStorage.write(key: 'refresh_token', value: response.refreshToken);
    _accessToken = response.accessToken;
    _isLoggedIn = true;
  }
}
