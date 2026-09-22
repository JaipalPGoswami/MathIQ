import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/audio/audio_service.dart';
import '../../widgets/buttons/kid_button.dart';

class GamePatternDetective extends StatefulWidget {
  const GamePatternDetective({super.key});

  @override
  State<GamePatternDetective> createState() => _GamePatternDetectiveState();
}

class _GamePatternDetectiveState extends State<GamePatternDetective> {
  final Random _rnd = Random();
  int _score = 0;

  final List<Map<String, dynamic>> _patterns = [
    {
      'seq': ['🔴', '🔵', '🔴', '🔵', '?'],
      'correct': '🔴',
      'options': ['🔴', '🔵', '⭐', '🟩'],
    },
    {
      'seq': ['⭐', '🌙', '⭐', '🌙', '?'],
      'correct': '⭐',
      'options': ['⭐', '🌙', '☀️', '☁️'],
    },
    {
      'seq': ['🍎', '🍌', '🍎', '🍌', '?'],
      'correct': '🍎',
      'options': ['🍎', '🍌', '🍊', '🍇'],
    },
    {
      'seq': ['🔺', '🔺', '🟩', '🔺', '🔺', '?'],
      'correct': '🟩',
      'options': ['🟩', '🔺', '🔵', '⚪'],
    },
  ];

  late Map<String, dynamic> _currentPattern;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      _currentPattern = _patterns[_rnd.nextInt(_patterns.length)];
    });
  }

  void _choose(String val) {
    if (val == _currentPattern['correct']) {
      AudioService().playCorrect();
      setState(() => _score++);
      _nextRound();
    } else {
      AudioService().playIncorrect();
    }
  }

  @override
  Widget build(BuildContext context) {
    final seq = _currentPattern['seq'] as List<String>;
    final opts = _currentPattern['options'] as List<String>;

    return Scaffold(
      appBar: AppBar(title: const Text('Game 10: Pattern Detective 🕵️')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Score: $_score ⭐', style: AppTypography.titleLarge.copyWith(color: AppColors.warmAmber)),
            const SizedBox(height: 20),
            Text('Crack the secret sequence! What comes next? 🔍', style: AppTypography.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 36),

            // Pattern line
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder, width: 2),
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: seq.map((item) {
                  final isBlank = item == '?';
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isBlank ? AppColors.amberLight : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isBlank ? Border.all(color: AppColors.warmAmber, width: 2) : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(item, style: const TextStyle(fontSize: 32)),
                  );
                }).toList(),
              ),
            ),
            const Spacer(),

            Row(
              children: opts.map((opt) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: KidButton(
                      text: opt,
                      fontSize: 28,
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
