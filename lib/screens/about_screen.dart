import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À Propos de l\'Application'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gestion de Stock (Projet Universitaire)',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const Divider(height: 30, thickness: 2),

            // Objectifs
            const Text(
              'Objectifs du Projet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ce projet a été développé dans le cadre d\'un TP/Projet universitaire pour démontrer la maîtrise des concepts de développement mobile Flutter et de la gestion de données locales (CRUD).',
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 20),

            // Technologie
            const Text(
              'Technologies Utilisées',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            buildTechList([
              'Framework: Flutter (Dart)',
              'Base de Données: SQLite (via sqflite)',
              'Interface: Material Design',
              'Architecture: Models, DB Helpers, Screens',
            ]),

            const SizedBox(height: 20),

            // Version
            const Text(
              'Version',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Text(
              'V 1.0.0 - Première version CRUD complète.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                'Développé par [ISMAIL ALAOUY / TAREK AHMRE]',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Liste simplifiée des technologies
  Widget buildTechList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 4),
        child: Text('• $item', style: const TextStyle(fontSize: 16)),
      ))
          .toList(),
    );
  }
}
