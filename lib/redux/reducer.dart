import 'package:casseurflutter/redux/actions/setProfile.dart';
import 'package:flutter/cupertino.dart';

import 'actions/setIsAuthenticated.dart';
import 'actions.dart';
import 'state.dart';
import 'store.dart';

class Dispatchable {
  final AppActions action;
  final dynamic data;

  Dispatchable({Key key, this.action, this.data});
}

dispatch(AppActions action, dynamic data) {
  store.dispatch(Dispatchable(action: action, data: data));
}

AppState reducer(AppState curState, dynamic recEvt) {
  Dispatchable evt = recEvt;
  switch (evt.action) {
    case AppActions.setIsAuthenticated: {
      return handleSetIsAuthenticated(curState, evt);
    }
    break;
    case AppActions.setProfile: {
      return handleSetProfile(curState, evt);
    }
    break;
  }
  return curState;
}