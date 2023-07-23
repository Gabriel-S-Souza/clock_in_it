import './notification_stub.dart'
    if (dart.library.html) './notification_web.dart'
    if (dart.library.io) './notification_mobile.dart';

import 'notification_base.dart';

class NotificationServiceImp implements NotificationServiceBase {
  final NotificationServiceBase _notificationServiceBase = NotificationService();

  static final NotificationServiceImp I = NotificationServiceImp._internal();

  factory NotificationServiceImp() => I;

  NotificationServiceImp._internal();

  @override
  Future<void> initialize() async {
    await _notificationServiceBase.initialize();
  }

  @override
  void activatePeriodicNotification() {
    _notificationServiceBase.activatePeriodicNotification();
  }

  @override
  void cancelPeriodicNotification() {
    _notificationServiceBase.cancelPeriodicNotification();
  }

  @override
  Future<void> show(int id, String title, [String? body]) async {
    await _notificationServiceBase.show(id, title, body);
  }
}
