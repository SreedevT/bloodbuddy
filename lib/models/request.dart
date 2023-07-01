import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

enum Status { pending, accepted }

class Request {
  //? ID of the user making the request
  // each user can have multiple requests
  // we can identify the user by this ID
  final String id;

  final String hospitalName;
  final String bloodGroup;
  final int units;
  //? name of the patient for whom the request is made
  final String patientName;
  // final String area;
  // var requisitionForm; //? image/pdf of the requisition form
  // final DateTime expiryDate;

  //? emergency requests treated differenty
  // maybe shown in a different screen / different color / highlighted
  // final bool isEmergency;
  Status status;
  final String name;
  //? position of the hospital
  final LatLng position;

  static List<String>  getDonorBloodGroups(String bloodType) {
    switch (bloodType) {
      case 'A+':
        return ['A+', 'A-', 'O+', 'O-'];
      case 'A-':
        return ['A-', 'O-'];
      case 'B+':
        return ['B+', 'B-', 'O+', 'O-'];
      case 'B-':
        return ['B-', 'O-'];
      case 'AB+':
        return ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
      case 'AB-':
        return ['A-', 'B-', 'AB-', 'O-'];
      case 'O+':
        return ['O+', 'O-'];
      case 'O-':
        return ['O-'];
      default:
        return [];
    }
  }
  static List<String>  getRecipientBloodGroups(String bloodType) {
    switch (bloodType) {
      case 'A+':
        return ['A+', 'A-', 'O+', 'O-'];
      case 'A-':
        return ['A-', 'O-'];
      case 'B+':
        return ['B+', 'B-', 'O+', 'O-'];
      case 'B-':
        return ['B-', 'O-'];
      case 'AB+':
        return ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
      case 'AB-':
        return ['A-', 'B-', 'AB-', 'O-'];
      case 'O+':
        return ['O+', 'O-'];
      case 'O-':
        return ['O-'];
      default:
        return [];
    }
  }

  Request({
    required this.id,
    required this.hospitalName,
    required this.bloodGroup,
    required this.units,
    required this.name,
    required this.patientName,
    // required this.area,
    // required this.expiryDate,
    // this.isEmergency = false,
    this.status = Status.pending,
    required this.position,
  });

  final CollectionReference reqs =
      FirebaseFirestore.instance.collection('Reqs');

  //? convert the request object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Name': name,
      'hospitalName': hospitalName,
      'bloodGroup': bloodGroup,
      'units': units,
      'patientName': patientName,
      // 'area': area,
      // 'expiryDate': expiryDate,
      // 'isEmergency': isEmergency,
      'status': status.name,
      'position': GeoPoint(position.latitude, position.longitude),
    };
  }

  //? convert the map to a request object
  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map['id'],
      name: map['Name'],
      hospitalName: map['hospitalName'],
      bloodGroup: map['bloodGroup'],
      units: map['units'],
      patientName: map['patientName'],
      // area: map['area'],
      // expiryDate: map['expiryDate'],
      // isEmergency: map['isEmergency'],
      //! not sure if this will work
      status:
          Status.values.firstWhere((element) => element.name == map['status']),
      position: LatLng(map['position'].latitude, map['position'].longitude),
    );
  }

  //? convert to string
//   @override
//   String toString() {
//     return '$patientName needs $units units of $bloodGroup blood at $hospitalName in $area';
//   }
// }


  Future updateRequest() async {
    await reqs.doc().set(toMap());
  }
}
