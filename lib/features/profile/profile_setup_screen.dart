import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/buttons/kid_button.dart';
import '../../data/repositories/student_repository.dart';
import '../home/home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Leo');
  String _selectedGrade = 'Grade 1';
  int _selectedAge = 6;
  String _selectedAvatar = 'astro_bear';
  int _dailyGoalXp = 50;

  final List<String> _grades = ['KG', 'Grade 1', 'Grade 2', 'Grade 3'];

  Future<void> _saveAndContinue() async {
    final name = _nameController.text.trim().isEmpty ? 'Super Star' : _nameController.text.trim();
    final repo = StudentRepository();
    await repo.createStudent(
      name: name,
      grade: _selectedGrade,
      age: _selectedAge,
      avatar: _selectedAvatar,
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Profile ⭐'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What is your name?', style: AppTypography.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: AppTypography.titleMedium,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter your name...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    borderSide: const BorderSide(color: AppColors.cardBorder, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text('Choose your avatar 🐻', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.avatars.length,
                  itemBuilder: (context, index) {
                    final a = AppConstants.avatars[index];
                    final isSelected = a['id'] == _selectedAvatar;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAvatar = a['id']!),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryBlueLight : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primaryBlue : AppColors.cardBorder,
                            width: isSelected ? 3 : 1.5,
                          ),
                        ),
                        child: Text(
                          a['emoji']!,
                          style: const TextStyle(fontSize: 44),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              Text('Select your Grade 🎒', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: _grades.map((g) {
                  final isSelected = g == _selectedGrade;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGrade = g;
                            if (g == 'KG') _selectedAge = 5;
                            else if (g == 'Grade 1') _selectedAge = 6;
                            else if (g == 'Grade 2') _selectedAge = 7;
                            else _selectedAge = 8;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.warmAmber : Colors.white,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            border: Border.all(
                              color: isSelected ? AppColors.warmAmber : AppColors.cardBorder,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            g,
                            style: AppTypography.titleMedium.copyWith(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              Text('Daily Practice Goal ⭐', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [20, 50, 100].map((goal) {
                  final isSelected = goal == _dailyGoalXp;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => setState(() => _dailyGoalXp = goal),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.mintGreen : Colors.white,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            border: Border.all(
                              color: isSelected ? AppColors.mintGreen : AppColors.cardBorder,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$goal XP',
                            style: AppTypography.titleMedium.copyWith(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 36),

              KidButton(
                text: 'Let us Start Learning! 🚀',
                color: AppColors.primaryBlue,
                onPressed: _saveAndContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
