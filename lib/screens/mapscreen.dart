import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blood/map_picker/osm_search_and_pick_mod.dart';
import 'package:blood/map_picker/models/hospitals.dart';

class NewInter extends StatefulWidget {
  const NewInter({super.key});

  @override
  State<NewInter> createState() => _NewInterState();
}

class _NewInterState extends State<NewInter> {
  LatLong? latLong;
  String location = '';
  String area = '';
  bool _load = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 129, 36, 30),
            elevation: 0,
            title: const Text('Search your current location')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                  // shape also can be specified like this => shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 129, 36,
                      30), // use decoration for giving both color and radius
                  borderRadius: BorderRadius.circular(
                      20), // otherwise, if we give it separately, error will show up
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(1.0), // here, I set opacity to maximum
                      spreadRadius:
                          3, // this is to specify how much spread the shadow
                      blurRadius: 10, // how much blur the shadow
                      //  offset: Offset(0, 3),
                    ),
                  ]),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Thanks for coming so far!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Please set your location by clicking the button below.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(height: 100),
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "We don't share your location with anyone.",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.question_mark_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "The location you set will be used to show\n you blood requests.",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors
                                .white), // by writing this instead of materialstateproperty, we can give dynamic colors
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
                              color: Color.fromARGB(255, 129, 36, 30),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _load
                              ? const SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator())
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                        ],
                      ),
                      onPressed: () async {
                        _setLoadingState(true);
                        await _getCurrentLocation();

                        await fetchHospitals(
                                latLong!.latitude, latLong!.longitude, 5)
                            .then((value) {
                          OpenStreetMapSearchAndPick.hospitals = value;
                          log(value.toString());
                          _setLoadingState(false);
                        }).catchError((e) {
                          log(e.toString());
                        });

                        if (!mounted) return;
                        _showModalBottomSheet(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              location,
              style: const TextStyle(
                color: Color.fromARGB(255, 129, 36, 30),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              area.isNotEmpty ? "Your are in $area" : '',
              style: const TextStyle(
                color: Color.fromARGB(255, 129, 36, 30),
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            // const SizedBox(height: 10,),
            // ElevatedButton(onPressed: (){}, child: Text("Next")),
          ],
        ));
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withOpacity(
            0.7), // so what this does is that it gives this color to main screen when the sheet pops up
        builder: (BuildContext context) {
          return SizedBox(
            height: 500,
            child: OpenStreetMapSearchAndPick(
              center: latLong ?? LatLong(0, 0),
              buttonColor: const Color.fromARGB(255, 129, 36, 30),
              onPicked: (PickedData pickedData) {
                setState(() {
                  location = pickedData.address;
                  area = pickedData.area;
                });
                Navigator.pop(
                    context); // this enables  to close the bottom sheet when this button is clicked
              },
            ),
          );
        });
  }
}
