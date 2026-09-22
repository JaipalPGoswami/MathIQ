import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../data/repositories/student_repository.dart';
import '../../data/repositories/stats_repository.dart';
import '../../data/repositories/curriculum_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/database/app_database.dart';
import '../../widgets/buttons/kid_button.dart';
import '../settings/settings_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  final SettingsRepository _settingsRepo = SettingsRepository();
  final StudentRepository _studentRepo = StudentRepository();
  final StatsRepository _statsRepo = StatsRepository();
  final CurriculumRepository _currRepo = CurriculumRepository();

  bool _isUnlocked = false;
  final TextEditingController _pinController = TextEditingController();
  String? _pinError;

  void _verifyPin() {
    if (_settingsRepo.verifyParentPin(_pinController.text.trim())) {
      setState(() {
        _isUnlocked = true;
        _pinError = null;
      });
    } else {
      setState(() {
        _pinError = 'Incorrect PIN. Default is 1234.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUnlocked) {
      return Scaffold(
        appBar: AppBar(title: const Text('Parent Lock 🛡️')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.p24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_rounded, size: 70, color: AppColors.primaryBlue),
                const SizedBox(height: 16),
                Text('Parent Access', style: AppTypography.displayMedium),
                const SizedBox(height: 8),
                Text('Please enter your 4-digit PIN to access parent controls.', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, letterSpacing: 8, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '••••',
                      errorText: _pinError,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onSubmitted: (_) => _verifyPin(),
                  ),
                ),
                const SizedBox(height: 20),
                KidButton(
                  text: 'Unlock Dashboard 🔓',
                  color: AppColors.primaryBlue,
                  onPressed: _verifyPin,
                ),
                const SizedBox(height: 12),
                Text('Hint for testing: Default PIN is 1234', style: AppTypography.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      );
    }

    final student = _studentRepo.getCurrentStudent();
    final totalSolved = _statsRepo.getTotalQuestionsSolved();
    final correctSolved = _statsRepo.getCorrectQuestionsSolved();
    final accuracy = totalSolved > 0 ? (correctSolved / totalSolved * 100).toInt() : 100;
    final masteries = _statsRepo.getAllMasteries();
    final settings = _settingsRepo.getSettings();

    // Identify weak topics (accuracy < 65% with attempts)
    final weakTopics = masteries.where((m) => m.accuracy < 0.65 && m.attempts > 0).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard 🛡️'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: AppColors.textPrimary, size: 28),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ).then((_) => setState(() {})),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Overview Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                border: Border.all(color: AppColors.cardBorder, width: 2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlueLight,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text('👤', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student?.name ?? 'Student', style: AppTypography.titleMedium),
                        Text('${student?.grade} • ${student?.xp} Total XP', style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Performance Cards
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile('Accuracy', '$accuracy%', AppColors.mintGreen, '🎯'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricTile('Questions', '$totalSolved', AppColors.primaryBlue, '📝'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Recommendations for Parent
            Text('Smart Recommendations 💡', style: AppTypography.titleMedium),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.amberLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(color: AppColors.warmAmber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      weakTopics.isNotEmpty
                          ? 'Focus 10 minutes on ${_currRepo.getTopicById(weakTopics.first.topicId)?.name ?? "weak topics"} to build strong foundations.'
                          : 'Student is performing well across all grade standards! Keep up the daily 10-minute streak.',
                      style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF92400E)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Parent Controls
            Text('Learning Controls ⚙️', style: AppTypography.titleMedium),
            const SizedBox(height: 12),

            SwitchListTile(
              title: const Text('AI Math Tutor Access'),
              subtitle: const Text('Allow child to chat with the child-safe AI tutor'),
              value: settings.aiAccessEnabled,
              activeColor: AppColors.primaryBlue,
              onChanged: (val) async {
                final s = settings.copyWith(aiAccessEnabled: val);
                await _settingsRepo.updateSettings(s);
                setState(() {});
              },
            ),

            SwitchListTile(
              title: const Text('Sound Effects'),
              subtitle: const Text('Play chimes, victory fanfare and cheers'),
              value: settings.soundEnabled,
              activeColor: AppColors.primaryBlue,
              onChanged: (val) async {
                final s = settings.copyWith(soundEnabled: val);
                await _settingsRepo.updateSettings(s);
                setState(() {});
              },
            ),

            SwitchListTile(
              title: const Text('Voice Narration (TTS)'),
              subtitle: const Text('Read questions aloud for early readers (KG/G1)'),
              value: settings.voiceEnabled,
              activeColor: AppColors.primaryBlue,
              onChanged: (val) async {
                final s = settings.copyWith(voiceEnabled: val);
                await _settingsRepo.updateSettings(s);
                setState(() {});
              },
            ),
            const SizedBox(height: 24),

            // Reset Data Warning Button
            KidButton(
              text: 'Manage Full App Settings ⚙️',
              color: AppColors.primaryBlue,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String title, String val, Color color, String icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.cardBorder, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              Text(val, style: AppTypography.displayMedium.copyWith(fontSize: 22, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
