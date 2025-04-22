import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _usePin = false;
  bool _useFingerprint = false;
  bool _useFaceId = false;
  bool _autoLock = false;
  bool _hideNotifications = false;
  bool _isLoading = true;

  String _autoLockTime = '1 นาที';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _usePin = prefs.getBool('usePin') ?? false;
        _useFingerprint = prefs.getBool('useFingerprint') ?? false;
        _useFaceId = prefs.getBool('useFaceId') ?? false;
        _autoLock = prefs.getBool('autoLock') ?? false;
        _hideNotifications = prefs.getBool('hideNotifications') ?? false;
        _autoLockTime = prefs.getString('autoLockTime') ?? '1 นาที';
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    } catch (e) {
      debugPrint('Error saving setting: $e');
    }
  }

  void _showPinDialog() {
    final TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text('กำหนดรหัส PIN',
            style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            labelText: 'กรุณากรอกรหัส PIN ที่มีความยาวระหว่าง 4 ถึง 6 หลัก',
            labelStyle: GoogleFonts.prompt(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิกการดำเนินการ', style: GoogleFonts.prompt()),
          ),
          ElevatedButton(
            onPressed: () {
              if (pinController.text.length >= 4) {
                Navigator.pop(context);
                setState(() => _usePin = true);
                _saveSetting('usePin', true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ระบบได้บันทึกรหัส PIN ของท่านเรียบร้อยแล้ว',
                        style: GoogleFonts.prompt()),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'กรุณากรอกรหัส PIN ที่มีความยาวอย่างน้อย 4 หลัก',
                        style: GoogleFonts.prompt()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('ยืนยัน', style: GoogleFonts.prompt()),
          ),
        ],
      ),
    );
  }

  void _showTimerDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('เลือกระยะเวลาในการล็อคอัตโนมัติ',
            style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
        children: [
          _buildTimeOption('30 วินาที'),
          _buildTimeOption('1 นาที'),
          _buildTimeOption('5 นาที'),
          _buildTimeOption('15 นาที'),
          _buildTimeOption('30 นาที'),
          _buildTimeOption('1 ชั่วโมง'),
        ],
      ),
    );
  }

  Widget _buildTimeOption(String time) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() => _autoLockTime = time);
        _saveSetting('autoLockTime', time);
        Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(time, style: GoogleFonts.prompt()),
          if (_autoLockTime == time)
            const Icon(Icons.check, color: Colors.blue),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
            title: Text('การตั้งค่าความปลอดภัย', style: GoogleFonts.prompt())),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('การตั้งค่าความปลอดภัย', style: GoogleFonts.prompt()),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _sectionTitle('การยืนยันตัวตน'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  title: Text('การใช้งานรหัส PIN เพื่อเข้าสู่ระบบ',
                      style: GoogleFonts.prompt()),
                  subtitle: Text('เพิ่มความปลอดภัยในการเข้าสู่ระบบด้วยรหัส PIN',
                      style: GoogleFonts.prompt(fontSize: 12)),
                  trailing: Switch(
                    value: _usePin,
                    activeColor: Colors.blue,
                    onChanged: (value) => value
                        ? _showPinDialog()
                        : setState(() => _usePin = false),
                  ),
                ),
                const Divider(indent: 16, endIndent: 16),
                ListTile(
                  title:
                      Text('การใช้งานลายนิ้วมือ', style: GoogleFonts.prompt()),
                  subtitle: Text('เข้าสู่ระบบด้วยลายนิ้วมือของท่าน',
                      style: GoogleFonts.prompt(fontSize: 12)),
                  leading: const Icon(Icons.fingerprint),
                  trailing: Switch(
                    value: _useFingerprint,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() => _useFingerprint = value);
                      _saveSetting('useFingerprint', value);
                    },
                  ),
                ),
                const Divider(indent: 16, endIndent: 16),
                ListTile(
                  title: Text('การใช้งาน Face ID', style: GoogleFonts.prompt()),
                  subtitle: Text('เข้าสู่ระบบด้วยการสแกนใบหน้า',
                      style: GoogleFonts.prompt(fontSize: 12)),
                  leading: const Icon(Icons.face),
                  trailing: Switch(
                    value: _useFaceId,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() => _useFaceId = value);
                      _saveSetting('useFaceId', value);
                    },
                  ),
                ),
              ],
            ),
          ),
          _sectionTitle('การล็อคอัตโนมัติ'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  title: Text('เปิดใช้งานการล็อคอัตโนมัติ',
                      style: GoogleFonts.prompt()),
                  subtitle: Text(
                      'ระบบจะทำการล็อคโดยอัตโนมัติเมื่อไม่มีการใช้งาน',
                      style: GoogleFonts.prompt(fontSize: 12)),
                  leading: const Icon(Icons.lock_clock),
                  trailing: Switch(
                    value: _autoLock,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() => _autoLock = value);
                      _saveSetting('autoLock', value);
                    },
                  ),
                ),
                const Divider(indent: 16, endIndent: 16),
                ListTile(
                  title: Text('ระยะเวลาในการล็อคอัตโนมัติ',
                      style: GoogleFonts.prompt()),
                  subtitle: Text(_autoLockTime,
                      style: GoogleFonts.prompt(fontSize: 12)),
                  leading: const Icon(Icons.timer),
                  trailing: _autoLock
                      ? const Icon(Icons.arrow_forward_ios, size: 16)
                      : const SizedBox(width: 16),
                  enabled: _autoLock,
                  onTap: _autoLock ? _showTimerDialog : null,
                ),
              ],
            ),
          ),
          _sectionTitle('การแจ้งเตือนและความเป็นส่วนตัว'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text('การปกปิดเนื้อหาการแจ้งเตือน',
                  style: GoogleFonts.prompt()),
              subtitle: Text(
                  'ปิดการแสดงผลข้อความแจ้งเตือนบนหน้าจอล็อกเพื่อรักษาความเป็นส่วนตัว',
                  style: GoogleFonts.prompt(fontSize: 12)),
              leading: const Icon(Icons.notifications_off),
              trailing: Switch(
                value: _hideNotifications,
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() => _hideNotifications = value);
                  _saveSetting('hideNotifications', value);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('รีเซ็ตการตั้งค่า',
                        style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
                    content: Text(
                        'คุณต้องการรีเซ็ตการตั้งค่าความปลอดภัยทั้งหมดหรือไม่?',
                        style: GoogleFonts.prompt()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('ยกเลิกการดำเนินการ',
                            style: GoogleFonts.prompt()),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          setState(() => _isLoading = true);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          setState(() {
                            _usePin = false;
                            _useFingerprint = false;
                            _useFaceId = false;
                            _autoLock = false;
                            _hideNotifications = false;
                            _autoLockTime = '1 นาที';
                            _isLoading = false;
                          });
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'รีเซ็ตการตั้งค่าความปลอดภัยเรียบร้อยแล้ว',
                                    style: GoogleFonts.prompt()),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        child: Text('รีเซ็ตการตั้งค่า',
                            style: GoogleFonts.prompt(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.refresh),
              label: Text('รีเซ็ตการตั้งค่าความปลอดภัยทั้งหมด',
                  style: GoogleFonts.prompt()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(title,
            style: GoogleFonts.prompt(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor)),
      );
}
