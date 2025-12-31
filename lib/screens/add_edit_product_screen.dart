import 'package:flutter/material.dart';
import '../models/produit.dart';
import '../database/db_helper.dart';

class AddEditProductScreen extends StatefulWidget {
  final Produit? produit; // Null si c'est un ajout
  const AddEditProductScreen({this.produit, super.key});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prixController = TextEditingController();
  final _quantiteController = TextEditingController();

  // Initialisation des champs si on est en mode modification
  @override
  void initState() {
    super.initState();
    if (widget.produit != null) {
      _nomController.text = widget.produit!.nom;
      _prixController.text = widget.produit!.prix.toString();
      _quantiteController.text = widget.produit!.quantite.toString();
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prixController.dispose();
    _quantiteController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final nom = _nomController.text;
      final prix = double.tryParse(_prixController.text) ?? 0.0;
      final quantite = int.tryParse(_quantiteController.text) ?? 0;

      final newProduct = Produit(
        id: widget.produit?.id, // Garde l'ID pour la modification
        nom: nom,
        prix: prix,
        quantite: quantite,
      );

      final dbHelper = DBHelper();
      if (widget.produit == null) {
        // Mode Ajout (CREATE)
        await dbHelper.insertProduit(newProduct);
      } else {
        // Mode Modification (UPDATE)
        await dbHelper.updateProduit(newProduct);
      }

      // Retourne à l'écran précédent (et déclenche un rechargement)
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.produit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier Produit' : 'Ajouter Produit'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom du Produit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prixController,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (double.tryParse(value ?? '') == null) {
                    return 'Veuillez entrer un prix valide';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantiteController,
                decoration: const InputDecoration(labelText: 'Quantité'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (int.tryParse(value ?? '') == null) {
                    return 'Veuillez entrer une quantité entière';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: Icon(isEditing ? Icons.save : Icons.add),
                label: Text(isEditing ? 'Sauvegarder les modifications' : 'Ajouter le produit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}