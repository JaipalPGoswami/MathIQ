import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../data/models/topic.dart';
import '../../math_engine/models/visual_item.dart';
import '../../widgets/visuals/math_illustration.dart';
import '../../widgets/buttons/kid_button.dart';
import '../../core/audio/tts_service.dart';
import '../practice/practice_screen.dart';

class LearnScreen extends StatefulWidget {
  final Topic topic;

  const LearnScreen({super.key, required this.topic});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  int _currentStep = 0;

  late final List<Map<String, dynamic>> _steps;

  @override
  void initState() {
    super.initState();
    _steps = [
      {
        'title': 'Step 1: Look at the group!',
        'desc': 'Here are 3 sweet red apples. 🍎🍎🍎 Count them with me: one, two, three!',
        'visual': const VisualData(type: VisualType.apple, countA: 3),
      },
      {
        'title': 'Step 2: Add more items!',
        'desc': 'A friendly friend gives us 2 more shiny apples! 🍎🍎 How many are added?',
        'visual': const VisualData(type: VisualType.apple, countA: 2),
      },
      {
        'title': 'Step 3: Count them together!',
        'desc': '3 apples plus 2 apples makes 5 apples in total! 3 + 2 = 5! ⭐',
        'visual': const VisualData(type: VisualType.apple, countA: 3, countB: 2, operation: '+'),
      },
    ];

    // Speak initial step
    TtsService().speak(_steps[0]['desc'] as String);
  }

  @override
  void dispose() {
    TtsService().stop();
    super.dispose();
  }

  void _speakCurrent() {
    TtsService().speak(_steps[_currentStep]['desc'] as String);
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];

    return Scaffold(
      appBar: AppBar(
        title: Text('Learn: ${widget.topic.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryBlue, size: 30),
            tooltip: 'Read Aloud',
            onPressed: _speakCurrent,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.p20),
          child: Column(
            children: [
              // Stepper Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _steps.length,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: i == _currentStep ? 32 : 12,
                    height: 10,
                    decoration: BoxDecoration(
                      color: i == _currentStep ? AppColors.primaryBlue : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Visual Illustration
              MathIllustration(visualData: step['visual'] as VisualData),
              const SizedBox(height: 24),

              // Title & Description
              Text(
                step['title'] as String,
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(color: AppColors.cardBorder, width: 2),
                ),
                child: Text(
                  step['desc'] as String,
                  style: AppTypography.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),

              // Next / Practice Button
              Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: KidButton(
                        text: 'Back',
                        color: Colors.grey.shade400,
                        onPressed: () {
                          setState(() => _currentStep--);
                          _speakCurrent();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: KidButton(
                      text: _currentStep < _steps.length - 1 ? 'Next Step ➜' : 'Practice Now! 🚀',
                      color: AppColors.mintGreen,
                      onPressed: () {
                        if (_currentStep < _steps.length - 1) {
                          setState(() => _currentStep++);
                          _speakCurrent();
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => PracticeScreen(
                                topicId: widget.topic.id,
                                topicName: widget.topic.name,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
