import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/controller/activite_controller/activite_controller.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/async_value_ui.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/models/activites/activite_model.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/pages/activite/activite_video.dart';

class ActiviteDetailScreen extends ConsumerStatefulWidget {
  final ActiviteModel activite;
  final EnfantModel enfantModel;

  const ActiviteDetailScreen({
    super.key,
    required this.activite,
    required this.enfantModel,
  });

  @override
  ConsumerState<ActiviteDetailScreen> createState() =>
      _ActiviteDetailScreenState();
}

class _ActiviteDetailScreenState
    extends ConsumerState<ActiviteDetailScreen> {
  bool _activiteTerminee = false;

  @override
  void initState() {
    super.initState();

    _activiteTerminee =
        widget.enfantModel.activitesRealisees.any(
      (item) => item['activite_id'] == widget.activite.id,
    );
  }

  Future<void> _terminerActivite() async {
    final parentUid = FirebaseAuth.instance.currentUser?.uid;

    if (parentUid == null) {
      return;
    }

    final succes = await ref
        .read(activiteControllerProvider.notifier)
        .marquerCommeTerminee(
          parentUid: parentUid,
          enfantId: widget.enfantModel.id,
          activiteId: widget.activite.id,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(activiteControllerProvider);

    if (succes) {
      setState(() {
        _activiteTerminee = true;
      });

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
  }

  bool get _aUneVideo =>
      widget.activite.videoUrl != null && widget.activite.videoUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final state = ref.watch(activiteControllerProvider);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: SizeConfig.getProportionateHeight(280),
                    child: _aUneVideo
                        ? ActiviteVideo(
                            videoUrl: widget.activite.videoUrl!,
                            thumbnailUrl: widget.activite.image,
                          )
                        : (widget.activite.image != null &&
                                widget.activite.image!.isNotEmpty
                            ? Image.network(
                                widget.activite.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _imagePlaceholder();
                                },
                              )
                            : _imagePlaceholder()),
                  ),

                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppStyles.bgColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppStyles.shadowColor,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: AppStyles.textDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.activite.titre,
                      style: AppStyles.headingTextStyle.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppStyles.textDark,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        _InfoItem(
                          icon: Icons.timer_outlined,
                          text:
                              '${widget.activite.dureeMinutes} min',
                        ),

                        const SizedBox(width: 20),

                        _InfoItem(
                          icon: Icons.child_care_outlined,
                          text:
                              '${widget.activite.ageMin}-${widget.activite.ageMax} ans',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppStyles.textDark,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      widget.activite.description,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: AppStyles.textMuted,
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: _activiteTerminee || state.isLoading
                            ? null
                            : _terminerActivite,
                        icon: state.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                _activiteTerminee
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                              ),
                        label: Text(
                          state.isLoading
                              ? 'Enregistrement...'
                              : _activiteTerminee
                                  ? 'Activité déjà terminée'
                                  : 'Marquer comme terminée',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _activiteTerminee
                              ? Colors.grey
                              : AppStyles.primaryOrange,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                          disabledForegroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
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
      color: AppStyles.boxSurfaceLight,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 60,
          color: AppStyles.textMuted,
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppStyles.textDark,
          ),
        ),
      ],
    );
  }
}