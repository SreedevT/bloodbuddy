import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blood/screens/welcomesreen.dart';
import 'package:flutter/material.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(  // able to use page transition animation
          //context is already passed, previous page is not available
          pageBuilder: (_, __, ___) => const WelcomeScreen(),
          transitionsBuilder:   // defines the transition animation
              // 1st parameter is the context, 2nd is the animation, 3rd is the secondary animation, 4th is the child which is the welcome screen
              // passed to the PageRouteBuilder (that is, child is the destination page)
              (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(
              opacity: animation, // animation object is passed since as the transition progresses,
              // the opacity changes from 0 to 1 (transparent to opaque)
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 2000),
        ),
      );
    });

    return Stack(
      children: [
        Container(
          color: Colors.red[900],
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          child:DefaultTextStyle(
          style: const TextStyle(
            fontSize: 60.0,
            fontFamily: 'Argentum Sans',
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius:7.0,
                color: Colors.white,
                offset: Offset(0,0),
              ),
            ],
          ),
          child: AnimatedTextKit(
            isRepeatingAnimation: false,
            animatedTexts: [
              FadeAnimatedText('WELCOME'),
            ],

          ),
        ),
                ),
                Container(
                  alignment:const  Alignment(0,0.2),
                  margin: const EdgeInsets.all(5),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize:20.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.white
                    ),
                    child:AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        FadeAnimatedText('"World\'s Largest Blood Donor\'s mobile app"',textAlign: TextAlign.center)
                      ],
                    )
                  ),
                )
              ],
            );
          }
        }
