
import 'package:blood/authentication/phone_signup.dart';
import 'package:blood/authentication/register.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // to keep track on which page we are
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _controller,
          children: [
            firstView(),
            secondView(),
            thirdView(),
          ],
        ),
        Container(
          alignment: const Alignment(0.0, 0.75),
          child: SmoothPageIndicator(
            controller: _controller,
            count: 3,
            effect: const WormEffect(
              dotColor: Colors.grey,
              activeDotColor: Colors.purple,
              dotHeight: 10,
              dotWidth: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget firstView() {
    return Container(
      color: Colors.red[900],
      child: Center(
        child: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 40,
              letterSpacing: 1,
            ),
            children: [
              TextSpan(
                text: "Welc",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "O",
                style: TextStyle(fontSize: 70, fontStyle: FontStyle.italic),
              ),
              TextSpan(
                text: "me",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "\n\"World's largest Blood Donors\n mobile app\"",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget secondView() {
    return Container(
      color: Colors.white,
      
        child:Stack(
          children: [
            Container(
        alignment:const Alignment(0.0,0.0),
            child:SpinKitPumpingHeart(
              color: Colors.red[900],
              size: 300.0, 
            ),
            ),
            Container(
              alignment: Alignment(0,0),
              child:RichText(
                text: const TextSpan(
                  //text:"One Act of Donation, Countless Lives Saved!"
                  text:"\" One Act of ",
                  style:TextStyle(
                    fontSize: 15,
                    color:Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: "DONATION,\n",
                      style:TextStyle(
                        fontSize:20,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    TextSpan(
                  text:"Countless Lives ",
                  style:TextStyle(
                    fontSize: 15,
                    color:Colors.white,
                  ),),
                  TextSpan(
                      text: "SAVED! \"\n",
                      style:TextStyle(
                        fontSize:20,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget thirdView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical:150),
      color: Colors.red[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: const Icon(Icons.bloodtype_outlined,size: 100,color: Colors.white,)),
            const SizedBox(height:30),
            RichText(
            text: const TextSpan(
              text:"\"You believe in donating blood,\nwe believe in making it easier for you to do so\".\n",
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
            ),
            const SizedBox(height:30),
            Stack(
              children: [
                Transform.rotate(
                angle: 5.5,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MyPhone(),
                      ),
                    );
                  },
                ),
                ),
              ),  
            Transform.rotate(
              angle: 5.9,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MyPhone(),
                      ),
                    );
                  },
                ),
              ),
            ),
            Transform.rotate(
              angle: 5,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MyPhone(),
                      ),
                    );
                  },
                ),
              ),
            ),
            RichText(
            text: const TextSpan(
              text:"\n\n\n\n\t\t\t\tJoin our community!\n",
              style: TextStyle(
                fontSize: 17,
                color: Colors.red,
                fontStyle: FontStyle.italic,
              ),
            ),
            ),
            
            ],
            ),
        ],
      ),
    );
  }
}
