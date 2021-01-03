import 'package:casseurflutter/blocs/memo/memo.dart';
import 'package:casseurflutter/models/models.dart';
import 'package:casseurflutter/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemoCard extends StatelessWidget {
  const MemoCard({@required this.memo, @required this.edit});

  final Memo memo;
  final void Function(Memo memo) edit;

  Widget _memoBlocProvider(
      {@required Widget child, @required BuildContext context}) {
    final APIService apiService = RepositoryProvider.of<APIService>(context);

    return BlocProvider<MemoBloc>(
        create: (BuildContext context) =>
            MemoBloc(apiService)..add(FetchFirstReminder(memo.id)),
        child: child);
  }

  Future<void> _createReminder(BuildContext context) async {
    try {
      final MemoBloc memoBloc = BlocProvider.of<MemoBloc>(context);
      final DateTime date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)));
      if (date == null) {
        return;
      }
      final TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time == null) {
        return;
      }
      final DateTime realTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      memoBloc.add(AddReminder(
          memo.id,
          CreateReminderRequest(
              memo.title, 'It\'s time to care about your memo', realTime)));
    } catch (err) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _memoBlocProvider(
      context: context,
      child: BlocBuilder<MemoBloc, MemoState>(
          buildWhen: (MemoState prev, MemoState current) =>
              current is MemoReminder,
          builder: (BuildContext context, MemoState rawState) {
            if (rawState is MemoFailure) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(rawState.error),
                duration: const Duration(seconds: 5),
              ));
            }
            if (rawState is! MemoReminder) {
              return Container();
            }
            final MemoBloc memoBloc = BlocProvider.of<MemoBloc>(context);
            final MemoReminder state = rawState as MemoReminder;
            return Container(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                memo.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 30.0),
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: state.hasReminder
                                        ? const Icon(Icons.alarm_off)
                                        : const Icon(Icons.alarm_add),
                                    onPressed: () => state.hasReminder
                                        ? memoBloc.add(DeleteReminder(
                                            memo.id, state.reminderId))
                                        : _createReminder(context),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => edit(memo),
                                  ),
                                ],
                              ),
                            )
                          ]),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(children: <Widget>[
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      constraints: const BoxConstraints(
                                          minHeight: 100,
                                          minWidth: double.infinity,
                                          maxHeight: 300),
                                      child: Text(
                                        memo.content,
                                      )),
                                ],
                              ),
                            ),
                          ])),
                      Row(
                        children: <Widget>[
                          if (memo.location != null && memo.location != '')
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 2 / 3,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(Icons.location_pin),
                                  Expanded(
                                    child: Text(
                                      memo.location,
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
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
