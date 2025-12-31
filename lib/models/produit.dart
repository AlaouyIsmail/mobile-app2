class Produit {
  int? id;
  String nom;
  double prix;
  int quantite;

  Produit({this.id, required this.nom, required this.prix, required this.quantite});

  Map<String, dynamic> toMap() => {'id': id, 'nom': nom, 'prix': prix, 'quantite': quantite};

  factory Produit.fromMap(Map<String, dynamic> map) => Produit(
    id: map['id'], nom: map['nom'], prix: map['prix'], quantite: map['quantite'],
  );
}
