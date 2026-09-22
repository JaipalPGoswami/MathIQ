class ChildSafetyFilter {
  // PII Patterns to block
  static final RegExp _emailRegex = RegExp(r'[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+');
  static final RegExp _phoneRegex = RegExp(r'(\+?\d{1,3}[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}');
  static final List<String> _inappropriateKeywords = [
    'password', 'address', 'where do you live', 'phone number', 'credit card',
    'hate', 'kill', 'gun', 'weapon', 'die', 'stupid', 'ugly', 'dumb'
  ];

  static bool isInputSafe(String input) {
    final lower = input.toLowerCase();

    // Check PII
    if (_emailRegex.hasMatch(input)) return false;
    if (_phoneRegex.hasMatch(input)) return false;

    // Check prohibited words
    for (final kw in _inappropriateKeywords) {
      if (lower.contains(kw)) return false;
    }

    return true;
  }

  static String sanitizeResponse(String response) {
    // Ensure no phone/email in response
    var safe = response.replaceAll(_emailRegex, '[protected]');
    safe = safe.replaceAll(_phoneRegex, '[protected]');
    return safe;
  }

  static String getSafetyRedirectMessage() {
    return 'I am your friendly Math Tutor! 🌟 Let us focus on fun numbers, shapes, and math adventures. What would you like to solve next?';
  }
}
