import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:casseurflutter/blocs/memo/memo.dart';
import 'package:casseurflutter/models/models.dart';
import 'package:casseurflutter/services/api.dart';
import 'package:casseurflutter/widgets/authenticated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ViewMemoScaffold extends StatelessWidget {
  const ViewMemoScaffold({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MemoViewRequest args = Get.arguments as MemoViewRequest;
    if (args == null) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Memo'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              CircularProgressIndicator(),
            ],
          ));
    }
    final AuthenticationBloc authBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    final APIService apiService = RepositoryProvider.of<APIService>(context);

    return AuthenticationEnforcer(
        authenticationBloc: authBloc,
        child: BlocProvider<MemoBloc>(
          create: (BuildContext context) =>
              MemoBloc(apiService)..add(FetchMemo(args.id)),
          child: Scaffold(
            appBar: AppBar(
              title: BlocBuilder<MemoBloc, MemoState>(
                builder: (BuildContext context, MemoState state) {
                  if (state is MemoLoaded) {
                    return Text(state.memo.title);
                  }
                  return const Text('Memo');
                },
              ),
            ),
            body: Container(
              child: child,
              constraints: const BoxConstraints(minWidth: double.infinity),
            ),
          ),
        ));
  }
}
