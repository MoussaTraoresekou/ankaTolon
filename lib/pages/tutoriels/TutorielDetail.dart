import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/admin_model/tutoriel_model.dart';

class TutorielDetailScreen extends StatefulWidget {
  final TutorielModel tutoriel;

  const TutorielDetailScreen({super.key, required this.tutoriel});

  @override
  State<TutorielDetailScreen> createState() => _TutorielDetailScreenState();
}

class _TutorielDetailScreenState extends State<TutorielDetailScreen> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  void _initVideoPlayer() {
    final videoUrl = widget.tutoriel.videoUrl ?? '';
    if (videoUrl.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
            _resetHideTimer();
          }
        });
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  /// Relance le minuteur de masquage
  void _resetHideTimer() {
    _hideTimer?.cancel();
    if (_videoController != null && _videoController!.value.isPlaying) {
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && _videoController!.value.isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  /// Active / Désactive l'affichage de l'interface
  void _toggleControlsOverlay() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      _resetHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  /// Gestion Play / Pause
  void _togglePlayPause() {
    if (_videoController != null && _isInitialized) {
      setState(() {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
          _showControls = true;
          _hideTimer?.cancel(); // Reste visible tant que la vidéo est en pause
        } else {
          _videoController!.play();
          _showControls = true;
          _resetHideTimer(); // Relance le minuteur au démarrage
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final String categoryText =
        (widget.tutoriel.categorieId != null &&
            widget.tutoriel.categorieId!.isNotEmpty)
        ? widget.tutoriel.categorieId!
        : 'Dessins';

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: context.textDark),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------- LECTEUR VIDÉO INTERACTIF -----------------
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: context.shadowColor,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggleControlsOverlay,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Vidéo / Image de couverture
                      if (_isInitialized && _videoController != null)
                        AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        )
                      else if (widget.tutoriel.imageVideoUrl != null &&
                          widget.tutoriel.imageVideoUrl!.isNotEmpty)
                        Image.network(
                          widget.tutoriel.imageVideoUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: context.primarySoft,
                            child: Icon(Icons.image, color: context.textMuted),
                          ),
                        )
                      else
                        Container(
                          color: context.primarySoft,
                          child: Icon(Icons.image, color: context.textMuted),
                        ),

                      // 2. Fond sombre translucide pour accentuer la lisibilité
                      if (_isInitialized && _showControls)
                        Container(color: Colors.black.withOpacity(0.4)),

                      // 3. Bouton central Play / Pause
                      if (_isInitialized && _showControls)
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: context.primary.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              (_videoController?.value.isPlaying ?? false)
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 42,
                            ),
                          ),
                        ),

                      // 4. Barre de progression & Durées en bas (Style YouTube)
                      if (_isInitialized && _showControls)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: ValueListenableBuilder(
                              valueListenable: _videoController!,
                              builder:
                                  (context, VideoPlayerValue value, child) {
                                    final position = value.position;
                                    final duration = value.duration;

                                    return Row(
                                      children: [
                                        Text(
                                          _formatDuration(position),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTapDown: (_) => _resetHideTimer(),
                                            onHorizontalDragUpdate: (_) =>
                                                _resetHideTimer(),
                                            child: VideoProgressIndicator(
                                              _videoController!,
                                              allowScrubbing: true,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                              colors: VideoProgressColors(
                                                playedColor: context.primary,
                                                bufferedColor: Colors.white
                                                    .withOpacity(0.4),
                                                backgroundColor: Colors.white
                                                    .withOpacity(0.2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _formatDuration(duration),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ----------------- TITRE DU TUTORIEL -----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: context.cardMenuYellow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: context.borderColor.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Text(
                widget.tutoriel.titre,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.textDark,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ----------------- CATÉGORIE & ÂGE -----------------
            Row(
              children: [
                Text(
                  'Art',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: context.textMuted.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  categoryText,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ----------------- DESCRIPTION -----------------
            if (widget.tutoriel.description != null &&
                widget.tutoriel.description!.isNotEmpty) ...[
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.tutoriel.description!,
                style: TextStyle(
                  fontSize: 15,
                  color: context.textDark.withOpacity(0.85),
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
