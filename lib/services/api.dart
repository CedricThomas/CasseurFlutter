import 'dart:convert';

import 'package:casseurflutter/exceptions/exceptions.dart';
import 'package:casseurflutter/models/models.dart';
import 'package:casseurflutter/models/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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
    if (!(await tryToGetValidCredentials())) {
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

  Future<bool> tryToGetValidCredentials() async {
    if (_idToken == null) {
      //  || _refreshToken == null
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

  Future<User> loadUserFromStorage() async {
    _idToken = await secureStorage.read(key: 'id_token');
    if (_idToken == null) {
      // || _refreshToken == null
      return null;
    }
    return User.fromIdToken(_idToken);
  }

  Future<Subscription> loadSubscriptionFromStorage() async {
    final String messagingToken = await secureStorage.read(key: 'messaging');
    if (messagingToken == null) {
      return null;
    }
    return Subscription.fromJson(jsonDecode(messagingToken));
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

  Future<Subscription> _internalRegisterNotification(CreateSubscription data) async {
    http.Client();
    if (!(await tryToGetValidCredentials())) {
      throw const AuthenticationException('Not logged in');
    }
    final String url = '$API_URL/subscription';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{'Authorization': 'Bearer $_idToken', 'Content-type' : 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode < 400 && response.statusCode != 0) {
      return Subscription.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register notifications');
    }
  }

  Future<void> _internalUnregisterNotification(Subscription old) async {
    http.Client();
    if (!(await tryToGetValidCredentials())) {
      throw const AuthenticationException('Not logged in');
    }
    final String subId = old.subscriptionId;
    final String url = '$API_URL/subscription/$subId';
    final http.Response response = await http.delete(
      url,
      headers: <String, String>{'Authorization': 'Bearer $_idToken'},
    );

    if (response.statusCode >= 400 || response.statusCode == 0) {
      throw Exception('Failed to unregister notifications');
    }
  }

  Future<Subscription> registerNotification() async {
    final String messagingToken = await secureStorage.read(key: 'messaging');
    Subscription currentSub;
    if (messagingToken != null) {
      currentSub = Subscription.fromJson(jsonDecode(messagingToken));
    }
    final FirebaseMessaging messaging = FirebaseMessaging();
    final bool hasNotificationPermission = await messaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );
    if (hasNotificationPermission != null && !hasNotificationPermission) {
      throw const NotificationsRefusedException('The notification permission has been specifically denied by the user');
    }
    final String registrationToken = await messaging.getToken();
    if (currentSub != null && registrationToken == currentSub.registrationId) {
      return currentSub;
    } else if (currentSub != null) {
      try {
        await _internalUnregisterNotification(currentSub);
      } catch (e) {
        throw const NotificationsRegisterException('Unable to unregister old notification subscription on the API');
      }
    }
    try {
      final Subscription sub = await _internalRegisterNotification(CreateSubscription(registrationId: registrationToken));
      await secureStorage.write(key: 'messaging', value: jsonEncode(sub.toJson()));
      return sub;
    } catch (e) {
      throw const NotificationsRegisterException('Unable to register notification on the API');
    }
  }

  Future<Memo> createMemo(CreateMemoRequest memoToCreate) async {
    http.Client();
    if (!(await tryToGetValidCredentials())) {
      throw const AuthenticationException('Not logged in');
    }
    final String url = '$API_URL/memo';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{'Authorization': 'Bearer $_idToken', 'Content-type' : 'application/json'},
      body: json.encode(memoToCreate),
    );

    if (response.statusCode < 400 && response.statusCode != 0) {
      return Memo.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception('Invalid memo');
    } else {
      throw Exception('Failed to create memo');
    }
  }
}
