import 'package:flutter/material.dart';
import 'package:tier_birthday/core/models/contact_model.dart';
import 'package:tier_birthday/core/theme/colors.dart';
import 'package:tier_birthday/core/theme/styled_text.dart';

class ContactListTile extends StatelessWidget {
  final Contact contact;
  const ContactListTile({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        tileColor: AppColor.primaryBg,

        leading: CircleAvatar(
          foregroundImage: contact.profilePicture?.thumbnail != null
              ? MemoryImage(contact.profilePicture!.thumbnail!)
              : null,
          backgroundColor: AppColor.secondary,
          child: StyledText(
            contact.name?[0].toUpperCase() ?? '',
            color: Colors.white,
          ),
        ),
        title: StyledText(contact.name ?? ''),
        subtitle: MonoFontText(
          '${contact.birthday!.day.toString()}.${contact.birthday!.month.toString()}.${contact.birthday!.year.toString()}',
          fontSize: 16,
        ),
      ),
    );
  }
}
