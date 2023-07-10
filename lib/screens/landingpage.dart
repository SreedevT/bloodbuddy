import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/donor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _animation;
  late final Query query;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
    getFeed();
  }

  Future getFeed() async{
      query = FirebaseFirestore.instance.collection('Reqs').where('status',isEqualTo: 'accepted');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 0 && ModalRoute.of(context)!.settings.name != 'home') {
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    }
    if (index == 1) {
      Navigator.pushNamed(context, 'donate');
    }
    if (index == 2) {
    Navigator.pushNamed(context, 'my_requests');
    }
    if(index == 3){
      Navigator.pushNamed(context,'profile');
    }
  }



  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          elevation: 0,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                color: Colors.white,
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              );
            },
          ),
        ),
        drawer: drawer(context),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DonorCard(),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(9.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Colors.red[300],
                  ),
                  child:const  Text("See, whats happening in BLOOD BUDDY!",style:TextStyle(fontSize: 20,
                      fontWeight: FontWeight.bold))
                ),
                StreamBuilder(
                  stream: query.snapshots(),
                  builder: (context,snapshots){
                      if(snapshots.hasError){
                        return const Center(child: Text('No Donations Yet'));
                      }
                       if(snapshots.hasData){
                        for(var i in snapshots.data!.docs){
                          log("FEEED!!!!: ${i.data().toString()}");
                        }   
                        return feedCards(snapshots.data!.docs);
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/donation.png"),
                color: Colors.red,
                size: 24,
              ),
              label: 'Donation',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/blood.png"),
                color: Colors.red,
                size: 24,
              ),
              label: 'Request',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.red[800],
          unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Drawer drawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: const EdgeInsets.fromLTRB(60, 35, 0, 0),
              decoration: BoxDecoration(
                color: Colors.red[800],
              ),
              child: RichText(
                text: const TextSpan(
                  text: "Blood Buddy",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Argentum Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  children: [
                    TextSpan(
                      text: "\nEmpowering Blood Donation.",
                      style: TextStyle(
                        fontFamily: 'normal',
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('FAQS',style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.pushNamed(context, 'faq');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support',style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout',style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}


Widget feedCards(List<QueryDocumentSnapshot> snapshot){
  return ListView.builder(
    padding: const EdgeInsets.all(8.0),
    shrinkWrap: true,
    physics: const ClampingScrollPhysics(),
    itemCount: snapshot.length,
    itemBuilder: (context,index){
      Map<String,dynamic> data= snapshot[index].data() as Map<String,dynamic>;
      return Card(
        color: Colors.grey[400],
        child: ListTile(
          leading: Icon(Icons.favorite,color: Colors.red[800],),
          title: Text("${data['Name']} donated to ${data['patientName']} at ${data['hospitalName']}\n- BLOOD BUDDY"),
        ),
      );
    }
  );
}