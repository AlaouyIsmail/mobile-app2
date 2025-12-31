import 'package:flutter/material.dart';
import '../models/produit.dart';
import '../database/db_helper.dart';
import '../widgets/product_item.dart';
import 'add_edit_product_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<List<Produit>> produitsFuture;

  void loadProducts() {
    setState(() {
      produitsFuture = DBHelper.getAll();
    });
  }

  void deleteProduct(int id, String nom) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer $nom du stock ?'),
        actions: [
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
      await DBHelper.delete(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$nom supprimé.')),
        );
      }
      loadProducts();
    }
  }

  void navigateToEdit(Produit produit) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => AddEditProductScreen(produit: produit),
      ),
    );
    if (result == true) loadProducts();
  }

  void navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const AddEditProductScreen(),
      ),
    );
    if (result == true) loadProducts();
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de Stock'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.inventory_2, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Menu du Stock',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil (Stock)'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('À Propos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => const AboutScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Produit>>(
        future: produitsFuture,
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
            final produits = snapshot.data!;
            return ListView.builder(
              itemCount: produits.length,
              itemBuilder: (ctx, index) {
                final produit = produits[index];
                return ProductItem(
                  produit: produit,
                  onEdit: () => navigateToEdit(produit),
                  onDelete: () => deleteProduct(produit.id!, produit.nom),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAdd,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
