import 'package:casseurflutter/blocs/memo/memo_bloc.dart';
import 'package:casseurflutter/blocs/memo/memo_event.dart';
import 'package:casseurflutter/widgets/memos/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Memos extends StatefulWidget {
  static const String id = '/memos';

  @override
  _MemosState createState() => _MemosState();
}

class _MemosState extends State<Memos> {
  @override
  Widget build(BuildContext context) {
    return MemosScaffold(child: Builder(builder: (BuildContext context) {
      final MemoBloc memoBloc = BlocProvider.of<MemoBloc>(context);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Memos'),
          const CircularProgressIndicator(),
          ElevatedButton(
            onPressed: () {
              memoBloc.add(MemoLoaded());
            },
            child: const Text('Test'),
          ),
        ],
      );
    }));
  }
}
