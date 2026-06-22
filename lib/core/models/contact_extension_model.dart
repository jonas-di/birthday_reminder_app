enum Tier { S, A, B, C, D }

class ContactExtension {
  final String flutterContactsId;
  final Tier tier;

  ContactExtension({required this.flutterContactsId, required this.tier});
}
