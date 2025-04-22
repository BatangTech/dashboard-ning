import 'package:flutter/material.dart';
import 'package:nurse_system/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurse_system/widgets/dashboard/nav_item.dart';
import 'package:nurse_system/widgets/dashboard/sidebar_header.dart';

class DashboardSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onNavigation;

  const DashboardSidebar({
    Key? key,
    required this.selectedIndex,
    required this.onNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black87 : AppColors.cardColor;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final iconColor = isDarkMode ? Colors.white : AppColors.primaryColor;
    final dividerColor = isDarkMode ? Colors.white54 : Colors.black54;

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: _buildSidebarContent(
        context, textColor, iconColor, dividerColor, isDarkMode),
    );
  }

  Widget _buildSidebarContent(BuildContext context, Color textColor, Color iconColor, Color dividerColor, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SidebarHeader(),
        _buildWelcomeBox(textColor, iconColor),
        const SizedBox(height: 10),
        _buildMenuHeader('เมนูหลัก', Icons.apps, textColor, iconColor),
        const SizedBox(height: 8),
        NavItem(
          icon: Icons.dashboard_rounded,
          text: 'หน้าหลัก',
          index: 0,
          selectedIndex: selectedIndex,
          onTap: onNavigation,
          iconColor: iconColor,
        ),
        NavItem(
          icon: Icons.person_outline_rounded,
          text: 'ตารางข้อมูล',
          index: 1,
          selectedIndex: selectedIndex,
          onTap: onNavigation,
          iconColor: iconColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Divider(height: 1, thickness: 1, color: dividerColor),
        ),
        _buildMenuHeader('การตั้งค่า', Icons.settings_outlined, textColor, iconColor),
        const SizedBox(height: 8),
        NavItem(
          icon: Icons.settings,
          text: 'ตั้งค่าระบบ',
          index: 3,
          selectedIndex: selectedIndex,
          onTap: onNavigation,
          disabled: false,
          iconColor: iconColor,
        ),
        NavItem(
          icon: Icons.person,
          text: 'โปรไฟล์',
          index: 4,
          selectedIndex: selectedIndex,
          onTap: onNavigation,
          disabled: false,
          iconColor: iconColor,
        ),
        const Spacer(),
        Divider(height: 1, thickness: 1, color: dividerColor),
        NavItem(
          icon: Icons.logout_rounded,
          text: 'ออกจากระบบ',
          index: 2,
          selectedIndex: selectedIndex,
          onTap: onNavigation,
          isWarning: true,
          iconColor: Colors.redAccent,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildWelcomeBox(Color textColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: iconColor,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ยินดีต้อนรับสู่ระบบบริหารจัดการข้อมูล',
              style: GoogleFonts.prompt(
                fontSize: 12,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuHeader(String title, IconData icon, Color textColor, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.prompt(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
