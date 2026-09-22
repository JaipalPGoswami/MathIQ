import '../models/topic.dart';
import '../database/seed_data.dart';
import '../database/app_database.dart';
import '../models/mastery.dart';

class CurriculumRepository {
  final AppDatabase _db;

  CurriculumRepository({AppDatabase? db}) : _db = db ?? AppDatabase();

  List<Topic> getTopicsForGrade(String grade) {
    final all = SeedData.getInitialTopics();
    final normalized = grade.toLowerCase();
    return all.where((t) {
      if (normalized.contains('kg')) {
        return t.gradeMin == 'KG' || t.gradeMax == 'KG';
      } else if (normalized.contains('1')) {
        return t.gradeMin == 'Grade 1' || t.gradeMax == 'Grade 1';
      } else if (normalized.contains('2')) {
        return t.gradeMin == 'Grade 2' || t.gradeMax == 'Grade 2';
      } else {
        return t.gradeMin == 'Grade 3' || t.gradeMax == 'Grade 3';
      }
    }).toList();
  }

  Topic? getTopicById(String id) {
    final all = SeedData.getInitialTopics();
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  TopicMastery? getMastery(String topicId) {
    return _db.getMasteryForTopic(topicId);
  }
}
