import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/common_button.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/pages/enfant/enfant_cart.dart';
import 'package:tolon/repository/enfant/enfant_repository.dart';

class ListeEnfants extends ConsumerStatefulWidget {
  const ListeEnfants({super.key});

  @override
  ConsumerState<ListeEnfants> createState() => _ChildrenListScreenState();
}

class _ChildrenListScreenState extends ConsumerState<ListeEnfants> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final enfantsAsync = ref.watch(enfantsStreamProvider);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.goNamed(AppRoutes.home.name);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Text(
                        'Mes enfants',
                        style: AppStyles.headingTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  enfantsAsync.when(
                    loading: () {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },

                    error: (error, stackTrace) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            'Une erreur est survenue.',
                            style: AppStyles.normalTextStyle.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },

                    data: (enfants) {
                      if (enfants.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: enfants.length,
                        itemBuilder: (context, index) {
                          return EnfantCard(enfant: enfants[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: CustomButton(
                onTap: () {
                  context.pushNamed(AppRoutes.addEnfant.name);
                },
                title: 'Ajouter un profil enfant',
                isLoading: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.child_care_rounded,
                size: 36,
                color: AppStyles.navbarColor,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Aucun enfant',
              style: AppStyles.titleTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Ajoutez un profil enfant pour commencer.',
              textAlign: TextAlign.center,
              style: AppStyles.normalTextStyle.copyWith(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
