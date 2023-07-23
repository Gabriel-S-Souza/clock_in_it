abstract class NotificationServiceBase {
  Future<void> initialize();

  Future<void> show(
    int id,
    String title, [
    String? body,
  ]);

  void activatePeriodicNotification();

  void cancelPeriodicNotification();
}
