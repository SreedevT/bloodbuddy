import 'package:cloud_firestore/cloud_firestore.dart';

class Req{
  final CollectionReference reqs = FirebaseFirestore.instance.collection('Reqs');

  Future updateReq(
    String useruid,
    String name,
    String pname,
    int units,
    String btype,
  ) async{
    await reqs.doc().set(
      {
        'User UID': useruid,
        'Name': name,
        'Patient Name': pname,
        'Units': units,
        'Blood Type': btype
      }
    );
  }
}