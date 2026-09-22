class Skill {
  final String id;
  final String topicId;
  final String name;
  final String description;
  final String difficulty;

  const Skill({
    required this.id,
    required this.topicId,
    required this.name,
    required this.description,
    this.difficulty = 'medium',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic_id': topicId,
      'name': name,
      'description': description,
      'difficulty': difficulty,
    };
  }

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      id: map['id'] as String,
      topicId: map['topic_id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      difficulty: (map['difficulty'] as String?) ?? 'medium',
    );
  }
}
