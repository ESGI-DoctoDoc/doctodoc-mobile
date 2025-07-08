import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/models/notification.dart';
import 'package:doctodoc_mobile/services/repositories/notification_repository/notification_repository.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';

part 'display_notifications_event.dart';
part 'display_notifications_state.dart';

class DisplayNotificationsBloc extends Bloc<DisplayNotificationsEvent, DisplayNotificationsState> {
  final NotificationRepository notificationRepository;

  DisplayNotificationsBloc({
    required this.notificationRepository,
  }) : super(DisplayNotificationsState()) {
    on<OnGetNotifications>((event, emit) async {
      try {
        emit(state.copyWith(status: DisplayNotificationsStatus.loading));
        List<Notification> notifications = await notificationRepository.get();
        emit(state.copyWith(
            status: DisplayNotificationsStatus.success, notifications: notifications));
      } catch (error) {
        emit(state.copyWith(
            status: DisplayNotificationsStatus.error, exception: AppException.from(error)));
      }
    });

    on<OnSetReadNotification>((event, emit) async {
      try {
        await notificationRepository.markAsRead(event.id);
        List<Notification> notifications =
            state.notifications.where((notification) => notification.id != event.id).toList();
        emit(state.copyWith(
            status: DisplayNotificationsStatus.success, notifications: notifications));
      } catch (error) {
        emit(state.copyWith(
            status: DisplayNotificationsStatus.error, exception: AppException.from(error)));
      }
    });
  }
}
