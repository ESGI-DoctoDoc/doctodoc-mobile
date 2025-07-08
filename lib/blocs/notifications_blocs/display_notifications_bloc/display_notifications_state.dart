part of 'display_notifications_bloc.dart';

enum DisplayNotificationsStatus { initial, loading, success, error }

class DisplayNotificationsState {
  final DisplayNotificationsStatus status;
  final List<Notification> notifications;
  final AppException? exception;

  DisplayNotificationsState({
    this.status = DisplayNotificationsStatus.initial,
    this.notifications = const [],
    this.exception,
  });

  DisplayNotificationsState copyWith({
    DisplayNotificationsStatus? status,
    List<Notification>? notifications,
    AppException? exception,
  }) {
    return DisplayNotificationsState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }
}
