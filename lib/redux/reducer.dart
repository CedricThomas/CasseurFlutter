import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';

import 'actions/setIsAuthenticated.dart';
import 'actions.dart';
import 'state.dart';

class Dispatchable {
  final AppActions action;
  final dynamic data;

  Dispatchable({Key key, this.action, this.data});
}

dispatch(Store<AppState> store, AppActions action, dynamic data) {
  store.dispatch(Dispatchable(action: action, data: data));
}

AppState reducer(AppState curState, dynamic recEvt) {
  Dispatchable evt = recEvt;
  switch (evt.action) {
    case AppActions.setIsAuthenticated: {
      return handleSetIsAuthenticated(curState, evt);
    }
    break;
  }
  return curState;
}