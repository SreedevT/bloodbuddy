import 'package:blood/Firestore/userprofile.dart';
import 'package:blood/screens/mapscreen.dart';
import 'package:blood/widgets/info_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class QuestionCard extends StatefulWidget {
  final String question;
  //? fuction onChanged is called when the switch is toggled
  // it is a callback fuction that is used to update the question bool variables
  final Function(bool) onChanged;
  const QuestionCard(
      {super.key, required this.question, required this.onChanged});

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool _switchValue = false;
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
              activeTrackColor: Color.fromARGB(255, 126, 232, 130),

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

class _SignUpScreenState extends State<SignUpScreen> {
  final inputDecoration = InputDecoration(
    contentPadding:
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2,
        color: Colors.red,
      ),
      borderRadius: BorderRadius.circular(28.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2,
        color: Color.fromARGB(255, 201, 41, 41),
      ),
      borderRadius: BorderRadius.circular(28.0),
    ),
    prefixIcon: const Icon(
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

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 201, 41, 41),
        title: const Text(
          'Complete Your Profile',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 50),
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
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
                  prefixIcon: const Icon(
                    Icons.event_note,
                    size: 25,
                  ),
                ),
                mode: DateTimeFieldPickerMode.date,
                autovalidateMode: AutovalidateMode.always,
                lastDate: DateTime.now(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: ageController,
                decoration: inputDecoration.copyWith(
                  labelText: 'Age',
                  prefixIcon: const Icon(
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
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    weight = double.tryParse(val) ?? 0;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: inputDecoration.copyWith(
                  labelText: 'Weight',
                  prefixIcon: const Icon(
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
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: inputDecoration.copyWith(
                  labelText: 'Select blood group',
                  prefixIcon: const Icon(
                    Icons.bloodtype,
                    size: 25,
                  ),
                ),
                value: selectedBloodGroup,
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: const TextStyle(fontSize: 18)),
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
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: inputDecoration.copyWith(
                  labelText: 'Are you willing to donate',
                  prefixIcon: const Icon(
                    Icons.bloodtype,
                    size: 25,
                  ),
                ),
                value: selectedWillingToDonateOption,
                items: willingToDonateOptions
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: const TextStyle(fontSize: 18)),
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
              const SizedBox(height: 20),
              DateTimeFormField(
                onDateSelected: (DateTime? value) {
                  setState(() {
                    lastDonated = value; // Update the lastDonated variable
                  });
                },
                decoration: inputDecoration.copyWith(
                  labelText: 'Last Donated Date',
                  prefixIcon: const Icon(
                    Icons.event_note,
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
                    "\tComplete the Questionnaire",
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
                  setState(() {
                    question1 = value;
                  });
                },
              ),
              QuestionCard(
                question: "Have you ever tested positive for HIV?",
                onChanged: (value) {
                  setState(() {
                    question2 = value;
                  });
                },
              ),
              QuestionCard(
                question: "Have you taken Covid-19 vaccine?",
                onChanged: (value) {
                  setState(() {
                    question3 = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              InfoBox(
                icon: Icons.info_outline,
                text:
                    "Information is collected to make meaningful requests. We don't share your sensitive information with anyone!",
                textColor: Colors.grey,
                backgroundColor: Colors.white,
                borderColor: Colors.grey,
                padding: 10,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: const [
              //     Icon(
              //       Icons.info_outlined,
              //       color: Colors.grey,
              //     ),
              //     Text("\tInformation is collected to make meaningful",
              //         style: TextStyle(color: Colors.grey)),
              //   ],
              // ),
              // const Text(
              //     "requests. We don't share your sensitive information with anyone!",
              //     style: TextStyle(color: Colors.grey)),
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
                      if (!mounted) return;
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const NewInter(),
                          transitionsBuilder: (_, Animation<double> animation,
                              __, Widget child) {
                            return SlideTransition(
                              position: Tween(
                                begin: const Offset(1.0, 0.0), // bottom to top
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
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
              const SizedBox(height: 20),
            ],
          ),
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
