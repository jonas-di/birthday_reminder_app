import 'package:flutter/material.dart';
import 'package:tier_birthday/core/models/contact_extension_model.dart';
import 'package:tier_birthday/core/models/contact_model.dart';
import 'package:tier_birthday/core/theme/colors.dart';
import 'package:tier_birthday/core/theme/styled_text.dart';

class ContactListTile extends StatelessWidget {
  final Contact contact;
  const ContactListTile({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final color = (() {
      switch (contact.tier) {
        case Tier.S:
          return AppColor.sTier;
        case Tier.A:
          return AppColor.aTier;
        case Tier.B:
          return AppColor.bTier;
        case Tier.C:
          return AppColor.cTier;
        case Tier.D:
          return AppColor.dTier;
      }
    })();

    final List<String> monthsShort = const [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mai',
      'Jun',
      'Jul',
      'Aug',
      'Seb',
      'Oct',
      'Nov',
      'Dez',
    ];
    return Container(
      //style
      height: 100,
      width: double.maxFinite,

      padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: color,
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          //left part
          CircleAvatar(
            radius: 42,
            foregroundImage: contact.profilePicture?.thumbnail != null
                ? MemoryImage(contact.profilePicture!.thumbnail!)
                : null,

            backgroundColor: color,
            child: StyledText(contact.name![0], fontSize: 48),
          ),
          SizedBox(width: 8),

          //middle part
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledText('${contact.name}', fontSize: 24),
              Icon(Icons.notifications, size: 24, color: AppColor.textDisabled),
            ],
          ),
          Expanded(child: SizedBox()),

          //right part
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StyledText(contact.birthday!.day.toString(), fontSize: 36),
              StyledText(monthsShort[contact.birthday!.month], fontSize: 20),
            ],
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
