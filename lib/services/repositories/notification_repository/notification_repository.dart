import 'dart:async';

import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/notification.dart';
import 'package:doctodoc_mobile/services/data_sources/notification_data_source/notification_data_source.dart';

class NotificationRepository {
  final NotificationDataSource notificationDataSource;

  NotificationRepository({
    required this.notificationDataSource,
  });

  Future<List<Notification>> get() async {
    try {
      return await notificationDataSource.get();
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      return await notificationDataSource.markAsRead(id);
    } catch (error) {
      throw UnknownException();
    }
  }
}
