import '../reducer.dart';
import '../state.dart';

class SetIsAuthenticatedData {
  final bool isAuthenticated;

  SetIsAuthenticatedData({this.isAuthenticated});
}

AppState handleSetIsAuthenticated(AppState curState, Dispatchable evt) {
  SetIsAuthenticatedData data = evt.data;
  curState.isAuthenticated = data.isAuthenticated;
  return curState;
}