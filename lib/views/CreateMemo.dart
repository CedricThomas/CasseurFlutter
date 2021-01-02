import 'package:casseurflutter/blocs/create_memo/create_memo.dart';
import 'package:casseurflutter/models/memo.dart';
import 'package:casseurflutter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateMemo extends StatefulWidget {
  static const String id = '/createMemo';

  @override
  _CreateMemo createState() => _CreateMemo();
}

class _CreateMemo extends State<CreateMemo> {
  bool _isLoading = false;
  String _memoTitle = '';
  String _memoContent = '';
  CreateMemoBloc _memoBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateMemoBloc>(
      create: (BuildContext context) {
        final APIService apiService =
            RepositoryProvider.of<APIService>(context);
        _memoBloc = CreateMemoBloc(apiService);
        return _memoBloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create new memo'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isLoading
              ? null
              : () {
                  _memoBloc.add(StartCreateMemo(
                      memo: CreateMemoRequest(_memoTitle, _memoContent, null)));
                },
          child: _isLoading
              ? const CircularProgressIndicator(backgroundColor: Colors.white)
              : const Icon(Icons.done),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return BlocListener<CreateMemoBloc, CreateMemoState>(
              listener: (BuildContext context, CreateMemoState state) {
                if (state is CreateMemoCreating) {
                  setState(() {
                    _isLoading = true;
                  });
                }
                if (state is CreateMemoFailure) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    duration: const Duration(seconds: 5),
                  ));
                  setState(() {
                    _isLoading = false;
                  });
                }
                if (state is CreateMemoCreated) {
                  Future<void>.microtask(() => Navigator.pop(context));
                }
              },
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
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
                      TextField(
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
