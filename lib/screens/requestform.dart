import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../map_picker/osm_search_and_pick_mod.dart';
import '../models/request.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String pname;
  late int units;
  late String area;
  String? hospitalName;
  LatLong userLocation = LatLong(0, 0);
  LatLong hospitalLocation = LatLong(0, 0);
  String? _selectedBloodType;
  bool isEmergency = false;
  String? _selectedDate;
  String? _selectedTime;
  DateTime? _selectedDateTime;
  DateTime? expiryDate;
  User? user;

  final TextEditingController _requesterController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();

  ButtonStyle buttonStyle = ButtonStyle(
    splashFactory: InkSplash.splashFactory,
    padding:
        MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(17)),
    elevation: MaterialStateProperty.all<double>(0),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey.shade600,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
  TextStyle formEntryTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  final int _emergencyExpiryTime = 12;
  bool _load = false;
  void _setLoadingState(bool load) {
    setState(() {
      _load = load;
    });
  }

  String? _uploadedFileName;
  final List<String> _bloodTypes = [
    'A+',
    'B+',
    'A-',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _requesterController.dispose();
    _patientNameController.dispose();
    _unitsController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? errorMessage;

  void _submitForm() async {
    setState(() {
      errorMessage = null; // Clear any previous error message
    });

    try {
      if (_formKey.currentState!.validate()) {
        // All fields are valid, submit the form
        String requester = _requesterController.text;
        String patientName = _patientNameController.text;
        String phoneString = _phoneController.text
          ..replaceAll(RegExp(r'\D'), ''); // Remove all non-digit characters

        log('Requester: $requester');
        log("Patient's Name: $patientName");
        log('Blood Type: $_selectedBloodType');
        log('Units of Blood: $units');
        log('Date: $_selectedDate');
        log('Time: $_selectedTime');
        log('Phone: $phoneString');
        log('Uploaded File Name: $_uploadedFileName');

        if (_selectedDate != null && _selectedTime != null) {
          final DateFormat dateTimeFormat = DateFormat('dd/MM/yyyy hh:mm a');
          final String combinedDateTimeString = '$_selectedDate $_selectedTime';
          try {
            _selectedDateTime = dateTimeFormat.parse(combinedDateTimeString);
          } catch (e) {
            throw const FormatException('Invalid date or time format');
          }
        }

        setState(() {
          _load = true; // Show the loading indicator
        });

        // Validate phone number format using regular expression
        RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
        if (!phoneRegex.hasMatch(phoneString)) {
          throw const FormatException('Invalid phone number format');
        } else {
          phoneString = '+91$phoneString'; // Add the country code IN
        }

        Request request = Request(
          id: user!.uid,
          isEmergency: isEmergency,
          name: requester,
          patientName: patientName,
          bloodGroup: _selectedBloodType!,
          units: units,
          area: area,
          expiryDate: _selectedDateTime!,
          phone: phoneString,
          hospitalName: hospitalName!,
          hospitalLocation: LatLng(
            hospitalLocation.latitude,
            hospitalLocation.longitude,
          ),
        );

        await request.updateRequest();

        // Reset the form and clear the fields after successful submission
        // _formKey.currentState!.reset();
        // _requesterController.clear();
        // _patientNameController.clear();
        // _unitsController.clear();
        // _phoneController.clear();
        // _hospitalController.clear();
        // _selectedBloodType = null;
        // _selectedDate = null;
        // _selectedTime = null;
        // _selectedDateTime = null;
        // _uploadedFileName = null;

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Form submitted successfully!'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to submit form: $e';
      });
    } finally {
      setState(() {
        _load = false; // Hide the loading indicator
      });
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
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay.fromDateTime(_selectedDateTime!)
          : TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = DateFormat('hh:mm a').format(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            picked.hour,
            picked.minute,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Request Form',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                emergencyButton(),

                const SizedBox(height: 7),
                hospitalFeild(context),

                const SizedBox(height: 11),
                bustanderNameField(),
                const SizedBox(height: 11),
                patientNameField(),
                const SizedBox(height: 11),
                Row(
                  children: [
                    Expanded(
                      child: bloodTypeField(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: unitsField(),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                //DateTime field
                // Date field
                Row(
                  children: [
                    if (!isEmergency) // Show the date field if emergency is off
                      Expanded(
                        child: dateField(context),
                      ),
                    SizedBox(
                      width: !isEmergency ? 16 : 0,
                    ), // Add spacing between the fields
                    if (!isEmergency) // Show the time field if emergency is off
                      Expanded(
                        child: timeField(context),
                      ),
                  ],
                ),

                const SizedBox(height: 11),
                phoneField(),
                //Show form submission errors
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 11),
                fileUploadButton(),
                const SizedBox(height: 11),
                if (_uploadedFileName != null)
                  Text(
                    'Uploaded File: $_uploadedFileName',
                    style: const TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 5),
                submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 198, 40, 40),
        ), // Change the button color to blue
      ),
      child: const Text(
        'SUBMIT',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ElevatedButton fileUploadButton() {
    return ElevatedButton.icon(
      onPressed: _uploadFile,
      icon: const Icon(
        Icons.file_upload,
        color: Colors.white,
      ),
      label: const Text(
        'Upload Requisition Form',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 198, 40, 40)),
      ),
    );
  }

  TextFormField phoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Phone',
        border: OutlineInputBorder(),
      ),
      style: formEntryTextStyle,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a phone number';
        }
        return null;
      },
    );
  }

  TextFormField timeField(BuildContext context) {
    return TextFormField(
      readOnly: true,
      onTap: () => _selectTime(context),
      controller: TextEditingController(text: _selectedTime ?? ''),
      decoration: const InputDecoration(
        labelText: 'Time',
        border: OutlineInputBorder(),
      ),
      style: formEntryTextStyle,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a time';
        }
        _selectedTime = value;
        return null;
      },
    );
  }

  TextFormField dateField(BuildContext context) {
    return TextFormField(
      readOnly: true,
      onTap: () => _selectDate(context),
      controller: TextEditingController(text: _selectedDate ?? ''),
      decoration: const InputDecoration(
        labelText: 'Date',
        border: OutlineInputBorder(),
      ),
      style: formEntryTextStyle,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        _selectedDate = value;
        return null;
      },
    );
  }

  TextFormField unitsField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Units of Blood',
        border: OutlineInputBorder(),
      ),
      style: formEntryTextStyle,
      validator: (value) {
        if (value == null || value.isEmpty || int.tryParse(value) == null) {
          return 'Please enter the units of blood';
        }
        if (int.tryParse(value)! > 10) {
          return 'Units must be less than 10';
        }
        units = int.parse(value);
        return null;
      },
    );
  }

  DropdownButtonFormField<String> bloodTypeField() {
    return DropdownButtonFormField<String>(
      value: _selectedBloodType,
      decoration: const InputDecoration(
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
    );
  }

  TextFormField patientNameField() {
    return TextFormField(
      controller: _patientNameController,
      decoration: const InputDecoration(
        labelText: "Patient's Name",
        border: OutlineInputBorder(),
      ),
      style: formEntryTextStyle,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the patient's name";
        }
        pname = value;
        return null;
      },
    );
  }

  TextFormField bustanderNameField() {
    return TextFormField(
      controller: _requesterController,
      decoration: const InputDecoration(
        labelText: "Bystander's name",
        border: OutlineInputBorder(),
      ),
      style: formEntryTextStyle,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the bystander's name";
        }
        name = value;
        return null;
      },
    );
  }

  Row hospitalFeild(BuildContext context) {
    return Row(
      children: [
        //Search Button
        ElevatedButton(
          style: buttonStyle,
          onPressed: () async {
            _setLoadingState(true);
            await _getCurrentLocation()
                .then((value) => _setLoadingState(false));
            if (!mounted) return;
            _showModalBottomSheet(context);
          },
          child: _load
              ? const SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator())
              : const Icon(
                  Icons.search,
                  size: 30,
                ),
        ),

        const SizedBox(width: 11),
        Expanded(
          child: TextFormField(
            controller: _hospitalController,
            enabled: _hospitalController.text.isNotEmpty,
            decoration: const InputDecoration(
              labelText: 'Search Hospital',
              border: OutlineInputBorder(),
            ),
            style: formEntryTextStyle,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select current hospital location';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Row emergencyButton() {
    return Row(
      children: [
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message:
              "Emergency requests will expire in $_emergencyExpiryTime hours",
          child: const Icon(Icons.info_outline_rounded),
        ),
        Container(
          padding: const EdgeInsets.only(left: 5),
          child: const Text(
            'Emergency ',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          width: 50,
          height: 30,
          child: Transform.scale(
            scale: 0.8, // Adjust the scale factor as needed
            child: Switch(
              value: isEmergency,
              onChanged: (value) {
                setState(() {
                  isEmergency = value;
                  if (isEmergency) {
                    _selectedDateTime = DateTime.now()
                        .add(Duration(hours: _emergencyExpiryTime));
                  } else {
                    _selectedDateTime = null;
                  }
                });
                log("Emergency: $isEmergency");
              },
              activeTrackColor: const Color.fromARGB(255, 187, 49, 39),
            ),
          ),
        ),
      ],
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
                  _hospitalController.text = hospitalName!;
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
}
