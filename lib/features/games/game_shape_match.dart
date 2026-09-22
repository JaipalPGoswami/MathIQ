import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/audio/audio_service.dart';
import '../../widgets/buttons/kid_button.dart';

class GameShapeMatch extends StatefulWidget {
  const GameShapeMatch({super.key});

  @override
  State<GameShapeMatch> createState() => _GameShapeMatchState();
}

class _GameShapeMatchState extends State<GameShapeMatch> {
  final Random _rnd = Random();
  int _score = 0;

  final List<Map<String, String>> _shapes = [
    {'name': 'Circle', 'emoji': '⚪', 'hint': 'Round with zero corners!'},
    {'name': 'Triangle', 'emoji': '🔺', 'hint': 'Has 3 sharp corners!'},
    {'name': 'Square', 'emoji': '🟩', 'hint': '4 equal sides!'},
    {'name': 'Star', 'emoji': '⭐', 'hint': 'Shines bright with 5 points!'},
    {'name': 'Heart', 'emoji': '❤️', 'hint': 'Sweet and curved!'},
  ];

  late Map<String, String> _targetShape;
  late List<String> _options;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      _targetShape = _shapes[_rnd.nextInt(_shapes.length)];
      final Set<String> opts = {_targetShape['name']!};
      for (final s in _shapes) {
        opts.add(s['name']!);
      }
      _options = opts.toList()..shuffle(_rnd);
    });
  }

  void _choose(String name) {
    if (name == _targetShape['name']) {
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
      appBar: AppBar(title: const Text('Game 5: Shape Match 🔷')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Score: $_score ⭐', style: AppTypography.titleLarge.copyWith(color: AppColors.warmAmber)),
            const SizedBox(height: 20),
            Text('What shape is this? 🧐', style: AppTypography.bodyLarge),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cardBorder, width: 2),
              ),
              child: Text(
                _targetShape['emoji']!,
                style: const TextStyle(fontSize: 80),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _targetShape['hint']!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const Spacer(),

            Column(
              children: _options.map((name) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: KidButton(
                    text: name,
                    fontSize: 22,
                    color: AppColors.skyTeal,
                    onPressed: () => _choose(name),
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
