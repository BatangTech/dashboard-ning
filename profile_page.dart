import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:nurse_system/components/setting/custom_profile.dart';

import 'package:nurse_system/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:nurse_system/provider/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  final String displayName;
  final String email;
  final String password;

  const ProfilePage({
    Key? key,
    required this.displayName,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _userDataFuture;
  String _displayName = '';
  String _email = '';
  String _role = '';
  String _lastLogin = '';
  String _createdAt = '';
  String? _photoURL;

  @override
  void initState() {
    super.initState();
    _displayName = widget.displayName;
    _email = widget.email;
    _userDataFuture = _loadUserData();
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    try {
      // ดึงข้อมูลผู้ใช้ปัจจุบัน
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return {
          'displayName': _displayName,
          'email': _email,
          'role': 'ผู้ดูแลระบบ',
          'lastLogin': DateTime.now(),
          'createdAt': DateTime.now(),
          'photoURL': null,
        };
      }

      // ดึงข้อมูลจาก Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _displayName = data['displayName'] ?? widget.displayName;
          _email = data['email'] ?? widget.email;
          _role = data['role'] == 'admin' ? 'ผู้ดูแลระบบ' : 'ผู้ใช้งาน';
          _photoURL = data['photoURL'];

          // แปลงวันที่เป็นรูปแบบไทย
          if (data['lastLogin'] != null) {
            final lastLogin = (data['lastLogin'] as Timestamp).toDate();
            _lastLogin =
                DateFormat('dd/MM/yyyy HH:mm', 'th_TH').format(lastLogin);
          } else {
            _lastLogin = 'ไม่พบข้อมูล';
          }

          if (data['createdAt'] != null) {
            final createdAt = (data['createdAt'] as Timestamp).toDate();
            _createdAt =
                DateFormat('dd/MM/yyyy HH:mm', 'th_TH').format(createdAt);
          } else {
            _createdAt = 'ไม่พบข้อมูล';
          }
        });
        return data;
      }

      return {
        'displayName': _displayName,
        'email': _email,
        'role': 'ผู้ดูแลระบบ',
        'lastLogin': DateTime.now(),
        'createdAt': DateTime.now(),
        'photoURL': null,
      };
    } catch (e) {
      print('Error loading user data: $e');
      return {
        'displayName': _displayName,
        'email': _email,
        'role': 'ผู้ดูแลระบบ',
        'lastLogin': DateTime.now(),
        'createdAt': DateTime.now(),
        'photoURL': null,
      };
    }
  }

  Future<void> _refreshUserData() async {
    setState(() {
      _userDataFuture = _loadUserData();
    });
  }

  

  

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final backgroundColor = isDarkMode
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;
    final cardColor = isDarkMode ? const Color(0xFF2C2C2C) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'เกิดข้อผิดพลาด: ${snapshot.error}',
                style: GoogleFonts.prompt(color: textColor),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: cardColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // รูปโปรไฟล์
                        CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              AppColors.primaryColor.withOpacity(0.2),
                          child: _photoURL != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    _photoURL!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: 50,
                                        color: AppColors.primaryColor,
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppColors.primaryColor,
                                ),
                        ),
                        const SizedBox(height: 16),
                        // ชื่อ
                        Text(
                          _displayName,
                          style: GoogleFonts.prompt(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // อีเมล
                        Text(
                          _email,
                          style: GoogleFonts.prompt(
                            fontSize: 16,
                            color: textColor.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // ตำแหน่ง
                        
                        // ปุ่มแก้ไขโปรไฟล์
                        
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // ข้อมูลการใช้งาน
              ],
            ),
          );
        },
      ),
    );
  }

 
}
