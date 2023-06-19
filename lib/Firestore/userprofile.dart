import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase{
  final String uid;
  DataBase({ required this.uid });

  final CollectionReference userProfile = FirebaseFirestore.instance.collection('User Profile');
  final CollectionReference userLocation = FirebaseFirestore.instance.collection('User Location');
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

  Future updateUserProfile(String fname, String lname, int age, double weight, bool isDonor) async{
    return await userProfile.doc(uid).set(
      {
        'First Name': fname,
        'Last Name': lname,
        'Age': age,
        'Weight': weight,
      }
    );
  }

  // to update user location

  Future updateUserLocation(String genArea) async {
    return await userLocation.doc(uid).set({
      'General Area':genArea
    });
  }


}