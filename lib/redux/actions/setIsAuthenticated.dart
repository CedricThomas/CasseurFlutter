import '../reducer.dart';
import '../state.dart';

class SetIsAuthenticatedData {
  SetIsAuthenticatedData({this.isAuthenticated});

  final bool isAuthenticated;
}

AppState handleSetIsAuthenticated(AppState curState, Dispatchable evt) {
  final SetIsAuthenticatedData data = evt.data as SetIsAuthenticatedData;
  curState.isAuthenticated = data.isAuthenticated;
  return curState;
}