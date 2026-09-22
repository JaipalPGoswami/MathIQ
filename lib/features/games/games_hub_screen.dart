import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import 'game_number_match.dart';
import 'game_count_objects.dart';
import 'game_missing_number.dart';
import 'game_math_race.dart';
import 'game_shape_match.dart';
import 'game_number_ordering.dart';
import 'game_fraction_pizza.dart';
import 'game_money_shop.dart';
import 'game_time_challenge.dart';
import 'game_pattern_detective.dart';

class GamesHubScreen extends StatelessWidget {
  const GamesHubScreen({super.key});

  static final List<Map<String, dynamic>> games = [
    {
      'title': 'Number Match',
      'desc': 'Match digits with item groups',
      'icon': '🔢',
      'color': AppColors.primaryBlueLight,
      'builder': () => const GameNumberMatch(),
    },
    {
      'title': 'Count the Objects',
      'desc': 'Tap & count playful animals',
      'icon': '🍎',
      'color': AppColors.pinkLight,
      'builder': () => const GameCountObjects(),
    },
    {
      'title': 'Missing Number',
      'desc': 'Fill the stepping stone blanks',
      'icon': '❓',
      'color': AppColors.amberLight,
      'builder': () => const GameMissingNumber(),
    },
    {
      'title': 'Math Race',
      'desc': 'Speed math against the clock',
      'icon': '🏎️',
      'color': AppColors.orangeLight,
      'builder': () => const GameMathRace(),
    },
    {
      'title': 'Shape Match',
      'desc': 'Identify triangles, squares & more',
      'icon': '🔷',
      'color': AppColors.tealLight,
      'builder': () => const GameShapeMatch(),
    },
    {
      'title': 'Number Ordering',
      'desc': 'Order numbers smallest to largest',
      'icon': '📈',
      'color': AppColors.greenLight,
      'builder': () => const GameNumberOrdering(),
    },
    {
      'title': 'Fraction Pizza',
      'desc': 'Slice delicious pizza fractions',
      'icon': '🍕',
      'color': AppColors.amberLight,
      'builder': () => const GameFractionPizza(),
    },
    {
      'title': 'Money Toy Shop',
      'desc': 'Buy cute toys with cash & coins',
      'icon': '🪙',
      'color': AppColors.purpleLight,
      'builder': () => const GameMoneyShop(),
    },
    {
      'title': 'Time Challenge',
      'desc': 'Read analog clocks like a pro',
      'icon': '⏰',
      'color': AppColors.primaryBlueLight,
      'builder': () => const GameTimeChallenge(),
    },
    {
      'title': 'Pattern Detective',
      'desc': 'Crack the secret sequence pattern',
      'icon': '🕵️',
      'color': AppColors.pinkLight,
      'builder': () => const GamePatternDetective(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('10 Math Mini-Games 🎮'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppDimensions.p16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.88,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final g = games[index];
          return InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => (g['builder'] as Widget Function())()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(color: AppColors.cardBorder, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: g['color'] as Color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(g['icon'] as String, style: const TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    g['title'] as String,
                    style: AppTypography.titleMedium.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    g['desc'] as String,
                    style: AppTypography.bodyMedium.copyWith(fontSize: 12),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
