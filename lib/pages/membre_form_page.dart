import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/famille_membre.dart';
import '../services/api_client.dart';
import '../services/famille_service.dart';

/// Si [membre] est null → ajout. Sinon → modification.
class MembreFormPage extends StatefulWidget {
  final FamilleMembre? membre;
  const MembreFormPage({super.key, this.membre});

  @override
  State<MembreFormPage> createState() => _MembreFormPageState();
}

class _MembreFormPageState extends State<MembreFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nom;
  late final TextEditingController _postnom;
  late final TextEditingController _prenom;
  late final TextEditingController _lieu;
  late final TextEditingController _parente;
  DateTime? _date;
  XFile? _image;
  Uint8List? _imageBytes; // pour l'aperçu
  bool _enregistrement = false;
  Map<String, String> _erreursServeur = {};

  bool get _modeModification => widget.membre != null;

  @override
  void initState() {
    super.initState();
    final m = widget.membre;
    _nom = TextEditingController(text: m?.nom ?? '');
    _postnom = TextEditingController(text: m?.postnom ?? '');
    _prenom = TextEditingController(text: m?.prenom ?? '');
    _lieu = TextEditingController(text: m?.lieuNaissance ?? '');
    _parente = TextEditingController(text: m?.parente ?? '');
    _date = m != null ? DateTime.tryParse(m.dateNaissance) : null;
  }

  @override
  void dispose() {
    for (final c in [_nom, _postnom, _prenom, _lieu, _parente]) {
      c.dispose();
    }
    super.dispose();
  }

  /// L'API exige le format AAAA-MM-JJ (ex. 1970-05-12).
  String _formatDate(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _choisirPhoto() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024, // réduit la taille : l'API refuse plus de 2 Mo
      imageQuality: 75,
    );
    if (photo == null) return;
    final bytes = await photo.readAsBytes();
    setState(() {
      _image = photo;
      _imageBytes = bytes;
    });
  }

  Future<void> _choisirDate() async {
    final choisie = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(), // pas de date dans le futur
    );
    if (choisie != null) setState(() => _date = choisie);
  }

  Future<void> _enregistrer() async {
    setState(() => _erreursServeur = {});
    if (!_formKey.currentState!.validate()) return;
    if (_date == null) {
      setState(() => _erreursServeur = {
            'date_naissance': 'Choisis une date de naissance'
          });
      return;
    }

    final membre = FamilleMembre(
      id: widget.membre?.id,
      nom: _nom.text.trim(),
      postnom: _postnom.text.trim(),
      prenom: _prenom.text.trim(),
      lieuNaissance: _lieu.text.trim(),
      dateNaissance: _formatDate(_date!),
      parente: _parente.text.trim(),
    );

    setState(() => _enregistrement = true);
    try {
      if (_modeModification) {
        await FamilleService.update(membre, image: _image);
      } else {
        await FamilleService.create(membre, image: _image);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true); // true = enregistré
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _erreursServeur = e.errors);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _enregistrement = false);
    }
  }

  Widget _champ(TextEditingController controller, String label, String cle,
      {int max = 50, String? exemple}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLength: max,
        decoration: InputDecoration(
          labelText: label,
          hintText: exemple,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          counterText: '',
          errorText: _erreursServeur[cle], // erreur renvoyée par l'API
        ),
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urlActuelle = widget.membre?.imageUrl;
    ImageProvider? photo; // nouvelle photo choisie, sinon photo actuelle
    if (_imageBytes != null) {
      photo = MemoryImage(_imageBytes!);
    } else if (urlActuelle != null) {
      photo = NetworkImage(urlActuelle);
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
              _modeModification ? 'Modifier le membre' : 'Ajouter un membre')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _choisirPhoto,
                  child: CircleAvatar(
                    radius: 52,
                    backgroundImage: photo,
                    child: photo == null
                        ? const Icon(Icons.add_a_photo_outlined, size: 32)
                        : null,
                  ),
                ),
              ),
              TextButton(
                onPressed: _choisirPhoto,
                child: Text(
                    photo == null ? 'Ajouter une photo' : 'Changer la photo'),
              ),
              if (_erreursServeur['image'] != null)
                Text(_erreursServeur['image']!,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              const SizedBox(height: 8),
              _champ(_nom, 'Nom', 'nom'),
              _champ(_postnom, 'Postnom', 'postnom'),
              _champ(_prenom, 'Prénom', 'prenom'),
              _champ(_parente, 'Lien de parenté', 'parente',
                  exemple: 'ex. Père, Mère, Frère, Sœur, Tante'),
              _champ(_lieu, 'Lieu de naissance', 'lieu_naissance', max: 100),
              InkWell(
                onTap: _choisirDate,
                borderRadius: BorderRadius.circular(14),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date de naissance',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                    errorText: _erreursServeur['date_naissance'],
                  ),
                  child: Text(_date == null ? 'Choisir…' : _formatDate(_date!)),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52)),
                onPressed: _enregistrement ? null : _enregistrer,
                icon: _enregistrement
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save_outlined),
                label: Text(_modeModification
                    ? 'Enregistrer les modifications'
                    : 'Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
