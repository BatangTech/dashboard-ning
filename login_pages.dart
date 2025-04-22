import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurse_system/components/login/custom_text_field.dart';
import 'package:nurse_system/components/login/error_message.dart';
import 'package:nurse_system/components/login/login_button.dart';
import 'package:nurse_system/components/login/login_footer.dart';
import 'package:nurse_system/components/login/login_header.dart';
import 'package:nurse_system/constants/styles.dart';
import 'package:nurse_system/services/auth_service.dart';
import 'package:nurse_system/services/log_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // ตรวจสอบความถูกต้องของ Form ก่อนดำเนินการต่อ
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // เคลียร์ Error Message เก่า และแสดง Loading
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      // เรียกใช้ AuthService.login สำหรับ Admin ตายตัว
      final authResult = await AuthService.login(username, password);

      if (authResult.success) {
        // ถ้า Login ด้วย AuthService (Admin ตายตัว) สำเร็จ
        try {
          // ลอง Log การ Login ของ Admin
          final platform = await LogService.detectPlatform(context);
          await LogService.logAdminLogin(username, platform);

          // เพิ่มโค้ดส่วนนี้: บันทึกข้อมูล Admin ลง Firebase สำหรับใช้แสดงบนหน้าโปรไฟล์
          // หากยังไม่มีบัญชี Admin ใน Firebase Auth ให้สร้างใหม่
          String adminUid = '';
          String adminEmail = username; // ใช้ username เป็น email
          String adminDisplayName = authResult.displayName ?? 'ผู้ดูแลระบบ';

          try {
            // ลองตรวจสอบว่ามีผู้ใช้นี้ใน Firebase Auth หรือไม่
            final userCredential =
                await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: username,
              password: password,
            );
            adminUid = userCredential.user!.uid;
          } catch (e) {
            // ถ้าไม่พบผู้ใช้ ให้สร้างใหม่ใน Firebase Auth
            try {
              final userCredential =
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: username,
                password: password,
              );
              adminUid = userCredential.user!.uid;
              // ตั้งค่า displayName
              await userCredential.user!.updateDisplayName(adminDisplayName);
            } catch (e) {
              print('ไม่สามารถสร้างผู้ใช้ใน Firebase Auth: $e');
            }
          }

          // บันทึกหรืออัปเดตข้อมูลใน Firestore
          if (adminUid.isNotEmpty) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(adminUid)
                .set({
              'displayName': adminDisplayName,
              'email': adminEmail,
              'role': 'admin',
              'lastLogin': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true)); // ใช้ merge เพื่อไม่ให้ลบข้อมูลเดิม
          }
        } catch (e) {
          print('Failed to log admin login or save to Firebase: $e');
        }

        // ตรวจสอบว่า Widget ยังอยู่ก่อนนำทาง
        if (!context.mounted) return;

        // ดึงข้อมูลของ Admin จาก Firebase Auth
        final currentUser = FirebaseAuth.instance.currentUser;
        final String displayName =
            currentUser?.displayName ?? authResult.displayName ?? 'ผู้ดูแลระบบ';
        final String email = currentUser?.email ?? username;

        // นำทางไปยัง DashboardPage โดยแทนที่หน้าปัจจุบัน
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(
              displayName: displayName,
              email: email,
              password: password, // ส่งรหัสผ่านไปด้วยเพื่อใช้ในการอัปเดตข้อมูล
            ),
          ),
        );
      } else {
        // ถ้า Login ด้วย AuthService (Admin ตายตัว) ไม่สำเร็จ
        setState(() {
          // แสดง Error Message จาก AuthService
          _errorMessage =
              authResult.errorMessage ?? 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
        });
      }
    } catch (e) {
      // ดักจับ Error อื่นๆ ที่อาจเกิดขึ้นนอก AuthService
      print('Login process failed: $e'); // Log ข้อผิดพลาดเพื่อ Debug
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ: ${e.toString()}';
      });
    } finally {
      // ซ่อน Loading Indicator เสมอเมื่อกระบวนการ Login เสร็จสิ้น
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? AppStyles.darkBackground : AppStyles.lightBackground;
    final textColor =
        isDarkMode ? AppStyles.darkTextColor : AppStyles.lightTextColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      // เพิ่ม GestureDetector เพื่อซ่อนคีย์บอร์ดเมื่อแตะที่ว่าง
      body: GestureDetector(
        onTap: () {
          // Unfocus ทุก TextField เพื่อซ่อนคีย์บอร์ด
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LoginHeader(textColor: textColor),
                      const SizedBox(height: 40),
                      Text(
                        "ชื่อผู้ใช้หรืออีเมล",
                        style: GoogleFonts.prompt(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _usernameController,
                        textColor: textColor,
                        hintText: "กรอกชื่อผู้ใช้หรืออีเมล",
                        icon: Icons.person_outline,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'กรุณากรอกชื่อผู้ใช้หรืออีเมล';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "รหัสผ่าน",
                        style: GoogleFonts.prompt(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _passwordController,
                        textColor: textColor,
                        hintText: "กรอกรหัสผ่าน",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        onTogglePasswordVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          }
                          if (value.length < 6) {
                            return 'รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      if (_errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ErrorMessage(message: _errorMessage),
                      ],
                      const SizedBox(height: 32),
                      LoginButton(
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 24),
                      LoginFooter(textColor: textColor),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
