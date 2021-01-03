import 'package:equatable/equatable.dart';

class CreateReminderRequest extends Equatable {
  const CreateReminderRequest(this.title, this.content, this.date);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'content': content,
        'date': date.toUtc().toIso8601String(),
      };

  final String title;
  final String content;
  final DateTime date;

  @override
  List<Object> get props => <Object>[title, content, date];
}

class Reminder extends Equatable {
  Reminder.fromJson(dynamic json)
      : id = json['id'] as String,
        triggered = json['triggered'] as bool;

  final String id;
  final bool triggered;

  @override
  List<Object> get props => <Object>[id];
}
