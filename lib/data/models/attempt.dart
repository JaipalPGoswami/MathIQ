class Attempt {
  final String id;
  final String studentId;
  final String questionId;
  final String skillId;
  final String answer;
  final bool isCorrect;
  final int responseTimeMs;
  final DateTime createdAt;

  Attempt({
    required this.id,
    required this.studentId,
    required this.questionId,
    required this.skillId,
    required this.answer,
    required this.isCorrect,
    required this.responseTimeMs,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'question_id': questionId,
      'skill_id': skillId,
      'answer': answer,
      'is_correct': isCorrect ? 1 : 0,
      'response_time': responseTimeMs,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Attempt.fromMap(Map<String, dynamic> map) {
    return Attempt(
      id: map['id'] as String,
      studentId: map['student_id'] as String,
      questionId: map['question_id'] as String,
      skillId: map['skill_id'] as String,
      answer: map['answer'] as String,
      isCorrect: (map['is_correct'] as int) == 1,
      responseTimeMs: (map['response_time'] as num).toInt(),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
