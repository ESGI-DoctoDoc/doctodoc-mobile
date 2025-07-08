part of 'display_notifications_bloc.dart';

@immutable
sealed class DisplayNotificationsEvent {}

class OnGetNotifications extends DisplayNotificationsEvent {}

class OnSetReadNotification extends DisplayNotificationsEvent {
  final String id;

  OnSetReadNotification({
    required this.id,
  });
}
