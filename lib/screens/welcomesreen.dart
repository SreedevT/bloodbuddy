import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isNextButtonEnabled = false;

  void enableNextButton() {
    setState(() {
      isNextButtonEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.red[900],
        child: Center(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Welcome",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [Colors.red, Colors.white],
                  ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: isNextButtonEnabled ? () {} : null,
              child: Text("Next"),
            ),
            ElevatedButton(
              onPressed: enableNextButton,
              child: Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}
