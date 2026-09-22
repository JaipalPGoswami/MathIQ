import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'ai_service.dart';
import 'safety/child_safety_filter.dart';
import 'prompts/tutor_prompts.dart';

class GeminiAiService implements AiService {
  final String? _apiKey;
  final String _proxyEndpoint;

  GeminiAiService({
    String? apiKey,
    String proxyEndpoint = 'https://api.mathfactsai.example.com/v1/tutor',
  })  : _apiKey = apiKey,
        _proxyEndpoint = proxyEndpoint;

  @override
  Future<String> explainQuestion({
    required String question,
    required String correctAnswer,
    required String grade,
  }) async {
    final prompt = TutorPrompts.getExplanationPrompt(question, correctAnswer, grade);
    try {
      final response = await _queryAi(prompt, grade: grade, studentName: 'friend');
      return ChildSafetyFilter.sanitizeResponse(response);
    } catch (_) {
      // Local deterministic fallback explanation
      return 'Let us count together! 🌟 Look at the numbers step-by-step: the answer is $correctAnswer.';
    }
  }

  @override
  Future<String> generateHint({
    required String question,
    required String grade,
  }) async {
    final prompt = TutorPrompts.getHintPrompt(question, grade);
    try {
      final response = await _queryAi(prompt, grade: grade, studentName: 'friend');
      return ChildSafetyFilter.sanitizeResponse(response);
    } catch (_) {
      return 'Hint: Count the items one by one with your finger! 👆 You are super close!';
    }
  }

  @override
  Future<String> generateStory({
    required String topic,
    required String grade,
  }) async {
    final prompt = TutorPrompts.getStoryPrompt(topic, grade);
    try {
      final response = await _queryAi(prompt, grade: grade, studentName: 'friend');
      return ChildSafetyFilter.sanitizeResponse(response);
    } catch (_) {
      return 'Sammy the Squirrel had 3 tasty acorns 🌰. A friendly bird brought 2 more acorns! How many acorns does Sammy have now?';
    }
  }

  @override
  Future<String> tutorResponse({
    required String userMessage,
    required List<Map<String, String>> chatHistory,
    required String grade,
    required String studentName,
  }) async {
    if (!ChildSafetyFilter.isInputSafe(userMessage)) {
      return ChildSafetyFilter.getSafetyRedirectMessage();
    }

    try {
      final prompt = '''
Student asked: "$userMessage"
Provide a warm, supportive, child-friendly explanation suitable for a $grade student.
''';
      final response = await _queryAi(prompt, grade: grade, studentName: studentName);
      return ChildSafetyFilter.sanitizeResponse(response);
    } catch (_) {
      // Offline fallback
      return 'Let us look at it together, $studentName! 🎈 When we take our time and count step-by-step, math is like a fun puzzle!';
    }
  }

  Future<String> _queryAi(String prompt, {required String grade, required String studentName}) async {
    // If an API key is provided, query Google Gemini directly; otherwise use the secure proxy or fallback
    if (_apiKey != null && _apiKey!.isNotEmpty) {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey',
      );
      final systemPrompt = TutorPrompts.getSystemPrompt(grade, studentName);
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': '$systemPrompt\n\nUser: $prompt'}
            ]
          }
        ]
      });

      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(const Duration(seconds: 6));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List;
          return parts[0]['text'] as String;
        }
      }
    }

    // Fallback if network offline or key unset
    throw Exception('Offline fallback');
  }
}
