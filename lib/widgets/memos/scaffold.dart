import 'package:casseurflutter/blocs/memos/memos.dart';
import 'package:casseurflutter/services/api.dart';
import 'package:casseurflutter/widgets/memos/fabCreateMemo.dart';
import 'package:casseurflutter/widgets/scaffold/appbar/leading.dart';
import 'package:casseurflutter/widgets/scaffold/appbar/title.dart';
import 'package:casseurflutter/widgets/scaffold/drawer/default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemosScaffold extends StatelessWidget {
  const MemosScaffold({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final APIService apiService = RepositoryProvider.of<APIService>(context);
    return BlocProvider<MemosBloc>(
      create: (BuildContext context) =>
          MemosBloc(apiService)..add(FetchMemos()),
      child: Scaffold(
        drawer: DefaultDrawer(),
        appBar: AppBar(
          leading: AppBarLeading(),
          title: AppBarTitle(),
        ),
        floatingActionButton: const FabCreateMemo(),
        body: Container(
          child: child,
          constraints: const BoxConstraints(minWidth: double.infinity),
        ),
      ),
    );
  }
}
