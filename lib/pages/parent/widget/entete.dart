import 'package:flutter/material.dart';

import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';

class Entete extends StatelessWidget {
  const Entete({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: SizeConfig.getProportionateWidth(48),
              height: SizeConfig.getProportionateWidth(48),

              decoration: BoxDecoration(
                color: context.primarySoft,
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.person,
                color: Colors.black45,
                size: SizeConfig.getProportionateWidth(25),
              ),
            ),

            SizedBox(width: SizeConfig.getProportionateWidth(12)),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour 👋',

                  style: context.titleTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: SizeConfig.getProportionateHeight(2)),

                Text(
                  'Heureux de vous retrouver',

                  style: context.normalTextStyle.copyWith(
                    fontSize: 13,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {},

              icon: Icon(
                Icons.notifications_none_outlined,
                size: SizeConfig.getProportionateWidth(28),
                color: context.textDark,
              ),
            ),

            Positioned(
              right: SizeConfig.getProportionateWidth(5),
              top: SizeConfig.getProportionateHeight(3),

              child: Container(
                padding: EdgeInsets.all(SizeConfig.getProportionateWidth(4)),

                decoration: BoxDecoration(
                  color: context.badgeRed,
                  shape: BoxShape.circle,
                ),

                child: Text(
                  '10',

                  style: context.normalTextStyle.copyWith(
                    color: context.textInverse,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
