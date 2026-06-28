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
      margin: EdgeInsets.symmetric(vertical: 4),

      child: Row(
        children: [
          //left part - picture
          SizedBox(
            height: 96,
            width: 96,
            child: contact.profilePicture?.thumbnail == null
                ? Container(
                    color: Color(0xffC3557A),
                    child: Center(
                      child: StyledText(
                        contact.name![0],
                        fontSize: 48,
                        color: AppColor.primaryBg,
                      ),
                    ),
                  )
                : Image.memory(
                    contact.profilePicture!.thumbnail!,
                    fit: BoxFit.fill,
                  ),
          ),

          //middle part - name, age, notification
          Expanded(
            child: Container(
              //style
              height: 96,
              padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
              color: color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StyledText('${contact.name}', fontSize: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      StyledText(
                        'Age: 21',
                        color: AppColor.textGray,
                        fontSize: 20,
                      ),
                      Expanded(child: SizedBox()),
                      NumberedIcon(number: 0, icon: Icons.card_giftcard),
                      SizedBox(width: 16),
                      NumberedIcon(number: 3, icon: Icons.notifications),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //right part
          Container(
            height: 96,
            padding: EdgeInsets.fromLTRB(8, 8, 16, 8),

            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StyledText(contact.birthday!.day.toString(), fontSize: 36),
                StyledText(monthsShort[contact.birthday!.month], fontSize: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NumberedIcon extends StatelessWidget {
  final int number;
  final IconData icon;

  const NumberedIcon({super.key, required this.number, required this.icon});

  @override
  Widget build(BuildContext context) {
    final Color color = number == 0 ? AppColor.textDisabled : AppColor.textGray;

    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StyledText(number.toString(), fontSize: 20, color: color),
          SizedBox(width: 4),
          Icon(icon, color: color, size: 24),
        ],
      ),
    );
  }
}
