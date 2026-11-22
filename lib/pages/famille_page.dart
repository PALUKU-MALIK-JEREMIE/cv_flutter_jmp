import 'package:flutter/material.dart';

import '../models/famille_membre.dart';
import '../services/api_client.dart';
import '../services/famille_service.dart';
import 'membre_detail_page.dart';
import 'membre_form_page.dart';

/// Forme de la photo : mettez `true` pour un cercle, `false` pour un rectangle arrondi.
const bool photoEnCercle = true;

class FamillePage extends StatefulWidget {
  const FamillePage({super.key});

  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  late Future<List<FamilleMembre>> _future;

  @override
  void initState() {
    super.initState();
    _future = FamilleService.getAll();
  }

  /// Recharge la liste depuis l'API.
  Future<void> _rafraichir() async {
    final future = FamilleService.getAll();
    setState(() => _future = future);
    try {
      await future;
    } catch (_) {
      // l'erreur est affichée par le FutureBuilder
    }
  }

  void _message(String texte) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(texte)));

  Future<void> _ouvrirFormulaire([FamilleMembre? membre]) async {
    final enregistre = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => MembreFormPage(membre: membre)),
    );
    if (enregistre == true) {
      _message(membre == null ? 'Membre ajouté' : 'Membre modifié');
      _rafraichir();
    }
  }

  Future<void> _ouvrirDetail(FamilleMembre membre) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MembreDetailPage(id: membre.id!)),
    );
    _rafraichir(); // le membre a pu être modifié depuis le détail
  }

  Future<void> _confirmerSuppression(FamilleMembre membre) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.delete_outline_rounded, size: 36),
        title: const Text('Supprimer ce membre ?'),
        content: Text('${membre.nomComplet} sera supprimé définitivement.',
            textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Supprimer')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await FamilleService.delete(membre.id!);
      _message('Membre supprimé');
      _rafraichir();
    } on ApiException catch (e) {
      _message(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final couleurs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: couleurs.surfaceContainerLowest,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _ouvrirFormulaire(),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Ajouter'),
      ),
      body: RefreshIndicator(
        onRefresh: _rafraichir,
        child: FutureBuilder<List<FamilleMembre>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 40),
                  Icon(Icons.cloud_off_rounded,
                      size: 56, color: couleurs.error),
                  const SizedBox(height: 12),
                  Text(snapshot.error.toString(), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: _rafraichir,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ),
                ],
              );
            }

            final membres = snapshot.data ?? [];
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: membres.isEmpty ? 2 : membres.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                if (i == 0) return _EnTete(nombre: membres.length);
                if (membres.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                        'Aucun membre pour le moment.\nAppuie sur « Ajouter ».',
                        textAlign: TextAlign.center),
                  );
                }
                final m = membres[i - 1];
                return _CarteMembre(
                  membre: m,
                  onTap: () => _ouvrirDetail(m),
                  onModifier: () => _ouvrirFormulaire(m),
                  onSupprimer: () => _confirmerSuppression(m),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// En-tête en dégradé en haut de la page
class _EnTete extends StatelessWidget {
  final int nombre;
  const _EnTete({required this.nombre});

  @override
  Widget build(BuildContext context) {
    final couleurs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [couleurs.primary, couleurs.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: couleurs.onPrimary.withAlpha(40),
            child: Icon(Icons.family_restroom,
                color: couleurs.onPrimary, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ma famille',
                    style: TextStyle(
                        color: couleurs.onPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('$nombre membre${nombre > 1 ? 's' : ''}',
                    style: TextStyle(color: couleurs.onPrimary.withAlpha(220))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Une carte : photo à gauche, informations au milieu, menu à droite
class _CarteMembre extends StatelessWidget {
  final FamilleMembre membre;
  final VoidCallback onTap;
  final VoidCallback onModifier;
  final VoidCallback onSupprimer;

  const _CarteMembre({
    required this.membre,
    required this.onTap,
    required this.onModifier,
    required this.onSupprimer,
  });

  @override
  Widget build(BuildContext context) {
    final couleurs = Theme.of(context).colorScheme;
    const rayonPhoto = photoEnCercle ? 40.0 : 14.0;

    final sansPhoto = Container(
      width: 72,
      height: 72,
      color: couleurs.primaryContainer,
      alignment: Alignment.center,
      child: Text(membre.initiales,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: couleurs.onPrimaryContainer)),
    );

    return Material(
      color: couleurs.surface,
      elevation: 2,
      shadowColor: couleurs.shadow.withAlpha(60),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Photo avec un contour coloré
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(rayonPhoto + 3),
                  gradient: LinearGradient(
                    colors: [couleurs.primary, couleurs.tertiary],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(rayonPhoto),
                  child: membre.imageUrl == null
                      ? sansPhoto
                      : Image.network(
                          membre.imageUrl!,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => sansPhoto,
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // Nom, parenté et naissance
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      membre.nomComplet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: couleurs.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        membre.parente,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: couleurs.onPrimaryContainer),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Né(e) le ${membre.dateNaissance} à ${membre.lieuNaissance}',
                      style: TextStyle(
                          fontSize: 13, color: couleurs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),

              // Menu Modifier / Supprimer
              PopupMenuButton<String>(
                onSelected: (choix) =>
                    choix == 'modifier' ? onModifier() : onSupprimer(),
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'modifier',
                    child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Modifier')),
                  ),
                  PopupMenuItem(
                    value: 'supprimer',
                    child: ListTile(
                        leading: Icon(Icons.delete_outline),
                        title: Text('Supprimer')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
