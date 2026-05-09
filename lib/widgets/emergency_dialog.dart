import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esafak_app/database/es3afak_db.dart';
import 'package:esafak_app/database/Models/Models/emergency_call_m.dart';

class EmergencyDialog extends StatelessWidget {
  const EmergencyDialog({super.key});

  // ميزة الاتصال 
  Future<void> _makeCall() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 1;

    Es3afakDb db = Es3afakDb();
    await db.insertEmergencyCall(EmergencyCallM(userId: userId));
    final Uri url = Uri.parse('tel:997'); 
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded, 
              color: AppColors.primaryOrange, size: 60),
          const SizedBox(height: 10),
          const Text("حالة طوارئ؟", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 20),

          // زر الاتصال  
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _makeCall,
            icon: const Icon(Icons.phone, color: Colors.white),
            label: const Text("اتصال بـ 997", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 15),
          
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء", 
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}