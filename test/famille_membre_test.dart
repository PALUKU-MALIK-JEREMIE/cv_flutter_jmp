import 'package:flutter_test/flutter_test.dart';
import 'package:cv_flutter_jmp/models/famille_membre.dart';

void main() {
  test('Un membre est bien lu depuis le JSON de l’API', () {
    final m = FamilleMembre.fromJson({
      'id': 3,
      'nom': 'ARAMA',
      'postnom': 'Bigega',
      'prenom': 'Hussein',
      'lieu_naissance': 'Goma',
      'date_naissance': '1970-05-12',
      'parente': 'Père',
      'image_url': null,
    });
    expect(m.id, 3);
    expect(m.nomComplet, 'Hussein ARAMA Bigega');
    expect(m.imageUrl, isNull);
  });

  test('Les champs envoyés ont les noms des colonnes de la base', () {
    const m = FamilleMembre(
      nom: 'ARAMA',
      postnom: 'Bigega',
      prenom: 'Hussein',
      lieuNaissance: 'Goma',
      dateNaissance: '1970-05-12',
      parente: 'Père',
    );
    expect(m.toFields()['lieu_naissance'], 'Goma');
    expect(m.toFields()['date_naissance'], '1970-05-12');
  });
}
