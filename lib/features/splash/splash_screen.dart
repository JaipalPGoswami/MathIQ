import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../data/database/app_database.dart';
import '../onboarding/onboarding_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _scaleAnimation = CurvedAnimation(parent: _animController, curve: Curves.elasticOut);
    _animController.forward();

    _checkStudentAndNavigate();
  }

  Future<void> _checkStudentAndNavigate() async {
    await AppDatabase().init();
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final student = AppDatabase().getStudent();
    if (student != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  '🧮',
                  style: TextStyle(fontSize: 60),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Math Facts AI',
                style: AppTypography.displayLarge.copyWith(
                  color: Colors.white,
                  fontSize: 38,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Learn Math. Play. Improve. ⭐',
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('➕', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 16),
                  Text('➖', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 16),
                  Text('✖️', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 16),
                  Text('➗', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 16),
                  Text('🍕', style: TextStyle(fontSize: 24)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
