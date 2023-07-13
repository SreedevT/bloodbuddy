import 'package:flutter/material.dart';

class Utils {
  static reload({required Widget page, required BuildContext context}) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return page; // Replace with the desired route widget
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return child; // No transition animation, directly show the new route
        },
        transitionDuration: const Duration(
            milliseconds: 0), // Set the duration to zero to remove any delay
      ),
    );
  }

  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input; // Return the original string if it's empty
    }

    String firstLetter = input.substring(0, 1).toUpperCase();
    String remainingLetters = input.substring(1);

    return '$firstLetter$remainingLetters';
  }
}
