class Produit {
  int? id;
  String nom;
  double prix;
  int quantite;

  Produit({this.id, required this.nom, required this.prix, required this.quantite});

  // Convertit un Produit en Map. La clé doit correspondre aux noms des colonnes de la DB.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prix': prix,
      'quantite': quantite,
    };
  }

  // Crée un Produit à partir d'une Map (lecture de la DB).
  Produit.fromMap(Map<String, dynamic> map)
      : id = map['id'] as int?,
        nom = map['nom'] as String,
        prix = map['prix'] as double,
        quantite = map['quantite'] as int;
}