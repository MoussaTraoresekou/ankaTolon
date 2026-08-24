import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/models/jouets/jouet_models.dart';

class Jouetcart extends StatefulWidget {
  final JouetModel jouet;

  const Jouetcart({super.key, required this.jouet});

  @override
  State<Jouetcart> createState() => _JouetcartState();
}

class _JouetcartState extends State<Jouetcart> {
  bool estFavori = false;

  @override
  Widget build(BuildContext context) {
    final jouet = widget.jouet;

    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.jouetDetail.name, extra: jouet);
      },
      child: Container(
        width: SizeConfig.getProportionateWidth(160),
        margin: EdgeInsets.only(right: SizeConfig.getProportionateWidth(14)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                clipBehavior: Clip.antiAlias,
                child: jouet.image.isNotEmpty
                    ? Image.network(
                        jouet.image.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            color: Colors.black26,
                            size: SizeConfig.getProportionateWidth(40),
                          );
                        },
                      )
                    : Icon(
                        Icons.image,
                        color: Colors.black26,
                        size: SizeConfig.getProportionateWidth(40),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(SizeConfig.getProportionateWidth(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jouet.nomJouet,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.normalTextStyle.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(4)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getProportionateWidth(6),
                      vertical: SizeConfig.getProportionateHeight(2),
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: SizeConfig.getProportionateWidth(14),
                          ),
                          SizedBox(width: SizeConfig.getProportionateWidth(2)),
                          Text(
                            jouet.noteMoyen.toStringAsFixed(1),
                            style: AppStyles.normalTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            estFavori = !estFavori;
                          });
                        },
                        child: Icon(
                          estFavori ? Icons.favorite : Icons.favorite_border,
                          color: estFavori ? Colors.red : Colors.black45,
                          size: SizeConfig.getProportionateWidth(22),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
