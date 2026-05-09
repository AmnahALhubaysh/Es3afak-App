import 'package:flutter/material.dart';
import 'package:esafak_app/database/es3afak_db.dart';
import 'package:esafak_app/database/Models/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String firebaseUid;

  const ProfileSettingsScreen({super.key, required this.firebaseUid});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // دالة جلب البيانات من قاعدة البيانات المحلية
  Future<void> _loadUserData() async {
    try {
      UserModel? fetchedUser = await Es3afakDb().getUser(widget.firebaseUid);
      if (mounted) {
        setState(() {
          user = fetchedUser;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      debugPrint("Error loading user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF5FF),
      appBar: AppBar(
        title: const Text("الملف الشخصي", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? _buildEmptyState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // صورة البروفايل الافتراضية
                      const CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 65, color: Color(0xFF6CA6DC)),
                      ),
                      const SizedBox(height: 25),

                      // بطاقات المعلومات
                      _buildInfoCard("الاسم", user?.name ?? "غير محدد"),
                      _buildInfoCard("البريد الإلكتروني", user?.email ?? "لا يوجد بريد"),
                      _buildInfoCard("نوع الحساب", (user?.isGuest ?? 1) == 1 ? "زائر" : "مستخدم مسجل"),

                      const SizedBox(height: 40),

                      // زر تسجيل الخروج
                      ElevatedButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();

                          // ← حذف الـ userId المحفوظ
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.remove('user_id');

                          if (mounted) {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          "تسجيل الخروج",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // واجهة تظهر في حال لم تكن هناك بيانات
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_circle_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text("بياناتك غير مسجلة في قاعدة البيانات المحلية"),
          TextButton(onPressed: _loadUserData, child: const Text("إعادة المحاولة")),
        ],
      ),
    );
  }

  // دالة بناء بطاقة المعلومة
  Widget _buildInfoCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}