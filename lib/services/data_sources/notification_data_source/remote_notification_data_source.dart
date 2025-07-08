import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/notification.dart';

import 'notification_data_source.dart';

class RemoteNotificationDataSource implements NotificationDataSource {
  final Dio dio;

  RemoteNotificationDataSource({
    required this.dio,
  });

  @override
  Future<List<Notification>> get() async {
    final response = await dio.get("/patients/notifications");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => Notification.fromJson(jsonElement)).toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await dio.patch("/patients/notifications/$id");
  }
}
