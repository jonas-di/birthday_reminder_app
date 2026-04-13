import 'package:flutter/widgets.dart';
import 'package:tier_birthday/core/models/friend_model.dart';
import 'package:tier_birthday/utils/command.dart';
import 'package:tier_birthday/utils/result.dart';
import 'package:tier_birthday/core/repositoies/friends_repository.dart';

class HomeViewmodel extends ChangeNotifier {
  final FriendsRepository _friendsRepository;
  HomeViewmodel({required FriendsRepository friendsRepository})
    : _friendsRepository = friendsRepository {
    load = Command0<void>(_load)..execute();
    addFriend = Command1<void, Map<String, String>>(_addFriend);
    removeFriend = Command1<void, int>(_removeFriend);
  }

  late Command0<void> load;

  late Command1<void, Map<String, String>> addFriend;

  late Command1<void, int> removeFriend;

  List<Friend> _friends = [];
  List<Friend> get friendsList => _friends;

  Future<Result<void>> _load() async {
    try {
      final result = await _friendsRepository.fetchFriends();
      switch (result) {
        case Ok<List<Friend>>():
          _friends = result.value;
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _addFriend(Map<String, String> friend) async {
    try {
      debugPrint('VM: Try add friend');
      final result = await _friendsRepository.createFriend(friend);
      switch (result) {
        case Ok<Friend>():
          _friends.add(result.value);
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _removeFriend(int id) async {
    try {
      final result = await _friendsRepository.deleteFriend(id);
      switch (result) {
        case Ok<void>():
          _friends.removeWhere((friend) => friend.id == id);
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }
}
