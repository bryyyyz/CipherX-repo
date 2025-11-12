import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/cipher/atbash_screen.dart';
import 'screens/cipher/caesar_screen.dart';
import 'screens/cipher/vigenere_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/currency_screen.dart';
import 'screens/jokes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CipherX Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/cipher/atbash': (context) => const AtbashScreen(),
        '/cipher/caesar': (context) => const CaesarScreen(),
        '/cipher/vigenere': (context) => const VigenereScreen(),
        '/calculator': (context) => const CalculatorScreen(),
        '/currency': (context) => const CurrencyScreen(),
        '/jokes': (context) => const JokesScreen(),
      },
    );
  }
}
