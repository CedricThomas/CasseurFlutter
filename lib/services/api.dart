import 'dart:convert';
import 'package:casseurflutter/exceptions/exceptions.dart';
import 'package:casseurflutter/models/models.dart';
import 'package:casseurflutter/models/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';

import '../constants.dart';

class APIService {
  APIService()
      : appAuth = FlutterAppAuth(),
        secureStorage = const FlutterSecureStorage(),
        _idToken = '',
        _refreshToken = '';

  final FlutterAppAuth appAuth;
  final FlutterSecureStorage secureStorage;
  String _idToken;
  String _refreshToken;

  Future<Profile> getProfile() async {
    http.Client();
    if (!(await tryToGetValideCredentials())) {
      throw const AuthenticationException('Not logged in');
    }

    final String url = 'https://$AUTH0_DOMAIN/userinfo';
    final http.Response response = await http.get(
      url,
      headers: <String, String>{'Authorization': 'Bearer $_idToken'},
    );

    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<bool> tryToGetValideCredentials() async {
    if (_idToken == null || _refreshToken == null) {
      return false;
    }
    final User user = User.fromIdToken(_idToken);
    if (user.isTokenExpired()) {
      try {
        refreshToken();
      } catch (e) {
        return false;
      }
    }
    return true;
  }

  Future<User> loadFromStorage() async {
    _refreshToken = await secureStorage.read(key: 'refresh_token');
    _idToken = await secureStorage.read(key: 'id_token');
    if (_refreshToken != null || _idToken != null) {
      return null;
    }
    return User.fromIdToken(_idToken);
  }

  Future<User> login() async {
    final AuthorizationTokenResponse result =
        await appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
      AUTH0_CLIENT_ID,
      AUTH0_REDIRECT_URI,
      issuer: 'https://$AUTH0_DOMAIN',
      scopes: <String>['openid', 'profile', 'offline_access', 'email'],
      additionalParameters: <String, String>{'audience': 'casseur_flutter'},
    ));
    await secureStorage.write(key: 'refresh_token', value: result.refreshToken);
    await secureStorage.write(key: 'id_token', value: result.idToken);
    _refreshToken = result.refreshToken;
    _idToken = result.idToken;
    return User.fromIdToken(_idToken);
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'refresh_token');
    await secureStorage.delete(key: 'id_token');
    _idToken = null;
    _refreshToken = null;
  }

  Future<User> refreshToken() async {
    if (_refreshToken == null) {
      return null;
    }
    final TokenResponse response = await appAuth.token(TokenRequest(
      AUTH0_CLIENT_ID,
      AUTH0_REDIRECT_URI,
      issuer: AUTH0_ISSUER,
      refreshToken: _refreshToken,
    ));

    await secureStorage.write(key: 'id_token', value: response.idToken);
    await secureStorage.write(
        key: 'refresh_token', value: response.refreshToken);
    _idToken = response.idToken;
    _refreshToken = response.refreshToken;
    return User.fromIdToken(response.idToken);
  }
}
