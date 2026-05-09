import 'package:flutter/material.dart';
import '../../widgets/celebration_overlay.dart'; 
import '../../l10n/app_localizations.dart';
import '../../l10n/extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esafak_app/database/es3afak_db.dart';

class QuickQuizPage extends StatefulWidget {
  const QuickQuizPage({super.key});

  @override
  State<QuickQuizPage> createState() => _QuickQuizPageState();
}

// حالة صفحة الاختبار السريع
class _QuickQuizPageState extends State<QuickQuizPage> {
  // رقم السؤال الحالي
  int currentQuestion = 0;
  // نتيجة الاختبار
  int score = 0;
  // الخيار المختار
  int? selectedIndex;
  // هل تم الإجابة؟
  bool answered = false;
  // إظهار الاحتفال
  bool showCelebration = false;

  // قائمة الأسئلة
  final List<Map<String, dynamic>> questions = [
    {
      "q": "q1",
      "options": ["q1_o1", "q1_o2", "q1_o3", "q1_o4"],
      "correct": 1,
      "icon": Icons.bloodtype
    },
    {
      "q": "q2",
      "options": ["q2_o1", "q2_o2", "q2_o3", "q2_o4"],
      "correct": 2,
      "icon": Icons.local_fire_department
    },
    {
      "q": "q3",
      "options": ["q3_o1", "q3_o2", "q3_o3", "q3_o4"],
      "correct": 1,
      "icon": Icons.face
    },
    {
      "q": "q4",
      "options": ["q4_o1", "q4_o2", "q4_o3", "q4_o4"],
      "correct": 2,
      "icon": Icons.bug_report
    },
    {
      "q": "q5",
      "options": ["q5_o1", "q5_o2", "q5_o3", "q5_o4"],
      "correct": 1,
      "icon": Icons.warning
    },
    {
      "q": "q6",
      "options": ["q6_o1", "q6_o2", "q6_o3", "q6_o4"],
      "correct": 0,
      "icon": Icons.accessibility_new
    },
    {
      "q": "q7",
      "options": ["q7_o1", "q7_o2", "q7_o3", "q7_o4"],
      "correct": 0,
      "icon": Icons.phone_in_talk
    },
    {
      "q": "q8",
      "options": ["q8_o1", "q8_o2", "q8_o3", "q8_o4"],
      "correct": 1,
      "icon": Icons.hotel
    },
    {
      "q": "q9",
      "options": ["q9_o1", "q9_o2", "q9_o3", "q9_o4"],
      "correct": 1,
      "icon": Icons.wb_sunny
    },
    {
      "q": "q10",
      "options": ["q10_o1", "q10_o2", "q10_o3", "q10_o4"],
      "correct": 1,
      "icon": Icons.visibility
    },
  ];

  // دالة إرسال الإجابة
  void _submitAnswer(int index) {
    if (answered) return;
    setState(() {
      selectedIndex = index;
      answered = true;
      if (index == questions[currentQuestion]['correct']) {
        score += 100;
        _showCelebration();
      }
    });
  }

  // إظهار الاحتفال
  void _showCelebration() {
    setState(() {
      showCelebration = true;
    });
  }

  // اكتمال الاحتفال
  void _onCelebrationComplete() {
    setState(() {
      showCelebration = false;
    });
  }

  // الانتقال للسؤال التالي
  void _next() {
    final t = AppLocalizations.of(context)!;
    if (currentQuestion < 9) {
      setState(() {
        currentQuestion++;
        selectedIndex = null;
        answered = false;
      });
    } else {
      _showEnd("${t.quizEnd} $score");
    }
  }

  // عرض نهاية الاختبار
  void _showEnd(String msg) async {
        Es3afakDb db = Es3afakDb();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 1;

     await db.updateGameResult(
     userId:   userId,
     gameName: 'Quick Quiz',
     isWon:    score >= 500, // ← فاز لو حصل على 500 أو أكثر من 1000
     );
      if (!mounted) return;
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(msg, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق الحوار
              Navigator.pop(context); // العودة للصفحة السابقة
            },
            child:  Text(t.back),
          )
        ],
      ),
    );
  }


  Widget _bottomBar(BuildContext context, {VoidCallback? onNext}) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 153, 255),
                foregroundColor: Colors.white,
              ),
              child:  Text(t.exit),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child:  Text(t.next),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    var q = questions[currentQuestion];
    return Scaffold(
      appBar: AppBar(title: Text("${t.q}${currentQuestion + 1} / 10")),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Icon(q['icon'], size: 80, color: Colors.blue),
              ),
              Text(
                t.getByKey(q['q']),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: 4,
                  itemBuilder: (c, i) => Card(
                    color: answered
                        ? (i == q['correct']
                            ? Colors.green.shade100
                            : (i == selectedIndex
                                ? Colors.red.shade100
                                : Colors.white))
                        : Colors.white,
                    child: ListTile(
                      title: Text(t.getByKey(q['options'][i])),
                      onTap: () => _submitAnswer(i),
                    ),
                  ),
                ),
              ),
              // استدعاء الشريط السفلي
              _bottomBar(context, onNext: answered ? _next : null),
            ],
          ),
          CelebrationOverlay(
            show: showCelebration,
            onComplete: _onCelebrationComplete,
          ),
        ],
      ),
    );
  }
}