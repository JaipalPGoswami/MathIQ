import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/audio/audio_service.dart';
import '../../widgets/buttons/kid_button.dart';

class GameCountObjects extends StatefulWidget {
  const GameCountObjects({super.key});

  @override
  State<GameCountObjects> createState() => _GameCountObjectsState();
}

class _GameCountObjectsState extends State<GameCountObjects> {
  final Random _rnd = Random();
  late int _count;
  int _tappedCount = 0;
  final Set<int> _tappedIndices = {};
  int _score = 0;

  final List<String> _animals = ['🦁', '🐸', '🐼', '🦊', '🐰', '🐥'];
  late String _currentAnimal;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      _count = _rnd.nextInt(6) + 3; // 3-8
      _currentAnimal = _animals[_rnd.nextInt(_animals.length)];
      _tappedCount = 0;
      _tappedIndices.clear();
    });
  }

  void _tapObject(int idx) {
    if (_tappedIndices.contains(idx)) return;
    AudioService().playTap();
    setState(() {
      _tappedIndices.add(idx);
      _tappedCount++;
    });

    if (_tappedCount == _count) {
      AudioService().playCorrect();
      setState(() => _score++);
      Future.delayed(const Duration(milliseconds: 600), _nextRound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game 2: Count Animals 🐾')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: $_score ⭐', style: AppTypography.titleLarge.copyWith(color: AppColors.warmAmber)),
                Text('Tapped: $_tappedCount / $_count', style: AppTypography.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            Text('Tap each friendly animal to count them! 👆', style: AppTypography.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 24),

            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: List.generate(_count, (i) {
                    final isTapped = _tappedIndices.contains(i);
                    return GestureDetector(
                      onTap: () => _tapObject(i),
                      child: AnimatedScale(
                        scale: isTapped ? 1.25 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isTapped ? AppColors.greenLight : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isTapped ? AppColors.mintGreen : AppColors.cardBorder,
                              width: 2.5,
                            ),
                          ),
                          child: Text(
                            isTapped ? '✔️' : _currentAnimal,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
