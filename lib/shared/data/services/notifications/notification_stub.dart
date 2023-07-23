import 'notification_base.dart';

class NotificationService implements NotificationServiceBase {
  @override
  Future<void> initialize() {
    throw UnimplementedError();
  }

  @override
  void activatePeriodicNotification() {
    throw UnimplementedError();
  }

  @override
  void cancelPeriodicNotification() {
    throw UnimplementedError();
  }

  @override
  Future<void> show(int id, String title, [String? body]) async {
    throw UnimplementedError();
  }
}
