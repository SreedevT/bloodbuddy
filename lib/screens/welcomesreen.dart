import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
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
      color: Colors.red[900],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(animationController1: _animationController1),

            // RichText(
            //   text: const TextSpan(
            //     style: TextStyle(
            //       fontSize: 40,
            //       letterSpacing: 1,
            //     ),
            //     children: [
            //       TextSpan(
            //         text: "Welc",
            //         style: TextStyle(
            //           fontSize: 60,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       TextSpan(
            //         text: "O",
            //         style: TextStyle(fontSize: 70, fontStyle: FontStyle.italic),
            //       ),
            //       TextSpan(
            //         text: "me",
            //         style: TextStyle(
            //           fontSize: 60,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'WELCOME',
                  textStyle: TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'SF',
                  ),
                  colors: [
                    Colors.red,
                    Colors.yellow,
                    Colors.purple,
                    Colors.blue,
                  ],
                ),
              ],
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
                child: RotationTransition(
                  turns: _waveAnimation,
                  child: const Icon(
                    Icons.waving_hand_outlined,
                    size: 60,
                    color: Colors.red,
                  ),
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

class Hero extends StatelessWidget {
  const Hero({
    super.key,
    required AnimationController animationController1,
  }) : _animationController1 = animationController1;

  final AnimationController _animationController1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(0, 0),
      children: [
        RotationTransition(
          turns: _animationController1,
          child: Blob.animatedRandom(
            // id: const ['5-6-43178'],=
            size: 400,
            edgesCount: 7,
            minGrowth: 9,
            styles: BlobStyles(
              color: Colors.white,
              fillType: BlobFillType.fill,
            ),
            loop: true,
          ),
        ),
        Lottie.asset(
          'assets/lottie/welcome_red.json',
        ),
        //! Cannot import svg files using Image.asset(). Needs flutter_svg package
        SvgPicture.asset(
          'assets/icons/logo.svg',
          height: 125,
          width: 125,
        )
      ],
    );
  }
}
