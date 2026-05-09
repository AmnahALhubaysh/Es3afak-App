import 'package:esafak_app/widgets/celebration_overlay.dart';
import 'package:flutter/material.dart';
import '../../l10n/extension.dart';
import '../../l10n/app_localizations.dart';
import 'package:esafak_app/database/es3afak_db.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EmergencyScenariosPage extends StatefulWidget {
  const EmergencyScenariosPage({super.key});

  @override
  State<EmergencyScenariosPage> createState() => _EmergencyScenariosPageState();
}

class _EmergencyScenariosPageState extends State<EmergencyScenariosPage> {
  int stepIndex = 0;
  bool solved = false;
  bool gameCompleted = false;
  bool showCelebration = false;

  // القائمة الكاملة والنهائية لـ 10 سيناريوهات مع كافة الأدوات
  final List<Map<String, dynamic>> scenarios = [
    {
      "msg": "s1_msg",
      "correctTool": "legs_up",
      "image": "assets/images/9.jpg",
      "tools": [
        {"id": "legs_up", "icon": Icons.airline_seat_legroom_extra},
        {"id": "water", "icon": Icons.water_drop},
        {"id": "shake", "icon": Icons.vibration},
      ]
    },
    {
      "msg": "s2_msg",
      "correctTool": "cool_place",
      "image": "assets/images/2.jpg",
      "tools": [
        {"id": "cool_place", "icon": Icons.ac_unit},
        {"id": "coffee", "icon": Icons.coffee },
        {"id": "cover", "icon": Icons.check_box_outline_blank},
      ]
    },
    {
      "msg": "s3_msg",
      "correctTool": "pressure",
      "image": "assets/images/1.jpg",
      "tools": [
        {"id": "pressure", "icon": Icons.pan_tool },
        {"id": "wash", "icon": Icons.waves },
        {"id": "ointment", "icon": Icons.medication},
      ]
    },
    {
      "msg": "s4_msg",
      "correctTool": "tap_water",
      "image": "assets/images/4.jpg",
      "tools": [
        {"id": "ice", "icon": Icons.icecream},
        {"id": "tap_water", "icon": Icons.opacity},
        {"id": "paste", "icon": Icons.brush},
      ]
    },
    {
      "msg": "s5_msg",
      "correctTool": "back_blows",
      "image": "assets/images/5.jpg",
      "tools": [
        {"id": "back_blows", "icon": Icons.back_hand },
        {"id": "give_water", "icon": Icons.local_drink},
        {"id": "lie_down", "icon": Icons.hotel},
      ]
    },
    {
      "msg": "s6_msg",
      "correctTool": "no_move",
      "image": "assets/images/8.jpg",
      "tools": [
        {"id": "massage", "icon": Icons.dry_cleaning},
        {"id": "no_move", "icon": Icons.block },
        {"id": "pull", "icon": Icons.straighten },
      ]
    },
    {
      "msg": "s7_msg",
      "correctTool": "card",
      "image": "assets/images/7.jpg",
      "tools": [
        {"id": "card", "icon": Icons.credit_card },
        {"id": "fingers", "icon": Icons.pan_tool_alt },
        {"id": "rub", "icon": Icons.back_hand },
      ]
    },
    {
      "msg": "s8_msg",
      "correctTool": "ice_pack",
      "image": "assets/images/8.jpg",
      "tools": [
        {"id": "ice_pack", "icon": Icons.severe_cold },
        {"id": "walk", "icon": Icons.directions_walk },
        {"id": "hot_water", "icon": Icons.hot_tub },
      ]
    },
    {
      "msg": "s9_msg",
      "correctTool": "cpr",
      "image": "assets/images/9.jpg",
      "tools": [
        {"id": "cpr", "icon": Icons.favorite },
        {"id": "wait", "icon": Icons.timer },
        {"id": "cry", "icon": Icons.sentiment_very_dissatisfied },
      ]
    },
    {
      "msg": "s10_msg",
      "correctTool": "flush",
      "image": "assets/images/10.jpg",
      "tools": [
        {"id": "rub_eye", "icon": Icons.visibility_off },
        {"id": "flush", "icon": Icons.shower },
        {"id": "close", "icon": Icons.remove_red_eye },
      ]
    },
  ];

