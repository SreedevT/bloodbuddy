import 'package:blood/authentication/phone_signup.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin{
  // to keep track which page we are on
  final PageController _controller = PageController();

  late final AnimationController _animationController1 = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat(min: 0, max: 1);

  late final AnimationController _waveController = AnimationController(
    duration: const Duration(seconds: 1),
    upperBound: .1,
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation1 = CurvedAnimation(
    parent: _animationController1,
    curve: Curves.linear,
  );

  late final Animation<double> _waveAnimation = CurvedAnimation(
    parent: _waveController,
    curve: Curves.bounceOut,
  );



  @override
  void dispose() {
    _animationController1.dispose();
    _waveController.dispose();
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
      color: Colors.red[800],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Image.asset('assets/reqblood3.png'),
          const SizedBox(height: 80),
          const Text(
            "Empowering Generosity",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'Argentum Sans',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Submit a Blood Request \nand Inspire Donors!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w500,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
          // RichText(
          //   text: const TextSpan(
          //       text: "\t\t\tEmpowering Generosity",
          //       style: TextStyle(
          //         fontSize: 30,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //       ),
          //       children: [
          //         TextSpan(
          //           text: "\n\nSubmit a Blood Request and Inspire Donors!",
          //           style: TextStyle(
          //             fontStyle: FontStyle.italic,
          //             fontSize: 18,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         )
          //       ]),
          // ),
        ],
      ));
}

 Widget secondView(){
  return Container(
    color: Colors.red[800],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
            Container(
            alignment: const Alignment(0, 0),
            child: RichText(
              text: const TextSpan(
                text: "Be a ",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                      text: "Lifeline,\n",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      )),
                  TextSpan(
                    text: "\t\t\t\t\tDonate ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                      text: "Blood!\n",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ),
        const SizedBox(height: 100),
        SvgPicture.asset('assets/donblood2.svg',
        height: 200,),
      ],
    ),
  );
}

  Widget thirdView() {
    return Container(
      color: Colors.red[800],
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
                child: RotationTransition(
                  turns: _waveAnimation,
                  child: const Icon(
                    Icons.waving_hand_outlined,
                    size: 60,
                    color: Color.fromARGB(255, 198, 40, 40),
                  ),
                )),
            RichText(
              text: const TextSpan(
                text: "You are one step away.\n",
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 198, 40, 40),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
                alignment: const Alignment(0, 0.1),
                child: ElevatedButton(
                        onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const MyPhone(),
                    transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                      return SlideTransition(
                        position: Tween(
                          begin: const Offset(1.0, 0.0), // bottom to top
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                );
              },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red[800]),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: const Text("Join our community!"))),
          ],
        ),
      ),
    );
  }
}
