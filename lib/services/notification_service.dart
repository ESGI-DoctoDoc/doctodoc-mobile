import 'package:doctodoc_mobile/screens/appointments/appointment_detail_screen.dart';
import 'package:doctodoc_mobile/screens/care_tracking/care_tracking_detail_screen.dart';
import 'package:doctodoc_mobile/services/data_sources/local_auth_data_source/local_auth_data_source.dart';
import 'package:doctodoc_mobile/services/repositories/user_repository/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final LocalAuthDataSource localAuthDataSource;
  final UserRepository userRepository;

  NotificationService({
    required this.localAuthDataSource,
    required this.userRepository,
  });

  initFCM() async {
    await _firebaseMessaging.requestPermission();

    String? userTokenFcm = await localAuthDataSource.retrieveUserFcmToken();

    if (userTokenFcm == null) {
      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        print("Create new FCM Token: $fcmToken");
        try {
          await userRepository.saveFcmToken(fcmToken);
          await localAuthDataSource.saveFcmToken(fcmToken);
        } catch (error) {
          print("Failed to save FCM token");
        }
      } else {
        print("Failed to get FCM token");
      }
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

      if (data.containsKey('careTracking_id')) {
        final careTrackingId = data['careTracking_id'];
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => CareTrackingDetailScreen(careTrackingId: careTrackingId),
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
