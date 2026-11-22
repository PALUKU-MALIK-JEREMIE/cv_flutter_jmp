import 'package:flutter/material.dart';

import '../models/famille_membre.dart';
import '../services/famille_service.dart';
import 'membre_form_page.dart';

class MembreDetailPage extends StatefulWidget {
  final int id;
  const MembreDetailPage({super.key, required this.id});

  @override
  State<MembreDetailPage> createState() => _MembreDetailPageState();
}

class _MembreDetailPageState extends State<MembreDetailPage> {
  late Future<FamilleMembre> _future;

  @override
  void initState() {
    super.initState();
    _future = FamilleService.getById(widget.id); // GET /famille-membres/{id}
  }

  Future<void> _modifier(FamilleMembre membre) async {
    final enregistre = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => MembreFormPage(membre: membre)),
    );
    if (enregistre == true) {
      setState(() => _future = FamilleService.getById(widget.id));
    }
  }

  Widget _info(IconData icone, String titre, String valeur) => ListTile(
        leading: Icon(icone),
        title: Text(titre),
        subtitle: Text(valeur),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FamilleMembre>(
      future: _future,
      builder: (context, snapshot) {
        final m = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Détail du membre'),
            actions: [
              if (m != null)
                IconButton(
                  tooltip: 'Modifier',
                  icon: const Icon(Icons.edit),
                  onPressed: () => _modifier(m),
                ),
            ],
          ),
          body: snapshot.connectionState != ConnectionState.done
              ? const Center(child: CircularProgressIndicator())
              : snapshot.hasError
                  ? Center(child: Text(snapshot.error.toString()))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 64,
                            backgroundImage: m!.imageUrl != null
                                ? NetworkImage(m.imageUrl!)
                                : null,
                            child: m.imageUrl == null
                                ? Text(m.initiales,
                                    style: const TextStyle(fontSize: 34))
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(m.nomComplet,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 16),
                        Card(
                          child: Column(
                            children: [
                              _info(Icons.people_alt_outlined,
                                  'Lien de parenté', m.parente),
                              _info(Icons.cake_outlined, 'Date de naissance',
                                  m.dateNaissance),
                              _info(Icons.place_outlined, 'Lieu de naissance',
                                  m.lieuNaissance),
                            ],
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
