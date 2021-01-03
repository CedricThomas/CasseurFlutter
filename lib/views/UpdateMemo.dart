import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:casseurflutter/blocs/update_memo/update_memo.dart';
import 'package:casseurflutter/models/memo.dart';
import 'package:casseurflutter/services/services.dart';
import 'package:casseurflutter/widgets/authenticated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

class UpdateMemo extends StatefulWidget {
  static const String id = '/updateMemo';

  @override
  _UpdateMemo createState() => _UpdateMemo();
}

class _UpdateMemo extends State<UpdateMemo> {
  bool _isLoading = false;
  String _memoTitle = '';
  String _memoContent = '';
  Position _memoPosition;
  ButtonState _locationButtonState = ButtonState.idle;
  UpdateMemoBloc _memoBloc;
  Memo _baseMemo;

  Future<void> _onGeolocationAsked() async {
    if (_locationButtonState == ButtonState.idle) {
      try {
        setState(() {
          _locationButtonState = ButtonState.loading;
        });
        final LocationPermission perm = await Geolocator.checkPermission();
        if (perm != LocationPermission.always &&
            perm != LocationPermission.whileInUse) {
          final LocationPermission newPerm =
              await Geolocator.requestPermission();
          if (newPerm != LocationPermission.always &&
              newPerm != LocationPermission.whileInUse) {
            setState(() {
              _locationButtonState = ButtonState.fail;
              _memoPosition = null;
            });
            return;
          }
        }
        final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 20),
        );
        setState(() {
          _memoPosition = position;
          _locationButtonState = ButtonState.success;
        });
      } catch (e) {
        setState(() {
          _locationButtonState = ButtonState.fail;
          _memoPosition = null;
        });
      }
    } else if (_locationButtonState == ButtonState.success) {
      setState(() {
        _locationButtonState = ButtonState.idle;
        _memoPosition = null;
      });
    } else if (_locationButtonState == ButtonState.fail) {
      setState(() {
        _locationButtonState = ButtonState.idle;
        _memoPosition = null;
      });
    }
  }

  @override
  void initState() {
    final Memo baseMemo = Get.arguments as Memo;
    if (baseMemo != null) {
      setState(() {
        _memoTitle = baseMemo.title;
        _memoContent = baseMemo.content;
        _baseMemo = baseMemo;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return AuthenticationEnforcer(
        authenticationBloc: authBloc,
        child: BlocProvider<UpdateMemoBloc>(
          create: (BuildContext context) {
            final APIService apiService =
                RepositoryProvider.of<APIService>(context);
            _memoBloc = UpdateMemoBloc(apiService);
            return _memoBloc;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Update memo'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      _memoBloc.add(StartUpdateMemo(
                          id: _baseMemo.id,
                          memo: UpdateMemoRequest(
                              _memoTitle,
                              _memoContent,
                              (_memoPosition != null)
                                  ? Location(_memoPosition.latitude,
                                      _memoPosition.longitude)
                                  : null)));
                    },
              child: _isLoading
                  ? const CircularProgressIndicator(
                      backgroundColor: Colors.white)
                  : const Icon(Icons.done),
            ),
            body: Builder(
              builder: (BuildContext context) {
                return BlocListener<UpdateMemoBloc, UpdateMemoState>(
                    listener: (BuildContext context, UpdateMemoState state) {
                      if (state is UpdateMemoCreating) {
                        setState(() {
                          _isLoading = true;
                        });
                      }
                      if (state is UpdateMemoFailure) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(state.message),
                          duration: const Duration(seconds: 5),
                        ));
                        setState(() {
                          _isLoading = false;
                        });
                      }
                      if (state is UpdateMemoUpdated) {
                        Future<void>.microtask(() => Navigator.pop(context));
                      }
                    },
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                initialValue: _baseMemo.title,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _memoTitle = newValue;
                                  });
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Memo title',
                                  filled: true,
                                  fillColor: Color(0xFFDBEDFF),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                              ),
                              TextFormField(
                                initialValue: _baseMemo.content,
                                minLines: 10,
                                maxLines: 15,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _memoContent = newValue;
                                  });
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Memo content here',
                                  filled: true,
                                  fillColor: Color(0xFFDBEDFF),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                              ),
                              ProgressButton(
                                stateWidgets: const <ButtonState, Widget>{
                                  ButtonState.idle: Text(
                                    'Add a geolocation',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  ButtonState.loading: Text(
                                    'Locating',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  ButtonState.fail: Text(
                                    'Could not get position',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  ButtonState.success: Text(
                                    'Geolocation added',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )
                                },
                                stateColors: <ButtonState, Color>{
                                  ButtonState.idle: Colors.blue,
                                  ButtonState.loading: Colors.blue.shade300,
                                  ButtonState.fail: Colors.red.shade300,
                                  ButtonState.success: Colors.green.shade400,
                                },
                                radius: 5.0,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                onPressed: _onGeolocationAsked,
                                state: _locationButtonState,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              },
            ),
          ),
        ));
  }
}
