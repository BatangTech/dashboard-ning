import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nurse_system/firebase_option.dart';
import 'package:nurse_system/pages/dashboard_pages.dart';
import 'package:nurse_system/pages/login_pages.dart';
import 'package:nurse_system/provider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        primarySwatch: themeProvider.primaryColor,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      darkTheme: ThemeData(
        primarySwatch: themeProvider.primaryColor,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: const LoginPage(),
    );
  }
}
