import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiHelper {
  static ConfettiController createController({Duration duration = const Duration(seconds: 2)}) {
    return ConfettiController(duration: duration);
  }

  static Widget buildCelebrationConfetti({
    required ConfettiController controller,
    Alignment alignment = Alignment.topCenter,
  }) {
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
        confettiController: controller,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple,
          Colors.amber,
        ],
        numberOfParticles: 35,
        emissionFrequency: 0.05,
        gravity: 0.15,
      ),
    );
  }
}
