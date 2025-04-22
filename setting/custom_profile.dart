import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    Key? key,
    required String content,
    Color backgroundColor = Colors.green,
    Duration duration = const Duration(seconds: 3),
  }) : super(
          key: key,
          content: Text(
            content,
            style: GoogleFonts.prompt(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          duration: duration,
        );
}
