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
    String? currentRequestId,
  ) async {
    return await userProfile.doc(uid).set(
      {
        'First Name': fname,
        'Last Name': lname,
        'Date of Birth': dob,
        'Age': age,
        'Weight': weight,
        'Blood Group': selectedBloodGroup,
        'Is donor': selectedWillingToDonateOption == 'Yes',
        'Last Donated': lastDonated,
        'tattoo': question1,
        'HIV_tested': question2,
        'Covid_vaccine': question3,
        'Current Request': currentRequestId,
      },
    );
  }

  Future updateUserProfile(
      double weight,
      bool isWillingToDonate,
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

  Future<void> updateUserLocation(String genArea) async {
    return await userProfile.doc(uid).update(
      {
        'General Area': genArea,
      },
    );
  }

  Future<void> updateCurrentRequest(String? currentRequestId) async {
    return await userProfile.doc(uid).update(
      {
        'Current Request': currentRequestId,
      },
    );
  }

  Future<void> profileOnCloseRequest() async {
    return await userProfile.doc(uid).update(
      {'Current Request': null, 'Last Donated': DateTime.now()},
    );
  }

  Future<void> setNotificationToken(String? mesgToken) async {
    return await userProfile.doc(uid).update(
      {'mesgToken': mesgToken},
    );
  }
}
