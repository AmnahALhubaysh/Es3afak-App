import 'package:esafak_app/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:esafak_app/core/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esafak_app/database/Models/Models/user_model.dart';
import 'package:esafak_app/database/es3afak_db.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isArabic = false;
  bool _obscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // دالة تسجيل الدخول المحدثة لربط Firebase بـ SQLite
  Future signIn(String email, String password) async {
    try {
      // 1. تسجيل الدخول عبر Firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      
      // 2. التحقق من وجود المستخدم في قاعدة البيانات المحلية
      Es3afakDb db = Es3afakDb();
      UserModel? existingUser = await db.getUser(userCredential.user!.uid);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (existingUser == null) {
        // إذا كان المستخدم مسجلاً في Firebase ولكن ليس لديه سجل محلي
        int userId = await db.insertUser(UserModel(
          name: userCredential.user!.displayName ?? email.split('@')[0], 
          email: email,
          firebaseUid: userCredential.user!.uid,
        ));
        // توحيد المفتاح ليكون 'userid'
        await prefs.setInt('userid', userId);
        debugPrint("مستخدم جديد: تم الحفظ في SQLite");
      } else {
        // إذا كان المستخدم موجوداً مسبقاً، نجلب الـ ID الخاص به
        await prefs.setInt('userid', existingUser.userId!);
        debugPrint("مستخدم متاح: تم جلب الـ ID من SQLite");
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم تسجيل الدخول بنجاح")),
        );

        // 3. الانتقال لشاشة الهوم
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("خطأ في تسجيل الدخول: ${e.toString()}")),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF5FF),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              Align(
                alignment: isArabic ? Alignment.topRight : Alignment.topLeft,
                child: TextButton(
                  onPressed: () => setState(() => isArabic = !isArabic),
                  child: Text(
                    isArabic ? "English" : "العربية",
                    style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                isArabic ? "تسجيل الدخول" : "Login",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Text(isArabic ? "البريد الإلكتروني" : "Email"),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "example@email.com",
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              Text(isArabic ? "كلمة المرور" : "Password"),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "********",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يرجى تعبئة الحقول")));
                      return;
                    }
                    signIn(emailController.text, passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D4A5C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(isArabic ? "تسجيل الدخول" : "Login", style: const TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () async {
                    Es3afakDb db = Es3afakDb();
                    int userId = await db.insertGuest();
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('userid', userId);
                    if (mounted) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                    }
                  },
                  child: Text(
                    isArabic ? "الدخول كضيف" : "Continue as Guest",
                    style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isArabic ? "ليس لديك حساب؟ " : "Doesn’t have account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: Text(
                      isArabic ? "إنشاء حساب" : "Create Account",
                      style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}