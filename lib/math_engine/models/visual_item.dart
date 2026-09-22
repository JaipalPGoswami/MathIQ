enum VisualType {
  apple('🍎', 'Apples'),
  star('⭐', 'Stars'),
  balloon('🎈', 'Balloons'),
  flower('🌸', 'Flowers'),
  cookie('🍪', 'Cookies'),
  car('🚗', 'Toy Cars'),
  pizza('🍕', 'Pizza Slices'),
  shape('🔷', 'Shapes'),
  clock('⏰', 'Clock Face'),
  coin('🪙', 'Coins');

  final String emoji;
  final String label;
  const VisualType(this.emoji, this.label);
}

class VisualData {
  final VisualType type;
  final int countA;
  final int countB;
  final String? operation;
  final Map<String, dynamic> extraData;

  const VisualData({
    required this.type,
    required this.countA,
    this.countB = 0,
    this.operation,
    this.extraData = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'count_a': countA,
      'count_b': countB,
      'operation': operation,
      'extra_data': extraData,
    };
  }

  factory VisualData.fromMap(Map<String, dynamic> map) {
    return VisualData(
      type: VisualType.values.firstWhere(
        (v) => v.name == map['type'],
        orElse: () => VisualType.apple,
      ),
      countA: (map['count_a'] as num).toInt(),
      countB: (map['count_b'] as num?)?.toInt() ?? 0,
      operation: map['operation'] as String?,
      extraData: (map['extra_data'] as Map<String, dynamic>?) ?? {},
    );
  }
}
