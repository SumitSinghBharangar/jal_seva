import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jal_seva/common/constants/app_collections.dart';



import 'package:jal_seva/common/models/user_model.dart';

class AuthServices extends ChangeNotifier {
  bool isLoading = false;
  String? _verificationId;
  String? phoneNumber;
  String? location;
  Position? position;
  // UserModel? user;
  String? primaryAdress;

  Future<void> sendOtp({
    required String phone,
    required void Function(bool success) onSend,
  }) async {
    isLoading = true;
    notifyListeners();

    phoneNumber = phone;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phone',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          log(e.message ?? "");
          Fluttertoast.showToast(msg: e.message ?? "Failed");
          isLoading = false;
          notifyListeners();
          onSend(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          onSend(false);
          Fluttertoast.showToast(msg: "Code sent");
          _verificationId = verificationId;

          isLoading = false;
          notifyListeners();
          onSend(true);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          isLoading = false;
          notifyListeners();
          onSend(false);
        },
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message ?? e.code);
      isLoading = false;

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> verifyOTP({required String otp}) async {
    isLoading = true;
    notifyListeners();

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      isLoading = false;
      notifyListeners();
      await init();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: "This Number is already linked with one account",
          toastLength: Toast.LENGTH_LONG,
        );

        return false;
      }
      if (e.code == 'session-expired') {
        Fluttertoast.showToast(msg: "Session expired..");
        return false;
      }

      isLoading = false;
      Fluttertoast.showToast(
        msg: e.code == 'invalid-verification-code'
            ? "Incorrect OTP"
            : e.message ?? e.code,
      );

      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");

      isLoading = false;
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  resend({required void Function(bool success) onSend}) {
    if (phoneNumber != null) {
      sendOtp(phone: phoneNumber!, onSend: onSend);
    }
  }

  init() async {
    isLoading = true;
    notifyListeners();

    // var u = FirebaseAuth.instance.currentUser!;

    // var data = await users.doc(u.uid).get();

    // String? token = await FirebaseMessaging.instance.getToken();

    // if (data.exists) {
    //   primaryAdress = (data.data()!)['primaryAdress'] as String?;

    //   await users.doc(u.uid).update({
    //     'tokens': FieldValue.arrayUnion([token]),
    //   });

    //   notifyListeners();
    // } else {
    //   await users.doc(u.uid).set({
    //     'uid': u.uid,
    //     'phone': u.phoneNumber,
    //     'primaryAdress': null,
    //     'createdAt': Timestamp.fromDate(
    //       u.metadata.creationTime ?? DateTime.now(),
    //     ),
    //     'lastSignIn': Timestamp.fromDate(
    //       u.metadata.lastSignInTime ?? DateTime.now(),
    //     ),
    //     'tokens': [token],
    //   });
    // }

    // if (u.displayName == null) {
    //   try {
    //     var data = await users.doc(u.uid).get();
    //     if (data.data() == null) {
    //       user = UserModel.fromMap(data.data()!);
    //     }
    //   } catch (e) {
    //     log(e.toString());
    //   }
    // }
    var r = await _getCurrentLocationName();
    location = r;

    isLoading = false;
    notifyListeners();
  }

  updatePrimary(String? id) async {
    var u = FirebaseAuth.instance.currentUser!;

    await users.doc(u.uid).update({'primaryAdress': id});
    primaryAdress = id;
    notifyListeners();
  }

  updateProfile({
    required String name,
    required String phone,
    required String mail,
    required String imageUrl,
  }) async {
    isLoading = true;
    notifyListeners();
    var u = FirebaseAuth.instance.currentUser!;
    await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
    await FirebaseAuth.instance.currentUser?.reload();
    UserModel user = UserModel(
      uid: u.uid,
      name: name,
      phone: phone,
      mail: mail,
      balance: "0.00",
      imageUrl: imageUrl,
      createdAt: u.metadata.creationTime ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await users.doc(u.uid).update(user.toMap());
    } catch (e) {
      await users.doc(u.uid).set(user.toMap());
    }

    await u.updateDisplayName(name);
    await u.updatePhotoURL(imageUrl);

    await u.reload();

    await init();

    isLoading = false;
    notifyListeners();
  }

  Future<String?> _getCurrentLocationName() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg:
            'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    final location = await Geolocator.getCurrentPosition();
    position = location;
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );

    var f = placemarks.first;
    return (f.street ?? "") + (f.country ?? "");
  }
}
