import 'package:flutter/material.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/profile_setup_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/home/home_screen.dart';
import '../features/curriculum/curriculum_screen.dart';
import '../features/games/games_hub_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/achievements/achievements_screen.dart';
import '../features/ai_tutor/ai_tutor_screen.dart';
import '../features/story_math/story_math_screen.dart';
import '../features/parent_dashboard/parent_dashboard_screen.dart';
import '../features/settings/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String profileSetup = '/profile-setup';
  static const String profile = '/profile';
  static const String home = '/home';
  static const String curriculum = '/curriculum';
  static const String games = '/games';
  static const String progress = '/progress';
  static const String achievements = '/achievements';
  static const String aiTutor = '/ai-tutor';
  static const String storyMath = '/story-math';
  static const String parentDashboard = '/parent-dashboard';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case profileSetup:
        return MaterialPageRoute(builder: (_) => const ProfileSetupScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case curriculum:
        return MaterialPageRoute(builder: (_) => const CurriculumScreen());
      case games:
        return MaterialPageRoute(builder: (_) => const GamesHubScreen());
      case progress:
        return MaterialPageRoute(builder: (_) => const ProgressScreen());
      case achievements:
        return MaterialPageRoute(builder: (_) => const AchievementsScreen());
      case aiTutor:
        return MaterialPageRoute(builder: (_) => const AiTutorScreen());
      case storyMath:
        return MaterialPageRoute(builder: (_) => const StoryMathScreen());
      case parentDashboard:
        return MaterialPageRoute(builder: (_) => const ParentDashboardScreen());
      case AppRouter.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
