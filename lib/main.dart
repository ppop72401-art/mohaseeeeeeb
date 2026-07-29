import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';
import 'package:google_fonts/google_fonts.dart';

import 'logic/providers/analytics_provider.dart';
import 'presentation/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()..fetchAnalytics()),
      ],
      child: const MassiveAccountingApp(),
    ),
  );
}

class MassiveAccountingApp extends StatelessWidget {
  const MassiveAccountingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Massive ERP',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // وضع ليلي افتراضي لفخامة التطبيق
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          surface: Color(0xFF2A2D3E),
        ),
        textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
      ),
      home: const DashboardScreen(),
    );
  }
}
