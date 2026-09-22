import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/audio/audio_service.dart';
import '../../widgets/buttons/kid_button.dart';

class GameNumberOrdering extends StatefulWidget {
  const GameNumberOrdering({super.key});

  @override
  State<GameNumberOrdering> createState() => _GameNumberOrderingState();
}

class _GameNumberOrderingState extends State<GameNumberOrdering> {
  final Random _rnd = Random();
  int _score = 0;

  late List<int> _numbers;
  late List<int> _selectedOrder;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      final Set<int> nums = {};
      while (nums.length < 4) {
        nums.add(_rnd.nextInt(30) + 1);
      }
      _numbers = nums.toList()..shuffle(_rnd);
      _selectedOrder = [];
    });
  }

  void _tapNumber(int n) {
    if (_selectedOrder.contains(n)) return;
    AudioService().playTap();

    setState(() {
      _selectedOrder.add(n);
    });

    if (_selectedOrder.length == _numbers.length) {
      // Check if sorted ascending
      final sorted = List<int>.from(_numbers)..sort();
      bool correct = true;
      for (int i = 0; i < sorted.length; i++) {
        if (_selectedOrder[i] != sorted[i]) correct = false;
      }

      if (correct) {
        AudioService().playCorrect();
        setState(() => _score++);
        Future.delayed(const Duration(milliseconds: 600), _nextRound);
      } else {
        AudioService().playIncorrect();
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() => _selectedOrder.clear());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game 6: Number Ordering 📈')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Score: $_score ⭐', style: AppTypography.titleLarge.copyWith(color: AppColors.warmAmber)),
            const SizedBox(height: 16),
            Text('Tap numbers from Smallest to Largest! 🎈', style: AppTypography.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 24),

            // Target Tray
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.amberLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final hasNum = i < _selectedOrder.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: hasNum ? AppColors.warmAmber : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.warmAmber, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      hasNum ? '${_selectedOrder[i]}' : '${i + 1}',
                      style: AppTypography.titleMedium.copyWith(
                        color: hasNum ? Colors.white : Colors.grey.shade400,
                        fontSize: 20,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const Spacer(),

            // Floating Number Bubbles
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: _numbers.map((n) {
                final isPicked = _selectedOrder.contains(n);
                return GestureDetector(
                  onTap: () => _tapNumber(n),
                  child: AnimatedOpacity(
                    opacity: isPicked ? 0.25 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$n',
                        style: AppTypography.displayMedium.copyWith(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
