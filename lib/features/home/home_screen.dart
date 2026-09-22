import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../core/constants/app_constants.dart';
import '../../data/repositories/student_repository.dart';
import '../../data/repositories/curriculum_repository.dart';
import '../../data/repositories/stats_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../math_engine/adaptive/recommendation_engine.dart';
import '../../widgets/buttons/kid_button.dart';
import '../curriculum/curriculum_screen.dart';
import '../curriculum/topic_detail_screen.dart';
import '../practice/practice_screen.dart';
import '../games/games_hub_screen.dart';
import '../progress/progress_screen.dart';
import '../ai_tutor/ai_tutor_screen.dart';
import '../story_math/story_math_screen.dart';
import '../profile/profile_screen.dart';
import '../parent_dashboard/parent_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;
  final StudentRepository _studentRepo = StudentRepository();
  final CurriculumRepository _currRepo = CurriculumRepository();
  final StatsRepository _statsRepo = StatsRepository();
  final SettingsRepository _settingsRepo = SettingsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          _buildHomeDashboard(),
          const CurriculumScreen(),
          const GamesHubScreen(),
          const ProgressScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (index) => setState(() => _currentTabIndex = index),
        backgroundColor: Colors.white,
        elevation: 8,
        indicatorColor: AppColors.primaryBlueLight,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded, size: 28),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_rounded, size: 28),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_esports_rounded, size: 28),
            label: 'Play',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_rounded, size: 28),
            label: 'Progress',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeDashboard() {
    final student = _studentRepo.getCurrentStudent();
    if (student == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final avatarMap = AppConstants.avatars.firstWhere(
      (a) => a['id'] == student.avatar,
      orElse: () => AppConstants.avatars.first,
    );

    final topics = _currRepo.getTopicsForGrade(student.grade);
    final masteries = _statsRepo.getAllMasteries();
    final settings = _settingsRepo.getSettings();

    RecommendationItem? recommendation;
    if (topics.isNotEmpty) {
      recommendation = RecommendationEngine.getDailyRecommendation(
        gradeTopics: topics,
        masteries: masteries,
      );
    }

    final dailyGoal = settings.dailyGoal;
    final xpToday = (student.xp % dailyGoal);
    final xpRemaining = (dailyGoal - xpToday).clamp(0, dailyGoal);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20, vertical: AppDimensions.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: Avatar, Greeting, Parent Lock
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ).then((_) => setState(() {})),
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlueLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryBlue, width: 2.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      avatarMap['emoji']!,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, ${student.name}! 👋',
                        style: AppTypography.titleLarge.copyWith(fontSize: 22),
                      ),
                      Text(
                        '${student.grade} • Level ${student.level} 👑',
                        style: AppTypography.bodyMedium.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Parent PIN Button
                IconButton(
                  icon: const Icon(Icons.shield_outlined, color: AppColors.textSecondary, size: 28),
                  tooltip: 'Parent Dashboard',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ParentDashboardScreen()),
                  ).then((_) => setState(() {})),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Daily Goal Banner
            Container(
              padding: const EdgeInsets.all(AppDimensions.p16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.warmAmber, Color(0xFFFBBF24)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.warmAmber.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daily Goal ⭐',
                        style: AppTypography.titleMedium.copyWith(color: Colors.white),
                      ),
                      Text(
                        '$xpRemaining XP to goal!',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                    child: LinearProgressIndicator(
                      value: (xpToday / dailyGoal).clamp(0.05, 1.0),
                      minHeight: 12,
                      backgroundColor: Colors.white.withOpacity(0.35),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recommended Challenge Card
            if (recommendation != null) ...[
              Container(
                padding: const EdgeInsets.all(AppDimensions.p16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  border: Border.all(color: AppColors.cardBorder, width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.greenLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(recommendation.icon, style: const TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recommended Practice',
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 12,
                              color: AppColors.emeraldGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            recommendation.topic.name,
                            style: AppTypography.titleMedium.copyWith(fontSize: 17),
                          ),
                          Text(
                            recommendation.reason,
                            style: AppTypography.bodyMedium.copyWith(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    KidButton(
                      text: 'Go! ➜',
                      isFullWidth: false,
                      height: 44,
                      fontSize: 15,
                      color: AppColors.mintGreen,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PracticeScreen(
                              topicId: recommendation!.topic.id,
                              topicName: recommendation.topic.name,
                            ),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Quick Hub Shortcuts (2x2 Grid)
            Text('Quick Activities 🎈', style: AppTypography.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickHubCard(
                    title: 'Practice Math',
                    subtitle: 'Questions & hints',
                    icon: '✏️',
                    color: AppColors.primaryBlueLight,
                    borderColor: AppColors.primaryBlue,
                    onTap: () {
                      if (topics.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PracticeScreen(
                              topicId: topics.first.id,
                              topicName: topics.first.name,
                            ),
                          ),
                        ).then((_) => setState(() {}));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickHubCard(
                    title: 'AI Tutor',
                    subtitle: 'Ask your buddy',
                    icon: '🤖',
                    color: AppColors.purpleLight,
                    borderColor: AppColors.grapePurple,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AiTutorScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickHubCard(
                    title: 'Math Games',
                    subtitle: '10 fun games',
                    icon: '🎮',
                    color: AppColors.orangeLight,
                    borderColor: AppColors.orangeTangerine,
                    onTap: () => setState(() => _currentTabIndex = 2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickHubCard(
                    title: 'Story Math',
                    subtitle: 'Fun word tales',
                    icon: '📖',
                    color: AppColors.greenLight,
                    borderColor: AppColors.mintGreen,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const StoryMathScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Top Grade Topics Preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Curriculum Topics 📚', style: AppTypography.titleMedium),
                TextButton(
                  onPressed: () => setState(() => _currentTabIndex = 1),
                  child: const Text('View All ➜'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...topics.take(3).map((t) {
              final m = _currRepo.getMastery(t.id);
              final percent = ((m?.accuracy ?? 0) * 100).toInt();
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(color: AppColors.cardBorder, width: 1.5),
                ),
                child: Row(
                  children: [
                    Text(t.icon, style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.name, style: AppTypography.titleMedium.copyWith(fontSize: 16)),
                          Text('Mastery: $percent%', style: AppTypography.bodyMedium.copyWith(fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => TopicDetailScreen(topic: t)),
                        ).then((_) => setState(() {}));
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHubCard({
    required String title,
    required String subtitle,
    required String icon,
    required Color color,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.p16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: borderColor.withOpacity(0.4), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 34)),
            const SizedBox(height: 8),
            Text(title, style: AppTypography.titleMedium.copyWith(fontSize: 16)),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTypography.bodyMedium.copyWith(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
