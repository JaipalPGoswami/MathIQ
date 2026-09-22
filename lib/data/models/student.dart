import 'dart:convert';

class Student {
  final String id;
  final String name;
  final int age;
  final String grade;
  final String avatar;
  final String language;
  final int xp;
  final int streak;
  final int level;
  final DateTime createdAt;
  final DateTime updatedAt;

  Student({
    required this.id,
    required this.name,
    required this.age,
    required this.grade,
    required this.avatar,
    this.language = 'en',
    this.xp = 0,
    this.streak = 1,
    this.level = 1,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Student copyWith({
    String? name,
    int? age,
    String? grade,
    String? avatar,
    String? language,
    int? xp,
    int? streak,
    int? level,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      grade: grade ?? this.grade,
      avatar: avatar ?? this.avatar,
      language: language ?? this.language,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      level: level ?? this.level,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'grade': grade,
      'avatar': avatar,
      'language': language,
      'xp': xp,
      'streak': streak,
      'level': level,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      age: (map['age'] as num).toInt(),
      grade: map['grade'] as String,
      avatar: map['avatar'] as String,
      language: (map['language'] as String?) ?? 'en',
      xp: (map['xp'] as num?)?.toInt() ?? 0,
      streak: (map['streak'] as num?)?.toInt() ?? 1,
      level: (map['level'] as num?)?.toInt() ?? 1,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'] as String) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'] as String) : null,
    );
  }
}
