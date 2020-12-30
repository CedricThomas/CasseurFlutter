import '../reducer.dart';
import '../state.dart';

class SetProfileData {
  SetProfileData({this.profile});

  final ProfileState profile;
}


AppState handleSetProfile(AppState curState, Dispatchable evt) {
  final SetProfileData data = evt.data as SetProfileData;
  curState.profile = data.profile;
  return curState;
}