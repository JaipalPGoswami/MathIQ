import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/audio/audio_service.dart';
import '../../widgets/buttons/kid_button.dart';

class GameNumberMatch extends StatefulWidget {
  const GameNumberMatch({super.key});

  @override
  State<GameNumberMatch> createState() => _GameNumberMatchState();
}

class _GameNumberMatchState extends State<GameNumberMatch> {
  final Random _rnd = Random();
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
      _targetNumber = _rnd.nextInt(8) + 2; // 2-9
      final Set<int> opts = {_targetNumber};
      while (opts.length < 4) {
        opts.add(_rnd.nextInt(9) + 1);
      }
      _options = opts.toList()..shuffle(_rnd);
    });
  }

  void _select(int num) {
    if (num == _targetNumber) {
      AudioService().playCorrect();
      setState(() => _score++);
      if (_score % 5 == 0) {
        AudioService().playCheer();
      }
      _nextRound();
    } else {
      AudioService().playIncorrect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game 1: Number Match 🔢'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Score: $_score ⭐', style: AppTypography.titleLarge.copyWith(color: AppColors.warmAmber)),
            const SizedBox(height: 20),
            Text('How many stars do you see? Count them! 👇', style: AppTypography.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 24),

            // Item Cluster
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.amberLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.warmAmber.withOpacity(0.4), width: 2),
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: List.generate(
                  _targetNumber,
                  (index) => const Text('⭐', style: TextStyle(fontSize: 44)),
                ),
              ),
            ),
            const Spacer(),

            // Options
            Row(
              children: _options.map((opt) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: KidButton(
                      text: '$opt',
                      fontSize: 28,
                      color: AppColors.primaryBlue,
                      onPressed: () => _select(opt),
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
