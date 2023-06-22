import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin{
  // to keep track which page we are on
  final PageController _controller = PageController();

  late final AnimationController _animationController1 = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat(min: 0, max: 1);
  late final Animation<double> _animation1 = CurvedAnimation(
    parent: _animationController1,
    curve: Curves.linear,
  );

  @override
  void dispose() {
    _animationController1.dispose();
    super.dispose();
  }

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
            effect: WormEffect(
              dotColor: Colors.grey.shade300,
              activeDotColor: Colors.black,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
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
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
                "\"World's largest Blood Donors mobile app\"",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.none,
                  fontSize: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget secondView() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            alignment: const Alignment(0.0, 0.0),
            child: SpinKitPumpingHeart(
              color: Colors.red[900],
              size: 300.0,
            ),
          ),
          Container(
            alignment: const Alignment(0, 0),
            child: RichText(
              text: const TextSpan(
                text: "\" One Act of ",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                      text: "DONATION,\n",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  TextSpan(
                    text: "Countless Lives ",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                      text: "SAVED! \"\n",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
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
      color: Colors.red[900],
      child: Center(
        child: Stack(
          alignment: const Alignment(0, 0),
          children: [
            Transform.rotate(
              angle: -5.5,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            RotationTransition(
              turns: _animation1,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            RotationTransition(
              turns: ReverseAnimation(_animation1),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Container(
                alignment: const Alignment(-0.5, -0.15),
                child: const Icon(
                  Icons.waving_hand_outlined,
                  size: 60,
                  color: Colors.red,
                )),
            RichText(
              text: const TextSpan(
                text: "You are one step away.\n",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
                alignment: const Alignment(0, 0.1),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'phone_signup');
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red[900]),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: const Text("Join our community!"))),
          ],
        ),
      ),
    );
  }
}
