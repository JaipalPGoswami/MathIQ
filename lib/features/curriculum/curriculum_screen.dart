import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../data/repositories/student_repository.dart';
import '../../data/repositories/curriculum_repository.dart';
import '../../widgets/cards/topic_card.dart';
import 'topic_detail_screen.dart';

class CurriculumScreen extends StatefulWidget {
  const CurriculumScreen({super.key});

  @override
  State<CurriculumScreen> createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumScreen> {
  final StudentRepository _studentRepo = StudentRepository();
  final CurriculumRepository _currRepo = CurriculumRepository();

  late String _activeGrade;

  @override
  void initState() {
    super.initState();
    final s = _studentRepo.getCurrentStudent();
    _activeGrade = s?.grade ?? 'Grade 1';
  }

  @override
  Widget build(BuildContext context) {
    final topics = _currRepo.getTopicsForGrade(_activeGrade);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Curriculum 📚'),
      ),
      body: Column(
        children: [
          // Grade Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p16, vertical: 8),
            child: Row(
              children: ['KG', 'Grade 1', 'Grade 2', 'Grade 3'].map((g) {
                final isSelected = g == _activeGrade;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(g, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                    selected: isSelected,
                    selectedColor: AppColors.warmAmber,
                    onSelected: (_) => setState(() => _activeGrade = g),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Topic Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppDimensions.p16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                final mastery = _currRepo.getMastery(topic.id);
                return TopicCard(
                  topic: topic,
                  mastery: mastery,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TopicDetailScreen(topic: topic),
                      ),
                    ).then((_) => setState(() {}));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
