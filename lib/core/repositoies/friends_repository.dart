import 'package:flutter/foundation.dart';
import 'package:tier_birthday/core/models/friend_model.dart';
import 'package:tier_birthday/utils/result.dart';
import 'package:tier_birthday/core/services/database_service.dart';

class FriendsRepository {
  FriendsRepository({required DatabaseService databaseService})
    : _database = databaseService;

  final DatabaseService _database;

  Future<Result<List<Friend>>> fetchFriends() async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.getAll();
  }

  Future<Result<Friend>> createFriend(Map<String, String> friend) async {
    if (!_database.isOpen()) {
      debugPrint('Repo: Try to open Database');
      await _database.open();
    }
    debugPrint('Repo: Try to add friend');
    return await _database.insert(friend);
  }

  Future<Result<void>> deleteFriend(int id) async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.delete(id);
  }
}
