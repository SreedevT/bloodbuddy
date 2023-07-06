import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

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
        //? Get data from user profile
        Map<String, dynamic> data = await DataBase(uid: id).getUserProfile();

        //? Get data from interested subcollection
        Map<String, dynamic> interestedData = await getInterestedDoc(id);

        //? Get the request data
        Map<String, dynamic> requestData = await getReqData(widget.reqid);

        //? Combine all data
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
//         return Card(
//           child: ListTile(
//             title: Text("""DETAILS

// First Name: ${userData['First Name'] ?? 'loading...'}
// Blood Group: ${userData['Blood Group'] ?? 'loading...'}"""),
//             subtitle: Text("""
// Additonal Info

//  Area : ${userData['General Area'] ?? 'loading...'}
//  Age: ${userData['Age'] ?? 'loading...'}
//  Date of birth: ${userData['Date of Birth'].toDate() ?? 'loading...'}
//  Weight: ${userData['Weight'] ?? 'loading...'}"""),
//             trailing: ElevatedButton.icon(
//               onPressed: () {
//                 log('Chat button pressed');
//                 sendWhatsappMsg(userData);
//               },
//               icon: SvgPicture.asset('assets/icons/whatsapp_icon.svg'),
//               label: const Text('Chat'),
//             ),
//           ),
//         );
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: InterestedUserCard(userData: userData),
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
  ///Returns a map with key values respecting firestore document structure
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
}

class InterestedUserCard extends StatefulWidget {
  final Map<String, dynamic> userData;

  const InterestedUserCard({Key? key, required this.userData})
      : super(key: key);
  @override
  State<InterestedUserCard> createState() => _InterestedUserCardState();
}

class _InterestedUserCardState extends State<InterestedUserCard> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTileCard(
      contentPadding: EdgeInsets.all(10),
      baseColor: Colors.cyan[50],
      expandedColor: Colors.red[50],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${widget.userData['First Name']} ${widget.userData['Last Name']}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "${widget.userData['Blood Group']}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      subtitle: Text(
          "Age: ${widget.userData['Age']} | Place: ${widget.userData['General Area']}"),
      // trailing: Row(
      //   children: [
      //     // Use an Expanded widget to wrap the Icon widget
      //     Icon(
      //       Icons.expand_more,
      //       size: 30.0,
      //     ),
      //     Text(
      //       "${widget.userData['Blood Group']}",
      //       style: TextStyle(
      //         fontSize: 18.0,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ],
      // ),
      children: [
        const Divider(
          thickness: 1.0,
          height: 1.0,
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          buttonHeight: 52.0,
          buttonMinWidth: 90.0,
          children: [
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
              onPressed: () {
                log("Whatsapp pressed");
                sendWhatsappMsg(widget.userData);
              },
              child: Column(
                children: [
                  SvgPicture.asset('assets/icons/whatsapp_icon.svg',
                      height: 30),
                  const SizedBox(height: 1.5),
                  const Text('Chat'),
                ],
              ),
            ),
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
              onPressed: () {
                log("Call pressed");
                callUser(widget.userData);
              },
              child: Column(
                children: const [
                  Icon(Icons.call),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text('Call'),
                ],
              ),
            ),
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
              onPressed: () {
                //TODO confirm user
                log("Confirm pressed");
              },
              child: Column(
                children: const [
                  Icon(Icons.check),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text('Confirm'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void sendWhatsappMsg(Map<String, dynamic> userData) async {
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

  void callUser(Map<String, dynamic> userData) async {
    String phone = userData['phone'].toString();
    Uri callUrl = Uri.parse('tel:$phone');
    try {
      await launchUrl(callUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      //To handle error and display error message
      log(e.toString());
    }
  }
}
