import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Firestore/userprofile.dart';

class Listee extends StatefulWidget {
  final List<String> ids;
  final String reqid;

  const Listee({Key? key, required this.ids, required this.reqid})
      : super(key: key);

  @override
  State<Listee> createState() => _ListeeState();
}

class _ListeeState extends State<Listee> {
  List<Map<String, dynamic>> userDataList = [];
  // late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

///Fetches data from interested user's profile, the interested subcollection and parent request
///
///Returns a combined map with key values respecting firestore document structure
  void fetchData() async {
    userDataList.clear();
    for (String id in widget.ids) {
      try {
        Map<String, dynamic> data = await DataBase(uid: id).getUserProfile();
        Map<String, dynamic> interestedData = await getInterestedDoc(id);
        Map<String, dynamic> requestData =
            await getReqData(widget.reqid); //? Get the request data
        data
          ..addAll(interestedData)
          ..addAll(requestData);
        log("Intersted users: ${data.toString()}");
        if (data.isNotEmpty) {
          setState(() {
            userDataList.add(data);
          });
        }
      } catch (e) {
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userDataList.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> userData = userDataList[index];
        return Card(
          child: ListTile(
            title: Text("""DETAILS
                
First Name: ${userData['First Name'] ?? 'loading...'}
Blood Group: ${userData['Blood Group'] ?? 'loading...'}"""),
            subtitle: Text("""
Additonal Info

 Area : ${userData['General Area'] ?? 'loading...'}
 Age: ${userData['Age'] ?? 'loading...'}
 Date of birth: ${userData['Date of Birth'].toDate() ?? 'loading...'}
 Weight: ${userData['Weight'] ?? 'loading...'}"""),
            trailing: ElevatedButton.icon(
              onPressed: () {
                log('Chat button pressed');
                sendWhatsappMsg(userData);
              },
              icon: SvgPicture.asset('assets/icons/whatsapp_icon.svg'),
              label: const Text('Chat'),
            ),
          ),
        );
      },
    );
  }

///Function for getting interesterd users phone number and time of interest
  Future<Map<String, dynamic>> getInterestedDoc(String uid) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Reqs")
          .doc(widget.reqid)
          .collection("Interested")
          .doc(uid)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data;
      }
    } catch (e) {
      log(e.toString());
    }
    return {};
  }

///Function for getting hospital name and location
///
//TODO location may be used for sending google map link
  Future<Map<String, dynamic>> getReqData(String uid) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Reqs")
          .doc(widget.reqid)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        //Return the hospital name and location
        return {
          'hospitalName': data['hospitalName'],
          'position': data['position'],
        };
      }
    } catch (e) {
      log(e.toString());
    }
    return {};
  }

  void sendWhatsappMsg(Map<String, dynamic> userData) async{
    //TODO maybe reword msg template
    //? Solution from: https://stackoverflow.com/questions/55892495/how-to-send-a-message-directly-from-my-flutter-app-to-whatsapp-using-urllauncher
    String phone = userData['phone'].toString().replaceAll('+', '');
    String msg = '''Hello ${userData['First Name']}, 
I am in need for ${userData['Blood Group']} blood at ${userData['hospitalName']}

Please confirm your availability as fast as possible.

Here is the location: 
http://www.google.com/maps/place/${userData['position'].latitude},${userData['position'].longitude}

Thank you''';
    Uri whatsappUrl = Uri.parse('https://wa.me/$phone?text=$msg');

    try {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      //To handle error and display error message
      log(e.toString());
    }
  }
}
