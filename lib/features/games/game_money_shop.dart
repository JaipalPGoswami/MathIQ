import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/audio/audio_service.dart';
import '../../widgets/buttons/kid_button.dart';

class GameMoneyShop extends StatefulWidget {
  const GameMoneyShop({super.key});

  @override
  State<GameMoneyShop> createState() => _GameMoneyShopState();
}

class _GameMoneyShopState extends State<GameMoneyShop> {
  final Random _rnd = Random();
  int _score = 0;

  final List<Map<String, dynamic>> _toys = [
    {'name': 'Toy Robot', 'emoji': '🤖', 'price': 7},
    {'name': 'Stuffed Bear', 'emoji': '🧸', 'price': 5},
    {'name': 'Race Car', 'emoji': '🏎️', 'price': 10},
    {'name': 'Dino Toy', 'emoji': '🦖', 'price': 8},
    {'name': 'Space Rocket', 'emoji': '🚀', 'price': 12},
  ];

  late Map<String, dynamic> _currentToy;
  int _insertedMoney = 0;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      _currentToy = _toys[_rnd.nextInt(_toys.length)];
      _insertedMoney = 0;
    });
  }

  void _insert(int amount) {
    AudioService().playTap();
    setState(() {
      _insertedMoney += amount;
    });

    final target = _currentToy['price'] as int;
    if (_insertedMoney == target) {
      AudioService().playCorrect();
      setState(() => _score++);
      Future.delayed(const Duration(milliseconds: 600), _nextRound);
    } else if (_insertedMoney > target) {
      AudioService().playIncorrect();
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() => _insertedMoney = 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = _currentToy['price'] as int;

    return Scaffold(
      appBar: AppBar(title: const Text('Game 8: Toy Shop 🪙')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: $_score ⭐', style: AppTypography.titleLarge.copyWith(color: AppColors.warmAmber)),
                Text('Paid: \$$_insertedMoney / \$$price', style: AppTypography.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            Text('Insert the exact coins & cash to buy the toy! 🧸', style: AppTypography.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 24),

            // Toy Showcase
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.cardBorder, width: 2),
              ),
              child: Column(
                children: [
                  Text(_currentToy['emoji'] as String, style: const TextStyle(fontSize: 70)),
                  const SizedBox(height: 8),
                  Text(_currentToy['name'] as String, style: AppTypography.titleMedium),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.greenLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Price: \$$price',
                      style: AppTypography.titleMedium.copyWith(color: AppColors.emeraldGreen),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Money buttons
            Row(
              children: [
                Expanded(
                  child: KidButton(
                    text: '+\$1 🪙',
                    color: AppColors.warmAmber,
                    onPressed: () => _insert(1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: KidButton(
                    text: '+\$2 🪙',
                    color: AppColors.warmAmber,
                    onPressed: () => _insert(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: KidButton(
                    text: '+\$5 💵',
                    color: AppColors.mintGreen,
                    onPressed: () => _insert(5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
