import '../reducer.dart';
import '../state.dart';

class SetProfileData {
  final ProfileState profile;

  SetProfileData({this.profile});
}


AppState handleSetProfile(AppState curState, Dispatchable evt) {
  SetProfileData data = evt.data;
  curState.profile = data.profile;
  return curState;
}