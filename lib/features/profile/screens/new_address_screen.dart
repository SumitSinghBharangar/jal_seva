import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/common/constants/app_collections.dart';
import 'package:jal_seva/common/models/address_model.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:jal_seva/utils.dart';
import 'package:string_validator/string_validator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dotted_border/dotted_border.dart';

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({super.key});

  @override
  State<NewAddressScreen> createState() => _SavedAddressState();
}

class _SavedAddressState extends State<NewAddressScreen> {
  double? lat;
  double? lng;

  final TextEditingController _street = TextEditingController();
  final TextEditingController _postCode = TextEditingController();
  final TextEditingController _pinCode = TextEditingController();

  final TextEditingController _address = TextEditingController();
  final TextEditingController _apartment = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _landmark = TextEditingController();

  ValueNotifier<int?> labeTyperNotifier = ValueNotifier<int?>(null);

  LatLng _initialPosition = const LatLng(37.77483, -122.41942);
  LatLng _pickedLocation = const LatLng(0, 0);
  bool _isAddressWorking = false;

  File? pickedFile;
  final _fKey = GlobalKey<FormState>();
  ImageSource? source;
  Marker? _locationMarker;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    // _getUserLocation(); //get location when the user want to set loaction by using the current loacation
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _pickedLocation = _initialPosition;
      getName();
      _locationMarker = _createMarker(_pickedLocation);
      setState(() {});
    });
  }

  Marker _createMarker(LatLng position) {
    return Marker(
      markerId: const MarkerId('selected-location'),
      position: position,
      infoWindow: const InfoWindow(title: 'Selected Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }

  getName() async {
    _isAddressWorking = true;
    setState(() {});

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _initialPosition.latitude,
      _initialPosition.longitude,
    ); // change here _initialPosition  to  _pickedLocation

    var f = placemarks.first;

    _address.text = (f.street ?? "") + (f.country ?? "");
    _street.text = (f.street ?? "");
    _pinCode.text = (f.postalCode ?? "");
    _landmark.text = (f.administrativeArea ?? "");
    _isAddressWorking = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.3),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left),
        ),
        title: Text(
          "Add New Address",
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Form(
              key: _fKey,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * .05,
                        ),
                        CustomTextField(
                          controller: _fullName,
                          iconData: Iconsax.personalcard,
                          hintText: "full Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            if (value.length < 3) {
                              return "Must Have 3 Chars";
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: _phoneNumber,
                          iconData: Iconsax.personalcard,
                          hintText: "Enter Phone Number",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }

                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Text(
                              "Select location",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                          .85,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  context.pop();
                                                },
                                                icon: const Icon(Icons.close),
                                              ),
                                              const Spacer(),
                                              CupertinoButton(
                                                onPressed: () {
                                                  context.pop();
                                                },
                                                child: Text("Done"),
                                              ),
                                            ],
                                          ),
                                          StatefulBuilder(
                                            builder: (context, setS) {
                                              return Expanded(
                                                child: GoogleMap(
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                        target:
                                                            _initialPosition,
                                                        zoom: 2.0,
                                                      ),
                                                  onTap: (argument) {
                                                    _pickedLocation = argument;
                                                    getName();
                                                    _locationMarker =
                                                        _createMarker(argument);
                                                    _controller?.animateCamera(
                                                      CameraUpdate.newLatLng(
                                                        argument,
                                                      ),
                                                    );
                                                    setState(() {});
                                                    setS(() {});
                                                  },
                                                  myLocationEnabled: true,
                                                  markers:
                                                      _locationMarker != null
                                                      ? {_locationMarker!}
                                                      : {},
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text("See Full Map"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: GoogleMap(
                      gestureRecognizers: {
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 2.0,
                      ),
                      // onCameraMove: _onCameraMove,
                      mapToolbarEnabled: false,
                      myLocationButtonEnabled: false,
                      onMapCreated: (controller) {
                        _controller = controller;
                        _controller?.animateCamera(
                          CameraUpdate.newLatLng(_pickedLocation),
                        );
                      },
                      onTap: (argument) {
                        _pickedLocation = argument;
                        getName();
                        _locationMarker = _createMarker(argument);
                        setState(() {});
                      },

                      markers: _locationMarker != null
                          ? {_locationMarker!}
                          : {},
                      myLocationEnabled: true,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                showLoading(context);

                                var r = await Geolocator.getCurrentPosition();
                                lat = r.latitude;
                                lng = r.longitude;

                                _pickedLocation = LatLng(
                                  r.latitude,
                                  r.longitude,
                                );
                                _locationMarker = _createMarker(
                                  _pickedLocation,
                                );

                                setState(() {});
                                _controller?.animateCamera(
                                  CameraUpdate.newLatLng(_pickedLocation),
                                );

                                await getName();

                                if (context.mounted) context.pop();
                              },
                              label: Text("use current location"),
                              icon: const Icon(Iconsax.gps),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: _address,
                          enabled: !_isAddressWorking,
                          hintText: "Address",
                          iconData: Iconsax.building,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: _street,
                          enabled: !_isAddressWorking,
                          hintText: "Your Street",
                          iconData: Iconsax.path,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: _landmark,
                          enabled: !_isAddressWorking,
                          hintText: "Nearby Landmark",
                          iconData: Iconsax.home,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: _pinCode,
                          enabled: !_isAddressWorking,
                          hintText: "Your Postcode",
                          iconData: Iconsax.personalcard,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: _apartment,
                          enabled: !_isAddressWorking,
                          hintText: "Your building no",
                          iconData: Iconsax.home,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Pipe Image",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        if (pickedFile == null)
                          DottedBorder(
                            // borderType: BorderType.RRect,
                            // radius: const Radius.circular(30),
                            // strokeWidth: 3,
                            // dashPattern: const [6, 12],
                            // strokeCap: StrokeCap.round,
                            // padding: const EdgeInsets.all(8),
                            // borderPadding: const EdgeInsets.all(4),
                            child: SizedBox(
                              height:
                                  ((MediaQuery.sizeOf(context).width - 44) *
                                  (3 / 4)),
                              width: double.infinity,
                              child: Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(16.h),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "Select the image source and pick image",
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ScaleButton(
                                            onTap: () {
                                              source = ImageSource.camera;

                                              setState(() {});
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 400,
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border:
                                                    source != ImageSource.camera
                                                    ? null
                                                    : Border.all(
                                                        color: AppColors
                                                            .buttonColor,
                                                        width: 4,
                                                      ),
                                              ),
                                              child: Image.asset(
                                                'assets/icons/camera.png',
                                              ),
                                            ),
                                          ),
                                          ScaleButton(
                                            onTap: () {
                                              source = ImageSource.gallery;
                                              setState(() {});
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 400,
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border:
                                                    source !=
                                                        ImageSource.gallery
                                                    ? null
                                                    : Border.all(
                                                        color: AppColors
                                                            .buttonColor,
                                                        width: 4,
                                                        strokeAlign: BorderSide
                                                            .strokeAlignInside,
                                                      ),
                                              ),
                                              child: Image.asset(
                                                'assets/icons/gallery.png',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: source == null
                                          ? null
                                          : () async {
                                              var r = await ImagePicker()
                                                  .pickImage(source: source!);
                                              if (r != null) {
                                                try {
                                                  pickedFile = File(r.path);
                                                  setState(() {});
                                                } catch (e) {
                                                  log(e.toString());
                                                }
                                              }
                                            },
                                      child: Text("Pick Image"),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.file(
                              pickedFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height:
                                  ((MediaQuery.sizeOf(context).width - 44) *
                                  (3 / 4)),
                            ),
                          ),
                        const SizedBox(height: 20),
                        DynamicButton.fromText(
                          onPressed: () async {
                            if (_fKey.currentState?.validate() ?? false) {
                              showLoading(context);
                              var ref = addressesCollection.doc();
                              await FirebaseAuth.instance.currentUser
                                  ?.updateDisplayName(_fullName.text);
                              await FirebaseAuth.instance.currentUser?.reload();

                              String? imgUrl;
                              String uid =
                                  FirebaseAuth.instance.currentUser!.uid;

                              var storageRef = FirebaseStorage.instance
                                  .ref(uid)
                                  .child('pipeImages')
                                  .child(ref.id);
                              if (pickedFile != null) {
                                var data = await pickedFile!.readAsBytes();

                                await storageRef.putData(data).whenComplete(
                                  () async {
                                    imgUrl = await storageRef.getDownloadURL();
                                  },
                                );

                                imgUrl = await storageRef.getDownloadURL();
                              }

                              AddressModel model = AddressModel(
                                id: ref.id,
                                uid: uid,
                                createdAt: DateTime.now(),
                                name: _fullName.text,
                                phone: _phoneNumber.text,
                                address: _address.text,
                                lat: _pickedLocation.latitude,
                                lng: _pickedLocation.longitude,
                                pipeImage: imgUrl,
                                street: _street.text,
                                pincode: _pinCode.text.toInt(),
                                appartment: _apartment.text,
                                landmark: _landmark.text,
                              );

                              await ref.set(model.toMap());

                              if (context.mounted) {
                                context.pop();
                                context.push(Routes.addressAdded.path);
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "Check your Credentials",
                              );
                            }
                          },
                          text: "Add address",
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ), // previous widget
                  // SizedBox(
                  //   height: 300,
                  //   width: double.infinity,
                  //   child: GoogleMap(
                  //     gestureRecognizers: {
                  //       Factory<OneSequenceGestureRecognizer>(
                  //           () => EagerGestureRecognizer())
                  //     },
                  //     initialCameraPosition: CameraPosition(
                  //       target: _initialPosition,
                  //       zoom: 2.0,
                  //     ),
                  //     // onCameraMove: _onCameraMove,
                  //     mapToolbarEnabled: false,
                  //     myLocationButtonEnabled: false,
                  //     onMapCreated: (controller) {
                  //       _controller = controller;
                  //       _controller?.animateCamera(
                  //           CameraUpdate.newLatLng(_pickedLocation));
                  //     },
                  //     onTap: (argument) {
                  //       _pickedLocation = argument;
                  //       getName();
                  //       _locationMarker = _createMarker(argument);
                  //       setState(() {});
                  //     },

                  //     markers:
                  //         _locationMarker != null ? {_locationMarker!} : {},
                  //     myLocationEnabled: true,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 15.h,
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 32.w),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "ADDRESS",
                  //         style: TextStyle(fontSize: 14.sp),
                  //       ),
                  //       SizedBox(
                  //         height: 7.5.h,
                  //       ),
                  //       CustomTextField(
                  //         controller: _address,
                  //         enabled: !_isAddressWorking,
                  //         hintText: "",
                  //         iconData: Icons.location_pin,
                  //         validator: (value) {
                  //           if (value == null || value.isEmpty) {
                  //             return "This can't be empty";
                  //           }
                  //           return null;
                  //         },
                  //       ),
                  //       SizedBox(
                  //         height: 10.h,
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         mainAxisSize: MainAxisSize.max,
                  //         children: [
                  //           Flexible(
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Text(
                  //                   "STREET",
                  //                   style: TextStyle(fontSize: 14.sp),
                  //                 ),
                  //                 CustomTextField(
                  //                   controller: _street,
                  //                   hintText: "",
                  //                   validator: (value) {
                  //                     if (value == null || value.isEmpty) {
                  //                       return "This field is required";
                  //                     }
                  //                     if (value.length < 3) {
                  //                       return "Must have at least 3 chars";
                  //                     }
                  //                     return null;
                  //                   },
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             width: 20.w,
                  //           ),
                  //           Flexible(
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Text(
                  //                   "POST CODE",
                  //                   style: TextStyle(fontSize: 14.sp),
                  //                 ),
                  //                 CustomTextField(
                  //                   controller: _postCode,
                  //                   hintText: "",
                  //                   // iconData: Iconsax.personalcard,
                  //                   validator: (value) {
                  //                     if (value == null || value.isEmpty) {
                  //                       return "This field is required";
                  //                     }
                  //                     if (value.length < 3) {
                  //                       return "Must have at least 3 chars";
                  //                     }
                  //                     return null;
                  //                   },
                  //                 ),
                  //               ],
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: 15.h,
                  //       ),
                  //       Text(
                  //         "APPARTMENT",
                  //         style: TextStyle(fontSize: 14.sp),
                  //       ),
                  //       CustomTextField(
                  //         controller: _apartment,
                  //         hintText: "",
                  //         validator: (value) {
                  //           if (value == null || value.isEmpty) {
                  //             return "This field is required";
                  //           }
                  //           return null;
                  //         },
                  //       ),
                  //       SizedBox(
                  //         height: 15.h,
                  //       ),
                  //       Text(
                  //         "LABEL AS",
                  //         style: TextStyle(fontSize: 14.sp),
                  //       ),
                  //       SizedBox(
                  //         height: 7.5.h,
                  //       ),
                  //       ValueListenableBuilder(
                  //         valueListenable: labeTyperNotifier,
                  //         builder: (context, value, _) {
                  //           return Row(
                  //             children: [
                  //               Expanded(
                  //                 child: ScaleButton(
                  //                   scale: .98,
                  //                   onTap: () {
                  //                     labeTyperNotifier.value = 1;
                  //                   },
                  //                   child: AnimatedContainer(
                  //                     duration:
                  //                         const Duration(milliseconds: 400),
                  //                     padding: const EdgeInsets.all(12),
                  //                     decoration: BoxDecoration(
                  //                       color: value == 1
                  //                           ? AppColors.buttonColor
                  //                           : Colors.grey.withOpacity(0.1),
                  //                       borderRadius:
                  //                           BorderRadius.circular(22.5),
                  //                       border: Border.all(
                  //                         width: value == 1 ? 2 : .5,
                  //                         strokeAlign:
                  //                             BorderSide.strokeAlignOutside,
                  //                         color: value == 1
                  //                             ? AppColors.buttonColor
                  //                             : Colors.grey,
                  //                       ),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         "Home",
                  //                         style: TextStyle(
                  //                             fontSize: 14.sp,
                  //                             color: value == 1
                  //                                 ? Colors.white
                  //                                 : Colors.black),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 width: 20.w,
                  //               ),
                  //               Expanded(
                  //                 child: ScaleButton(
                  //                   scale: .98,
                  //                   onTap: () {
                  //                     labeTyperNotifier.value = 2;
                  //                   },
                  //                   child: AnimatedContainer(
                  //                     duration:
                  //                         const Duration(milliseconds: 400),
                  //                     padding: const EdgeInsets.all(12),
                  //                     decoration: BoxDecoration(
                  //                       color: value == 2
                  //                           ? AppColors.buttonColor
                  //                           : Colors.grey.withOpacity(0.1),
                  //                       borderRadius:
                  //                           BorderRadius.circular(22.5),
                  //                       border: Border.all(
                  //                         width: value == 2 ? 2 : .5,
                  //                         strokeAlign:
                  //                             BorderSide.strokeAlignOutside,
                  //                         color: value == 2
                  //                             ? AppColors.buttonColor
                  //                             : Colors.grey,
                  //                       ),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         "Work",
                  //                         style: TextStyle(
                  //                             fontSize: 14.sp,
                  //                             color: value == 2
                  //                                 ? Colors.white
                  //                                 : Colors.black),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 width: 20.w,
                  //               ),
                  //               Expanded(
                  //                 child: ScaleButton(
                  //                   scale: .98,
                  //                   onTap: () {
                  //                     labeTyperNotifier.value = 3;
                  //                   },
                  //                   child: AnimatedContainer(
                  //                     duration:
                  //                         const Duration(milliseconds: 400),
                  //                     padding: const EdgeInsets.all(12),
                  //                     decoration: BoxDecoration(
                  //                       color: value == 3
                  //                           ? AppColors.buttonColor
                  //                           : Colors.grey.withOpacity(0.1),
                  //                       borderRadius:
                  //                           BorderRadius.circular(22.5),
                  //                       border: Border.all(
                  //                         width: value == 3 ? 2 : .5,
                  //                         strokeAlign:
                  //                             BorderSide.strokeAlignOutside,
                  //                         color: value == 3
                  //                             ? AppColors.buttonColor
                  //                             : Colors.grey,
                  //                       ),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         "Other",
                  //                         style: TextStyle(
                  //                             fontSize: 14.sp,
                  //                             color: value == 3
                  //                                 ? Colors.white
                  //                                 : Colors.black),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           );
                  //         },
                  //       ),
                  //       SizedBox(
                  //         height: 20.h,
                  //       ),
                  //       DynamicButton.fromText(
                  //           text: "Save Location", onPressed: () {
                  //             if(_fKey.currentState?.validate() ?? false){
                  //               showLoading(context);

                  //             }
                  //           },)
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // Positioned(
          //   top: 44.h,
          //   left: 18.w,
          //   child: IconButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     icon: const Icon(
          //       Iconsax.arrow_left,
          //       color: Colors.black,
          //       size: 35,
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: ClipRRect(
          //     child: Container(
          //       padding: EdgeInsets.only(
          //         top: MediaQuery.paddingOf(context).top + 10,
          //         bottom: 22,
          //         left: 22,
          //         right: 22,
          //       ),
          //       decoration: BoxDecoration(
          //         color: Colors.white.withOpacity(.3),
          //       ),
          //       child: Row(
          //         children: [
          //           GestureDetector(
          //             onTap: () {
          //               context.pop();
          //             },
          //             child: Container(
          //     padding: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       shape: BoxShape.circle,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.withOpacity(.1),
          //           blurRadius: 2,
          //           offset: const Offset(2, 2),
          //         ),
          //       ],
          //     ),
          //     child: const Icon(Iconsax.arrow_left),
          //   ),
          // ),
          // addnewaddress title
          // ],
          // ),
          // ),
          // ),
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _street.dispose();
    _postCode.dispose();
    _address.dispose();
    super.dispose();
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.iconData,
    required this.hintText,
    this.validator,
    this.removeFocusOutside,
    this.isNumber,
    this.onChanged,
    this.autofocus,
    this.bottomPadding,
    this.enabled,
    this.noKeyboard,
    this.onFocused,
  });

  final TextEditingController? controller;
  final IconData? iconData;
  final String hintText;
  final String? Function(String? value)? validator;
  final bool? removeFocusOutside;
  final bool? isNumber;
  final void Function(String value)? onChanged;
  final bool? autofocus;
  final bool? bottomPadding;
  final bool? enabled;
  final bool? noKeyboard;
  final VoidCallback? onFocused;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.addListener(() {
        setState(() {
          _focused = _focusNode.hasFocus;
        });

        if (widget.onFocused != null) {
          if (_focused) {
            widget.onFocused!();
          }
        }
        if (widget.noKeyboard ?? false) {
          _focusNode.unfocus();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: (widget.bottomPadding ?? true) ? 20 : 0),
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastEaseInToSlowEaseOut,
          decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(_focused ? .1 : .07),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (widget.iconData != null)
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(widget.iconData),
                ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextFormField(
                  enabled: widget.enabled,
                  onChanged: widget.onChanged,
                  autofocus: widget.autofocus ?? false,
                  keyboardType: (widget.noKeyboard ?? false)
                      ? TextInputType.none
                      : (widget.isNumber ?? false)
                      ? TextInputType.number
                      : null,
                  inputFormatters: (widget.isNumber ?? false)
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : null,
                  onTapOutside: (widget.removeFocusOutside ?? false)
                      ? (_) {
                          _focusNode.unfocus();
                        }
                      : null,
                  validator: widget.validator,
                  focusNode: _focusNode,
                  controller: widget.controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: widget.hintText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
