import 'dart:developer';

import 'package:blood/Firestore/userprofile.dart';
import 'package:blood/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../models/request.dart';

Future<void> handleBackGroundMessage(RemoteMessage message) async {
  log('Handling a background message ${message.toString()}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      'donate',
      arguments: message,
    );
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    //? Handling notification in terminated state
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    //? Hnadle notification in backgroud state
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    //?Handling Notifications
    FirebaseMessaging.onBackgroundMessage(handleBackGroundMessage);
  }

  Future<void> initNotification() async {
    await Firebase.initializeApp();

    await _firebaseMessaging.requestPermission();
    //? Get the token each time the application loads and store it in database and provider
    //? inintNotification is called in landing page. Here user is logged in and uid is available
    final mesgToken = await _firebaseMessaging.getToken();
    log('FirebaseMessaging token: $mesgToken');

    initPushNotifications();

    //? Store the token in database
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    await DataBase(uid: uid).setNotificationToken(mesgToken);

    // Subscribe to a topic based on the user's area
    FirebaseFirestore.instance
        .collection('User Profile')
        .doc(uid)
        .get()
        .then((doc) {
      String area = doc.data()!['General Area'];
      String bloodGroup = doc.data()!['Blood Group'];

      //? Subscribe to every topic that user can donate to
      List recipientBloodGroups = Request.getRecipientBloodGroups(bloodGroup);
      for (String bloodGroup in recipientBloodGroups) {
        String newBloodGroup = bloodGroup
            .replaceAll(RegExp(r'\+$'), "p")
            .replaceAll(RegExp(r'-$'), "n");
        log("Subscribing to topic: ${area}_$newBloodGroup");
        FirebaseMessaging.instance.subscribeToTopic('${area}_$newBloodGroup');
      }
    });
  }
}
