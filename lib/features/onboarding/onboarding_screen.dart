import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../widgets/buttons/kid_button.dart';
import '../profile/profile_setup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'emoji': '🎨',
      'title': 'Learn Math Visually',
      'desc': 'Discover numbers, shapes, and sums through colorful pictures, apples, and interactive blocks!',
      'color': '0xFF3B82F6',
    },
    {
      'emoji': '🤖',
      'title': 'Friendly AI Tutor',
      'desc': 'Ask questions anytime! Your patient buddy explains every step and never makes you feel bad.',
      'color': '0xFF8B5CF6',
    },
    {
      'emoji': '🎮',
      'title': 'Play 10 Math Games',
      'desc': 'Race against the clock, bake fraction pizzas, order number bubbles, and explore the toy shop!',
      'color': '0xFFF97316',
    },
    {
      'emoji': '📈',
      'title': 'Track Your Progress',
      'desc': 'Watch your mastery grow from Beginner to Grand Master as you practice every single day!',
      'color': '0xFF10B981',
    },
    {
      'emoji': '⭐',
      'title': 'Become a Math Star!',
      'desc': 'Earn shiny badges, level up your avatar, and celebrate every win with confetti!',
      'color': '0xFFFBBF24',
    },
  ];

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentPage];
    final slideColor = Color(int.parse(slide['color']!));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.p16),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: Text(
                    'Skip',
                    style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemBuilder: (context, index) {
                  final s = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: slideColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            s['emoji']!,
                            style: const TextStyle(fontSize: 70),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          s['title']!,
                          style: AppTypography.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          s['desc']!,
                          style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _currentPage ? 24 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: i == _currentPage ? slideColor : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p24, vertical: AppDimensions.p16),
              child: KidButton(
                text: _currentPage == _slides.length - 1 ? 'Get Started! 🚀' : 'Next ➜',
                color: slideColor,
                onPressed: () {
                  if (_currentPage < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _finishOnboarding();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
