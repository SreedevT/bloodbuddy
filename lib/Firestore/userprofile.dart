import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  final String uid;
  DataBase({required this.uid});

  final CollectionReference userProfile =
      FirebaseFirestore.instance.collection('User Profile');
  final CollectionReference userLocation =
      FirebaseFirestore.instance.collection('User Location');

  // to update the user profile data

  Future setUserProfile(
    String fname,
    String lname,
    DateTime dob,
    int age,
    double weight,
    String? selectedBloodGroup,
    DateTime? lastDonated,
    String?
        selectedWillingToDonateOption, // Add selectedWillingToDonateOption argument
    bool question1,
    bool question2,
    bool question3,
  ) async {
    return await userProfile.doc(uid).set(
      {
        'First Name': fname,
        'Last Name': lname,
        'Date of Birth': dob,
        'Age': age,
        'Weight': weight,
        'Blood Group': selectedBloodGroup,
        //TODO: change 'Is donor' to 'canDonate'
        //TODO: Function to check if user can donate using questionaire, age, weight, ect.
        'Is donor': selectedWillingToDonateOption == 'Yes',
        'Last Donated': lastDonated,
        'tattoo': question1,
        'HIV_tested': question2,
        'Covid_vaccine': question3,
      },
    );
  }

  Future updateUserProfile(
      double weight,
      String isWillingToDonate,
      DateTime? lastDonated,
      bool question1,
      bool question2,
      bool question3) async {
    return await userProfile.doc(uid).update(
      {
        'Weight': weight,
        'Is donor': isWillingToDonate,
        'Last Donated': lastDonated,
        'tattoo': question1,
        'HIV_tested': question2,
        'Covid_vaccine': question3,
      },
    );
  }

  // Function to get the use profile data

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      DocumentSnapshot snapshot = await userProfile.doc(uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data;
      }
    } catch (e) {
      log(e.toString());
    }
    return {};
  }
  // to update user location

  Future updateUserLocation(String genArea) async {
    return await userLocation.doc(uid).set(
      {
        'General Area': genArea,
      },
    );
  }
}
