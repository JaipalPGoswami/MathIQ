class AppSettings {
  final String id;
  final String studentId;
  final int dailyGoal;
  final bool soundEnabled;
  final bool voiceEnabled;
  final String difficultyMode; // adaptive, easy, medium, hard
  final String language;
  final String parentPin;
  final int screenTimeLimitMinutes;
  final bool aiAccessEnabled;

  AppSettings({
    required this.id,
    required this.studentId,
    this.dailyGoal = 50,
    this.soundEnabled = true,
    this.voiceEnabled = true,
    this.difficultyMode = 'adaptive',
    this.language = 'en',
    this.parentPin = '1234',
    this.screenTimeLimitMinutes = 30,
    this.aiAccessEnabled = true,
  });

  AppSettings copyWith({
    int? dailyGoal,
    bool? soundEnabled,
    bool? voiceEnabled,
    String? difficultyMode,
    String? language,
    String? parentPin,
    int? screenTimeLimitMinutes,
    bool? aiAccessEnabled,
  }) {
    return AppSettings(
      id: id,
      studentId: studentId,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      difficultyMode: difficultyMode ?? this.difficultyMode,
      language: language ?? this.language,
      parentPin: parentPin ?? this.parentPin,
      screenTimeLimitMinutes: screenTimeLimitMinutes ?? this.screenTimeLimitMinutes,
      aiAccessEnabled: aiAccessEnabled ?? this.aiAccessEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'daily_goal': dailyGoal,
      'sound_enabled': soundEnabled ? 1 : 0,
      'voice_enabled': voiceEnabled ? 1 : 0,
      'difficulty_mode': difficultyMode,
      'language': language,
      'parent_pin': parentPin,
      'screen_time_limit_minutes': screenTimeLimitMinutes,
      'ai_access_enabled': aiAccessEnabled ? 1 : 0,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      id: map['id'] as String,
      studentId: map['student_id'] as String,
      dailyGoal: (map['daily_goal'] as num?)?.toInt() ?? 50,
      soundEnabled: (map['sound_enabled'] as int?) == 1,
      voiceEnabled: (map['voice_enabled'] as int?) == 1,
      difficultyMode: (map['difficulty_mode'] as String?) ?? 'adaptive',
      language: (map['language'] as String?) ?? 'en',
      parentPin: (map['parent_pin'] as String?) ?? '1234',
      screenTimeLimitMinutes: (map['screen_time_limit_minutes'] as num?)?.toInt() ?? 30,
      aiAccessEnabled: ((map['ai_access_enabled'] as int?) ?? 1) == 1,
    );
  }
}
