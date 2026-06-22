import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:tier_birthday/utils/result.dart';

class FlutterContactsService {
  bool _isPermission = false;
  // Singleton instance
  static final FlutterContactsService _instance = FlutterContactsService._();

  // Private constructor - requests permission when initialized
  FlutterContactsService._();

  // Factory constructor to return singleton instance
  factory FlutterContactsService() {
    return _instance;
  }

  //Caches read write  permission for phone contacts.
  //Asks for permission, if it is not already granted.
  Future<bool> checkPermission() async {
    if (!_isPermission) {
      _isPermission = await requestPermission();
      debugPrint('Permission Status is $_isPermission');
      return _isPermission;
    }
    debugPrint('has_permission');
    return _isPermission;
  }

  // Requests read/write permission for contacts.
  Future<bool> requestPermission() async {
    final status = await FlutterContacts.permissions.request(
      PermissionType.readWrite,
    );
    return status == PermissionStatus.granted ||
        status == PermissionStatus.limited;
  }

  Future<Result<List<Contact>>> getAll() async {
    try {
      if (await checkPermission()) {
        final List<Contact> contacts = await FlutterContacts.getAll(
          properties: ContactProperties.all,
        );
        debugPrint('Contacts loaded from Phone: ${contacts.length}');
        return Result.ok(contacts);
      }
      return Result.error(
        Exception('No permission to contacts has been granted'),
      );
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
