import 'package:casseurflutter/blocs/memos/memos.dart';
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
    return MemosScaffold(child: BlocBuilder<MemosBloc, MemosState>(
        builder: (BuildContext context, MemosState state) {
      // final MemosBloc memoBloc = BlocProvider.of<MemosBloc>(context);
      if (state is MemosLoaded) {}
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
        ],
      );
    }));
  }
}
