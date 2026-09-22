import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../models/attempt.dart';
import '../models/mastery.dart';
import '../../core/constants/app_constants.dart';

class PracticeRepository {
  final AppDatabase _db;

  PracticeRepository({AppDatabase? db}) : _db = db ?? AppDatabase();

  Future<void> recordAnswer({
    required String studentId,
    required String questionId,
    required String topicId,
    required String answer,
    required bool isCorrect,
    required int responseTimeMs,
  }) async {
    final attempt = Attempt(
      id: const Uuid().v4(),
      studentId: studentId,
      questionId: questionId,
      skillId: topicId,
      answer: answer,
      isCorrect: isCorrect,
      responseTimeMs: responseTimeMs,
    );
    await _db.recordAttempt(attempt);

    // Update Topic Mastery
    final existing = _db.getMasteryForTopic(topicId);
    final attempts = (existing?.attempts ?? 0) + 1;
    final correct = (existing?.correctAnswers ?? 0) + (isCorrect ? 1 : 0);
    final accuracy = correct / attempts;

    final updatedMastery = TopicMastery(
      id: existing?.id ?? const Uuid().v4(),
      studentId: studentId,
      topicId: topicId,
      accuracy: accuracy,
      attempts: attempts,
      correctAnswers: correct,
      level: MasteryLevel.fromAccuracy(accuracy),
      lastPracticed: DateTime.now(),
    );

    await _db.saveMastery(updatedMastery);
  }
}
