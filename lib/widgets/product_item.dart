import 'package:flutter/material.dart';
import '../models/produit.dart';

class ProductItem extends StatelessWidget {
  final Produit produit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductItem({
    required this.produit,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            produit.quantite.toString(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          produit.nom,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Prix: ${produit.prix.toStringAsFixed(2)} €'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouton Modifier
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: onEdit,
            ),
            // Bouton Supprimer
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}