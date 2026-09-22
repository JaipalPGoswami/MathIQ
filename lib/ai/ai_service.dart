abstract class AiService {
  Future<String> explainQuestion({
    required String question,
    required String correctAnswer,
    required String grade,
  });

  Future<String> generateStory({
    required String topic,
    required String grade,
  });

  Future<String> generateHint({
    required String question,
    required String grade,
  });

  Future<String> tutorResponse({
    required String userMessage,
    required List<Map<String, String>> chatHistory,
    required String grade,
    required String studentName,
  });
}
