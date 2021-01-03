import 'package:casseurflutter/blocs/reminder/reminder.dart';
import 'package:casseurflutter/models/models.dart';
import 'package:casseurflutter/services/api.dart';
import 'package:casseurflutter/views/ViewMemo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class MemoCard extends StatelessWidget {
  const MemoCard({@required this.memo, @required this.edit});

  final Memo memo;
  final void Function(Memo memo) edit;

  Widget _reminderBlocProvider(
      {@required Widget child, @required BuildContext context}) {
    final APIService apiService = RepositoryProvider.of<APIService>(context);

    return BlocProvider<ReminderBloc>(
        create: (BuildContext context) =>
            ReminderBloc(apiService)..add(FetchFirstReminder(memo.id)),
        child: child);
  }

  Future<void> _createReminder(BuildContext context) async {
    try {
      final ReminderBloc reminderBloc = BlocProvider.of<ReminderBloc>(context);
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
      reminderBloc.add(AddReminder(
          memo.id,
          CreateReminderRequest(
              memo.title, 'It\'s time to care about your memo', realTime)));
    } catch (err) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _reminderBlocProvider(
      context: context,
      child: BlocBuilder<ReminderBloc, ReminderState>(
          buildWhen: (ReminderState prev, ReminderState current) =>
              current is MemoReminder,
          builder: (BuildContext context, ReminderState state) {
            if (state is ReminderFailure) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
                duration: const Duration(seconds: 5),
              ));
            }
            final ReminderBloc memoBloc =
                BlocProvider.of<ReminderBloc>(context);
            return GestureDetector(
                onTap: () {
                  Get.to<ViewMemo>(ViewMemo(),
                      arguments: MemoViewRequest(memo.id));
                },
                child: Container(
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
                                        icon: state is MemoReminder &&
                                                state.hasReminder
                                            ? const Icon(Icons.alarm_off)
                                            : const Icon(Icons.alarm_add),
                                        onPressed: () =>
                                            state is MemoReminder &&
                                                    state.hasReminder
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(children: <Widget>[
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        MediaQuery.of(context).size.width *
                                            2 /
                                            3,
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
                ));
          }),
    );
  }
}
