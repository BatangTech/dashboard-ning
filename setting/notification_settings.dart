import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_item.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool allNotifications = true;
  bool appointmentNotifications = true;
  bool medicationNotifications = true;
  bool systemNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'การแจ้งเตือน',
          style: GoogleFonts.prompt(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text('การแจ้งเตือนทั้งหมด', style: GoogleFonts.prompt()),
            value: allNotifications,
            onChanged: (value) {
              setState(() {
                allNotifications = value;
                if (!value) {
                  appointmentNotifications = false;
                  medicationNotifications = false;
                  systemNotifications = false;
                }
              });
            },
          ),
          const Divider(),
          
          SwitchListTile(
            title: Text('แจ้งเตือนการนัดหมาย', style: GoogleFonts.prompt()),
            subtitle: Text('รับการแจ้งเตือนเกี่ยวกับการนัดหมาย', style: GoogleFonts.prompt()),
            value: allNotifications && appointmentNotifications,
            onChanged: allNotifications ? (value) {
              setState(() {
                appointmentNotifications = value;
              });
            } : null,
          ),
          const Divider(),
          
          SwitchListTile(
            title: Text('แจ้งเตือนยา', style: GoogleFonts.prompt()),
            subtitle: Text('รับการแจ้งเตือนเกี่ยวกับการทานยา', style: GoogleFonts.prompt()),
            value: allNotifications && medicationNotifications,
            onChanged: allNotifications ? (value) {
              setState(() {
                medicationNotifications = value;
              });
            } : null,
          ),
          const Divider(),
          
          SwitchListTile(
            title: Text('แจ้งเตือนระบบ', style: GoogleFonts.prompt()),
            subtitle: Text('รับการแจ้งเตือนเกี่ยวกับการอัปเดตระบบ', style: GoogleFonts.prompt()),
            value: allNotifications && systemNotifications,
            onChanged: allNotifications ? (value) {
              setState(() {
                systemNotifications = value;
              });
            } : null,
          ),
        ],
      ),
    );
  }
}