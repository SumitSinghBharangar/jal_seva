import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';



class AddressModel {
  String id;
  String uid;
  DateTime createdAt;

  String name;
  String phone;
  String address;
  String street;
  num pincode;
  String appartment;
  String landmark;

  String? pipeImage;

  num lat;
  num lng;

  AddressModel({
    required this.id,
    required this.uid,
    required this.createdAt,
    required this.name,
    required this.phone,
    required this.address,
    required this.street,
    required this.pincode,
    required this.appartment,
    required this.landmark,
    required this.lat,
    required this.lng,
    this.pipeImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'addedAt': Timestamp.fromDate(createdAt),
      'name': name,
      'phone': phone,
      'address': address,
      'street': street,
      'pincode': pincode,
      'appartment': appartment,
      'landmark': landmark,
      'geo': GeoPoint(lat.toDouble(), lng.toDouble()),
      'point':
          geo.point(latitude: lat.toDouble(), longitude: lng.toDouble()).data,
      'pipeImage': pipeImage,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    // log(map.toString());
    log((map['geo'] as GeoPoint).latitude.toString());
    return AddressModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      createdAt: (map['addedAt'] as Timestamp).toDate(),
      name: map['name'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      street: map['street'] as String? ?? "",
      pincode: map['pincode'] as num? ?? 0,
      appartment: map['appartment'] as String? ?? "",
      landmark: map['landmark'] as String? ?? "",
      // lat: map['lat'] as num,
      // lng: map['lng'] as num,
      lat: (map['geo'] as GeoPoint).latitude,
      lng: (map['geo'] as GeoPoint).longitude,
      pipeImage: map['pipeImage'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
