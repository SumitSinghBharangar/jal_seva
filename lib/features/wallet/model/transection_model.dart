import 'dart:convert';

import 'package:jal_seva/common/constants/app_collections.dart';

enum TxnPaymentMethod { razorpay, wallet }

enum TxnPaymentStatus { success, failed, pending }

extension TxnPaymentMethodExt on TxnPaymentMethod {
  static TxnPaymentMethod fromString(String value) {
    return TxnPaymentMethod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TxnPaymentMethod.razorpay,
    );
  }
}

extension TxnPaymentStatusExt on TxnPaymentStatus {
  static TxnPaymentStatus fromString(String value) {
    return TxnPaymentStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TxnPaymentStatus.pending,
    );
  }
}

class TransactionModel {
  String id;
  String uid;
  String orderId;
  num amount;
  TxnPaymentMethod method; // renamed
  TxnPaymentStatus status; // renamed
  DateTime paidAt;
  String? paymentId;
  String? remark;

  TransactionModel({
    required this.id,
    required this.uid,
    required this.orderId,
    required this.amount,
    required this.method,
    required this.status,
    required this.paidAt,
    this.paymentId,
    this.remark,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'orderId': orderId,
      'amount': amount,
      'method': method.name,
      'status': status.name,
      'paidAt': Timestamp.fromDate(paidAt),
      'paymentId': paymentId,
      'remark': remark,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      orderId: map['orderId'] as String,
      amount: map['amount'] as num,
      method: TxnPaymentMethodExt.fromString(map['method'] as String),
      status: TxnPaymentStatusExt.fromString(map['status'] as String),
      paidAt: (map['paidAt'] as Timestamp).toDate(),
      paymentId: map['paymentId'] as String?,
      remark: map['remark'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
