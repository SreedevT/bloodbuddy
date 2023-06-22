import 'package:blood/Firestore/userprofile.dart';
import 'package:blood/screens/mapscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final inputDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Color.fromARGB(255, 160, 40, 40),
      ),
      borderRadius: BorderRadius.circular(28.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Color.fromARGB(255, 135, 34, 34),
      ),
      borderRadius: BorderRadius.circular(28.0),
    ),
    prefixIcon: Icon(
      Icons.person,
      size: 25,
    ),
  );

  final _formKey = GlobalKey<FormState>();

  List<String> items = ['A+', 'B+', 'A-', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  List<String> willingToDonateOptions = ['Yes', 'No'];

  String fname = '';
  String lname = '';
  DateTime dob = DateTime.now();
  int age = 0;
  double weight = 0;
  String? selectedBloodGroup;
  String? selectedWillingToDonateOption;
  DateTime? lastDonated;

  var con;
  TextEditingController ageController = TextEditingController();
  bool question1 = false;
  bool question2 = false;
  bool question3 = false;
  bool isWillingToDonate = true;
  bool isChecked = false; // Initial value of the checkbox
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 129, 36, 30),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(35.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 7.0),
                    child: Text(
                      'Fill some more details to proceed',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Rest of the code...

                  SizedBox(height: 11),
                  TextFormField(
                    onChanged: (val) {
                      setState(() {
                        fname = val;
                      });
                    },
                    decoration: inputDecoration.copyWith(
                      labelText: 'First Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    onChanged: (val) {
                      setState(() {
                        lname = val;
                      });
                    },
                    decoration: inputDecoration.copyWith(
                      labelText: 'Last Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 13),
                  DateTimeFormField(
                    onDateSelected: (DateTime value) {
                      setState(() {
                        dob = value;
                        age = _calculateAge(value);
                        ageController.text = age.toString();
                      });
                    },
                    decoration: inputDecoration.copyWith(
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(
                        Icons.event_note,
                        size: 25,
                      ),
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                  ),
                  SizedBox(height: 14),
                  TextFormField(
                    controller: ageController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Age',
                      prefixIcon: Icon(
                        Icons.cake,
                        size: 25,
                      ),
                    ),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    onChanged: (val) {
                      setState(() {
                        weight = double.tryParse(val) ?? 0;
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Weight',
                      prefixIcon: Icon(
                        Icons.info_outline,
                        size: 25,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Weight';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration.copyWith(
                      labelText: 'Select blood group',
                      prefixIcon: Icon(
                        Icons.bloodtype,
                        size: 25,
                      ),
                    ),
                    value: selectedBloodGroup,
                    items: items
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item, style: TextStyle(fontSize: 18)),
                          ),
                        )
                        .toList(),
                    onChanged: (item) {
                      setState(() {
                        selectedBloodGroup = item;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a blood group';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 17),
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration.copyWith(
                      labelText: 'Are you willing to donate',
                      prefixIcon: Icon(
                        Icons.bloodtype,
                        size: 25,
                      ),
                    ),
                    value: selectedWillingToDonateOption,
                    items: willingToDonateOptions
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item, style: TextStyle(fontSize: 18)),
                          ),
                        )
                        .toList(),
                    onChanged: (item) {
                      setState(() {
                        selectedWillingToDonateOption = item;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select yes/no';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 18),
                  DateTimeFormField(
                    onDateSelected: (DateTime? value) {
                      setState(() {
                        lastDonated = value; // Update the lastDonated variable
                      });
                    },
                    decoration: inputDecoration.copyWith(
                      labelText: 'Last Donated Date',
                      prefixIcon: Icon(
                        Icons.event_note,
                        size: 25,
                      ),
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                  ),
                  SizedBox(height: 19),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 22.0),
                        child: Text('Did you get tattoo\nin past 12 months?',
                            style: TextStyle(
                              fontSize: 15,
                            )),
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 32.0),
                        child: Switch(
                          value: question1,
                          onChanged: (value) {
                            setState(() {
                              question1 = value;
                            });
                          },
                        ),
                      ),
                      Text(question1 ? 'Yes' : 'No'),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 21.0),
                        child: Text(
                          'Have you ever tested\npositive for HIV?',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 21.0),
                        child: Switch(
                          value: question2,
                          onChanged: (value) {
                            setState(() {
                              question2 = value;
                            });
                          },
                        ),
                      ),
                      Text(question2 ? 'Yes' : 'No'),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 22.0),
                        child: Text(
                          'Have you taken\nCovid-19 vaccine?',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 37.0),
                        child: Switch(
                          value: question3,
                          onChanged: (value) {
                            setState(() {
                              question3 = value;
                            });
                          },
                        ),
                      ),
                      Text(question3 ? 'Yes' : 'No'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 129, 36, 30),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await DataBase(uid: user!.uid).updateUserProfile(
                            fname,
                            lname,
                            dob,
                            age,
                            weight,
                            selectedBloodGroup,
                            lastDonated,
                            selectedWillingToDonateOption,
                            question1,
                            question2,
                            question3,
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewInter(),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Incomplete Form'),
                              content:
                                  Text('Please fill all the required fields.'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          'PROCEED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int _calculateAge(DateTime dob) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - dob.year;
  if (currentDate.month < dob.month ||
      (currentDate.month == dob.month && currentDate.day < dob.day)) {
    age--;
  }
  return age;
}
