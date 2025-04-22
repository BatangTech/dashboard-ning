import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เกี่ยวกับแอป', style: GoogleFonts.prompt())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('เวอร์ชัน: 1.0.0'),
            SizedBox(height: 10),
            Text('แอปนี้พัฒนาเพื่อช่วยดูแลสุขภาพของคุณอย่างยั่งยืน'),
          ],
        ),
      ),
    );
  }
}
