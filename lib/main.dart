import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HandTalk',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xFF64CCC5)),
        fontFamily: 'Poppins', // Gunakan font Poppins
      ),
      home: const SplashScreen(),
    );
  }

  // Fungsi untuk membuat MaterialColor dari Color
  MaterialColor createMaterialColor(Color color) {
    Map<int, Color> colorSwatch = {
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    };
    return MaterialColor(color.value, colorSwatch);
  }
}
