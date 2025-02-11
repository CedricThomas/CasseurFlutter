import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:casseurflutter/blocs/memos/memos.dart';
import 'package:casseurflutter/models/memo.dart';
import 'package:casseurflutter/views/UpdateMemo.dart';
import 'package:casseurflutter/widgets/authenticated.dart';
import 'package:casseurflutter/widgets/memos/card.dart';
import 'package:casseurflutter/widgets/memos/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class Memos extends StatefulWidget {
  static const String id = '/memos';

  @override
  _MemosState createState() => _MemosState();
}

class _MemosState extends State<Memos> {
  List<Memo> _memos;
  bool _loading = true;

  Future<void> _refreshList(MemosBloc memosBloc) async {
    memosBloc.add(FetchMemos());
  }

  Future<void> _editMemo(MemosBloc memosBloc, Memo memo) async {
    await Get.to<UpdateMemo>(UpdateMemo(), arguments: memo);
    memosBloc.add(FetchMemos());
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return AuthenticationEnforcer(
        authenticationBloc: authBloc,
        child: MemosScaffold(
          child: BlocListener<MemosBloc, MemosState>(
            listener: (BuildContext context, MemosState state) {
              if (state is MemosLoaded) {
                setState(() {
                  _memos = state.memos;
                  _loading = false;
                });
              }
              if (state is MemosLoading) {
                setState(() {
                  _loading = true;
                });
              }
              if (state is MemosDeletedItem) {
                Scaffold.of(context).showSnackBar(
                    const SnackBar(content: Text('Memo deleted')));
              }
            },
            child: Builder(
              builder: (BuildContext context) {
                final MemosBloc memosBloc = BlocProvider.of<MemosBloc>(context);
                if (!_loading) {
                  return Container(
                    child: RefreshIndicator(
                      child: ListView.builder(
                        itemCount: _memos.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Memo memo = _memos[index];
                          return Dismissible(
                            key: Key(memo.id),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                _memos.removeWhere(
                                    (Memo item) => item.id == memo.id);
                                memosBloc.add(DeleteMemo(memo.id));
                              });
                            },
                            child: MemoCard(
                              memo: memo,
                              edit: (Memo memo) => _editMemo(memosBloc, memo),
                            ),
                          );
                        },
                      ),
                      onRefresh: () => _refreshList(memosBloc),
                    ),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
