import 'package:doctodoc_mobile/models/notification.dart';

abstract class NotificationDataSource {
  Future<List<Notification>> get();

  Future<void> markAsRead(String id);
}
