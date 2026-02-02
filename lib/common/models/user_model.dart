// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  String? phone;
  String? mail;
  String? userAddress;
  String? imageUrl;
  String? primaryAddress;
  String? balance;

  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel({
    this.uid,
    this.name,
    this.phone,
    this.mail,
    this.userAddress,
    this.imageUrl,
    this.createdAt,
    this.primaryAddress,
    this.updatedAt,
    this.balance,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'phone': phone,
      'mail': mail,
      'userAddress': userAddress,
      'imageUrl': imageUrl,
      "balance": balance,
      'primaryAddress': primaryAddress,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? "",
      name: map['name'] as String? ?? "",
      phone: map['phone'] as String? ?? "",
      mail: map['mail'] as String? ?? "",
      balance: map['balance'] as String? ?? "",
      userAddress: map['userAddress'] as String? ?? "",
      imageUrl: map['imageUrl'] as String? ?? "",
      primaryAddress: map['primaryAddress'] != null
          ? map['primaryAddress'] as String
          : null,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
