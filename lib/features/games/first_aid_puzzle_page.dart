import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/celebration_overlay.dart'; 
import '../../l10n/app_localizations.dart';
import '../../l10n/extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esafak_app/database/es3afak_db.dart';


class FirstAidPuzzlePage extends StatefulWidget {
  const FirstAidPuzzlePage({super.key});

  @override
  State<FirstAidPuzzlePage> createState() => _FirstAidPuzzlePageState();
}

class _FirstAidPuzzlePageState extends State<FirstAidPuzzlePage> {
  int caseIndex = 0;
  late List<String> userOrder;
  bool showCelebration = false;
  bool gameCompleted = false;

  // القائمة الكاملة لجميع الحالات (10 حالات)
  final List<Map<String, dynamic>> cases = [
    {
      "title": "case1_title",
      "steps": ["case1_step1", "case1_step2", "case1_step3"],
      "image": "assets/images/1.jpg" 
    },
    {
      "title": "case2_title",
      "steps": ["case2_step1", "case2_step2", "case2_step3"],
      "image": "assets/images/4.jpg"
    },
    {
      "title": "case3_title",
      "steps": ["case3_step1", "case3_step2", "case3_step3"],
      "image": "assets/images/11.jpg"
    },
    {
      "title": "case4_title",
      "steps": ["case4_step1", "case4_step2", "case4_step3"],
      "image": "assets/images/9.jpg"
    },
    {
      "title": "case5_title",
      "steps": ["case5_step1", "case5_step2", "case5_step3"],
      "image": "assets/images/5.jpg"
    },
    {
     "title": "case6_title",
      "steps": ["case6_step1", "case6_step2", "case6_step3"],
      "image": "assets/images/8.jpg"
    },
    {
       "title": "case7_title",
      "steps": ["case7_step1", "case7_step2", "case7_step3"],
      "image": "assets/images/2.jpg"
    },
    {
        "title": "case8_title",
      "steps": ["case8_step1", "case8_step2", "case8_step3"],
      "image": "assets/images/6.jpg"
    },
    {
      "title": "case9_title",
      "steps": ["case9_step1", "case9_step2", "case9_step3"],
      "image": "assets/images/7.jpg"
    },
    {
      "title": "case10_title",
      "steps": ["case10_step1", "case10_step2", "case10_step3"],
      "image": "assets/images/10.jpg"
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCase();
  }

  void _loadCase() {
    // تحميل الخطوات وعمل shuffle (خلط عشوائي) لضمان التحدي
    userOrder = List.from(cases[caseIndex]['steps'])..shuffle();
  }

  void _check() {
    final t = AppLocalizations.of(context)!;

    bool ok = true;
    for (int i = 0; i < userOrder.length; i++) {
      if (userOrder[i] != cases[caseIndex]['steps'][i]) {
        ok = false;
        break;
      }
    }
    
    if (ok) {
      setState(() => showCelebration = true); // تشغيل القصاصات الملونة
      
      // تأخير بسيط لرؤية الاحتفالية قبل الانتقال للمرحلة التالية
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            showCelebration = false;
            if (caseIndex < cases.length - 1) {
              caseIndex++;
              _loadCase();
            } else {
              _showFinishDialog();
            }
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(t.tryAgain1),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showFinishDialog() async {
    Es3afakDb db = Es3afakDb();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 1;

   await db.updateGameResult(
    userId:   userId,
    gameName: 'First Aid Puzzle',
    isWon:    true, // ← وصل لنهاية اللعبة = فاز
   );

   if (!mounted) return;
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title:  Text(t.wellDone, textAlign: TextAlign.center),
        content:  Text(t.completePuzzle),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الحوار
                Navigator.pop(context); // العودة للقائمة الرئيسية
              },
              child:  Text(t.done, style: TextStyle(fontSize: 18)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text("${t.arrange} : ${t.getByKey(cases[caseIndex]['title'])}"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.65, 
                  height: 150, 
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      cases[caseIndex]['image'],
                      fit: BoxFit.contain, 
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.medical_information, size: 60, color: Colors.blueGrey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
               Text(
                t.dragSteps,
                style: TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              Expanded(
                child: ReorderableListView(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  onReorder: (oldIdx, newIdx) {
                    setState(() {
                      if (newIdx > oldIdx) newIdx -= 1;
                      final item = userOrder.removeAt(oldIdx);
                      userOrder.insert(newIdx, item);
                    });
                  },
                  children: [
                    for (int i = 0; i < userOrder.length; i++)
                      Card(
                        key: ValueKey(userOrder[i]),
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          // أيقونة السحب (تعمل باللمس المباشر)
                          leading: ReorderableDragStartListener(
                            index: i,
                            child: const Icon(Icons.drag_handle, color: Colors.blue, size: 30),
                          ),
                          title: Text(
                             t.getByKey(userOrder[i]),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          trailing: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            child: Text("${i + 1}", style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // زر التحقق السفلي
              Padding(
                padding: const EdgeInsets.all(25),
                child: ElevatedButton(
                  onPressed: _check,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    t.check,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          
          // استدعاء الاحتفالية (القصاصات الملونة) لتظهر فوق كل شيء
          CelebrationOverlay(
            show: showCelebration,
            onComplete: () => setState(() => showCelebration = false),
          ),
        ],
      ),
    );
  }
} 