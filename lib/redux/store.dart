import 'package:casseurflutter/redux/reducer.dart';
import 'package:casseurflutter/redux/state.dart';
import 'package:redux/redux.dart';

final store = new Store<AppState>(reducer, initialState: AppState());