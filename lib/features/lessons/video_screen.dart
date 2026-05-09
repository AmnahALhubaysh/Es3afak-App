import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../l10n/app_localizations.dart';

class VideoScreen extends StatefulWidget {
  final String? videoUrl; // من Firebase
  final String? assetPath; // من داخل التطبيق

  const VideoScreen({
    super.key,
    this.videoUrl,
    this.assetPath,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    
    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl!),
      );
    } else {
      _controller = VideoPlayerController.asset(
        widget.assetPath ?? 'assets/videos/cpr.mp4',
      );
    }

    _controller.initialize().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _controller.value.isPlaying
          ? _controller.pause()
          : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
      final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title:  Text(t.educationalVideo),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _togglePlay,
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}