import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/database/app_database.dart';
import '../../widgets/buttons/kid_button.dart';
import '../splash/splash_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsRepository _repo = SettingsRepository();

  @override
  Widget build(BuildContext context) {
    final settings = _repo.getSettings();

    return Scaffold(
      appBar: AppBar(title: const Text('App Settings ⚙️')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Audio & Narration', style: AppTypography.titleMedium),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Sound Effects'),
                    value: settings.soundEnabled,
                    activeColor: AppColors.primaryBlue,
                    onChanged: (val) async {
                      await _repo.updateSettings(settings.copyWith(soundEnabled: val));
                      setState(() {});
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Voice Narration'),
                    value: settings.voiceEnabled,
                    activeColor: AppColors.primaryBlue,
                    onChanged: (val) async {
                      await _repo.updateSettings(settings.copyWith(voiceEnabled: val));
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Learning Preferences', style: AppTypography.titleMedium),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Daily Goal'),
                    trailing: DropdownButton<int>(
                      value: settings.dailyGoal,
                      underline: const SizedBox(),
                      items: [20, 50, 100].map((v) => DropdownMenuItem(value: v, child: Text('$v XP'))).toList(),
                      onChanged: (v) async {
                        if (v != null) {
                          await _repo.updateSettings(settings.copyWith(dailyGoal: v));
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Language'),
                    trailing: const Text('English (US) 🇺🇸', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Reset Data Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.pinkLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Column(
                children: [
                  const Text('Reset Student Data', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.coralPink)),
                  const SizedBox(height: 6),
                  const Text(
                    'This clears all progress, XP, and resets profile to start fresh.',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.coralPink),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Reset All Data?'),
                          content: const Text('Are you sure you want to clear all progress? This cannot be undone.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.coralPink),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Reset', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await AppDatabase().resetAllData();
                        if (!mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const SplashScreen()),
                          (_) => false,
                        );
                      }
                    },
                    child: const Text('Clear All Data', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
