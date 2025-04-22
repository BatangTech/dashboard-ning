import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  // Settings states
  bool _allowAnalytics = true;
  bool _allowEmailNotifications = true;
  bool _allowPushNotifications = true;
  bool _allowDataForServiceImprovement = true;
  bool _allowHealthDataForResearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ความเป็นส่วนตัว',
          style: GoogleFonts.prompt(fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('การเก็บข้อมูลและการวิเคราะห์'),
          SwitchListTile(
            title:
                Text('อนุญาตการวิเคราะห์ข้อมูล', style: GoogleFonts.prompt()),
            subtitle: Text(
              'อนุญาตให้เราเก็บข้อมูลการใช้งานเพื่อปรับปรุงแอปพลิเคชัน',
              style: GoogleFonts.prompt(fontSize: 14),
            ),
            value: _allowAnalytics,
            onChanged: (value) {
              setState(() {
                _allowAnalytics = value;
              });
            },
          ),
          SwitchListTile(
            title: Text(
              'ใช้ข้อมูลการสนทนาเพื่อปรับปรุงบริการ',
              style: GoogleFonts.prompt(),
            ),
            subtitle: Text(
              'อนุญาตให้ใช้ข้อมูลการสนทนาในการพัฒนา chatbot',
              style: GoogleFonts.prompt(fontSize: 14),
            ),
            value: _allowDataForServiceImprovement,
            onChanged: (value) {
              setState(() {
                _allowDataForServiceImprovement = value;
              });
            },
          ),
          SwitchListTile(
            title: Text(
              'อนุญาตให้ใช้ข้อมูลสุขภาพเพื่อการวิจัย NCDs',
              style: GoogleFonts.prompt(),
            ),
            subtitle: Text(
              'ข้อมูลจะถูกนำไปใช้โดยไม่ระบุตัวตนเพื่อการวิจัยโรคไม่ติดต่อเรื้อรัง',
              style: GoogleFonts.prompt(fontSize: 14),
            ),
            value: _allowHealthDataForResearch,
            onChanged: (value) {
              setState(() {
                _allowHealthDataForResearch = value;
              });
            },
          ),
          _buildSectionHeader('การแจ้งเตือน'),
          SwitchListTile(
            title: Text('การแจ้งเตือนผ่านอีเมล', style: GoogleFonts.prompt()),
            value: _allowEmailNotifications,
            onChanged: (value) {
              setState(() {
                _allowEmailNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('การแจ้งเตือนผ่านมือถือ', style: GoogleFonts.prompt()),
            value: _allowPushNotifications,
            onChanged: (value) {
              setState(() {
                _allowPushNotifications = value;
              });
            },
          ),
          _buildSectionHeader('จัดการข้อมูลส่วนตัว'),
          ListTile(
            title: Text('ลบประวัติการสนทนา', style: GoogleFonts.prompt()),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to delete chat history screen
              _showConfirmationDialog(
                'ลบประวัติการสนทนา',
                'คุณต้องการลบประวัติการสนทนาทั้งหมดหรือไม่? การกระทำนี้ไม่สามารถเรียกคืนได้',
              );
            },
          ),
          ListTile(
            title: Text('ดาวน์โหลดข้อมูลส่วนตัว', style: GoogleFonts.prompt()),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to download personal data screen
              _showSnackBar(
                  'เริ่มเตรียมข้อมูลสำหรับดาวน์โหลด คุณจะได้รับการแจ้งเตือนเมื่อพร้อม');
            },
          ),
          ListTile(
            title: Text('ลบบัญชีผู้ใช้', style: GoogleFonts.prompt()),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to account deletion screen
              _showConfirmationDialog(
                'ลบบัญชีผู้ใช้',
                'คุณแน่ใจหรือไม่ที่จะลบบัญชีผู้ใช้? ข้อมูลทั้งหมดจะถูกลบอย่างถาวร',
              );
            },
          ),
          _buildSectionHeader('ข้อมูลเพิ่มเติม'),
          ListTile(
            title: Text('นโยบายความเป็นส่วนตัว', style: GoogleFonts.prompt()),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to privacy policy
            },
          ),
          ListTile(
            title: Text('ข้อกำหนดการใช้งาน', style: GoogleFonts.prompt()),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to terms of service
            },
          ),
          ListTile(
            title: Text('วิธีการใช้ข้อมูลของคุณ', style: GoogleFonts.prompt()),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to data usage information
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.prompt(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  void _showConfirmationDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
              style: GoogleFonts.prompt(fontWeight: FontWeight.bold)),
          content: Text(content, style: GoogleFonts.prompt()),
          actions: [
            TextButton(
              child: Text('ยกเลิก', style: GoogleFonts.prompt()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยืนยัน', style: GoogleFonts.prompt()),
              onPressed: () {
                Navigator.of(context).pop();
                _showSnackBar('ดำเนินการเรียบร้อย');
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.prompt()),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
