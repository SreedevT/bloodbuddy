import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum Status { pending, accepted }

class Request  {
  //? ID of the user making the request
  // each user can have multiple requests
  // we can identify the user by this ID
  final String? id; 

  // final String hospitalName;
  final String? bloodGroup;
  final int? units;
  //? name of the patient for whom the request is made
  final String? patientName;
  // final String area;
  // var requisitionForm; //? image/pdf of the requisition form
  // final DateTime expiryDate;

  //? emergency requests treated differenty
  // maybe shown in a different screen / different color / highlighted
  // final bool isEmergency;
  Status status;
  final String? name;

  Request({
    this.id,
    // required this.hospitalName,
     this.bloodGroup,
    this.units,
    this.name,
    this.patientName,
    // required this.area,
    // required this.expiryDate,
    // this.isEmergency = false,
    this.status = Status.pending,
  });

  final CollectionReference reqs = FirebaseFirestore.instance.collection('Reqs');
  
  //? convert the request object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Name' : name,
      // 'hospitalName': hospitalName,
      'bloodGroup': bloodGroup,
      'units': units,
      'patientName': patientName,
      // 'area': area,
      // 'expiryDate': expiryDate,
      // 'isEmergency': isEmergency,
      'status': status.name,
    };
  }

  //? convert the map to a request object
  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map['id'],
      name: map['Name'],
      // hospitalName: map['hospitalName'],
      bloodGroup: map['bloodGroup'],
      units: map['units'],
      patientName: map['patientName'],
      // area: map['area'],
      // expiryDate: map['expiryDate'],
      // isEmergency: map['isEmergency'],
      //! not sure if this will work
      status: Status.values.firstWhere((element) => element.name == map['status']),
    );
  }

  //? convert to string
//   @override
//   String toString() {
//     return '$patientName needs $units units of $bloodGroup blood at $hospitalName in $area';
//   }
// }


// List<String> getCompatibleBloodGroups(String bloodType) {
//   switch (bloodType) {
//     case 'A+':
//       return ['A+', 'A-', 'O+', 'O-'];
//     case 'A-':
//       return ['A-', 'O-'];
//     case 'B+':
//       return ['B+', 'B-', 'O+', 'O-'];
//     case 'B-':
//       return ['B-', 'O-'];
//     case 'AB+':
//       return ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
//     case 'AB-':
//       return ['A-', 'B-', 'AB-', 'O-'];
//     case 'O+':
//       return ['O+', 'O-'];
//     case 'O-':
//       return ['O-'];
//     default:
//       return [];
//   }
// }

// instead of receiving snapshot,
//receive list of request objects 
// request list from snapshots

List<Request> requestListFromSnapshot(QuerySnapshot snapshot){
  return snapshot.docs.map((doc){
    return Request.fromMap(doc.data() as Map<String, dynamic>);
  }).toList();
}

// stream for this collection

Stream<List<Request>> get requestupdates{
  return reqs.snapshots().map(requestListFromSnapshot);
}

Future updateRequest() async {
  await reqs.doc().set(toMap());
}
}