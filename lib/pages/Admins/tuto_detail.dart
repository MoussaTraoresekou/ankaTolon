import 'dart:async'; // INDISPENSABLE pour utiliser le Timer de disparition
import 'package:flutter/material.dart';
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
  
  // GESTION DE L'AFFICHAGE DES CONTRÔLES
  bool _showControls = true; 
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();
    
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.tutoriel.videoUrl),
    )..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        // On lance le compte à rebours pour masquer les contrôles au départ
        _startControlsTimer();
      }).catchError((error) {
        debugPrint("Erreur de chargement vidéo : $error");
      });

    _videoController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  // Déclenche le compte à rebours de 1,5 seconde avant de masquer le bouton
  void _startControlsTimer() {
    _controlsTimer?.cancel(); // Annule l'ancien minuteur s'il y en avait un
    _controlsTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted && _videoController.value.isPlaying) {
        setState(() {
          _showControls = false; // Ferme le bouton si la vidéo joue
        });
      }
    });
  }

  // Inverse la visibilité des contrôles au clic sur la vidéo
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startControlsTimer(); // Si on réaffiche, on planifie sa disparition future
    }
  }

  @override
  Widget build(BuildContext context) {
    final dt = widget.tutoriel.dateCreation;
    final String dateStr = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            // 📺 LE LECTEUR VIDÉO PRO
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
                    // 1. Rendu vidéo
                    if (_isInitialized)
                      AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                    else
                      const Center(child: CircularProgressIndicator(color: AppColors.greenPrimary)),

                    // LE CAPTEUR DE CLIC INVISIBLE SUR TOUTE LA VIDÉO
                    if (_isInitialized)
                      Positioned.fill(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _toggleControls, // Un clic affiche ou cache l'en-tête du bouton
                          child: Container(color: Colors.transparent),
                        ),
                      ),

                    // LE BOUTON CENTRAL ANIMÉ : Apparaît ou disparaît selon l'état _showControls
                    if (_isInitialized && (_showControls || !_videoController.value.isPlaying))
                      AnimatedOpacity(
                        opacity: (_showControls || !_videoController.value.isPlaying) ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_videoController.value.isPlaying) {
                                _videoController.pause();
                              } else {
                                _videoController.play();
                                _startControlsTimer(); // Cache le bouton au démarrage
                              }
                            });
                          },
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.black45,
                            child: Icon(
                              _videoController.value.isPlaying 
                                  ? Icons.pause_rounded 
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 32,
                        ),
                      ),
                        ),
                      ),

                    // La barre de défilement (Progression) en bas
                    if (_isInitialized)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: VideoProgressIndicator(
                          _videoController,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: AppColors.greenPrimary,
                            bufferedColor: Colors.white24,
                            backgroundColor: Colors.black38,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // DESCRIPTION ET TITRES (Reste identique à votre design initial)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tutoriel.titre,
                    style: const TextStyle(fontFamily: 'Quicksand', fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoBadge(Icons.calendar_month_rounded, 'Publié le $dateStr', const Color(0xFFE8F5E9), AppColors.greenPrimary),
                      const SizedBox(width: 12),
                      _buildInfoBadge(Icons.child_care_rounded, '${widget.tutoriel.ageMin}-${widget.tutoriel.ageMax} ans', const Color(0xFFFFF3E0), Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 24),
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
    _videoController.dispose();
    _controlsTimer?.cancel();
    super.dispose();
  }
}