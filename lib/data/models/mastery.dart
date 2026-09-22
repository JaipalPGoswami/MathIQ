enum MasteryLevel {
  beginner('Beginner', 'Starting Out 🌱', 0.0),
  learning('Learning', 'Getting It 🌿', 0.40),
  developing('Developing', 'Growing Strong 🌳', 0.60),
  strong('Strong', 'Math Champ ⭐', 0.80),
  mastered('Mastered', 'Grand Master 👑', 0.95);

  final String title;
  final String badge;
  final double minThreshold;

  const MasteryLevel(this.title, this.badge, this.minThreshold);

  static MasteryLevel fromAccuracy(double accuracy) {
    if (accuracy >= 0.95) return MasteryLevel.mastered;
    if (accuracy >= 0.80) return MasteryLevel.strong;
    if (accuracy >= 0.60) return MasteryLevel.developing;
    if (accuracy >= 0.40) return MasteryLevel.learning;
    return MasteryLevel.beginner;
  }
}

class TopicMastery {
  final String id;
  final String studentId;
  final String topicId;
  final double accuracy;
  final int attempts;
  final int correctAnswers;
  final MasteryLevel level;
  final DateTime lastPracticed;

  TopicMastery({
    required this.id,
    required this.studentId,
    required this.topicId,
    required this.accuracy,
    required this.attempts,
    required this.correctAnswers,
    required this.level,
    DateTime? lastPracticed,
  }) : lastPracticed = lastPracticed ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'topic_id': topicId,
      'accuracy': accuracy,
      'attempts': attempts,
      'correct_answers': correctAnswers,
      'mastery_level': level.name,
      'last_practiced': lastPracticed.toIso8601String(),
    };
  }

  factory TopicMastery.fromMap(Map<String, dynamic> map) {
    final acc = (map['accuracy'] as num).toDouble();
    return TopicMastery(
      id: map['id'] as String,
      studentId: map['student_id'] as String,
      topicId: (map['topic_id'] ?? map['skill_id']) as String,
      accuracy: acc,
      attempts: (map['attempts'] as num).toInt(),
      correctAnswers: (map['correct_answers'] as num).toInt(),
      level: MasteryLevel.fromAccuracy(acc),
      lastPracticed: DateTime.parse(map['last_practiced'] as String),
    );
  }
}
