import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tolon/controller/activite_controller/activite_controller.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/models/activites/activite_model.dart';

class ActiviteDetailScreen extends ConsumerWidget {
  const ActiviteDetailScreen({
    super.key,
    required this.activite,
  });

  final ActiviteModel activite;

  Future<void> _terminerActivite(
    BuildContext context,
    WidgetRef ref,
  ) async {
    /*
    final succes = await ref
        .read(activiteControllerProvider.notifier)
        .marquerCommeTerminee(
          activiteId: activite.id,
        );
        

    if (!context.mounted) {
      return;
    }

    final state = ref.read(activiteControllerProvider);

    if (succes) {
      state.showSuccessDialog(
        context,
        'Activité terminée avec succès !',
        () {
          context.pop();
        },
      );
    } else {
      state.showErrorDialog(context);
    }
    */
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    SizeConfig.init(context);

    final state = ref.watch(
      activiteControllerProvider,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: SizeConfig.getProportionateHeight(
                      280,
                    ),
                    child: activite.image != null &&
                            activite.image!.isNotEmpty
                        ? Image.network(
                            activite.image!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                              return _imagePlaceholder();
                            },
                          )
                        : _imagePlaceholder(),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.10,
                            ),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      activite.titre,
                      style:
                          AppStyles.headingTextStyle.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        _InfoItem(
                          icon: Icons.timer_outlined,
                          text:
                              '${activite.dureeMinutes} min',
                        ),
                        const SizedBox(width: 20),
                        _InfoItem(
                          icon: Icons.child_care_outlined,
                          text:
                              '${activite.ageMin}-${activite.ageMax} ans',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      activite.description,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black54,
                      ),
                    ),

                    if (activite.videoUrl != null &&
                        activite.videoUrl!.isNotEmpty) ...[
                      const SizedBox(height: 24),

                       Text(
                        'Vidéo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        color: AppStyles.textDark,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            size: 65,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                _terminerActivite(
                                  context,
                                  ref,
                                );
                              },
                        icon: state.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.check_circle_outline,
                              ),
                        label: Text(
                          state.isLoading
                              ? 'Enregistrement...'
                              : 'Marquer comme terminée',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppStyles.primaryOrange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFF1F1ED),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 60,
          color: Colors.black26, 
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppStyles.primaryOrange,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style:  TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
                                    color: AppStyles.textDark,

          ),
        ),
      ],
    );
  }
}

