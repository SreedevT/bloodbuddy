import 'dart:async';
import 'dart:developer';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blood/widgets/info_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/profile.dart';
import '../widgets/donor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _animation;
  late final Query feedQuery;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("User Profile")
        .doc(uid)
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        Provider.of<Profile>(context, listen: false)
            .setAllFieldsFromJson(event.data()!);
        log("Profile Updated");
        log("Profile: ${Provider.of<Profile>(context, listen: false).toJson()}");
      }
    });

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();

    feedQuery = FirebaseFirestore.instance
        .collection('Reqs')
        .where('status', isEqualTo: 'complete')
        .orderBy('completedTime', descending: true)
        .limit(5);
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
    if (index == 3) {
      Navigator.pushNamed(context, 'profile');
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
          actions: [
            const Text("Home ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300)),
            SvgPicture.asset(
              'assets/donblood2.svg',
              height: 25,
            ),
            const SizedBox(
              width: 10,
            )
          ],
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
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width,
                  // margin: const EdgeInsets.all(9.0),
                  child: const Text("Recent Donations...",
                      style: TextStyle(
                          fontFamily: 'Argentum Sans',
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ),
                const Divider(
                  color: Colors.grey,
                  endIndent: 12.0,
                  indent: 12.0,
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream: feedQuery.snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.hasError) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: InfoBox(
                            text: 'No Donations Yet',
                            icon: Icons.error,
                            backgroundColor: Color.fromRGBO(255, 205, 210, 1),
                          ),
                        );
                      }
                      if (snapshots.hasData) {
                        for (var i in snapshots.data!.docs) {
                          log("FEEED!!!!: ${i.data().toString()}");
                        }
                        return feedCards(snapshots.data!.docs);
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
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
              icon: Icon(Icons.favorite_border_outlined),
              label: 'Donate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bloodtype_outlined),
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
              title: const Text(
                'FAQS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'faq');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text(
                'Help & Support',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'help_support');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, 'welcome', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget feedCards(List<QueryDocumentSnapshot> snapshot) {
  // ignore: no_leading_underscores_for_local_identifiers
  PageController _controller = PageController();
  return Container(
    padding: const EdgeInsets.fromLTRB(8.0, 3, 8, 5),
    height: 190,
    child: Stack(
      children: [
        PageView.builder(
          controller: _controller,
          scrollDirection: Axis.vertical,
          itemCount: snapshot.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                snapshot[index].data() as Map<String, dynamic>;
            return SizedBox(
              height: 190,
              child: Card(
                color: Colors.red[50],
                shadowColor: Colors.purple[900],
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 255, 205, 210), width: 1),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: ListTile(
                      leading: Icon(Icons.favorite, color: Colors.red[800]),
                      contentPadding: const EdgeInsets.only(left: 10),
                      title: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "${data['patientName']} received ${data['units']} units of blood at ${data['hospitalName']}",
                            textStyle: const TextStyle(
                              fontSize: 16,
                            ),
                            speed: const Duration(milliseconds: 30),
                          ),
                        ],
                        totalRepeatCount: 1,
                      ),
                      subtitle: const Text(
                        "\nThank you to all the donors!",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 85, 46, 46),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        Container(
          alignment: const Alignment(0.9, 0),
          child: RotatedBox(
            quarterTurns: 1,
            child: SmoothPageIndicator(
              controller: _controller,
              count: snapshot.length,
              effect: WormEffect(
                dotColor: Colors.grey.shade400,
                activeDotColor: Colors.black,
                dotHeight: 5,
                dotWidth: 5,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
