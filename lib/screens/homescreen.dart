import 'package:blood/screens/welcomesreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? uid;
  @override
  void initState() {
    user = _auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        
        child: ElevatedButton(onPressed: () async {
          try{
            await _auth.signOut();
            
            Navigator.pushNamedAndRemoveUntil(
          context,
          'welcome',
          (route) => false,
      );

          }
          catch(e){
            print(e.toString());
          }
          
        }, child:const  Text("Log out"))
      ),
    );

    
  }
}