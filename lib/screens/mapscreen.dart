import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:geolocator/geolocator.dart';

class NewInter extends StatefulWidget {
  const NewInter({super.key});

  @override
  State<NewInter> createState() => _NewInterState();
}

class _NewInterState extends State<NewInter> {
  Position? position; // position details to pass to OSM
  bool isSeeLocationInMapEnabled = false; // this allows  to use the disable/enable button

  // function to ge the current latitude and longitude
  void getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    } else {
      Position userPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        position = userPosition;
        isSeeLocationInMapEnabled = true; // This is set to true so once latlong is accessed, view location in map button can be enabled
        print(position?.latitude.toString());
        print(position?.longitude.toString());
      });
    }
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
              height: 350,
              margin: const EdgeInsets.only(
                  top: 30, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                  // shape also can be specified like this => shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 129, 36,30), // use decoration for giving both color and radius
                  borderRadius: BorderRadius.circular(20), // otherwise, if we give it separately, error will show up
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(1.0), // here, I set opacity to maximum
                      spreadRadius:3, // this is to specify how much spread the shadow
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
                      "Please set your location by clicking the below shown button.",
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
                          "The location you set will be used to show\n you blood requests.",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: getCurrentPosition,
                          child: const Text("Set Current Location"),
                        ),
                        ElevatedButton(
                          onPressed: isSeeLocationInMapEnabled?
                              () {
                                  showModalBottomSheet(
                                      context: context,
                                      barrierColor: Colors.black.withOpacity(
                                          0.7), // so what this does is that it gives this color to main screen when the sheet pops up
                                      builder: (BuildContext context) {
                                        return Container(
                                            height: 500,
                                            child: OpenStreetMapSearchAndPick(
                                              center: LatLong(
                                                  position!.latitude,
                                                  position!.longitude),
                                              buttonColor: const Color.fromARGB(
                                                  255, 129, 36, 30),
                                              onPicked: (PickedData) {
                                                setState(() {
                                                  print(PickedData.address);
                                                });
                                                Navigator.pop(
                                                    context); // this enables  to close the bottom sheet when this button is clicked
                                              },
                                            ));
                                      });
                                }
                              : null,
                          child: const Text(
                            "See location in Map",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
