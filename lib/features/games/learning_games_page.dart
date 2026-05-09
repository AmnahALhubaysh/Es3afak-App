import 'package:esafak_app/database/es3afak_db.dart';
import 'package:esafak_app/features/games/quick_quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:esafak_app/features/games/emergency_scenarios_page.dart';
import 'package:esafak_app/features/games/first_aid_puzzle_page.dart';
import 'package:esafak_app/features/games/memory_match_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';

class AppConfig {
  static const Color primaryBlue = Color(0xFF6CA6DC);
  static const Color primaryOrange = Color(0xFFFF6D38);
  static const Color background = Color(0xFFF8FBFF);
  static const Color cardWhite = Colors.white;
}

class LearningGamesPage extends StatelessWidget {
  const LearningGamesPage({super.key});

  @override
  Widget build(BuildContext context) {
      final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppConfig.primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          t.learningGames,
          style: TextStyle(color: Color(0xFF2D3E50), fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(t.practice, 
              style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.85,
                children: [
                  _buildGameCard(context, t.quickQuiz, 'Best: 850', Icons.bolt_rounded, const QuickQuizPage()),
                  _buildGameCard(context, t.memoryMatch, 'Best: 1200', Icons.psychology_outlined, const MemoryMatchPage()),
                  _buildGameCard(context, t.puzzle, 'New!', Icons.extension_outlined, const FirstAidPuzzlePage()),
                  _buildGameCard(context, t.scenarios, 'Best: 650', Icons.track_changes_outlined, const EmergencyScenariosPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, String badge, IconData icon, Widget target) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
      child: Container(
        decoration: BoxDecoration(
          color: AppConfig.cardWhite,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: const Color(0xFFFFF3F0), borderRadius: BorderRadius.circular(20)),
              child: Icon(icon, color: AppConfig.primaryBlue, size: 40),
            ),
            // --- كود شريط تقدم اللعبة ---
const SizedBox(height: 12),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15),
  child: FutureBuilder<double>(
    future: _fetchGameRatio(title), // دالة تجلب النسبة من قاعدة البيانات
    builder: (context, snapshot) {
      double val = snapshot.data ?? 0.0;
      return LinearProgressIndicator(
        value: val,
        backgroundColor: Colors.blue.shade50,
        color: const Color(0xFF6CA6DC),
        minHeight: 5,
        borderRadius: BorderRadius.circular(10),
      );
    },
  ),
),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFE6F0FB), borderRadius: BorderRadius.circular(12)),
              child: Text(badge, style: const TextStyle(color: AppConfig.primaryBlue, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            
          ],
        ),
      ),
    );
  }
  Future<double> _fetchGameRatio(String gameName) async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userid') ?? 1;
  return await Es3afakDb().getGameProgressRatio(userId, gameName);
}
}


