class Topic {
  final String id;
  final String name;
  final String description;
  final String gradeMin;
  final String gradeMax;
  final String category;
  final String icon;
  final int sortOrder;

  const Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.gradeMin,
    required this.gradeMax,
    required this.category,
    required this.icon,
    required this.sortOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'grade_min': gradeMin,
      'grade_max': gradeMax,
      'category': category,
      'icon': icon,
      'sort_order': sortOrder,
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      gradeMin: map['grade_min'] as String,
      gradeMax: map['grade_max'] as String,
      category: map['category'] as String,
      icon: map['icon'] as String,
      sortOrder: (map['sort_order'] as num).toInt(),
    );
  }
}
