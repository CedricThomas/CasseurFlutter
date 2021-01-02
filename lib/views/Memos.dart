import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:casseurflutter/blocs/memos/memos.dart';
import 'package:casseurflutter/models/memo.dart';
import 'package:casseurflutter/widgets/authenticated.dart';
import 'package:casseurflutter/widgets/memos/card.dart';
import 'package:casseurflutter/widgets/memos/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Memos extends StatefulWidget {
  static const String id = '/memos';

  @override
  _MemosState createState() => _MemosState();
}

class _MemosState extends State<Memos> {
  Future<void> _refreshList(MemosBloc memoBloc) async {
    memoBloc.add(FetchMemos());
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return AuthenticationEnforcer(
      authenticationBloc: authBloc,
      child: MemosScaffold(
        child: BlocBuilder<MemosBloc, MemosState>(
          builder: (BuildContext context, MemosState state) {
            final MemosBloc memoBloc = BlocProvider.of<MemosBloc>(context);
            if (state is MemosLoaded) {
              return Container(
                child: RefreshIndicator(
                  child: ListView.builder(
                    itemCount: state.memos.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Memo memo = state.memos[index];
                      return Dismissible(
                        key: Key(memo.id),
                        onDismissed: (DismissDirection direction) {
                          memoBloc.add(DeleteMemo(memo.id));
                          Scaffold.of(context).showSnackBar(
                              const SnackBar(content: Text('Memo deleted')));
                        },
                        child: MemoCard(
                          memo: memo,
                          edit: (Memo memo) {},
                        ),
                      );
                    },
                  ),
                  onRefresh: () => _refreshList(memoBloc),
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
    );
  }
}
