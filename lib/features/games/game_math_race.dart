import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/audio/audio_service.dart';
import '../../widgets/buttons/kid_button.dart';

class GameMathRace extends StatefulWidget {
  const GameMathRace({super.key});

  @override
  State<GameMathRace> createState() => _GameMathRaceState();
}

class _GameMathRaceState extends State<GameMathRace> {
  final Random _rnd = Random();
  int _score = 0;
  int _secondsLeft = 30;
  Timer? _timer;
  bool _isPlaying = false;

  late int _a, _b, _ans;
  late List<int> _options;

  void _startGame() {
    setState(() {
      _score = 0;
      _secondsLeft = 30;
      _isPlaying = true;
    });
    _nextProblem();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else {
        t.cancel();
        setState(() => _isPlaying = false);
        AudioService().playCheer();
      }
    });
  }

  void _nextProblem() {
    _a = _rnd.nextInt(6) + 1;
    _b = _rnd.nextInt(6) + 1;
    _ans = _a + _b;
    final Set<int> opts = {_ans};
    while (opts.length < 4) {
      opts.add(_ans + _rnd.nextInt(7) - 3);
    }
    _options = opts.where((n) => n > 0).toList()..shuffle(_rnd);
  }

  void _choose(int val) {
    if (!_isPlaying) return;
    if (val == _ans) {
      AudioService().playCorrect();
      setState(() => _score++);
      _nextProblem();
    } else {
      AudioService().playIncorrect();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game 4: Math Race 🏎️')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: $_score ⭐', style: AppTypography.titleLarge.copyWith(color: AppColors.warmAmber)),
                Text('⏱️ $_secondsLeft s', style: AppTypography.titleLarge.copyWith(color: AppColors.coralPink)),
              ],
            ),
            const SizedBox(height: 16),

            // Race track animation indicator
            LinearProgressIndicator(
              value: (30 - _secondsLeft) / 30.0,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.coralPink),
            ),
            const SizedBox(height: 32),

            if (!_isPlaying) ...[
              const Spacer(),
              const Text('🏎️ 💨', style: TextStyle(fontSize: 70)),
              const SizedBox(height: 16),
              Text('Speed Math Race!', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text('Solve as many quick sums as you can before time expires!', style: AppTypography.bodyLarge, textAlign: TextAlign.center),
              const Spacer(),
              KidButton(
                text: 'Start Race! 🏁',
                color: AppColors.coralPink,
                onPressed: _startGame,
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.cardBorder, width: 2),
                ),
                child: Text('$_a + $_b = ?', style: AppTypography.displayMedium.copyWith(fontSize: 40), textAlign: TextAlign.center),
              ),
              const Spacer(),
              Column(
                children: _options.map((opt) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: KidButton(
                      text: '$opt',
                      fontSize: 26,
                      color: AppColors.primaryBlue,
                      onPressed: () => _choose(opt),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
