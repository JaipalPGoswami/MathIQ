import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/audio/audio_service.dart';
import '../../widgets/visuals/analog_clock_widget.dart';
import '../../widgets/buttons/kid_button.dart';

class GameTimeChallenge extends StatefulWidget {
  const GameTimeChallenge({super.key});

  @override
  State<GameTimeChallenge> createState() => _GameTimeChallengeState();
}

class _GameTimeChallengeState extends State<GameTimeChallenge> {
  final Random _rnd = Random();
  int _score = 0;

  late int _hour;
  late int _minute;
  late String _correct;
  late List<String> _options;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      _hour = _rnd.nextInt(12) + 1;
      _minute = _rnd.nextBool() ? 0 : 30;
      final minStr = _minute.toString().padLeft(2, '0');
      _correct = '$_hour:$minStr';

      final Set<String> opts = {_correct};
      while (opts.length < 4) {
        final h = _rnd.nextInt(12) + 1;
        final m = _rnd.nextBool() ? '00' : '30';
        opts.add('$h:$m');
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
      appBar: AppBar(title: const Text('Game 9: Time Challenge ⏰')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Score: $_score ⭐', style: AppTypography.titleLarge.copyWith(color: AppColors.warmAmber)),
            const SizedBox(height: 16),
            Text('What time does this clock show? ⏰', style: AppTypography.bodyLarge),
            const SizedBox(height: 24),

            AnalogClockWidget(hour: _hour, minute: _minute, size: 200),
            const Spacer(),

            Row(
              children: _options.map((opt) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: KidButton(
                      text: opt,
                      fontSize: 22,
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
