import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jal_seva/common/models/address_model.dart';

class OrderModel {
  String id;
  AddressModel address;
  bool isExpressDelivery;
  int quantity;
  num totalCharge;
  DateTime createdAt;
  String uid;
  OrderStatus status;
  bool isClosed;
  num? rating;
  String? feedBack;
  String? driverId;

  OrderModel({
    required this.id,
    required this.address,
    required this.isExpressDelivery,
    required this.quantity,
    required this.totalCharge,
    required this.createdAt,
    required this.uid,
    required this.status,
    required this.isClosed,
    this.rating,
    this.feedBack,
    this.driverId,
  });

  // 🔥 Firestore Map (uses Timestamp)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address.toMap(),
      'isExpressDelivery': isExpressDelivery,
      'quantity': quantity,
      'totalCharge': totalCharge,
      'createdAt': Timestamp.fromDate(createdAt),
      'uid': uid,
      'status': status.name,
      'isClosed': isClosed,
      'rating': rating,
      'feedBack': feedBack,
      "driverId": driverId,
    };
  }

  // 🔥 JSON Map (NO Timestamp here)
  Map<String, dynamic> toJsonMap() {
    return {
      'id': id,
      'address': address.toMap(),
      'isExpressDelivery': isExpressDelivery,
      'quantity': quantity,
      'totalCharge': totalCharge,
      'createdAt': createdAt.toIso8601String(),
      'uid': uid,
      'status': status.name,
      'isClosed': isClosed,
      'rating': rating,
      'feedBack': feedBack,
      "driverId": driverId,
    };
  }

  // 🔥 Firestore → Model
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      status: OrderStatusExt.fromString(map['status'] as String),
      id: map['id'] as String,
      address: AddressModel.fromMap(map['address'] as Map<String, dynamic>),
      isExpressDelivery: map['isExpressDelivery'] as bool,
      quantity: map['quantity'] as int,
      totalCharge: map['totalCharge'] as num,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      uid: map['uid'] as String,
      isClosed: map['isClosed'] as bool,
      rating: map['rating'] as num?,
      feedBack: map['feedBack'] as String?,
      driverId: map['driverId'] as String?,
    );
  }

  // 🔥 JSON → Model
  factory OrderModel.fromJson(String source) {
    final map = json.decode(source);

    return OrderModel(
      status: OrderStatusExt.fromString(map['status']),
      id: map['id'],
      address: AddressModel.fromMap(map['address']),
      isExpressDelivery: map['isExpressDelivery'],
      quantity: map['quantity'],
      totalCharge: map['totalCharge'],
      createdAt: DateTime.parse(map['createdAt']), // ✅ fixed
      uid: map['uid'],
      isClosed: map['isClosed'],
      rating: map['rating'],
      feedBack: map['feedBack'],
      driverId: map['driverId'],
    );
  }

  // 🔥 Model → JSON String
  String toJson() => json.encode(toJsonMap());
}

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

extension OrderStatusExt on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  static OrderStatus fromString(String status) {
    switch (status) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        throw ArgumentError('Invalid order status: $status');
    }
  }
}
