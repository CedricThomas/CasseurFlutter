import 'package:equatable/equatable.dart';

class Location extends Equatable {
  const Location(this.latitude, this.longitude);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
      };

  final double latitude;
  final double longitude;

  @override
  List<Object> get props => <Object>[latitude, longitude];
}

class CreateMemoRequest extends Equatable {
  const CreateMemoRequest(this.title, this.content, this.location);

  Map<String, dynamic> toJson() {
    if (location == null) {
      return <String, dynamic>{
        'title': title,
        'content': content,
      };
    }
    return <String, dynamic>{
      'title': title,
      'content': content,
      'location': location.toJson(),
    };
  }

  final String title;
  final String content;
  final Location location;

  @override
  List<Object> get props => <Object>[title, content, location];
}

class UpdateMemoRequest extends Equatable {
  const UpdateMemoRequest(this.title, this.content, this.location);

  Map<String, dynamic> toJson() {
    if (location == null) {
      return <String, dynamic>{
        'title': title,
        'content': content,
      };
    }
    return <String, dynamic>{
      'title': title,
      'content': content,
      'location': location.toJson(),
    };
  }

  final String title;
  final String content;
  final Location location;

  @override
  List<Object> get props => <Object>[title, content, location];
}

class Memo extends Equatable {
  Memo.fromJson(dynamic json)
      : id = json['id'] as String,
        createdAt = DateTime.parse(json['created_at'] as String),
        title = json['title'] as String,
        content = json['content'] as String,
        location = json['location'] as String;

  final String id;
  final DateTime createdAt;
  final String title;
  final String content;
  final String location;

  @override
  List<Object> get props => <Object>[id, createdAt, title, content, location];
}
