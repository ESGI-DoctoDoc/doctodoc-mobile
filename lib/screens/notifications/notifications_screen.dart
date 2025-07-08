import 'package:doctodoc_mobile/blocs/notifications_blocs/display_notifications_bloc/display_notifications_bloc.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/notification.dart';

class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DisplayNotificationsBloc>().add(OnGetNotifications());
  }

  void _removeNotification(String id) {
    context.read<DisplayNotificationsBloc>().add(OnSetReadNotification(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'),
          ),
          body: BlocBuilder<DisplayNotificationsBloc, DisplayNotificationsState>(
            builder: (context, state) {
              return switch (state.status) {
                DisplayNotificationsStatus.initial ||
                DisplayNotificationsStatus.loading =>
                  const SizedBox.shrink(),
                DisplayNotificationsStatus.success => _buildSuccess(state.notifications),
                DisplayNotificationsStatus.error => _buildError(),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess(List<Notification> notifications) {
    if (notifications.isEmpty) {
      return const Center(child: Text('Aucune notification.'));
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return ListTile(
              title: Text(notification.title),
              subtitle: Text(notification.content),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeNotification(notification.id),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }
}
