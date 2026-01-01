import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        
        print('Notification tapped: ${response.payload}');
      },
    );

    
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();
  }

  
  Future<void> scheduleTaskNotification({
    required String id,
    required String title,
    required String description,
    required DateTime scheduledDate,
  }) async {
  
    await cancelNotification(id);

    if (scheduledDate.isBefore(DateTime.now())) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      channelDescription: 'Notifications for upcoming tasks',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id.hashCode, 
      '⏰ Task Reminder: $title',
      description.isEmpty ? 'Your task is due!' : description,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: id,
    );

    print('✅ Scheduled notification for task: $title at $scheduledDate');
  }

  
  Future<void> scheduleTaskReminder({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    Duration reminderBefore = const Duration(hours: 1),
  }) async {
    final reminderTime = dueDate.subtract(reminderBefore);

    if (reminderTime.isBefore(DateTime.now())) {
      return;
    }

    await scheduleTaskNotification(
      id: '${id}_reminder',
      title: title,
      description: description,
      scheduledDate: reminderTime,
    );
  }

  Future<void> cancelNotification(String taskId) async {
    await _notifications.cancel(taskId.hashCode);
    await _notifications.cancel('${taskId}_reminder'.hashCode);
  }

 
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }


  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'instant_notifications',
      'Instant Notifications',
      channelDescription: 'Immediate task notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
