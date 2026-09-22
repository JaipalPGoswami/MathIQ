import '../../data/models/topic.dart';
import '../../data/models/mastery.dart';

class RecommendationItem {
  final Topic topic;
  final String reason;
  final String actionTitle;
  final String icon;

  const RecommendationItem({
    required this.topic,
    required this.reason,
    required this.actionTitle,
    required this.icon,
  });
}

class RecommendationEngine {
  static RecommendationItem getDailyRecommendation({
    required List<Topic> gradeTopics,
    required List<TopicMastery> masteries,
  }) {
    if (gradeTopics.isEmpty) {
      throw Exception('No topics available for grade');
    }

    // 1. Identify weak topics (accuracy < 60% with attempts > 0)
    for (final m in masteries) {
      if (m.accuracy < 0.60 && m.attempts >= 2) {
        try {
          final weakTopic = gradeTopics.firstWhere((t) => t.id == m.topicId);
          return RecommendationItem(
            topic: weakTopic,
            reason: 'Let us practice ${weakTopic.name} together to grow stronger! 🌟',
            actionTitle: 'Practice 5 mins',
            icon: '💪',
          );
        } catch (_) {}
      }
    }

    // 2. Identify unattempted topics
    final attemptedIds = masteries.map((m) => m.topicId).toSet();
    for (final t in gradeTopics) {
      if (!attemptedIds.contains(t.id)) {
        return RecommendationItem(
          topic: t,
          reason: 'Brand new adventure: Discover ${t.name}! 🚀',
          actionTitle: 'Start Learning',
          icon: '✨',
        );
      }
    }

    // 3. Periodic refresh of mastered topic
    final favorite = gradeTopics.first;
    return RecommendationItem(
      topic: favorite,
      reason: 'Ready for a quick challenge in ${favorite.name}? 🏆',
      actionTitle: 'Take Quick Quiz',
      icon: '🎯',
    );
  }
}
