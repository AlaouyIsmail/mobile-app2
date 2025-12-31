import 'package:flutter/material.dart';
import '../models/produit.dart';
import '../database/db_helper.dart';

class AddEditProductScreen extends StatefulWidget {
  final Produit? produit;
  const AddEditProductScreen({this.produit, super.key});

  @override
  State<AddEditProductScreen> createState() => AddEditProductScreenState();
}

class AddEditProductScreenState extends State<AddEditProductScreen> {
  final formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final prixController = TextEditingController();
  final quantiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.produit != null) {
      nomController.text = widget.produit!.nom;
      prixController.text = widget.produit!.prix.toString();
      quantiteController.text = widget.produit!.quantite.toString();
    }
  }

  @override
  void dispose() {
    nomController.dispose();
    prixController.dispose();
    quantiteController.dispose();
    super.dispose();
  }

  void saveProduct() async {
    if (formKey.currentState!.validate()) {
      final nom = nomController.text;
      final prix = double.tryParse(prixController.text) ?? 0.0;
      final quantite = int.tryParse(quantiteController.text) ?? 0;

      final newProduct = Produit(
        id: widget.produit?.id,
        nom: nom,
        prix: prix,
        quantite: quantite,
      );

      if (widget.produit == null) {
        await DBHelper.insert(newProduct);
      } else {
        await DBHelper.update(newProduct);
      }

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
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nom du Produit'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Veuillez entrer un nom' : null,
              ),
              TextFormField(
                controller: prixController,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value ?? '') == null
                    ? 'Veuillez entrer un prix valide'
                    : null,
              ),
              TextFormField(
                controller: quantiteController,
                decoration: const InputDecoration(labelText: 'Quantité'),
                keyboardType: TextInputType.number,
                validator: (value) => int.tryParse(value ?? '') == null
                    ? 'Veuillez entrer une quantité entière'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: saveProduct,
                icon: Icon(isEditing ? Icons.save : Icons.add),
                label: Text(isEditing ? 'Sauvegarder' : 'Ajouter'),
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
