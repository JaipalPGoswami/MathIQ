enum DifficultyLevel {
  easy('Easy', 1),
  medium('Medium', 2),
  hard('Hard', 3);

  final String label;
  final int levelValue;
  const DifficultyLevel(this.label, this.levelValue);

  static DifficultyLevel fromLevel(int val) {
    if (val <= 1) return DifficultyLevel.easy;
    if (val == 2) return DifficultyLevel.medium;
    return DifficultyLevel.hard;
  }
}
