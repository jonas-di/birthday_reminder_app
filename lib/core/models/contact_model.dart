import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/models/contact/contact.dart'
    as flutter_contacts;
import 'package:tier_birthday/core/models/contact_extension_model.dart';

class Contact {
  //This [Contact] Class Contains 2 Subclasses.
  //
  // An other [Contact] class coming  from the Flutter Contacts Package.
  // The Contacts provided by this Package are the local saved contacts the user
  // has saved on this phone.
  final flutter_contacts.Contact _flutterContact;

  //And an [ContactExtension] Class. This Class is a Extension to the
  //Flutter Contacts [Contact] and does not Exist on his own.
  //It contains data this App needs to function, that is not part of the Phones Contact
  //but always linked to it.
  final ContactExtension _extension;

  //constructor
  Contact({
    required flutter_contacts.Contact flutterContact,
    required ContactExtension extension,
  }) : _flutterContact = flutterContact,
       _extension = extension;

  String? get name {
    if (_flutterContact.displayName != null) {
      return _flutterContact.displayName;
    } else {
      return _flutterContact.id;
    }
  }

  Event? get birthday {
    return _flutterContact.events.firstWhere(
      (event) => event.label.label == EventLabel.birthday,
    );
  }

  String get linkedID => _extension.flutterContactsId;

  Photo? get profilePicture => _flutterContact.photo;

  Tier get tier => _extension.tier;
}
