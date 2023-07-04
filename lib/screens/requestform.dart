import 'dart:developer';

import 'package:blood/models/request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../map_picker/osm_search_and_pick_mod.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String pname;
  late String btype;
  late int units;
  late String area;
  String? hospitalName;
  LatLong userLocation = LatLong(0, 0);
  LatLong hospitalLocation = LatLong(0, 0);
  User? user;

  List<String> bloodGroups = ['A+', 'B+', 'A-', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _getCurrentLocation() async {
    Position position = await _determinePosition();

    setState(() {
      userLocation = LatLong(position.latitude, position.longitude);
    });
  }

  //? From https://pub.dev/packages/geolocator
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Request Form"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    child: const Icon(Icons.search),
                    onPressed: () async {
                      await _getCurrentLocation();
                      if (!mounted) return;
                      _showModalBottomSheet(context);
                    },
                  ),
                  Expanded(
                      child: Container(
                    child: Text(hospitalName ?? 'Select a Hospital'),
                  ))
                ],
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter your name";
                          }
                          name = val;
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person_2_outlined),
                          hintText: "Your Name",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter the patient's name";
                          }
                          pname = val;
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: "Patient's Name",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter the number of units required";
                          } else if (int.tryParse(val) == null) {
                            return "Please enter units in number";
                          }
                          units = int.parse(val);
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.bloodtype_rounded),
                          hintText: "Units",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      DropdownButtonFormField(
                        validator: (val) {
                          if (val == null) {
                            return "Please select a blood group";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.bloodtype_outlined),
                          hintText: "Blood Group",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        items: [
                          for (var bGroups in bloodGroups)
                            DropdownMenuItem(
                              value: bGroups,
                              child: Text(bGroups),
                            ),
                        ],
                        onChanged: (val) {
                          setState(() {
                            btype = val.toString();
                          });
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Request(
                                id: user!.uid,
                                bloodGroup: btype,
                                units: units,
                                patientName: pname,
                                name: name,
                                hospitalName: hospitalName!,
                                hospitalLocation:
                                    LatLng(hospitalLocation.latitude, hospitalLocation.longitude),
                                area: area,
                              ).updateRequest();
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 80, 131, 82))),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        // shape and clipBehavior are used to make the sheet have rouned corners
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        barrierColor: Colors.black.withOpacity(
            0.7), // so what this does is that it gives this color to main screen when the sheet pops up
        builder: (BuildContext context) {
          return SizedBox(
            height: 500,
            child: OpenStreetMapSearchAndPick(
              center: userLocation,
              buttonColor: const Color.fromARGB(255, 129, 36, 30),
              onPicked: (PickedData pickedData) async {
                setState(() {
                  hospitalName = _getBuildingName(pickedData.address);
                  area = pickedData.area;
                  hospitalLocation = pickedData.latLong;
                });

                if (!mounted) return;
                Navigator.pop(context);

                // this enables  to close the bottom sheet when this button is clicked
              },
            ),
          );
        });
  }

  _getBuildingName(String address) {
    List<String> addressList = address.split(',');
    log("Hospital name: ${addressList[0]}, ${addressList[1]}");
    return "${addressList[0]}, ${addressList[1]}";
  }
}
