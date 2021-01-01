import 'package:casseurflutter/blocs/memo/memo_bloc.dart';
import 'package:casseurflutter/blocs/memo/memo_event.dart';
import 'package:casseurflutter/services/api.dart';
import 'package:casseurflutter/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Memos extends StatefulWidget {
  static const String id = '/memos';

  @override
  _MemosState createState() => _MemosState();
}

class _MemosState extends State<Memos> {
  Widget _furnishBloc({BuildContext context, Widget child}) {
    final APIService apiService = RepositoryProvider.of<APIService>(context);

    return BlocProvider<MemoBloc>(
      create: (BuildContext context) => MemoBloc(apiService),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _furnishBloc(
        context: context,
        child: Builder(builder: (BuildContext context) {
          final MemoBloc memoBloc = BlocProvider.of<MemoBloc>(context);

          return AppScaffold(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Memos'),
                const CircularProgressIndicator(),
                ElevatedButton(
                  onPressed: () {
                    memoBloc.add(MemoTrigger());
                  },
                  child: const Text('Test'),
                ),
              ],
            ),
          );
        }));
  }
}
