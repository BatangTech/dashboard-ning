import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurse_system/components/setting/about_app_page.dart';
import 'package:nurse_system/components/setting/notification_settings.dart';
import 'package:nurse_system/components/setting/privacy_settings.dart';
import 'package:nurse_system/components/setting/security_settings.dart';
import 'package:nurse_system/components/setting/settings_item.dart';
import 'package:nurse_system/constants/colors.dart';
import 'package:nurse_system/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required String displayName}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = 'ไทย'; // ค่าเริ่มต้นภาษา

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final backgroundColor = isDarkMode
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;

    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildHeader(context, textColor),
            SwitchListTile(
              title: Text(
                'เปิดโหมดมืด',
                style: GoogleFonts.prompt(fontSize: 16, color: textColor),
              ),
              value: isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
              secondary: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: textColor,
              ),
            ),
            _buildLanguageDropdown(textColor),
            SettingsItem(
              icon: Icons.notifications_outlined,
              title: 'การแจ้งเตือน',
              subtitle: 'เปิด/ปิด และจัดการการแจ้งเตือน',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationSettingsPage()),
                );
              },
            ),
            SettingsItem(
              icon: Icons.privacy_tip_outlined,
              title: 'ความเป็นส่วนตัว',
              subtitle: 'จัดการข้อมูลส่วนบุคคลและความปลอดภัย',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PrivacySettingsPage()));
              },
            ),
            SettingsItem(
              icon: Icons.lock_outline,
              title: 'ความปลอดภัย',
              subtitle: 'ตั้งค่าการยืนยันตัวตน',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SecuritySettingsPage()));
              },
            ),
            SettingsItem(
              icon: Icons.info_outline,
              title: 'เกี่ยวกับแอป',
              subtitle: 'เวอร์ชัน ปัญหา และข้อมูลเพิ่มเติม',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AboutAppPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color textColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(
          'ตั้งค่าระบบ',
          style: GoogleFonts.prompt(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ภาษา',
            style: GoogleFonts.prompt(
              fontSize: 16,
              color: textColor,
            ),
          ),
          DropdownButton<String>(
            value: selectedLanguage,
            underline: const SizedBox(),
            dropdownColor: Theme.of(context).cardColor,
            style: GoogleFonts.prompt(color: textColor),
            items: <String>['ไทย', 'English'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedLanguage = newValue;
                  // TODO: ใส่ logic เปลี่ยนภาษาจริง ๆ ที่นี่
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
