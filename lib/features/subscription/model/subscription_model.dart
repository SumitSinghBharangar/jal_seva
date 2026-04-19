import 'dart:convert';

import 'package:jal_seva/common/constants/app_collections.dart';
import 'package:jal_seva/common/models/address_model.dart';

class SubscriptionModel {
  String id;
  String uid;
  AddressModel address;

  DateTime? pausedAt;
  Map<String, int> planMap;
  Plan plan;
  DateTime createdAt;
  DateTime reNewDate;
  SubscriptionStatus status;

  SubscriptionModel({
    required this.id,
    required this.uid,
    this.pausedAt,
    required this.address,
    required this.plan,
    required this.reNewDate,
    required this.createdAt,
    required this.planMap,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'address': address.toMap(),
      'plan': plan.name,
      'status': status.name,
      "pausedAt": pausedAt != null ? Timestamp.fromDate(pausedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      "reNewDate": Timestamp.fromDate(reNewDate),
      'planMap': planMap,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] as String,
      uid: map['uid'] as String,

      pausedAt: map['pausedAt'] != null
          ? (map['pausedAt'] as Timestamp).toDate()
          : null,

      address: AddressModel.fromMap(map['address'] as Map<String, dynamic>),

      // Safely convert 'planMap'
      planMap: Map<String, int>.from(
        (map['planMap'] as Map).map(
          (key, value) => MapEntry(key as String, value as int),
        ),
      ),
      plan: PlanExt.fromString(map['plan']),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      reNewDate: (map['reNewDate'] as Timestamp).toDate(),

      status: SubscriptionStatusExt.fromString(map['status'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionModel.fromJson(String source) =>
      SubscriptionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum Plan { daily, alternate, weekly }

enum SubscriptionStatus { active, paused, cancelled, expired }

extension PlanExt on Plan {
  // Convert enum to string
  String get name {
    switch (this) {
      case Plan.daily:
        return 'daily';
      case Plan.weekly:
        return 'weekly';
      case Plan.alternate:
        return 'alternate';
    }
  }

  int get asInt {
    switch (this) {
      case Plan.daily:
        return 0;
      case Plan.weekly:
        return 1;
      case Plan.alternate:
        return 2;
    }
  }

  num get price {
    switch (this) {
      case Plan.daily:
        return 10;
      case Plan.weekly:
        return 10;
      case Plan.alternate:
        return 10;
    }
  }

  // num get days {
  //   switch (this) {
  //     case Plan.monthly:
  //       return 28;
  //     case Plan.weekly:
  //       return 7;
  //     case Plan.yearly:
  //       return 365;
  //   }
  // }

  // Convert string to enum
  static Plan fromString(String status) {
    switch (status) {
      case 'daily':
        return Plan.daily;
      case 'weekly':
        return Plan.weekly;
      case 'alternate':
        return Plan.alternate;

      default:
        throw ArgumentError('Invalid order status: $status');
    }
  }
}

extension SubscriptionStatusExt on SubscriptionStatus {
  // Convert enum to string
  String get name {
    switch (this) {
      case SubscriptionStatus.active:
        return 'active';
      case SubscriptionStatus.cancelled:
        return 'cancelled';
      case SubscriptionStatus.expired:
        return 'expired';
      case SubscriptionStatus.paused:
        return 'paused';
    }
  }

  int get asInt {
    switch (this) {
      case SubscriptionStatus.active:
        return 0;
      case SubscriptionStatus.paused:
        return 1;
      case SubscriptionStatus.expired:
        return 2;
      case SubscriptionStatus.cancelled:
        return 3;
    }
  }

  // Convert string to enum
  static SubscriptionStatus fromString(String status) {
    switch (status) {
      case 'active':
        return SubscriptionStatus.active;
      case 'paused':
        return SubscriptionStatus.paused;
      case 'expired':
        return SubscriptionStatus.expired;
      case 'cancelled':
        return SubscriptionStatus.cancelled;

      default:
        throw ArgumentError('Invalid order status: $status');
    }
  }
}
