import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/audio/audio_service.dart';
import '../../widgets/visuals/pizza_fraction_widget.dart';
import '../../widgets/buttons/kid_button.dart';

class GameFractionPizza extends StatefulWidget {
  const GameFractionPizza({super.key});

  @override
  State<GameFractionPizza> createState() => _GameFractionPizzaState();
}

class _GameFractionPizzaState extends State<GameFractionPizza> {
  final Random _rnd = Random();
  int _score = 0;

  late int _slices;
  late int _highlighted;
  late List<String> _options;
  late String _correct;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      final possible = [2, 3, 4, 6];
      _slices = possible[_rnd.nextInt(possible.length)];
      _highlighted = _rnd.nextInt(_slices - 1) + 1;
      _correct = '$_highlighted/$_slices';

      final Set<String> opts = {_correct};
      while (opts.length < 4) {
        final s = possible[_rnd.nextInt(possible.length)];
        final h = _rnd.nextInt(s) + 1;
        opts.add('$h/$s');
      }
      _options = opts.toList()..shuffle(_rnd);
    });
  }

  void _choose(String val) {
    if (val == _correct) {
      AudioService().playCorrect();
      setState(() => _score++);
      _nextRound();
    } else {
      AudioService().playIncorrect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game 7: Fraction Pizza 🍕')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Score: $_score ⭐', style: AppTypography.titleLarge.copyWith(color: AppColors.warmAmber)),
            const SizedBox(height: 16),
            Text('What fraction of pizza is topped with pepperoni? 🍕', style: AppTypography.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 20),

            PizzaFractionWidget(
              highlightedSlices: _highlighted,
              totalSlices: _slices,
              size: 200,
            ),
            const Spacer(),

            Row(
              children: _options.map((opt) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: KidButton(
                      text: opt,
                      fontSize: 24,
                      color: AppColors.warmAmber,
                      onPressed: () => _choose(opt),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
