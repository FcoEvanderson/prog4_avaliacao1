import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
    FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings = 
      AndroidInitializationSettings('app_icon');
    
    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'task_channel_id',
      'Task Notifications',
      channelDescription: 'Canal para notificações com prazo próximo ou expirado',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false
    );
    const NotificationDetails platformDetails = 
      NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, 
      title, 
      body, 
      platformDetails
    );
  }
}