import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // الجزء العلوي من الدراور (الهوية)
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(236, 93, 182, 255), // لون تطبيق إسعافك
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.medical_services, 
                size: 40, 
                color: AppColors.primaryOrange
              ),
            ),
            accountName: Text(
              'تطبيق إسعافك',
              style: TextStyle(
                fontFamily: 'Tajawal', 
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            accountEmail: Text(
              'إسعافك في كل مكان',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),

          // خيار الصفحة الرئيسية
          ListTile(
            leading: const Icon(Icons.home, color: AppColors.primaryOrange),
            title: const Text('الرئيسية', style: TextStyle(fontFamily: 'Tajawal')),
            onTap: () {
              Navigator.pop(context); // يغلق الدراور
            },
          ),

          // تم حذف خيار الإعدادات (Settings) نهائياً من هنا لعدم الحاجة له

          // مساحة مرنة لدفع زر الخروج للأسفل
          const Spacer(),

          const Divider(),

          // خيار تسجيل الخروج المحدث
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'تسجيل الخروج', 
              style: TextStyle(color: Colors.red, fontFamily: 'Tajawal'),
            ),
            onTap: () async {
              // تسجيل الخروج من الفايربيس
              await FirebaseAuth.instance.signOut();
              
              if (context.mounted) {
                Navigator.pop(context); // إغلاق الدراور
                // العودة لصفحة تسجيل الدخول ومسح كل الصفحات السابقة من الذاكرة
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}