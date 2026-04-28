// lib/core/services/background_task_service.dart
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tier_birthday/core/models/friend_model.dart';
import 'package:tier_birthday/core/repositoies/friends_repository.dart';
import 'package:tier_birthday/core/services/database_service.dart';
import 'package:tier_birthday/utils/result.dart';
import 'package:workmanager/workmanager.dart';
import 'package:background_fetch/background_fetch.dart';
import 'local_notification_service.dart';

//task name
const String birthdayCheckTask = 'check_birthday_task';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == birthdayCheckTask) {
      await _checkAndNotifyBirthdays();
    }
    return true;
  });
}

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessEvent task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;

  if (isTimeout) {
    BackgroundFetch.finish(taskId);
    return;
  }

  try {
    await _checkAndNotifyBirthdays();
  } finally {
    BackgroundFetch.finish(taskId);
  }
}

Future<void> _checkAndNotifyBirthdays() async {
  // 1. Initialize services
  final notificationService = LocalNotificationService();
  final databaseService = DatabaseService(databaseFactory: databaseFactory);

  // 2. Create Repository
  final friendsRepository = FriendsRepository(databaseService: databaseService);

  //3. Get friends from Repository
  final result = await friendsRepository.fetchFriends();

  //4.Handle the result
  switch (result) {
    case Error(:final error):
      debugPrint('Error fetching friends: $error');
      await databaseService.close();
      return;
    case Ok(:final value):
      final friends = value;
      final today = DateTime.now();

      for (Friend friend in friends) {
        if (friend.birthday.month == today.month &&
            friend.birthday.day == today.day) {
          final age = today.year - friend.birthday.year;
          await notificationService.sendBirthdayNotification(
            id: friend.id,
            friendName: '${friend.firstName}, ${friend.lastName}',
            friendAge: age,
          );
        }
      }

      await databaseService.close();
  }
}

class BackgroundTaskService {
  //Delete later
  static Future<void> debugBirthdayCheck() async {
    await _checkAndNotifyBirthdays();
  }

  // Initialize WorkManager (Android)
  static Future<void> initializeWorkManager() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  // Schedule daily birthday check (Android)
  static Future<void> schedulePeriodicBirthdayCheck() async {
    await Workmanager().registerPeriodicTask(
      birthdayCheckTask,
      birthdayCheckTask,
      frequency: Duration(days: 1),
      initialDelay: _calculateDelayToMorning(),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: Duration(minutes: 15),
    );
  }

  // Schedule daily birthday check (iOS)
  static Future<void> initializeBackgroundFetch() async {
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 960, // ~16 minutes, iOS minimum
        startOnBoot: true,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      //Handle on fetch
      backgroundFetchHeadlessTask,
      //Handle on timeout
      _backgroundFetchTimeout,
    );

    await BackgroundFetch.start();
  }

  @pragma('vm:entry-point')
  static void _backgroundFetchTimeout(String taskId) {
    BackgroundFetch.finish(taskId);
  }

  // Calculate delay until next morning (e.g., 8 AM)
  static Duration _calculateDelayToMorning() {
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));
    final morningTime = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      8,
    );
    return morningTime.difference(now);
  }

  // Cancel scheduled tasks
  static Future<void> cancelBirthdayCheck() async {
    await Workmanager().cancelByTag(birthdayCheckTask);
  }
}
