import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tier_birthday/core/repositoies/friends_repository.dart';
import 'package:tier_birthday/core/services/database_service.dart';
import 'package:tier_birthday/core/services/local_notification_service.dart';
import 'package:tier_birthday/screens/home/home_view.dart';
import 'package:tier_birthday/screens/home/home_viewmodel.dart';

void main() async {
  //initialize Services
  late DatabaseService databaseService;
  if (kIsWeb || Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    throw UnsupportedError('Platform is not supported');
  } else {
    debugPrint('App launched on Mobile');
    databaseService = DatabaseService(databaseFactory: databaseFactory);
  }

  //initialize Reposities
  FriendsRepository friendsRepository = FriendsRepository(
    databaseService: databaseService,
  );

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  final notificationService = LocalNotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              HomeViewmodel(friendsRepository: friendsRepository),
        ),
      ],
      child: MaterialApp(home: HomeView()),
    ),
  );
}
