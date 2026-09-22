class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int xpReward;
  final String conditionType;
  final int conditionValue;
  final bool isUnlocked;
  final DateTime? earnedAt;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.conditionType,
    required this.conditionValue,
    this.isUnlocked = false,
    this.earnedAt,
  });

  Achievement copyWith({
    bool? isUnlocked,
    DateTime? earnedAt,
  }) {
    return Achievement(
      id: id,
      name: name,
      description: description,
      icon: icon,
      xpReward: xpReward,
      conditionType: conditionType,
      conditionValue: conditionValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }
}
