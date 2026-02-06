/// Exception thrown when LaravelNotifyFcm is not initialized.
class LaravelNotifyFcmNotInitializedException implements Exception {
  final String message;

  LaravelNotifyFcmNotInitializedException(this.message);

  @override
  String toString() => 'LaravelNotifyFcmNotInitializedException: $message';
}
