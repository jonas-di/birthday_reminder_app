import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as flutter_contacts;
import 'package:flutter_contacts/models/labels/event_label.dart';
import 'package:tier_birthday/core/models/contact_extension_model.dart';

import 'package:tier_birthday/core/models/contact_model.dart';
import 'package:tier_birthday/core/services/flutter_contacts_service.dart';
import 'package:tier_birthday/utils/result.dart';

class ContactRepository {
  FlutterContactsService flutterContactsService = FlutterContactsService();
  static final _instance = ContactRepository._();

  ContactRepository._();

  factory ContactRepository() {
    return _instance;
  }

  Future<Result<List<Contact>>> fetchAllContacts() async {
    try {
      Result<List<flutter_contacts.Contact>> resultFlutterContacts =
          await flutterContactsService.getAll();
      switch (resultFlutterContacts) {
        case Ok ok:
          final List<flutter_contacts.Contact> flutterContacts = ok.value;
          debugPrint(
            'Contacts handed to Repository: ${flutterContacts.length}',
          );
          final List<Contact> contacts = [];
          for (flutter_contacts.Contact flutterContact in flutterContacts) {
            debugPrint(
              'Contact: ${flutterContact.displayName}, Events: ${flutterContact.events.length}',
            );
            for (var event in flutterContact.events) {
              debugPrint(
                'Event label: ${event.label}, Event label label: ${event.label.label}',
              );
            }
            if (flutterContact.events.isNotEmpty &&
                flutterContact.events.any(
                  (event) => event.label.label == EventLabel.birthday,
                )) {
              debugPrint('Found Contact with Birthday');
              contacts.add(
                Contact(
                  flutterContact: flutterContact,
                  extension: ContactExtension(
                    flutterContactsId: flutterContact.id!,
                  ),
                ),
              );
            }
          }
          debugPrint('Contacts with birthday found ${contacts.length}');
          return Result.ok(contacts);

        case Error error:
          return Result.error(error.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}

/*import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/models/contact/contact.dart' as flutter_contacts;
import 'package:tier_birthday/core/models/contact_extension_model.dart';
import 'package:tier_birthday/core/models/contact_model.dart';
import 'package:tier_birthday/core/services/flutter_contacts_service.dart';
import 'package:tier_birthday/utils/result.dart';
import 'package:tier_birthday/core/services/database_service.dart';

class ContactsRepository {
  ContactsRepository({required DatabaseService databaseService})
    : _database = databaseService;

  final DatabaseService _database;
  final FlutterContactsService _flutterContacts;

  Future<Result<List<flutter_contacts.Contact>>> fetchFriends() async {
    // 1. Fetch Contacts with Flutter Contacts
    Result<List<flutter_contacts.Contact>> flutterContactsResult = await _flutterContacts.getAllWithBirthday();

    // 2. Fetch ContactExtensions with Database Service
    if (!_database.isOpen()) {
      await _database.open();
    }j
    Result<List<ContactExtension>> contactExtensionResult = _database.getAll();

    // 3. Link Contact to ContactExtension
    if(flutterContactsResult is Ok && contactExtensionResult is Ok){
      flutter_contacts.Contact flutterContacts = flutterContactsResult.value;
    }

    // 4. Return
    
   
  }

  Future<Result<Contact>> createFriend(Map<String, String> friend) async {
    if (!_database.isOpen()) {
      debugPrint('Opening database ...');
      await _database.open();
      debugPrint('Opened Database');
    }
    return await _database.insert(friend);
  }

  Future<Result<void>> deleteFriend(int id) async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.delete(id);
  }
}
*/
