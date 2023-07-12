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
}
