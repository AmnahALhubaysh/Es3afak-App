import 'package:esafak_app/database/es3afak_db.dart';
import 'package:esafak_app/features/lessons/lessons_content_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  double progressRatio = 0.0;
  
  // 1. تعريف القوائم والمتحكم بالبحث
  List<Map<String, dynamic>> allLessons = []; // القائمة الأصلية الثابتة
  List<Map<String, dynamic>> filteredLessons = []; // القائمة اللي بتتغير مع البحث
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userid') ?? 1; 
    double ratio = await Es3afakDb().getLessonsProgressRatio(userId);
    if (mounted) {
      setState(() {
        progressRatio = ratio;
      });
    }
  }

  // 2. خوارزمية الفلترة: هي اللي بتخلي "الكسور" تطلع لحالها
  void _filterLessons(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredLessons = allLessons;
      } else {
        filteredLessons = allLessons
            .where((lesson) =>
                lesson["title"].toString().contains(query)) // بيبحث بالاسم
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    // 3. تعبئة قائمة الدروس (مهم تكون هنا عشان الترجمة t تشتغل)
    allLessons = [
      {"id": 1, "title": t.fracture, "icon": Icons.personal_injury_outlined},
      {"id": 2, "title": t.nosebleed, "icon": Icons.bloodtype_outlined},
      {"id": 3, "title": t.lowBloodSugar, "icon": Icons.monitor_heart_outlined},
      {"id": 4, "title": t.heatStroke, "icon": Icons.wb_sunny_outlined},
      {"id": 5, "title": t.choking, "icon": Icons.air_outlined},
      {"id": 6, "title": t.cpr, "icon": Icons.favorite_border},
      {"id": 7, "title": t.burn, "icon": Icons.local_fire_department_outlined},
      {"id": 8, "title": t.wound, "icon": Icons.healing_outlined},
    ];

    // لو ما في بحث، نعرض كل الدروس
    if (_searchController.text.isEmpty && filteredLessons.isEmpty) {
      filteredLessons = allLessons;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEAF5FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // شريط التقدم
              _buildProgressCard(),

              const SizedBox(height: 15),

              // 4. صندوق البحث المربوط بالدالة
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => _filterLessons(value), // 👈 هذا السطر هو الحل
                  decoration: InputDecoration(
                    hintText: t.search, 
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: Colors.orange),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text(t.firstAidLessons, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // 5. عرض الدروس المفلترة فقط
              Expanded(
                child: GridView.builder(
                  itemCount: filteredLessons.length, // 👈 يقرأ من القائمة المفلترة
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    final lesson = filteredLessons[index];
                    return _buildLessonItem(context, lesson, t);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة بناء كارت الدرس
  Widget _buildLessonItem(BuildContext context, Map<String, dynamic> lesson, var t) {
    return GestureDetector(
      onTap: () async {
        Es3afakDb db = Es3afakDb();
        var contentList = await db.getContentByLesson(lesson["id"]);
        if (contentList.isNotEmpty) {
          var content = contentList.first;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonContentScreen(
                title: lesson["title"],
                lessonId: lesson["id"],
                descriptionEn: content.descriptionEn ?? "",
                descriptionAr: content.descriptionAr ?? "",
                videoUrlEn: content.videoUrlEn ?? "",
                videoUrlAr: content.videoUrlAr ?? "",
              ),
            ),
          );
          _loadProgress();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(lesson["icon"], size: 40, color: const Color.fromARGB(236, 152, 212, 252)),
            const SizedBox(height: 10),
            Text("${lesson["title"]}", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("مستوى الإنجاز", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("${(progressRatio * 100).toInt()}%", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progressRatio,
            backgroundColor: Colors.grey.shade100,
            color: Colors.orange,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}