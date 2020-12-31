import 'dart:convert';
import 'package:casseurflutter/exceptions/exceptions.dart';
import 'package:casseurflutter/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';

import '../constants.dart';

class APIService {
  APIService()
      : appAuth = FlutterAppAuth(),
        secureStorage = const FlutterSecureStorage(),
        _isLoggedIn = false;

  final FlutterAppAuth appAuth;
  final FlutterSecureStorage secureStorage;
  bool _isLoggedIn;

  bool get isLoggedIn => _isLoggedIn;

  Future<User> getUserInfo(String _accessToken) async {
    http.Client();
    if (!isLoggedIn) {
      throw const AuthenticationException('Not logged in');
    }

    final String url = 'https://$AUTH0_DOMAIN/userinfo';
    final http.Response response = await http.get(
      url,
      headers: <String, String>{'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
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
      additionalParameters: <String, String>{'audience': 'casseur_flutter'},
    ));
    await secureStorage.write(key: 'refresh_token', value: result.refreshToken);
    _isLoggedIn = true;
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'refresh_token');
    _isLoggedIn = false;
  }
}
