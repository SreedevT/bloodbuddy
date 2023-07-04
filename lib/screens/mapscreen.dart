import 'dart:developer';
import 'package:blood/Firestore/userprofile.dart';
import 'package:blood/widgets/confetti.dart';
import 'package:blood/widgets/info_text.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blood/map_picker/osm_search_and_pick_mod.dart';
import 'package:blood/map_picker/models/hospitals.dart';
import 'package:lottie/lottie.dart';

class NewInter extends StatefulWidget {
  const NewInter({super.key});

  @override
  State<NewInter> createState() => _NewInterState();
}

class _NewInterState extends State<NewInter> {
  LatLong latLong = LatLong(0, 0);
  String location = '';
  String area = '';
  bool _load = false;

  late final ConfettiController _confettiController;

  Future<void> _getCurrentLocation() async {
    Position position = await _determinePosition();

    setState(() {
      latLong = LatLong(position.latitude, position.longitude);
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

  void _setLoadingState(bool load) {
    setState(() {
      _load = load;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  // ignore: prefer_typing_uninitialized_variables
  var con;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser as User;
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    con = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 198, 40, 40),
        elevation: 0,
        title: const Text(
          'Set your current location',
        ),
      ),
      body: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Lottie.asset('assets/lottie/select-location.json', width: 350),
          // Lottie.asset('assets/lottie/location-animation.json'),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: InfoBox(
              icon: Icons.question_mark_outlined,
              text:
                  "The location you set will be used to show you nearby requests.",
              textColor: Color.fromRGBO(104, 104, 104, 1),
              backgroundColor: Color.fromRGBO(255, 235, 238, 1),
              // borderColor: Color.fromRGBO(250, 250, 250, 1),
              borderColor: Colors.grey,
            ),
          ),
          area.isEmpty
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InfoBox(
                    icon: Icons.location_on_outlined,
                    text: "You'll get requests from hospitals in $area.",
                    textColor: const Color.fromRGBO(104, 104, 104, 1),
                    backgroundColor: const Color.fromARGB(191, 200, 230, 201),
                  ),
                ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => const Color.fromARGB(255, 198, 40, 40),
                ), // by writing this instead of materialstateproperty, we can give dynamic colors
                overlayColor: MaterialStateColor.resolveWith((states) =>
                    Colors.green.withOpacity(
                        0.3)), // like here the button color is changed, when we tap it. COOL ;)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Set Current Location",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _load
                      ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        ),
                ],
              ),
              onPressed: () async {
                _setLoadingState(true);
                await _getCurrentLocation();

                await fetchHospitals(latLong.latitude, latLong.longitude, 5)
                    .then((value) {
                  OpenStreetMapSearchAndPick.hospitals = value;
                  // log(value.toString());
                  _setLoadingState(false);
                }).catchError((e) {
                  log(e.toString());
                });

                if (!mounted) return;
                _showModalBottomSheet(context);
              },
            ),
          ),
          // ElevatedButton(onPressed: () => _confettiController.play(), child: Text('Play')),
          const Expanded(child: SizedBox(height: 20)),

          area.isEmpty
              ? const SizedBox(height: 0)
              : InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      con,
                      'home',
                      (route) => false,
                    );
                  },
                  onLongPress: () => _confettiController.play(),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 198, 40, 40),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Center(
                      child: Text(
                        'DONE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
        ]),
        Align(alignment: Alignment.topCenter,child: Confettie(controller: _confettiController)),
      ]),
    );
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
              center: latLong,
              buttonColor: const Color.fromARGB(255, 129, 36, 30),
              onPicked: (PickedData pickedData) async {
                setState(() {
                  location = pickedData.address;
                  area = pickedData.area;
                });

                await DataBase(uid: user.uid).updateUserLocation(area);

                Navigator.pop(con);

                await Future.delayed(const Duration(milliseconds: 200), () {
                  _confettiController.play();
                });
                // this enables  to close the bottom sheet when this button is clicked
              },
            ),
          );
        });
  }
}