  void _next() {
    if (stepIndex < scenarios.length - 1) {
      setState(() {
        stepIndex++;
        solved = false;
        showCelebration = false;
      });
    } else {
      _showFinishDialog();
    }
  }

  void _showFinishDialog() async {  
  
  gameCompleted = true;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int userId = prefs.getInt('user_id') ?? 1;
  await Es3afakDb().updateGameResult(
    userId:   userId,
    gameName: 'Emergency Scenarios',
    isWon:    true,
  );
  if (!mounted) return;
 
  final t = AppLocalizations.of(context)!;

      
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: Text(t.wellDone),
        content:  Text(t.completedScenarios),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child:  Text(t.back),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      final t = AppLocalizations.of(context)!;
    var current = scenarios[stepIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("${t.scenario} ${stepIndex + 1} / 10"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              // رسالة الحالة الإسعافية
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  t.getByKey(current['msg']),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const Spacer(),

              // منطقة الهدف (المصابة) - DragTarget
              DragTarget<String>(
                // ignore: deprecated_member_use
                onAccept: (data) {
                  if (data == current['correctTool']) {
                    setState(() {
                      solved = true;
                      showCelebration = true; 
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        content: Text(t.tryAgain),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
            builder: (context, candidate, rejected) => Column(
                  children: [
                    Container(
                     
                      width: MediaQuery.of(context).size.width * 0.85, 
                      height: 250,
                      decoration: BoxDecoration(
                        color: solved ? Colors.green.withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: solved ? Colors.green : Colors.blue.shade100,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: solved 
                          ? const Center(child: Icon(Icons.check_circle, size: 120, color: Colors.green))
                          : Image.asset(
                              current['image'],
                              fit: BoxFit.contain, // يضمن عدم تمدد الصورة وفقدان جودتها
                              errorBuilder: (c, e, s) => const Icon(Icons.person, size: 100, color: Colors.grey),
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      solved ? t.getByKey("success_msg") : t.getByKey("drag_tool_msg"),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: solved ? Colors.green : Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // منطقة الأدوات
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 25,
                  runSpacing: 10,
                  children: (current['tools'] as List).map((tool) {
                    return _buildDraggableTool(tool['id'], tool['icon']);
                  }).toList(),
                ),
              ),

              // أزرار التحكم
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {  
                            if (!gameCompleted) {
                               SharedPreferences prefs = await SharedPreferences.getInstance();
                                    int userId = prefs.getInt('user_id') ?? 1;
                                     await Es3afakDb().updateGameResult(
                                     userId:   userId,
                                     gameName: 'Emergency Scenarios',
                                     isWon:    false,
                                   );
                                  }
                                    if (!mounted) return;
                                    Navigator.pop(context);
                                  },
                       
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child:  Text(t.exit),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: solved ? _next : null,
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
              ),
            ],
          ),
          
          CelebrationOverlay(
            show: showCelebration,
            onComplete: () => setState(() => showCelebration = false),
          ), 
        ],
      ),
    );
  }

  // دالة بناء الأداة القابلة للسحب (Draggable)
  Widget _buildDraggableTool(String id, IconData icon) {
     final t = AppLocalizations.of(context)!;
    return Draggable<String>(
      data: id,
      feedback: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue.withOpacity(0.8),
              child: Icon(icon, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(t.getByKey(id)),
          ],
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Column(
          children: [
            CircleAvatar(radius: 30, backgroundColor: Colors.grey.shade200, child: Icon(icon, color: Colors.grey)),
            Text(t.getByKey(id)),
          ],
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, size: 28, color: Colors.blue),
          ),
          const SizedBox(height: 5),
          Text(t.getByKey(id)),
        ],
      ),
    );
  }
}