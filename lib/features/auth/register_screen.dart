import 'package:flutter/material.dart';
import 'package:esafak_app/core/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:esafak_app/database/es3afak_db.dart'; 
import 'package:esafak_app/database/Models/Models/user_model.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esafak_app/features/home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isArabic = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  //  دالة التسجيل  (الربط بين Firebase و SQLite و SharedPreferences)
  Future signUp(String name, String email, String password) async {
    try {
      // 1. إنشاء الحساب في Firebase
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. إذا نجح تسجيل Firebase، نحفظ في SQLite
      if (userCredential.user != null) {
        Es3afakDb db = Es3afakDb();
        
        UserModel newUser = UserModel(
          firebaseUid: userCredential.user!.uid,
          name: name, // نستخدم الاسم المدخل في الحقل
          email: email,
          isGuest: 0,
        );

        // حفظ المستخدم وجلب الـ userId التلقائي من SQLite
        int userId = await db.insertUser(newUser);
        debugPrint(" تم حفظ المستخدم بنجاح في SQLite بالرقم: $userId");

        // 3. حفظ الـ userId في SharedPreferences لاستخدامه لاحقاً (مثل التقدم)
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userid', userId);
        debugPrint(" تم حفظ الـ ID في SharedPreferences");

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم إنشاء الحساب بنجاح")),
          );
          
          // 4. الانتقال للهوم بعد التسجيل
        Navigator.pushReplacement(
           context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
        }
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("خطأ: ${e.toString()}")),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () => setState(() => isArabic = !isArabic),
                  child: Text(isArabic ? "English" : "العربية", 
                    style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),
              Text(isArabic ? "إنشاء حساب" : "Create Account", 
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              
              const SizedBox(height: 30),

              //  حقل الاسم الكامل
              Text(isArabic ? "الاسم الكامل" : "Full Name"),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: isArabic ? "أدخل اسمك" : "Your Name",
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),

              const SizedBox(height: 20),

              // البريد الإلكتروني
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

              //  كلمة المرور
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

              const SizedBox(height: 20),

              //  تأكيد كلمة المرور
              Text(isArabic ? "تأكيد كلمة المرور" : "Confirm Password"),
              const SizedBox(height: 8),
              TextField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: "********",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),

              const SizedBox(height: 30),

              //  زر إنشاء الحساب
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يرجى تعبئة جميع الحقول")));
                      return;
                    }
                    if (passwordController.text != confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("كلمة المرور غير متطابقة")));
                      return;
                    }
                    signUp(nameController.text, emailController.text, passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D4A5C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(isArabic ? "إنشاء الحساب" : "Create Account", style: const TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isArabic ? "لديك حساب؟ " : "Already have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text("Login", 
                      style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
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