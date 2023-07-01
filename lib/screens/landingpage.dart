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
          onPressed: (

            
          ) {
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
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Row(
                      children: [
                        const Text(
                          'User id',
                          style: TextStyle(
                              color: Color.fromARGB(255, 170, 168, 168),
                              fontSize: 14),
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
       floatingActionButton:FloatingActionButton( //Floating action button on Scaffold
      onPressed: (){
          //code to execute on button press
      },
      child: Icon(Icons.send,),backgroundColor: Colors.white,elevation: 2.0,//icon inside button
  ),

  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  //floating action button position to center

  bottomNavigationBar: BottomAppBar( //bottom navigation bar on scaffold
    color:const Color.fromARGB(255, 255, 255, 255),
    shape: CircularNotchedRectangle(), //shape of notch
    notchMargin: 5, //notche margin between floating button and bottom appbar
    child: Row( //children inside bottom appbar
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(icon: Icon(Icons.home, color: const Color.fromARGB(255, 8, 0, 0),), onPressed: () {},),
        IconButton(icon: Icon(Icons.search, color: const Color.fromARGB(255, 13, 0, 0),), onPressed: () {},),
        IconButton(icon: Icon(Icons.print, color: const Color.fromARGB(255, 0, 0, 0),), onPressed: () {},),
        IconButton(icon: Icon(Icons.person_outlined, color: const Color.fromARGB(255, 5, 0, 0),), onPressed: () {},),
      ],
    ),
  ),
    );
  }
}
