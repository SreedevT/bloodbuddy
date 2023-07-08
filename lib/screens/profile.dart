import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';
import '../Firestore/userprofile.dart';
import '../widgets/info_text.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final inputDecoration = InputDecoration(
    contentPadding:
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2,
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(28.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2,
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(28.0),
    ),
    // prefixIcon: const Icon(
    //   Icons.person,
    //   size: 25,
    // ),
  );

  final _formKey = GlobalKey<FormState>();

  // List<String> items = ['A+', 'B+', 'A-', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  List<String> willingToDonateOptions = ['Yes', 'No'];

  // String? selectedWillingToDonateOption;
  DateTime? lastDonated;

  TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  bool question1 = false;
  bool question2 = false;
  bool question3 = false;
  bool isWillingToDonate = true;
  bool isChecked = false; // Initial value of the checkbox
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Map<String, dynamic>? data;

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    user = _auth.currentUser;
    fetchUserProfile();

    super.initState();
  }

  fetchUserProfile() async {
    try {
      await DataBase(uid: user!.uid).getUserProfile().then((data) {
        // log("Data: $data");

        Provider.of<Profile>(context, listen: false).setAllFieldsFromJson(data);
        log("Profile: ${Provider.of<Profile>(context, listen: false).toJson()}");
      });
      // setState(() {
      //   data = fetchedData;
      //   log("$data");
      // });
      // Provider.of<Profile>(context, listen: false).setProfile(data!);

      // log('question1: $question1');
      // log('question2: $question2');
      // log('question3: $question3');
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 201, 41, 41),
        title: const Text(
          ' Your Profile',
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Consumer<Profile>(
          builder: (context, data, child) => Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                            text: data.firstName ?? 'loading...'),
                        decoration: inputDecoration.copyWith(
                            labelText: 'First Name',
                            labelStyle: const TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        controller: TextEditingController(
                            text: data.lastName ?? 'loading...'),
                        readOnly: true,
                        decoration: inputDecoration.copyWith(
                            labelText: 'Last Name',
                            labelStyle: const TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DateTimeFormField(
                        initialValue: data.dateOfBirth ?? DateTime.now(),
                        enabled: false,
                        decoration: inputDecoration.copyWith(
                          labelText: 'Date of Birth',
                        ),
                        mode: DateTimeFieldPickerMode.date,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _ageController
                          ..text = data.age == null
                              ? 'loading...'
                              : data.age.toString(),
                        decoration: inputDecoration.copyWith(
                            labelText: 'Age',
                            labelStyle: const TextStyle(color: Colors.grey)),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue:  data.weight!.toString(),
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration.copyWith(
                    labelText: 'Weight',
                    prefixIcon: const Icon(
                      Icons.edit,
                      color: Colors.green,
                      size: 25,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Weight';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if(value.isNotEmpty){
                      data.weight = double.parse(value);
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                      text: data.bloodGroup ?? 'loading...'),
                  decoration: inputDecoration.copyWith(
                      labelText: 'Blood Group',
                      labelStyle: const TextStyle(color: Colors.grey)),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: inputDecoration.copyWith(
                    labelText: 'Are you willing to donate',
                    prefixIcon: const Icon(
                      Icons.edit,
                      color: Colors.green,
                      size: 25,
                    ),
                  ),
                  value: data.canDonate == null
                      ? 'Yes'
                      : data.canDonate!
                          ? 'Yes'
                          : 'No',
                  items: willingToDonateOptions
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child:
                              Text(item, style: const TextStyle(fontSize: 18)),
                        ),
                      )
                      .toList(),
                  onChanged: (item) {
                    setState(() {
                      data.canDonate = item == 'Yes' ? true : false;
                    });
                    log("Can donate: ${data.canDonate}");
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select yes/no';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DateTimeFormField(
                  initialValue: data.lastDonated,
                  onDateSelected: (DateTime? value) {
                      data.lastDonated = value; // Update the lastDonated variable
                  },
                  decoration: inputDecoration.copyWith(
                    labelText: 'Last Donated Date',
                    prefixIcon: const Icon(
                      Icons.edit,
                      color: Colors.green,
                      size: 25,
                    ),
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  lastDate: DateTime.now(),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.question_answer,
                      size: 40,
                      color: Color.fromARGB(255, 198, 40, 40),
                    ),
                    Text(
                      "\tWould you like to change\n  the answers?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 198, 40, 40),
                        fontSize: 18,
                        fontFamily: "Argentum Sans",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                QuestionCard(
                  question: "Did you get tattoo in past 12 months?",
                  onChanged: (value) {
                    data.tattoo = value;
                  },
                  initialValue: data.tattoo ?? true,
                ),
                QuestionCard(
                  question: "Have you ever tested positive for HIV?",
                  onChanged: (value) {
                      data.hivTested = value;
                  },
                  initialValue: data.hivTested ?? false,
                ),
                QuestionCard(
                  question: "Have you taken Covid-19 vaccine?",
                  onChanged: (value) {
                      data.covidVaccine = value;
                  },
                  initialValue: data.covidVaccine ?? false,
                ),
                const SizedBox(height: 20),
                const InfoBox(
                  icon: Icons.info_outline,
                  text:
                      "Information is collected to make meaningful requests. We don't share your sensitive information with anyone!",
                  textColor: Colors.grey,
                  backgroundColor: Colors.white,
                  borderColor: Colors.grey,
                  padding: 10,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 201, 41, 41),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        log("Update Profile button pressed");
                        await DataBase(uid: user!.uid).updateUserProfile(
                          data.weight ?? 0.0,
                          data.canDonate ?? true,
                          data.lastDonated,
                          data.tattoo ?? false,
                          data.hivTested ?? false,
                          data.covidVaccine ?? false,
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Row(
                              children: const [
                                Icon(Icons.warning_amber),
                                SizedBox(width: 10),
                                Text(
                                  'Incomplete Form',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            content: const Text(
                              'Please fill all the required fields.',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Update Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  final String question;
  //? fuction onChanged is called when the switch is toggled
  // it is a callback fuction that is used to update the question bool variables
  final Function(bool) onChanged;
  final bool initialValue;
  const QuestionCard(
      {super.key,
      required this.question,
      required this.onChanged,
      this.initialValue = true});

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  late bool _switchValue;
  @override
  void initState() {
    log("Initial value: ${widget.initialValue}");
    _switchValue = widget.initialValue;
    log('initState: $_switchValue');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade900,
      // color: Colors.white,
      // surfaceTintColor: Colors.red.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      // Use some padding and margin for the card
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        // Use a row to align the text and the switch horizontally
        child: Row(
          // Use mainAxisAlignment to space the widgets evenly
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                // Use a text widget with some style
                child: Text(
                  widget.question,
                  style: const TextStyle(
                    fontSize: 18,
                    // color: Colors.black
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Use a switch widget with the state variable and an onChanged callback
            Switch(
              // activeColor: Color.fromARGB(255, 126, 232, 130),
              focusColor: Colors.white,
              activeTrackColor: const Color.fromARGB(255, 126, 232, 130),

              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.white,
              value: _switchValue,
              onChanged: (v) {
                // Update the state variable and call setState() to rebuild the UI
                setState(() {
                  _switchValue = v;
                });

                widget.onChanged(v);
              },
            ),
          ],
        ),
      ),
    );
  }
}
