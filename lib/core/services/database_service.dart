import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tier_birthday/core/models/friend_model.dart';
import 'package:tier_birthday/utils/result.dart';

class DatabaseService {
  //table and column names
  final String _friendsTableName = 'friends';
  final String _friendsIdColumnName = '_id';
  final String _friendsFirstNameColumnName = 'firstName';
  final String _friendsLastNameColumnName = 'lastName';
  final String _friendsBirthYearColumnName = 'birthYear';
  final String _friendsBirthMonthColumnName = 'birthMonth';
  final String _friendsBirthDayColumnName = 'birthDay';

  DatabaseService({required this.databaseFactory});

  final DatabaseFactory databaseFactory;

  Database? _db;

  bool isOpen() => _db != null;

  Future<void> open() async {
    _db = await databaseFactory.openDatabase(
      join(await databaseFactory.getDatabasesPath(), 'master_db.db'),
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) {
          db.execute('''
        CREATE TABLE $_friendsTableName(
          $_friendsIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
          $_friendsFirstNameColumnName TEXT NOT NULL,
          $_friendsLastNameColumnName TEXT NOT NULL,
          $_friendsBirthYearColumnName INTEGER NOT NULL,
          $_friendsBirthMonthColumnName INTEGER NOT NULL,
          $_friendsBirthDayColumnName INTEGER NOT NULL)
      ''');
        },
      ),
    );
  }

  Future<Result<List<Friend>>> getAll() async {
    try {
      final entries = await _db!.query(
        _friendsTableName,
        columns: [
          _friendsIdColumnName,
          _friendsFirstNameColumnName,
          _friendsLastNameColumnName,
          _friendsBirthYearColumnName,
          _friendsBirthMonthColumnName,
          _friendsBirthDayColumnName,
        ],
      );
      final list = entries
          .map(
            (element) => Friend(
              id: element[_friendsIdColumnName] as int,
              firstName: element[_friendsFirstNameColumnName] as String,
              lastName: element[_friendsLastNameColumnName] as String,
              birthday: DateTime(
                element[_friendsBirthYearColumnName] as int,
                element[_friendsBirthMonthColumnName] as int,
                element[_friendsBirthDayColumnName] as int,
              ),
            ),
          )
          .toList();
      return Result.ok(list);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Friend>> insert(Map<String, String> friend) async {
    try {
      final birthday = DateTime(
        int.parse(friend['birthday']!.substring(0, 4)),
        int.parse(friend['birthday']!.substring(5, 7)),
        int.parse(friend['birthday']!.substring(8, 10)),
      );
      final id = await _db!.insert(_friendsTableName, {
        _friendsFirstNameColumnName: friend['firstName'],
        _friendsLastNameColumnName: friend['lastName'],
        _friendsBirthYearColumnName: birthday.year,
        _friendsBirthMonthColumnName: birthday.month,
        _friendsBirthDayColumnName: birthday.day,
      });
      return Result.ok(
        Friend(
          id: id,
          firstName: friend['firstName']!,
          lastName: friend['lastName']!,
          birthday: birthday,
        ),
      );
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> delete(int id) async {
    try {
      final rowsDeleted = await _db!.delete(
        _friendsTableName,
        where: '$_friendsIdColumnName = ?',
        whereArgs: [id],
      );
      if (rowsDeleted == 0) {
        return Result.error(Exception('No friend found with id $id'));
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> close() async {
    await _db!.close();
    _db = null;
  }
}
