import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../core/constants/app_constants.dart';
import '../../data/repositories/student_repository.dart';
import '../../widgets/buttons/kid_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StudentRepository _repo = StudentRepository();

  @override
  Widget build(BuildContext context) {
    final student = _repo.getCurrentStudent();
    if (student == null) {
      return const Scaffold(body: Center(child: Text('No active profile')));
    }

    final avatarMap = AppConstants.avatars.firstWhere(
      (a) => a['id'] == student.avatar,
      orElse: () => AppConstants.avatars.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Math Profile 🐻'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.p24),
        child: Column(
          children: [
            // Avatar & Name Card
            Container(
              padding: const EdgeInsets.all(AppDimensions.p24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                border: Border.all(color: AppColors.cardBorder, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    avatarMap['emoji']!,
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 12),
                  Text(student.name, style: AppTypography.displayMedium),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlueLight,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                    ),
                    child: Text(
                      '${student.grade} • Age ${student.age}',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primaryBlueDark,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatBadge('Level', '${student.level}', '👑', AppColors.warmAmber),
                      _buildStatBadge('Total XP', '${student.xp}', '⭐', AppColors.primaryBlue),
                      _buildStatBadge('Streak', '${student.streak} Days', '🔥', AppColors.coralPink),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Switch Grade Selector
            Container(
              padding: const EdgeInsets.all(AppDimensions.p20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                border: Border.all(color: AppColors.cardBorder, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Change Grade Level 🎒', style: AppTypography.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['KG', 'Grade 1', 'Grade 2', 'Grade 3'].map((g) {
                      final isSelected = student.grade == g;
                      return ChoiceChip(
                        label: Text(g, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                        selected: isSelected,
                        selectedColor: AppColors.warmAmber,
                        onSelected: (_) async {
                          final updated = student.copyWith(grade: g);
                          await _repo.updateStudent(updated);
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(String title, String val, String emoji, Color color) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(val, style: AppTypography.titleMedium.copyWith(color: color)),
        Text(title, style: AppTypography.bodyMedium.copyWith(fontSize: 12)),
      ],
    );
  }
}
