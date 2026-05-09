import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

// --- استيراد ملفات الهوية الخاصة بالمشروع ---
import 'core/app_colors.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/lessons/lessons_screen.dart';
import 'features/home/home_screen.dart'; 
import 'widgets/emergency_dialog.dart';

// --- استيراد صفحات الألعاب ---
import 'features/games/quick_quiz_page.dart';
import 'features/games/memory_match_page.dart';
import 'features/games/first_aid_puzzle_page.dart';
import 'features/games/emergency_scenarios_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Es3afakApp());
}

class Es3afakApp extends StatefulWidget {
  const Es3afakApp({super.key});
  static _Es3afakAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_Es3afakAppState>();
  }
  @override
  State<Es3afakApp> createState() => _Es3afakAppState();
}
class _Es3afakAppState extends State<Es3afakApp> {
  Locale _locale = const Locale('en');

  void toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'en'
          ? const Locale('ar')
          : const Locale('en');
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        locale: _locale,
      
       supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],

    localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      debugShowCheckedModeBanner: false,
      title: 'إسعافك',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundBlue,
        // تطبيق خط تجول على كل التطبيق
        textTheme: GoogleFonts.tajawalTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      // المسارات (Routes)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(), // التوجه المباشر للهوم سكرين
      },
      home: const SplashScreen(), 
    );
  }
}


class MainScaffold extends StatefulWidget {
  final int initialIndex;
  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // العناوين المخصصة لكل تبويب
  final List<String> _titles = ['الرئيسية', 'الدروس التعليمية', 'منطقة الألعاب'];

  @override
  Widget build(BuildContext context) {
    // التنقل بين الصفحات
    final List<Widget> pages = [
      const HomeScreen(), // الصفحة الرئيسية التي تحتوي على البحث والبروفايل
      const LessonsScreen(), 
      _buildGamesPage(),   
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex], 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        elevation: 0,
        // تم حذف أسطر زر الإعدادات (IconButton) من هنا كما طلبتِ
      ),

      body: pages[_currentIndex],

      // زر الطوارئ العائم (SOS)
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryOrange,
        onPressed: () => showDialog(context: context, builder: (context) => const EmergencyDialog()),
        child: const Text("SOS", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      )
    );
  }

  // --- قسم الألعاب المدمج ---
  Widget _buildGamesPage() {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        _gameCard(context, "الاختبار السريع", Icons.flash_on, const QuickQuizPage()),
        _gameCard(context, "تطابق الذاكرة", Icons.psychology, const MemoryMatchPage()),
        _gameCard(context, "رتب الخطوات", Icons.extension, const FirstAidPuzzlePage()),
        _gameCard(context, "سيناريوهات", Icons.track_changes, const EmergencyScenariosPage()),
      ],
    );
  }

  Widget _gameCard(BuildContext context, String title, IconData icon, Widget page) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: AppColors.primaryOrange),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}