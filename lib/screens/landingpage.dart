import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/donor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  // TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text(
  //     'Index 0: Home',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 1: Business',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 2: School',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 3: Settings',
  //     style: optionStyle,
  //   ),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              _scaffoldKey.currentState!
                  .openDrawer(); // Handle menu button press
            },
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Handle search button press
            },
          ),
        ],
      ),
      drawer: drawer(context),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const DonorCard(),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 80, 0),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: const Text('Recent Donation',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
                width: 350,
                height: 100,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(212, 231, 231, 231),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('Sony donated to shaf......................',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 5, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
                width: 350,
                height: 100,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(212, 231, 231, 231),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('Sony donated to shaf......................',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 5, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(150, 0, 0, 0),
                  child: const InkWell(
                    child: Text(
                      'Click here for more donation Details',
                      style: TextStyle(fontSize: 9),
                    ),
                  )),
              Image.asset(
                'assets/images/image2.jpg',
                width: 150,
                height: 100,
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(50, 1, 50, 0),
                  color: const Color.fromARGB(211, 255, 255, 255),
                  child: const Text('Thank you For donating to save a life',
                      style: TextStyle(
                          color: Color.fromARGB(255, 5, 0, 0), fontSize: 15))),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //code to execute on button press
        },
        backgroundColor: const Color.fromARGB(255, 254, 253, 253),
        elevation: 2.0,
        child: const Icon(
          Icons.send,
        ),
        //icon inside button
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floating action button position to center
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
            label: '  Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[800],
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: _onItemTapped,
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
              child: RichText(text: const TextSpan(
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
                      color: Colors.white,
                      fontFamily: 'normal',
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  )
                ]
              )),
            ),
            ListTile(
              leading: const Icon(Icons.question_answer_outlined),
              tileColor: const Color.fromARGB(255, 255, 255, 255),
              title: const Text('FAQ',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline_outlined),
              tileColor: const Color.fromARGB(255, 255, 255, 255),
              title: const Text('Help',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
              onTap: () {
                // Handle item 2 tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              tileColor: const Color.fromARGB(255, 254, 254, 254),
              title: const Text('Support',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              tileColor: const Color.fromARGB(255, 255, 255, 255),
              title: const Text('Log out',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
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


