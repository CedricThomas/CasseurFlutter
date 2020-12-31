import 'package:bloc/bloc.dart';
import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:casseurflutter/services/services.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(AuthenticationBloc authenticationBloc, APIService apiService)
      : assert(authenticationBloc != null),
        assert(apiService != null),
        _authenticationBloc = authenticationBloc,
        _apiService = apiService,
        super(LoginInitial());

  final AuthenticationBloc _authenticationBloc;
  final APIService _apiService;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginInWithAuth0) {
      yield* _mapLoginInWithAuth0ToState(event);
    }
  }

  Stream<LoginState> _mapLoginInWithAuth0ToState(
      LoginInWithAuth0 event) async* {
    yield LoginLoading();
    try {
      await _apiService.login();
      //   if (user != null) {
      //     _authenticationBloc.add(UserLoggedIn(user: user));
      //     yield LoginSuccess();
      //     yield LoginInitial();
      //   } else {
      //     yield LoginFailure(error: 'Something very weird just happened');
      //   }
      // } on AuthenticationException catch (e) {
      //   yield LoginFailure(error: e.message);
    } catch (err) {
      yield LoginFailure(
          error: err.message as String ?? 'An unknown error occured');
    }
  }
}
