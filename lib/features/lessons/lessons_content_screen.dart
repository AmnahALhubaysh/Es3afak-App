import 'package:esafak_app/database/es3afak_db.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:esafak_app/core/app_colors.dart'; 
import '../../l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esafak_app/database/Models/Models/progress_record_m.dart';

class LessonContentScreen extends StatefulWidget {
  final String title;
  final int lessonId;
  final String descriptionEn;
  final String descriptionAr;
  final String videoUrlEn;
  final String videoUrlAr;

  const LessonContentScreen({
    super.key,
    required this.lessonId,
    required this.title,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.videoUrlEn,
    required this.videoUrlAr,
  });

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen> {
  VideoPlayerController? controller;
  String? currentPath;
  bool _isInitialized = false;
  bool _isSaved = false;

  Future<void> playVideo(String path) async {
    final t = AppLocalizations.of(context)!;
    if (path.isEmpty || path == 'YOUR_AR_VIDEO_URL_HERE') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.sorryVideoCU)),
      );
      return;
    }

    setState(() => _isInitialized = false);
    await controller?.dispose();

    controller = VideoPlayerController.asset(path);

    try {
      await controller!.initialize();
      
      
      // إضافة مستمع لمتابعة تقدم الفيديو ونهايته
      controller!.addListener(() {
        if (controller!.value.position == controller!.value.duration) {
          // هنا يتم استدعاء دالة حفظ التقدم عند اكتمال الفيديو
          _markLessonAsCompleted();
        }
        setState(() {}); // لتحديث شريط التقدم
      });

      setState(() {
        currentPath = path;
        _isInitialized = true;
      });
      controller!.play();
    } catch (e) {
      debugPrint("Error initializing video: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.failedVideoFile)),
      );
    }
  }

  
 void _markLessonAsCompleted() {
  if (!_isSaved) { 
    debugPrint("تم إكمال الدرس: ${widget.title}");
    _saveProgress(); 
    setState(() => _isSaved = true);
  }
}
void _saveProgress() async {
       final db = Es3afakDb();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        int userId = prefs.getInt('user_id') ?? 1;
        await db.insertProgressRecordM(
        ProgressRecordM(
        userId: userId,
        lessonId: widget.lessonId,
        completionStatus: 1,
        dateCompleted: DateTime.now().toString(),
      ),
    );

    debugPrint(" تم حفظ تقدم الدرس");
  }
  void togglePlayPause() {
    if (controller == null || !controller!.value.isInitialized) return;
    setState(() {
      controller!.value.isPlaying ? controller!.pause() : controller!.play();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF5FF),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(236, 189, 212, 247),
        title: Text(widget.title),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ///  منطقة الفيديو مع شريط التقدم
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _buildVideoDisplay(),
                  if (_isInitialized && controller != null)
                    Column(
                      children: [
                        //  شريط التقديم والتأخير (Video Progress Bar)
                        VideoProgressIndicator(
                          controller!,
                          allowScrubbing: true, // يسمح للمستخدم بالسحب والتقديم
                          colors: VideoProgressColors(
                            playedColor: AppColors.primaryOrange,
                            bufferedColor: Colors.grey.shade300,
                            backgroundColor: Colors.grey.shade100,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// أزرار التحكم المطورة
            _buildControlPanel(),

            const SizedBox(height: 25),

            Text(
              widget.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),
            _buildDescriptionBox(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoDisplay() {
    final t = AppLocalizations.of(context)!;
    if (currentPath == null) {
      return Container(
        height: 230,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_outline, size: 50, color: Colors.grey),
            const SizedBox(height: 10),
            Text(t.choose, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    if (!_isInitialized) {
      return Container(height: 230, alignment: Alignment.center, child: const CircularProgressIndicator());
    }
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(controller!),
            if (!controller!.value.isPlaying)
              const Icon(Icons.pause_circle_filled, size: 60, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Column(
      children: [
        if (controller != null && _isInitialized)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // زر رجوع 10 ثواني
              IconButton(
                icon: const Icon(Icons.replay_10, size: 35, color: Colors.blueGrey),
                onPressed: () {
                  final newPosition = controller!.value.position - const Duration(seconds: 10);
                  controller!.seekTo(newPosition);
                },
              ),
              // زر التشغيل والإيقاف المركزي
              IconButton(
                icon: Icon(
                  controller!.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 65, color: AppColors.primaryOrange,
                ),
                onPressed: togglePlayPause,
              ),
              // زر تقديم 10 ثواني
              IconButton(
                icon: const Icon(Icons.forward_10, size: 35, color: Colors.blueGrey),
                onPressed: () {
                  final newPosition = controller!.value.position + const Duration(seconds: 10);
                  controller!.seekTo(newPosition);
                },
              ),
            ],
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _languageButton("العربية", widget.videoUrlAr),
            const SizedBox(width: 15),
            _languageButton("English", widget.videoUrlEn),
          ],
        ),
      ],
    );
  }

  Widget _languageButton(String label, String url) {
    return ElevatedButton(
      onPressed: () => playVideo(url),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDescriptionBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text("وصف الحالة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 10),
          Text(widget.descriptionAr, style: const TextStyle(fontSize: 16, height: 1.6), textAlign: TextAlign.right),
          const Divider(height: 40),
          const Row(
            children: [
              Icon(Icons.language, color: Colors.orange),
              SizedBox(width: 8),
              Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)),
            ],
          ),
          const SizedBox(height: 10),
          Text(widget.descriptionEn, style: const TextStyle(fontSize: 16, height: 1.6), textAlign: TextAlign.left),
        ],
      ),
    );
  }
}