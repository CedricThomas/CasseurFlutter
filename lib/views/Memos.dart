import 'package:casseurflutter/blocs/memos/memos.dart';
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
    return MemosScaffold(child: BlocBuilder<MemosBloc, MemosState>(
        builder: (BuildContext context, MemosState state) {
      final MemosBloc memoBloc = BlocProvider.of<MemosBloc>(context);
      if (state is MemosLoaded) {
        return Container(
          child: RefreshIndicator(
            child: ListView.builder(
              itemCount: state.memos.length,
              itemBuilder: (BuildContext context, int index) => MemoCard(
                memo: state.memos[index],
              ),
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
    }));
  }
}
