import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:tolon/models/admin_model/tutoriel_model.dart';

class TutoDetail extends StatefulWidget {
  final TutorielModel tutoriel;

  const TutoDetail({required this.tutoriel, super.key});

  @override
  State<TutoDetail> createState() => _TutoDetailScreenState();
}

class _TutoDetailScreenState extends State<TutoDetail> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // LECTURE DIRECTE SUPABASE : On initialise le lecteur avec l'URL de votre base
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.tutoriel.videoUrl),
    )..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      }).catchError((error) {
        debugPrint("Impossible de charger la vidéo Supabase : $error");
      });
  }

  @override
  Widget build(BuildContext context) {
    // Formatage propre de la date de création
    final dt = widget.tutoriel.dateCreation;
    final String dateStr = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Visualisation Tutoriel',
          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📺 1. LE LECTEUR VIDÉO EN GRAND EN HAUT
            Container(
              width: double.infinity,
              height: 230,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isInitialized)
                      AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                    else
                      const Center(child: CircularProgressIndicator(color: AppColors.greenPrimary)),

                    // Bouton de contrôle Play/Pause superposé au centre
                    if (_isInitialized)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _videoController.value.isPlaying ? _videoController.pause() : _videoController.play();
                          });
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.black45,
                          child: Icon(
                            _videoController.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // LES DÉTAILS DU TUTORIEL EN BAS (Feuille d'information)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre principal
                  Text(
                    widget.tutoriel.titre,
                    style: const TextStyle(fontFamily: 'Quicksand', fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 12),

                  // Ligne des badges d'informations (Date et Tranche d'âge)
                  Row(
                    children: [
                      _buildInfoBadge(Icons.calendar_month_rounded, 'Publié le $dateStr', const Color(0xFFE8F5E9), AppColors.greenPrimary),
                      const SizedBox(width: 12),
                      _buildInfoBadge(Icons.child_care_rounded, '${widget.tutoriel.ageMin}-${widget.tutoriel.ageMax} ans', const Color(0xFFFFF3E0), Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Bloc de description
                  const Text(
                    'Objectifs pédagogiques & Description',
                    style: TextStyle(fontFamily: 'Quicksand', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFECECEC)),
                    ),
                    child: Text(
                      widget.tutoriel.description.isEmpty 
                          ? "Aucune description fournie pour cette vidéo éducative." 
                          : widget.tutoriel.description,
                      style: const TextStyle(fontFamily: 'Quicksand', fontSize: 13, height: 1.5, color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Petit widget d'aide pour dessiner de jolis badges d'informations colorés
  Widget _buildInfoBadge(IconData icon, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TRÈS IMPORTANT : On coupe le flux vidéo quand on quitte l'écran pour libérer la mémoire RAM
    _videoController.dispose();
    super.dispose();
  }
}
