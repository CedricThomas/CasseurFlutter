import 'package:casseurflutter/blocs/memo/memo.dart';
import 'package:casseurflutter/widgets/view_memo/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewMemo extends StatefulWidget {
  static const String id = '/viewMemo';

  @override
  _ViewMemo createState() => _ViewMemo();
}

class _ViewMemo extends State<ViewMemo> {
  @override
  Widget build(BuildContext context) {
    return ViewMemoScaffold(child: BlocBuilder<MemoBloc, MemoState>(
        builder: (BuildContext context, MemoState state) {
      if (state is MemoLoaded) {
        return Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (state.memo.location != null && state.memo.location != '')
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(Icons.location_pin),
                          Expanded(
                            child: Text(
                              state.memo.location,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      state.memo.content,
                    )),
              ],
            ),
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
