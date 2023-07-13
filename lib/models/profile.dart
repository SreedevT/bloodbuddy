import 'dart:developer';

import 'package:flutter/foundation.dart';

class Profile extends ChangeNotifier {
  String? id;
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;
  int? age;
  double? weight;
  String? bloodGroup;
  bool? canDonate;
  DateTime? lastDonated;
  bool? tattoo;
  bool? hivTested;
  bool? covidVaccine;
  String? area;
  String? mesgToken;

  void setAllFieldsFromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['First Name'];
    lastName = json['Last Name'];
    dateOfBirth = json['Date of Birth'].toDate();
    age = json['Age'];
    weight = json['Weight'].toDouble();
    bloodGroup = json['Blood Group'];
    canDonate = json['Is donor'];
    lastDonated = json['Last Donated']?.toDate();
    tattoo = json['tattoo'];
    hivTested = json['HIV_tested'];
    covidVaccine = json['Covid_vaccine'];
    area = json['General Area'];
    mesgToken = json['mesgToken'];

    notifyListeners();
  }

  Profile({
    this.id,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.age,
    this.weight,
    this.bloodGroup,
    this.canDonate,
    this.lastDonated,
    this.tattoo,
    this.hivTested,
    this.covidVaccine,
    this.area,
    this.mesgToken,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'First Name': firstName,
        'Last Name': lastName,
        'Date of Birth': dateOfBirth,
        'Age': age,
        'Weight': weight,
        'Blood Group': bloodGroup,
        'Is donor': canDonate,
        'Last Donated': lastDonated,
        'tattoo': tattoo,
        'HIV_tested': hivTested,
        'Covid_vaccine': covidVaccine,
        'General Area': area,
        'mesgToken': mesgToken,
      };

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      firstName: json['First Name'],
      lastName: json['Last Name'],
      dateOfBirth: json['Date of Birth']?.toDate(),
      age: json['Age'],
      weight: json['Weight'].toDouble(),
      bloodGroup: json['Blood Group'],
      canDonate: json['Is donor'],
      lastDonated: json['Last Donated']?.toDate(),
      tattoo: json['tattoo'],
      hivTested: json['HIV_tested'],
      covidVaccine: json['Covid_vaccine'],
      area: json['General Area'],
      mesgToken: json['mesgToken'],
    );
  }

  Map<String, dynamic> checkDonorEligibilityFunction() {
    try {
      bool eligible = true;
      String message = '';

      if (age! < 18) {
        eligible = false;
        message = 'You must be at least 18 years old to donate blood.';
      } else if (weight! < 50) {
        eligible = false;
        message = 'You must weigh at least 50 kilograms to donate blood.';
      } else if (canDonate == false) {
        eligible = false;
        message =
            'You chose not to be a donor. It can always be changed in you profile.';
      } else if (lastDonated != null) {
        if (lastDonated!
            .add(const Duration(days: 120))
            .isAfter(DateTime.now())) {
          eligible = false;
          message = 'You must wait at least 120 days between donations.';
        }
      } else if (tattoo! || hivTested! || !covidVaccine!) {
        eligible = false;
        message = 'You are not eligible to donate based on the questionnaire.';
      }

      return {
        'eligible': eligible,
        'message': message,
      };
    } catch (e) {
      log('Error: $e');
      return {
        'eligible': false,
        'message': 'An error occurred during eligibility check.',
      };
    }
  }
}
