import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const EndoSenseApp());
}

class EndoSenseApp extends StatelessWidget {
  const EndoSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EndoSense-AI',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
