import 'package:bloc/bloc.dart';
import 'package:casseurflutter/exceptions/exceptions.dart';
import 'package:casseurflutter/services/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(APIService apiService)
      : assert(apiService != null),
        _apiService = apiService,
        _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(),
        super(NotificationInitial());

  final APIService _apiService;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is RegisterNotification) {
      yield* _mapRegisterNotificationToState(event);
    }
  }

  Future<void> showNotification(
    int notificationId,
    String notificationTitle,
    String notificationContent,
    String payload, {
    String channelId = '1234',
    String channelTitle = 'Android Channel',
    String channelDescription = 'Default Android Channel for notifications',
    Priority notificationPriority = Priority.high,
    Importance notificationImportance = Importance.max,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription,
      playSound: false,
      importance: notificationImportance,
      priority: notificationPriority,
    );
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<dynamic> onSelectNotification(String payload) async {
    print('test mec');
  }

  Stream<NotificationState> _mapRegisterNotificationToState(
      RegisterNotification event) async* {
    yield NotificationRegistering();
    try {
      await _apiService.registerNotification();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@drawable/ic_notification');
      const IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings();
      const InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);
      _flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);

      yield NotificationRegistered();
      yield NotificationInitial();
    } on NotificationsRefusedException catch (e) {
      yield NotificationRefused(error: e.toString());
    } catch (err) {
      yield NotificationFailure(
          error: err.toString() ?? 'An unknown error occurred');
    }
  }
}
