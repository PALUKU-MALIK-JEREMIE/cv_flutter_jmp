/// Un membre de la famille, tel qu'il est stocké dans la table `famille_membre`.
class FamilleMembre {
  final int? id; // null tant que le membre n'est pas encore enregistré
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance; // format AAAA-MM-JJ
  final String parente; // ex. Père, Mère, Frère
  final String? imageUrl; // adresse complète de la photo, ou null

  const FamilleMembre({
    this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  /// Construit un membre à partir du JSON renvoyé par l'API.
  factory FamilleMembre.fromJson(Map<String, dynamic> json) {
    return FamilleMembre(
      id: int.tryParse(json['id'].toString()),
      nom: (json['nom'] ?? '').toString(),
      postnom: (json['postnom'] ?? '').toString(),
      prenom: (json['prenom'] ?? '').toString(),
      lieuNaissance: (json['lieu_naissance'] ?? '').toString(),
      dateNaissance: (json['date_naissance'] ?? '').toString(),
      parente: (json['parente'] ?? '').toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }

  /// Champs envoyés à l'API (mêmes noms que les colonnes de la base).
  Map<String, String> toFields() => {
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'lieu_naissance': lieuNaissance,
        'date_naissance': dateNaissance,
        'parente': parente,
      };

  String get nomComplet => '$prenom $nom $postnom';

  String get initiales =>
      '${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}'
          .toUpperCase();
}
