import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurse_system/components/login/custom_text_field.dart';
import 'package:nurse_system/components/login/error_message.dart';
import 'package:nurse_system/components/login/login_button.dart';
import 'package:nurse_system/constants/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nurse_system/services/log_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    // ตรวจสอบความถูกต้องของ Form ก่อนดำเนินการต่อ
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // เคลียร์ข้อความเก่า และแสดง Loading
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      final email = _emailController.text.trim();

      // ส่งอีเมลรีเซ็ตรหัสผ่านผ่าน Firebase Auth
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // บันทึกล็อกเมื่อรีเซ็ตรหัสผ่าน
      try {
        final platform = await LogService.detectPlatform(context);
        await LogService.logPasswordReset(email, platform);
      } catch (e) {
        print('Failed to log password reset: $e');
      }

      // แสดงข้อความสำเร็จ
      setState(() {
        _successMessage = 'กรุณาตรวจสอบอีเมลของคุณเพื่อรีเซ็ตรหัสผ่าน';
      });
    } on FirebaseAuthException catch (e) {
      // จัดการกับข้อผิดพลาดจาก Firebase Auth
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'ไม่พบบัญชีผู้ใช้ที่ใช้อีเมลนี้';
          break;
        case 'invalid-email':
          message = 'รูปแบบอีเมลไม่ถูกต้อง';
          break;
        default:
          message = 'เกิดข้อผิดพลาด: ${e.message}';
      }
      setState(() {
        _errorMessage = message;
      });
      print('Reset password failed: ${e.code} - ${e.message}');
    } catch (e) {
      // จัดการกับข้อผิดพลาดอื่นๆ
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาดในการรีเซ็ตรหัสผ่าน: ${e.toString()}';
      });
      print('Reset password process failed: $e');
    } finally {
      // ซ่อน Loading Indicator เมื่อเสร็จสิ้น
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 70, // เพิ่มความสูงของ toolbar
      ),
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
                      Image.asset(
                        'assets/images/logo.png',
                        height: 150,
                        width: 100,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "รีเซ็ตรหัสผ่าน",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.prompt(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "กรุณากรอกอีเมลของคุณ เราจะส่งลิงก์สำหรับรีเซ็ตรหัสผ่านให้คุณ",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.prompt(
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "อีเมล",
                        style: GoogleFonts.prompt(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _emailController,
                        textColor: textColor,
                        hintText: "กรอกอีเมลของคุณ",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'กรุณากรอกอีเมล';
                          }
                          // ตรวจสอบรูปแบบอีเมล
                          final emailRegex =
                              RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                          if (!emailRegex.hasMatch(value)) {
                            return 'กรุณากรอกอีเมลที่ถูกต้อง';
                          }
                          return null;
                        },
                      ),
                      if (_errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ErrorMessage(message: _errorMessage),
                      ],
                      if (_successMessage.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Text(
                            _successMessage,
                            style: GoogleFonts.prompt(
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      LoginButton(
                        onPressed: _handleResetPassword,
                        isLoading: _isLoading,
                        text: 'ส่งลิงก์รีเซ็ตรหัสผ่าน',
                      ),
                      const SizedBox(height: 24),
                      // แทนที่ TextButton เดิมด้วยโค้ดนี้
                      Container(
                        alignment: Alignment.center,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            side: BorderSide(
                              color: isDarkMode
                                  ? AppStyles.primaryColor.withOpacity(0.7)
                                  : AppStyles.primaryColor,
                              width: 1.5,
                            ),
                            backgroundColor: isDarkMode
                                ? AppStyles.primaryColor.withOpacity(0.1)
                                : AppStyles.primaryColor.withOpacity(0.05),
                          ),
                          icon: Icon(
                            Icons.login_rounded,
                            size: 20,
                            color: AppStyles.primaryColor,
                          ),
                          label: Text(
                            'กลับไปหน้าเข้าสู่ระบบ',
                            style: GoogleFonts.prompt(
                              fontSize: 15,
                              color: AppStyles.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
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
