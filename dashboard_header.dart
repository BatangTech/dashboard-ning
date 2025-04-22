import 'package:flutter/material.dart';
import 'package:nurse_system/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardHeader extends StatelessWidget {
  final int selectedIndex;
  final String currentDate;

  const DashboardHeader({
    Key? key,
    required this.selectedIndex,
    required this.currentDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black87 : AppColors.cardColor;
    final textColor = isDarkMode ? Colors.white : AppColors.primaryColor;
    final iconColor = isDarkMode ? Colors.white : AppColors.primaryColor;
    final accentColor = isDarkMode ? Colors.white70 : const Color.fromARGB(255, 255, 255, 255);
    final dateBackgroundColor = isDarkMode
        ? Colors.grey[800]!
        : AppColors.primaryColor.withOpacity(0.05);

    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                selectedIndex == 0
                    ? Icons.dashboard_rounded
                    : Icons.person_outline_rounded,
                size: 18,
                color: iconColor,
              ),
              const SizedBox(width: 8),
              Text(
                selectedIndex == 0 ? 'หน้าหลัก' : 'ตารางข้อมูล',
                style: GoogleFonts.prompt(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          // แสดงวันที่ปัจจุบัน
          _buildDateDisplay(dateBackgroundColor, textColor, iconColor),
          const SizedBox(width: 12),
          // แสดงข้อมูลผู้ใช้
          _buildUserInfo(accentColor, iconColor),
        ],
      ),
    );
  }

  Widget _buildDateDisplay(
      Color backgroundColor, Color textColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 14,
            color: iconColor,
          ),
          const SizedBox(width: 6),
          Text(
            currentDate,
            style: GoogleFonts.prompt(
              fontSize: 12,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(Color backgroundColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: backgroundColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.person,
                size: 16,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'ผู้ดูแลระบบ',
            style: GoogleFonts.prompt(
              fontSize: 13,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: iconColor,
          ),
        ],
      ),
    );
  }
}
