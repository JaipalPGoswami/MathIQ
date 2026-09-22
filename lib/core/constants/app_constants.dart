enum GradeLevel {
  kg('KG', 'Kindergarten', 4, 6),
  grade1('Grade 1', 'First Grade', 6, 7),
  grade2('Grade 2', 'Second Grade', 7, 8),
  grade3('Grade 3', 'Third Grade', 8, 9);

  final String label;
  final String description;
  final int minAge;
  final int maxAge;

  const GradeLevel(this.label, this.description, this.minAge, this.maxAge);

  static GradeLevel fromString(String val) {
    return GradeLevel.values.firstWhere(
      (g) => g.label.toLowerCase() == val.toLowerCase() || g.name.toLowerCase() == val.toLowerCase(),
      orElse: () => GradeLevel.grade1,
    );
  }
}

class AppConstants {
  static const String appName = 'Math Facts AI';
  static const String appTagline = 'Learn Math. Play. Improve.';
  static const String appVersion = '1.0.0';

  // XP Rewards
  static const int xpCorrectAnswer = 5;
  static const int xpPerfectQuiz = 25;
  static const int xpDailyGoal = 20;
  static const int xpTopicCompleted = 30;
  static const int xpAchievementUnlocked = 50;
  static const int xpGameCompleted = 15;

  // Mastery Percentages
  static const double masteryBeginnerMax = 0.39;
  static const double masteryLearningMax = 0.59;
  static const double masteryDevelopingMax = 0.79;
  static const double masteryStrongMax = 0.94;

  // Touch Targets
  static const double minTouchTarget = 56.0;
  static const double kidButtonHeight = 60.0;
  static const double kidCardRadius = 24.0;

  // Default Settings
  static const int defaultDailyGoalXp = 50;
  static const String defaultParentPin = '1234';

  // Avatars
  static const List<Map<String, String>> avatars = [
    {'id': 'astro_bear', 'emoji': '🐻', 'name': 'Barnaby Bear'},
    {'id': 'cosmo_fox', 'emoji': '🦊', 'name': 'Felix Fox'},
    {'id': 'wise_owl', 'emoji': '🦉', 'name': 'Oliver Owl'},
    {'id': 'fun_dino', 'emoji': '🦖', 'name': 'Danny Dino'},
    {'id': 'spark_robot', 'emoji': '🤖', 'name': 'Robbie Robot'},
    {'id': 'magic_unicorn', 'emoji': '🦄', 'name': 'Una Unicorn'},
    {'id': 'brave_lion', 'emoji': '🦁', 'name': 'Leo Lion'},
    {'id': 'clever_monkey', 'emoji': '🐵', 'name': 'Milo Monkey'},
  ];

  // Cheerful Feedback Strings
  static const List<String> praiseCorrect = [
    'Super Star! ⭐',
    'Awesome Job! 🎉',
    'You Got It! 🚀',
    'Math Wizard! 🧙‍♂️',
    'Brilliant Thinking! 💡',
    'High Five! ✋',
    'You are unstoppable! 🌟',
  ];

  static const List<String> encouragingIncorrect = [
    'Good try! Let us look at it together. 💡',
    'Almost there! You can do it. 🌱',
    'Mistakes help us learn! Try this one. 🎈',
    'Take a breath and count with me! 🍎',
    'Great effort! Let us see how it works. ✨',
  ];
}
