import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../data/repositories/student_repository.dart';
import '../../ai/gemini_ai_service.dart';
import '../../core/audio/tts_service.dart';

class AiTutorScreen extends StatefulWidget {
  const AiTutorScreen({super.key});

  @override
  State<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends State<AiTutorScreen> {
  final StudentRepository _studentRepo = StudentRepository();
  final GeminiAiService _aiService = GeminiAiService();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final List<String> _suggestedQuestions = [
    'What is 7 + 5? 🍎',
    'How do fractions work? 🍕',
    'Why is a triangle special? 🔺',
    'Teach me a fun trick! ✨',
  ];

  @override
  void initState() {
    super.initState();
    final s = _studentRepo.getCurrentStudent();
    final name = s?.name ?? 'friend';
    _messages.add({
      'sender': 'ai',
      'text': 'Hello $name! 🌟 I am your friendly Math Tutor. Ask me any math question or tap a suggestion below!',
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    final s = _studentRepo.getCurrentStudent();
    final grade = s?.grade ?? 'Grade 1';
    final name = s?.name ?? 'friend';

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isLoading = true;
      _textController.clear();
    });

    _scrollToBottom();

    final history = _messages.map((m) => {'role': m['sender']!, 'text': m['text']!}).toList();
    final reply = await _aiService.tutorResponse(
      userMessage: text,
      chatHistory: history,
      grade: grade,
      studentName: name,
    );

    if (!mounted) return;
    setState(() {
      _messages.add({'sender': 'ai', 'text': reply});
      _isLoading = false;
    });

    _scrollToBottom();
    TtsService().speak(reply);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Math Tutor 🤖'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppDimensions.p16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isAi = msg['sender'] == 'ai';

                  return Align(
                    alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      decoration: BoxDecoration(
                        color: isAi ? Colors.white : AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        border: isAi ? Border.all(color: AppColors.cardBorder, width: 1.5) : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg['text']!,
                            style: AppTypography.bodyLarge.copyWith(
                              color: isAi ? AppColors.textPrimary : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          if (isAi) ...[
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => TtsService().speak(msg['text']!),
                              child: const Icon(Icons.volume_up_rounded, size: 20, color: AppColors.primaryBlue),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('AI Tutor is thinking... 💭', style: TextStyle(color: AppColors.textSecondary)),
              ),

            // Quick Question Suggestion Chips
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestedQuestions.length,
                itemBuilder: (context, index) {
                  final q = _suggestedQuestions[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(q, style: AppTypography.titleMedium.copyWith(fontSize: 13)),
                      backgroundColor: AppColors.amberLight,
                      onPressed: () => _sendMessage(q),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Input Bar
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: AppTypography.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Ask a math question...',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: () => _sendMessage(_textController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
