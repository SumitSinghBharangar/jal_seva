import 'package:cloud_firestore/cloud_firestore.dart';

export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_auth/firebase_auth.dart';

var _store = FirebaseFirestore.instance;

CollectionReference<Map<String, dynamic>> users = _store.collection('users');

CollectionReference<Map<String, dynamic>> drivers = _store.collection(
  'drivers',
);

// CollectionReference<Map<String, dynamic>> get userAddresses =>
//     users.doc(FirebaseAuth.instance.currentUser!.uid).collection('addresses');

CollectionReference<Map<String, dynamic>> addressesCollection = _store
    .collection('addresses');

CollectionReference<Map<String, dynamic>> ordersCollection = _store.collection(
  'orders',
);

CollectionReference<Map<String, dynamic>> subscriptionsCollection = _store
    .collection('subscriptions');

CollectionReference<Map<String, dynamic>> balanceCollection = _store.collection(
  'balance',
);
