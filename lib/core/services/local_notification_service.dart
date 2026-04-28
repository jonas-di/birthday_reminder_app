import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  // Create a singleton instance
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  factory LocalNotificationService() {
    return _instance;
  }

  LocalNotificationService._internal();

  // The plugin instance
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  Future<void> initialize() async {
    // Android settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // Combine settings
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize the plugin
    await _plugin.initialize(settings: initSettings);
  }

  // Request permissions (especially important for Android)
  Future<bool?> requestPermissions() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    // Request Android permissions
    await androidPlugin?.requestNotificationsPermission();

    // Request iOS permissions
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);

    return true;
  }

  // Send a test notification
  Future<void> sendTestNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'birthday_channel', // Channel ID
          'Birthday Notifications', // Channel name
          channelDescription: 'Notifications for friend birthdays',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: 0, // Notification ID
      title: 'Birthday Reminder', // Title
      body: 'This is a test notification!', // Body
      notificationDetails: details,
    );
  }

  // Send a birthday notification for a specific friend
  Future<void> sendBirthdayNotification({
    required int id,
    required String friendName,
    required int friendAge,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'birthday_channel',
          'Birthday Notifications',
          channelDescription: 'Notifications for friend birthdays',
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: id,
      title: 'Birthday Today! 🎉',
      body: '$friendName is getting $friendAge years old!',
      notificationDetails: details,
    );
  }
}
