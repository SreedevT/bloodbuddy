import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  final String uid;
  DataBase({required this.uid});

  final CollectionReference userProfile =
      FirebaseFirestore.instance.collection('User Profile');
  final CollectionReference userLocation =
      FirebaseFirestore.instance.collection('User Location');
  // to update the user profile data

  // Future updateUserProfile(String fname, String lname, DateTime dob, DateTime lastDonated, int age, double weight, bool isDonor) async{
  //   return await userProfile.doc(uid).set(
  //     {
  //       'First Name': fname,
  //       'Last Name': lname,
  //       'Date of Birth': dob,
  //       'Last Donated': lastDonated,
  //       'Age': age,
  //       'Weight': weight,
  //       'Is Donor': isDonor,
  //     }
  //   );
  // }

  Future updateUserProfile(
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
        'Is donor': selectedWillingToDonateOption == 'Yes',
        'Last Donated': lastDonated,
        'tattoo': question1,
        'HIV_tested': question2,
        'Covid_vaccine': question3,
      },
    );
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
