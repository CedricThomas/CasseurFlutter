import 'package:casseurflutter/redux/reducer.dart';
import 'package:casseurflutter/redux/state.dart';
import 'package:redux/redux.dart';

final Store<AppState> store = Store<AppState>(reducer, initialState: AppState());