import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:video_player/video_player.dart';

class ActiviteVideo extends StatefulWidget {
  const ActiviteVideo({super.key, required this.videoUrl, this.thumbnailUrl});

  final String videoUrl;
  final String? thumbnailUrl;

  @override
  State<ActiviteVideo> createState() => _ActiviteVideoState();
}

class _ActiviteVideoState extends State<ActiviteVideo> {
  VideoPlayerController? _controller;
  bool _lectureDemarree = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _demarrerLecture() async {
    setState(() => _isLoading = true);

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    await controller.initialize();
    await controller.play();

    if (!mounted) {
      controller.dispose();
      return;
    }

    setState(() {
      _controller = controller;
      _lectureDemarree = true;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Avant que la lecture ne démarre : affiche la thumbnail (image de
    // l'activité) avec un bouton play par-dessus, sans télécharger
    // la vidéo tant que l'enfant n'a pas cliqué.
    if (!_lectureDemarree) {
      return GestureDetector(
        onTap: _isLoading ? null : _demarrerLecture,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                if (widget.thumbnailUrl != null &&
                    widget.thumbnailUrl!.isNotEmpty)
                  Image.network(
                    widget.thumbnailUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: context.boxSurfaceLight),
                  )
                else
                  Container(color: context.boxSurfaceLight),

                Container(color: Colors.black.withValues(alpha: 0.25)),

                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(
                        Icons.play_circle_fill,
                        size: 65,
                        color: Colors.white,
                      ),
              ],
            ),
          ),
        ),
      );
    }

    // Lecture en cours : affiche le vrai lecteur vidéo une fois initialisé.
    final controller = _controller!;

    if (!controller.value.isInitialized) {
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(controller),

            IconButton(
              onPressed: () {
                setState(() {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                });
              },
              icon: Icon(
                controller.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                size: 65,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
