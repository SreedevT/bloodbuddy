import 'dart:developer';

import 'package:blood/models/request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

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
  String? _selectedBloodType;
  String? _selectedDate;
  String? _selectedTime;
  TextEditingController _requesterController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _unitsController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  String? _uploadedFileName;
  List<String> _bloodTypes = ['A+', 'B+', 'A-', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
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
  void dispose() {
    _requesterController.dispose();
    _patientNameController.dispose();
    _unitsController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // All fields are valid, submit the form
      String requester = _requesterController.text;
      String patientName = _patientNameController.text;
      String units = _unitsController.text;
      String phone = _phoneController.text;

      print('Requester: $requester');
      print("Patient's Name: $patientName");
      print('Blood Type: $_selectedBloodType');
      print('Units of Blood: $units');
      print('Date: $_selectedDate');
      print('Time: $_selectedTime');
      print('Phone: $phone');
      print('Uploaded File Name: $_uploadedFileName');

      // Implement your logic here to submit the form
    }
  }

  void _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _uploadedFileName = result.files.single.name;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null
          ? DateTime.parse(_selectedDate!)
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime != null
          ? TimeOfDay.fromDateTime(DateTime.parse(_selectedTime!))
          : TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 135, 34, 34),
        title: Text(
          'Request Form',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 3),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Select Location',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          // TODO: Implement search functionality
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 11),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Requester',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the requester';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 11),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Patient's Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the patient's name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 11),
                  DropdownButtonFormField<String>(
                    value: _selectedBloodType,
                    decoration: InputDecoration(
                      labelText: 'Blood Type',
                      border: OutlineInputBorder(),
                    ),
                    items: _bloodTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedBloodType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a blood type';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 11),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Units of Blood',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the units of blood';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 11),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: IgnorePointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Date',
                                border: OutlineInputBorder(),
                              ),
                              initialValue: _selectedDate,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(context),
                          child: IgnorePointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Time',
                                border: OutlineInputBorder(),
                              ),
                              initialValue: _selectedTime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a time';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 11),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 11),
                  ElevatedButton.icon(
                    onPressed: _uploadFile,
                    icon: Icon(
                      Icons.file_upload,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Upload Requisition Form',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(0, 84, 30, 30)!),
                    ),
                  ),
                  SizedBox(height: 11),
                  if (_uploadedFileName != null)
                    Text(
                      'Uploaded File: $_uploadedFileName',
                      style: TextStyle(fontSize: 16),
                    ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 135, 34, 34),
                      ), // Change the button color to blue
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
