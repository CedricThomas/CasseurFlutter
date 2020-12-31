import 'package:bloc/bloc.dart';
import 'package:casseurflutter/exceptions/exceptions.dart';
import 'package:casseurflutter/models/models.dart';
import 'package:casseurflutter/services/services.dart';

import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(APIService apiService)
      : assert(apiService != null),
        _apiService = apiService,
        super(NotificationInitial());

  final APIService _apiService;

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is RegisterNotification) {
      yield* _mapRegisterNotificationToState(event);
    }

    if (event is AppLoadedNotification) {
      yield* _mapAppLoadedToState(event);
    }
  }

  Stream<NotificationState> _mapRegisterNotificationToState(
      RegisterNotification event) async* {
    yield NotificationRegistering();
    try {
      await _apiService.registerNotification();
      yield NotificationRegistered();
      yield NotificationInitial();
    } on NotificationsRefusedException catch (e) {
      yield NotificationRefused(error: e.toString());
    } catch (err) {
      yield NotificationFailure(
          error: err.message as String ?? 'An unknown error occurred');
    }
  }

  Stream<NotificationState> _mapAppLoadedToState(AppLoadedNotification event) async* {
    try {
      final Subscription sub = await _apiService.loadSubscriptionFromStorage();
      if (sub == null) {
        yield NotificationNotRegistered();
      } else {
        yield NotificationRegistered();
      }
    } catch (err) {
      yield NotificationFailure(error: err.message as String ?? 'An unknown error occurred');
    }
  }
}
