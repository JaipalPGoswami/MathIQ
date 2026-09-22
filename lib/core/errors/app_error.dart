class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic cause;

  AppError(this.message, {this.code, this.cause});

  @override
  String toString() => message;

  String get friendlyChildMessage {
    if (message.contains('network') || message.contains('internet')) {
      return 'Looks like the internet is taking a nap! Let us keep practicing offline. 🌈';
    }
    return 'Oops, something went funny! Let us try again. 🎈';
  }
}
