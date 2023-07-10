import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

enum Status { pending, accepted }

class Request {
  //? ID of the user making the request
  // each user can have multiple requests
  // we can identify the user by this ID
  final String id;
  final String name;
  final String patientName;
  final String hospitalName;
  final String bloodGroup;
  final int units;
  //? name of the patient for whom the request is made
  final DateTime expiryDate;
  final String area;
  // var requisitionForm; //? image/pdf of the requisition form
  final String phone;
  //? emergency requests treated differenty
  // maybe shown in a different screen / different color / highlighted
  final bool isEmergency;
  Status status;
  

  //? position of the hospital
  final LatLng hospitalLocation;

  static List<String> getDonorBloodGroups(String bloodType) {
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

  static List<String> getRecipientBloodGroups(String bloodType) {
    switch (bloodType) {
      case 'A+':
        return ['A+', 'AB+'];
      case 'A-':
        return ['A+', 'A-', 'AB+', 'AB-'];
      case 'B+':
        return ['B+', 'AB+'];
      case 'B-':
        return ['B+', 'B-', 'AB+', 'AB-'];
      case 'AB+':
        return ['AB+'];
      case 'AB-':
        return ['AB+', 'AB-'];
      case 'O+':
        return ['O+', 'A+', 'B+', 'AB+'];
      case 'O-':
        return ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];
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
    required this.area,
    required this.expiryDate,
    required this.phone,
    this.isEmergency = false,
    this.status = Status.pending,
    required this.hospitalLocation,
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
      'area': area,
      'expiryDate': expiryDate,
      'Phone': phone,
      'isEmergency': isEmergency,
      'status': status.name,
      'position':
          GeoPoint(hospitalLocation.latitude, hospitalLocation.longitude),
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
      area: map['area'],
      // Convert Timestamp to DateTime
      //TODO This should not be null but handled by setting a default value
      expiryDate: map['expiryDate'] != null
          ? (map['expiryDate'] as Timestamp).toDate()
          : DateTime(2000, 1, 1),
      isEmergency: map['isEmergency'],
      phone: map['Phone'],
      status: Status.values.firstWhere(
          (element) => element.name == map['status'],
          orElse: () => Status.pending),
      hospitalLocation:
          LatLng(map['position'].latitude, map['position'].longitude),
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
