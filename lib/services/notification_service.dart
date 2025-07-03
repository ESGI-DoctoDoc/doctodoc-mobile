import 'package:flutter/material.dart';
import 'package:doctodoc_mobile/screens/appointments/appointment_detail_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  initFCM() async {
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken != null) {
      print("FCM Token: $fcmToken");
    } else {
      print("Failed to get FCM token");
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked!");
      final data = message.data;
      if (data.containsKey('appointment_id')) {
        final appointmentId = data['appointment_id'];
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => AppointmentDetailScreen(appointmentId: appointmentId),
          ),
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title} - ${message.notification?.body}");
      // Handle the foreground message
      // You can show a dialog, snackbar, or update the UI
    });
  }
}