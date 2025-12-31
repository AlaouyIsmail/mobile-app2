import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  // Assure que les Widgets binding sont initialisés avant d'accéder à la base de données
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StockManagerApp());
}

class StockManagerApp extends StatelessWidget {
  const StockManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Stock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}