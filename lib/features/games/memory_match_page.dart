import 'dart:async';
import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../widgets/celebration_overlay.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esafak_app/database/es3afak_db.dart';

class MemoryMatchPage extends StatefulWidget {
  const MemoryMatchPage({super.key});

  @override
  State<MemoryMatchPage> createState() => _MemoryMatchPageState();
}

class _MemoryMatchPageState extends State<MemoryMatchPage> {
  final List<IconData> _icons = [
    Icons.healing, Icons.medical_services, Icons.local_hospital, Icons.emergency,
    Icons.vaccines, Icons.biotech, Icons.bloodtype, Icons.thermostat,
  ];
  late List<IconData> _gameIcons;
  late List<bool> _flipped;
  List<int> _selectedIndices = [];
  bool _waiting = false;
  bool _isWon = false;

  @override
  void initState() {
    super.initState();
    _gameIcons = [..._icons, ..._icons]..shuffle(); 
    _flipped = List.filled(16, false);
  }

  void _onTap(int index) async {
    if (_waiting || _flipped[index] || _selectedIndices.contains(index)) return;

    setState(() {
      _flipped[index] = true;
      _selectedIndices.add(index);
    });

    if (_selectedIndices.length == 2) {
      _waiting = true;
      if (_gameIcons[_selectedIndices[0]] == _gameIcons[_selectedIndices[1]]) {
        _selectedIndices.clear();
        _waiting = false;
        
        // التحقق من الفوز
        if (_flipped.every((e) => e)) {
          setState(() => _isWon = true);
          //  استدعاء دالة الحفظ فور الفوز
          await _saveGameResult(true);
        }
      } else {
        Timer(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _flipped[_selectedIndices[0]] = false;
              _flipped[_selectedIndices[1]] = false;
              _selectedIndices.clear();
              _waiting = false;
            });
          }
        });
      }
    }
  }

  // دالة الحفظ المحدثة
  Future<void> _saveGameResult(bool isWon) async {
    Es3afakDb db = Es3afakDb();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    int userId = prefs.getInt('userid') ?? 1;

    try {
      // استدعاء الدالة من ملف es3afak_db.dart المحدث
      await db.updateGameResult(
        userId: userId,
        gameName: 'Memory Match',
        isWon: isWon,
      );
      debugPrint("تم حفظ نتيجة اللعبة للمستخدم: $userId");
    } catch (e) {
      debugPrint(" خطأ أثناء حفظ اللعبة: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.memoryMatch),
        backgroundColor: const Color.fromARGB(236, 189, 212, 247),
      ),
      body: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemCount: 16,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => _onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: _flipped[index] ? Colors.white : const Color.fromARGB(255, 7, 75, 138),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [if (_flipped[index]) BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Icon(
                  _flipped[index] ? _gameIcons[index] : Icons.help_outline,
                  color: _flipped[index] ? Colors.blue : Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          
          // شاشة الاحتفال عند الفوز
          if (_isWon) 
            CelebrationOverlay(
              show: _isWon,
              onComplete: () {
                // العودة لصفحة الألعاب بعد انتهاء الاحتفال
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}