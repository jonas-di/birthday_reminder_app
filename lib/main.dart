import 'package:flutter/material.dart';
import 'package:tier_birthday/core/theme/theme_data.dart';
import 'package:tier_birthday/screens/home/UI/home_screen.dart';

void main() async {
  //initialize Services
  /*late DatabaseService databaseService;
  if (kIsWeb || Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    throw UnsupportedError('Platform is not supported');
  } else {
    debugPrint('App launched on Mobile');
    databaseService = DatabaseService(databaseFactory: databaseFactory);
  }*/

  WidgetsFlutterBinding.ensureInitialized();
  /*
  // Initialize notification service
  
  final notificationService = LocalNotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();
  

  // Initialize background tasks
  await BackgroundTaskService.initializeWorkManager();
  await BackgroundTaskService.schedulePeriodicBirthdayCheck();

  // iOS only
  if (Platform.isIOS) {
    await BackgroundTaskService.initializeBackgroundFetch();
  }*/

  runApp(MaterialApp(theme: primaryTheme, home: HomeScreen()));
}
