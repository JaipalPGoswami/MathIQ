import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/audio/audio_service.dart';
import '../../widgets/buttons/kid_button.dart';

class GameMissingNumber extends StatefulWidget {
  const GameMissingNumber({super.key});

  @override
  State<GameMissingNumber> createState() => _GameMissingNumberState();
}

class _GameMissingNumberState extends State<GameMissingNumber> {
  final Random _rnd = Random();
  late int _start;
  late int _step;
  late int _missingIndex; // 0, 1, 2, or 3
  late int _targetNumber;
  late List<int> _options;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      _start = _rnd.nextInt(15) + 1;
      _step = _rnd.nextBool() ? 1 : 2;
      _missingIndex = _rnd.nextInt(4);
      _targetNumber = _start + _missingIndex * _step;

      final Set<int> opts = {_targetNumber};
      while (opts.length < 4) {
        opts.add(_targetNumber + _rnd.nextInt(9) - 4);
      }
      _options = opts.where((n) => n > 0).toList()..shuffle(_rnd);
    });
  }

  void _choose(int num) {
    if (num == _targetNumber) {
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
      appBar: AppBar(title: const Text('Game 3: Missing Number 🚂')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Score: $_score ⭐', style: AppTypography.titleLarge.copyWith(color: AppColors.warmAmber)),
            const SizedBox(height: 24),
            Text('Find the missing train car number! 🚂', style: AppTypography.bodyLarge),
            const SizedBox(height: 32),

            // Train cars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final isBlank = i == _missingIndex;
                final val = _start + i * _step;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isBlank ? AppColors.amberLight : AppColors.primaryBlueLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isBlank ? AppColors.warmAmber : AppColors.primaryBlue,
                      width: 2.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isBlank ? '?' : '$val',
                    style: AppTypography.displayMedium.copyWith(fontSize: 26),
                  ),
                );
              }),
            ),
            const Spacer(),

            Row(
              children: _options.map((opt) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: KidButton(
                      text: '$opt',
                      fontSize: 24,
                      color: AppColors.primaryBlue,
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
