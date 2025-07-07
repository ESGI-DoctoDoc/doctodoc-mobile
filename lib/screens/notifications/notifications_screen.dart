import 'package:flutter/material.dart';

class Notification {
  final String title;
  final String? content;
  final DateTime createdAt;
  final bool isRead;

  const Notification({
    required this.title,
    this.content,
    required this.createdAt,
    this.isRead = false,
  });
}

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
  List<Notification> _notifications = [
    Notification(
      title: 'Rendez-vous confirmé',
      content: 'Votre rendez-vous du 10 juillet est confirmé.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Notification(
      title: 'Nouveau message',
      content: 'Dr. Dupont vous a envoyé un message.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    Notification(
      title: 'Rappel',
      content: 'Consultation prévue demain à 14h.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Notification(
      title: 'Rendez-vous confirmé',
      content: 'Votre rendez-vous du 10 juillet est confirmé.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Notification(
      title: 'Nouveau message',
      content: 'Dr. Dupont vous a envoyé un message.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    Notification(
      title: 'Rappel',
      content: 'Consultation prévue demain à 14h.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Notification(
      title: 'Rendez-vous confirmé',
      content: 'Votre rendez-vous du 10 juillet est confirmé.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Notification(
      title: 'Nouveau message',
      content: 'Dr. Dupont vous a envoyé un message.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    Notification(
      title: 'Rappel',
      content: 'Consultation prévue demain à 14h.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Notification(
      title: 'Rendez-vous confirmé',
      content: 'Votre rendez-vous du 10 juillet est confirmé.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Notification(
      title: 'Nouveau message',
      content: 'Dr. Dupont vous a envoyé un message.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    Notification(
      title: 'Rappel',
      content: 'Consultation prévue demain à 14h.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Notification(
      title: 'Rendez-vous confirmé',
      content: 'Votre rendez-vous du 10 juillet est confirmé.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Notification(
      title: 'Nouveau message',
      content: 'Dr. Dupont vous a envoyé un message.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    Notification(
      title: 'Rappel',
      content: 'Consultation prévue demain à 14h.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Notification(
      title: 'Rendez-vous confirmé',
      content: 'Votre rendez-vous du 10 juillet est confirmé.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Notification(
      title: 'Nouveau message',
      content: 'Dr. Dupont vous a envoyé un message.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    Notification(
      title: 'Rappel',
      content: 'Consultation prévue demain à 14h.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Notification(
      title: 'Rendez-vous confirmé',
      content: 'Votre rendez-vous du 10 juillet est confirmé.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Notification(
      title: 'Nouveau message',
      content: 'Dr. Dupont vous a envoyé un message.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    Notification(
      title: 'Rappel',
      content: 'Consultation prévue demain à 14h.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  void _removeNotification(int index) {
    //todo mélissa add
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
          body: _notifications.isEmpty
              ? const Center(child: Text('Aucune notification.'))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.separated(
                    itemCount: _notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final notif = _notifications[index];
                      return ListTile(
                        title: Text(notif.title),
                        subtitle: notif.content != null ? Text(notif.content!) : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeNotification(index),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
