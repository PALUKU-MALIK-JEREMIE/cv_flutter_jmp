import 'package:material_ui/material_ui.dart';
import '../data/mes_donnees.dart';

/// Forme de la photo : mettez `true` pour un cercle, `false` pour un rectangle arrondi.
const bool photoEnCercle = true;

class FamillePage extends StatelessWidget {
  const FamillePage({super.key});

  @override
  Widget build(BuildContext context) {
    final couleurs = Theme.of(context).colorScheme;

    return Container(
      color: couleurs.surfaceContainerLowest,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: famille.length + 1, // +1 pour l'en-tête
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          if (i == 0) return _EnTete(nombre: famille.length);
          return _CarteMembre(membre: famille[i - 1]);
        },
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
                Text('',
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

/// Une ligne : photo à gauche, informations à droite
class _CarteMembre extends StatelessWidget {
  final dynamic membre;
  const _CarteMembre({required this.membre});

  @override
  Widget build(BuildContext context) {
    final couleurs = Theme.of(context).colorScheme;
    const rayonPhoto = photoEnCercle ? 40.0 : 14.0;

    return Material(
      color: couleurs.surface,
      elevation: 2,
      shadowColor: couleurs.shadow.withAlpha(60),
      borderRadius: BorderRadius.circular(18),
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
                child: Image.asset(
                  membre.photo,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 72,
                    height: 72,
                    color: couleurs.primaryContainer,
                    child: Icon(Icons.person,
                        size: 36, color: couleurs.onPrimaryContainer),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Nom, lien et métier
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    membre.nom,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: couleurs.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      membre.lien,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: couleurs.onPrimaryContainer),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.work_outline,
                          size: 16, color: couleurs.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          membre.profession,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: couleurs.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
