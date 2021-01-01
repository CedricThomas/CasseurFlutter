import 'package:equatable/equatable.dart';

class Subscription extends Equatable {
  Subscription.fromJson(dynamic json)
      : subscriptionId = json['subscription_id'] as String,
        registrationId = json['registration_id'] as String,
        registrationDate = DateTime.parse(json['registration_date'] as String);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'subscription_id': subscriptionId,
        'registration_id': registrationId,
        'registration_date': registrationDate.toIso8601String()
      };

  final String subscriptionId;
  final String registrationId;
  final DateTime registrationDate;

  @override
  List<Object> get props => <Object>[
        subscriptionId,
        registrationId,
        registrationDate,
      ];
}

class CreateSubscription extends Equatable {
  const CreateSubscription({this.registrationId});

  CreateSubscription.fromJson(dynamic json)
      : registrationId = json['registration_id'] as String;


  Map<String, dynamic> toJson() => <String, dynamic>{
    'registration_id': registrationId,
  };

  final String registrationId;

  @override
  List<Object> get props => <Object>[
    registrationId,
  ];
}