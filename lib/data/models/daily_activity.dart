class DailyActivity {
  final String id;
  final String studentId;
  final String date; // YYYY-MM-DD
  final int questionsAttempted;
  final int questionsCorrect;
  final int xpEarned;
  final int practiceMinutes;

  DailyActivity({
    required this.id,
    required this.studentId,
    required this.date,
    this.questionsAttempted = 0,
    this.questionsCorrect = 0,
    this.xpEarned = 0,
    this.practiceMinutes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'date': date,
      'questions_attempted': questionsAttempted,
      'questions_correct': questionsCorrect,
      'xp_earned': xpEarned,
      'practice_minutes': practiceMinutes,
    };
  }

  factory DailyActivity.fromMap(Map<String, dynamic> map) {
    return DailyActivity(
      id: map['id'] as String,
      studentId: map['student_id'] as String,
      date: map['date'] as String,
      questionsAttempted: (map['questions_attempted'] as num).toInt(),
      questionsCorrect: (map['questions_correct'] as num).toInt(),
      xpEarned: (map['xp_earned'] as num).toInt(),
      practiceMinutes: (map['practice_minutes'] as num).toInt(),
    );
  }
}
