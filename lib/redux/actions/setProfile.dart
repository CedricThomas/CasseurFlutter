import '../reducer.dart';
import '../state.dart';

AppState handleSetProfile(AppState curState, Dispatchable evt) {
  ProfileState data = evt.data;
  curState.profile = data;
  return curState;
}