import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class Confettie extends StatelessWidget {
  final ConfettiController controller;

  const Confettie({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: controller,
      minBlastForce: 10,
      blastDirectionality: BlastDirectionality.explosive,
      particleDrag: 0.04,
      emissionFrequency: 0.05,
      numberOfParticles: 50,
      gravity: 0.5,
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple
      ],
    );
  }
}
