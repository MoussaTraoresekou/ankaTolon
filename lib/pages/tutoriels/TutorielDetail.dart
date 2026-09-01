import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
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

  static const Color primaryGreen = Color(0xFF388E52);
  static const Color bgLight = Color(0xFFF9FCF9);
  static const Color headerCardBg = Color(0xFFFBF4E8);

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
          setState(() {
            _isInitialized = true;
          });
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoController != null && _isInitialized) {
      setState(() {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
        } else {
          _videoController!.play();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String categoryText =
        (widget.tutoriel.categorieId != null &&
            widget.tutoriel.categorieId!.isNotEmpty)
        ? widget.tutoriel.categorieId!
        : 'Dessins';

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: bgLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------- LECTEUR VIDÉO / MINIATURE -----------------
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
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
                      )
                    else
                      Container(color: Colors.grey.shade300),

                    // Bouton Play / Pause
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: primaryGreen.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          (_videoController?.value.isPlaying ?? false)
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ----------------- TITRE DU TUTORIEL -----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: headerCardBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.tutoriel.titre,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  categoryText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ----------------- DESCRIPTION -----------------
            if (widget.tutoriel.description != null &&
                widget.tutoriel.description!.isNotEmpty) ...[
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.tutoriel.description!,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
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
