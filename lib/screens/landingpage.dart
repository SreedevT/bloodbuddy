import 'package:flutter/material.dart';



class BloodBuddyHomePage extends StatefulWidget {
  @override
  _BloodBuddyHomePageState createState() => _BloodBuddyHomePageState();
}

class _BloodBuddyHomePageState extends State<BloodBuddyHomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black,
          onPressed: () {
            // Handle menu button press
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.black,
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: 450.0,
              height: 160.0,
              padding: EdgeInsets.all(16.0),
              margin:
                  new EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: const Text('Welcome',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 25)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 450.0,
                    color: const Color.fromARGB(255, 3, 0, 0),
                    height: 35,
                    child: Row(
                      children: [
                        Text('Name here',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 255, 254, 254),
                                fontWeight: FontWeight.bold,
                                fontSize: 22)),
                                SizedBox(width: 150),
                        Image.asset(
                          'assets/images/blood.png',
                        scale: 1,
                          
                          
                          height: 300,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Row(
                      children: [
                        const Text(
                          'User id',
                          style: TextStyle(
                              color: Color.fromARGB(255, 170, 168, 168),
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 80, 0),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: const Text('Rescent Donation',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                width: 350,
                height: 100,
                decoration: BoxDecoration(
                    color: Color.fromARGB(212, 231, 231, 231),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('Sony donated to shaf......................',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 5, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 15))),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                width: 350,
                height: 100,
                decoration: BoxDecoration(
                    color: Color.fromARGB(212, 231, 231, 231),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('Sony donated to shaf......................',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 5, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 15))),
            SizedBox(
              height: 1,
            ),
            Container(
                padding: EdgeInsets.fromLTRB(150, 0, 0, 0),
                child: new InkWell(
                  child: new Text(
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
                padding: EdgeInsets.fromLTRB(50, 1, 50, 0),
                color: Color.fromARGB(211, 255, 255, 255),
                child: const Text('Thanku For donating to save a life',
                    style: TextStyle(
                        color: Color.fromARGB(255, 5, 0, 0), fontSize: 15))),
          ],
        ),
      ),
      floatingActionButton: Positioned(
        bottom: 64.0,
        right: 16.0,
        child: FloatingActionButton(
          onPressed: () {
            // Handle floating action button press
          },
          backgroundColor: Colors.red,
          child: Icon(
            Icons.local_hospital,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.red,
        selectedItemColor: const Color.fromARGB(255, 7, 0, 0),
        unselectedItemColor:
            const Color.fromARGB(255, 6, 0, 0).withOpacity(0.6),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/donationlogo.png'),
              size: 25,
            ),
            label: 'Donation',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/donationlogo.png'),
              size: 25,
            ),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
