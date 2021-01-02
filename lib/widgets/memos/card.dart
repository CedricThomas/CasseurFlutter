import 'package:casseurflutter/models/models.dart';
import 'package:flutter/material.dart';

class MemoCard extends StatelessWidget {
  const MemoCard({@required this.memo, @required this.edit});

  final Memo memo;
  final void Function(Memo memo) edit;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(children: <Widget>[
                Flexible(
                  child: Text(
                    memo.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 30.0),
                  ),
                ),
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
                        maxWidth: MediaQuery.of(context).size.width * 2 / 3,
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
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => edit(memo),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
