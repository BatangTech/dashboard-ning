import 'package:flutter/material.dart';
import 'package:nurse_system/constants/colors.dart';
import 'package:nurse_system/pages/dashboard_content.dart';
import 'package:nurse_system/pages/settings_page.dart';
import 'package:nurse_system/pages/table_pages.dart';
import 'package:nurse_system/pages/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:nurse_system/provider/theme_provider.dart';
import '../widgets/dashboard/dashboard_drawer.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/dashboard_sidebar.dart';
import '../widgets/dashboard/sign_out_dialog.dart';

class DashboardPage extends StatefulWidget {
  final String displayName; // Added this
  final String email;
  final String password;

  const DashboardPage({
    Key? key,
    required this.displayName,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final String _currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  void _handleNavigation(int index) {
    if (index == 2) {
      _handleSignOut();
      return;
    }

    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _handleSignOut() {
    showDialog(
      context: context,
      builder: (context) => SignOutDialog(
        onConfirm: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
    );
  }

  Widget _getSelectedContentWidget() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardContent();
      case 1:
        return const TablePage();
      case 3:
        return SettingsPage(displayName: widget.displayName); // ส่ง displayName ไปยัง SettingsPage
      case 4:
        return ProfilePage(
          displayName: widget.displayName,
          email: widget.email,
          password: widget.password,
        ); // ส่ง displayName, email, และ password ไปยัง ProfilePage
      default:
        return const DashboardContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1000;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: isWideScreen
          ? null
          : AppBar(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              title: Text(
                'ระบบ NCDs',
                style: GoogleFonts.prompt(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      drawer: isWideScreen
          ? null
          : DashboardDrawer(
              selectedIndex: _selectedIndex,
              onNavigation: _handleNavigation,
            ),
      body: isWideScreen
          ? Row(
              children: [
                DashboardSidebar(
                  selectedIndex: _selectedIndex,
                  onNavigation: _handleNavigation,
                ),
                Expanded(
                  child: _buildMainContent(themeProvider),
                ),
              ],
            )
          : _buildMainContent(themeProvider),
    );
  }

  Widget _buildMainContent(ThemeProvider themeProvider) {
    return Column(
      children: [
        DashboardHeader(
          selectedIndex: _selectedIndex,
          currentDate: _currentDate,
        ),
        Expanded(
          child: Container(
            color: themeProvider.themeMode == ThemeMode.dark
                ? AppColors.darkBackgroundColor
                : AppColors.lightBackgroundColor,
            child: _getSelectedContentWidget(),
          ),
        ),
      ],
    );
  }
}