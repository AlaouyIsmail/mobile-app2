import 'package:flutter/material.dart';
import '../models/produit.dart';
import '../database/db_helper.dart';
import '../widgets/product_item.dart';
import 'add_edit_product_screen.dart';
import 'about_screen.dart'; // <-- Importation de la nouvelle page 'À Propos'

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Produit>> _produitsFuture;
  final DBHelper _dbHelper = DBHelper();

  // Charger les données de la base de données
  void _loadProducts() {
    setState(() {
      _produitsFuture = _dbHelper.getProduits();
    });
  }

  // Suppression d'un produit (DELETE)
  void _deleteProduct(int id, String nom) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer $nom du stock ?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _dbHelper.deleteProduit(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$nom supprimé.')),
        );
      }
      _loadProducts(); // Recharger la liste après la suppression
    }
  }

  // Navigation vers l'écran de modification (UPDATE)
  void _navigateToEdit(Produit produit) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => AddEditProductScreen(produit: produit),
      ),
    );
    if (result == true) {
      _loadProducts(); // Recharger la liste si une modification a eu lieu
    }
  }

  // Navigation vers l'écran d'ajout (CREATE)
  void _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const AddEditProductScreen(),
      ),
    );
    if (result == true) {
      _loadProducts(); // Recharger la liste si un ajout a eu lieu
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Premier chargement
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de Stock'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      // --- DÉBUT DU MENU LATÉRAL (DRAWER) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.inventory_2, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Menu du Stock',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Lien vers la page Principale
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil (Stock)'),
              onTap: () {
                Navigator.pop(context); // Ferme le drawer
              },
            ),
            const Divider(),
            // Lien vers la page À Propos
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('À Propos'),
              onTap: () {
                Navigator.pop(context); // Ferme le drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
          ],
        ),
      ),
      // --- FIN DU MENU LATÉRAL (DRAWER) ---

      body: FutureBuilder<List<Produit>>(
        future: _produitsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Aucun produit en stock. Ajoutez-en un !',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            // Affichage de la liste (READ)
            final produits = snapshot.data!;
            return ListView.builder(
              itemCount: produits.length,
              itemBuilder: (ctx, index) {
                final produit = produits[index];
                return ProductItem(
                  produit: produit,
                  onEdit: () => _navigateToEdit(produit),
                  onDelete: () => _deleteProduct(produit.id!, produit.nom),
                );
              },
            );
          }
        },
      ),
      // Bouton flottant pour l'ajout (CREATE)
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}