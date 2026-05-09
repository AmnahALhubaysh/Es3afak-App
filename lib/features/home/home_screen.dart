import 'package:flutter/material.dart';
import 'package:esafak_app/main.dart';
import 'package:esafak_app/core/app_colors.dart';
import 'package:esafak_app/features/lessons/lessons_screen.dart';
import 'package:esafak_app/features/lessons/lessons_content_screen.dart'; 
import 'package:esafak_app/features/games/learning_games_page.dart';
import 'package:esafak_app/features/Profile/profile_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../../widgets/emergency_dialog.dart';
import '../../l10n/app_localizations.dart';
import 'package:esafak_app/database/es3afak_db.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 1. خوارزمية البحث والنتقال المباشر الذكية
  void _handleSearch(String query, BuildContext context) async {
    if (query.isEmpty) return;

    // فحص لغة التطبيق الحالية
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    Es3afakDb dbHelper = Es3afakDb();
    
    // مناداة قاعدة البيانات للبحث عن الاسم
    var lessonData = await dbHelper.getLessonByName(query);

    if (lessonData != null) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LessonContentScreen(
              // اختيار العنوان بناءً على لغة واجهة المستخدم
              title: isArabic ? lessonData['title_ar'] : lessonData['title_en'],
              lessonId: lessonData['id'],
              descriptionAr: lessonData['descriptionAr'] ?? "",
              descriptionEn: lessonData['descriptionEn'] ?? "",
              videoUrlAr: lessonData['videoUrlAr'] ?? "",
              videoUrlEn: lessonData['videoUrlEn'] ?? "",
            ),
          ),
        );
      }
    } else {
      // إذا لم يتم العثور على الدرس، يتم الانتقال لصفحة الدروس العامة
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LessonsScreen()),
        );
      }
    }
  }

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '997');
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFEAF5FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              _buildTopBar(context),
              const SizedBox(height: 25),
              _buildWelcomeSection(t),
              const SizedBox(height: 30),
              
              // 2. صندوق البحث المربوط بالدالة المباشرة
              _buildSearchBar(t, context),

              const SizedBox(height: 35),
              _buildCardsSection(context, t),
              const Spacer(),
              _buildSOSButton(t),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // --- دوال بناء الواجهة منظمة ---

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTopIcon(Icons.language, onTap: () => Es3afakApp.of(context)?.toggleLanguage()),
        _buildTopIcon(Icons.person_outline, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettingsScreen(firebaseUid: FirebaseAuth.instance.currentUser?.uid ?? "")));
        }),
      ],
    );
  }

  Widget _buildWelcomeSection(var t) {
    return Column(
      children: [
        Text(t.welcome, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
        const SizedBox(height: 8),
        Text(t.question, style: const TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildSearchBar(var t, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) => _handleSearch(value, context),
        decoration: InputDecoration(
          hintText: t.search,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryOrange),
          suffixIcon: IconButton(icon: const Icon(Icons.clear, size: 20), onPressed: () => _searchController.clear()),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCardsSection(BuildContext context, var t) {
    return Row(
      children: [
        Expanded(child: _buildMenuCard(context, title: t.lessons, subtitle: t.learnFirstAid, icon: Icons.menu_book_outlined, color: const Color(0xFFE6F0FB), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LessonsScreen())))),
        const SizedBox(width: 16),
        Expanded(child: _buildMenuCard(context, title: t.games, subtitle: t.practicePlay, icon: Icons.sports_esports_outlined, color: const Color(0xFFFCEEEE), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LearningGamesPage())))),
      ],
    );
  }

  Widget _buildSOSButton(var t) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: () async {
          await _makePhoneCall();
          if (mounted) showDialog(context: context, builder: (context) => const EmergencyDialog());
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.call, color: Colors.white),
            const SizedBox(width: 10),
            Text(t.emergencyCall, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIcon(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]), child: Icon(icon, color: Colors.black54)),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
        child: Column(children: [CircleAvatar(radius: 38, backgroundColor: color, child: Icon(icon, size: 40, color: const Color(0xFF6CA6DC))), const SizedBox(height: 16), Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 12))]),
      ),
    );
  }
}