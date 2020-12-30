import 'package:casseurflutter/redux/actions/setProfile.dart';

import 'actions.dart';
import 'actions/setIsAuthenticated.dart';
import 'state.dart';
import 'store.dart';

class Dispatchable {
  Dispatchable({this.action, this.data});

  final AppActions action;
  final dynamic data;
}

void dispatch(AppActions action, dynamic data) {
  store.dispatch(Dispatchable(action: action, data: data));
}

AppState reducer(AppState curState, dynamic recEvt) {
  final Dispatchable evt = recEvt as Dispatchable;
  switch (evt.action) {
    case AppActions.setIsAuthenticated:
      {
        return handleSetIsAuthenticated(curState, evt);
      }
      break;
    case AppActions.setProfile:
      {
        return handleSetProfile(curState, evt);
      }
      break;
  }
  return curState;
}
