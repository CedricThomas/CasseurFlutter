import 'package:bloc/bloc.dart';
import 'package:casseurflutter/exceptions/exceptions.dart';
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
          error: err.toString() ?? 'An unknown error occurred');
    }
  }
}
